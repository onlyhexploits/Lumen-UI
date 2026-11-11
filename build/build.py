#!/usr/bin/env python3
"""
Lumen UI build script.

    python3 build/build.py            # build dist/Lumen.lua and dist/Lumen.min.lua
    python3 build/build.py --verify   # ...then run the mocked smoke test on all three variants

Outputs
  dist/Lumen.lua      every module bundled into one readable file (one loadstring, no network fetches)
  dist/Lumen.min.lua  the same bundle with comments removed and every local renamed to v0_N

The obfuscator is token based and scope aware: only identifiers declared with `local`, as a function
parameter or as a for-loop variable are renamed. Globals, table keys and field/method names are never
touched, so behavior is unchanged. --verify proves it: all three builds must produce identical logs
when run against the mocked Roblox API in tests/smoke.lua.
"""
import os
import re
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIST = os.path.join(ROOT, "dist")
BUNDLE_MARKER = "local Bundle = nil -- __BUNDLE__"

KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in",
    "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while",
}


# --------------------------------------------------------------------------- bundling
def module_paths(library_source):
    block = re.search(r"local MODULES = \{(.*?)\n\}", library_source, re.S)
    if not block:
        raise SystemExit("could not find the MODULES list in Library.lua")
    return re.findall(r'"([^"]+\.lua)"', block.group(1))


def bundle():
    with open(os.path.join(ROOT, "Library.lua"), encoding="utf-8") as handle:
        library = handle.read()
    if BUNDLE_MARKER not in library:
        raise SystemExit("bundle marker missing from Library.lua")

    parts = ["local __LUMEN_BUNDLE = {\n"]
    for path in module_paths(library):
        with open(os.path.join(ROOT, path), encoding="utf-8") as handle:
            source = handle.read().rstrip("\n")
        parts.append('["%s"] = function(...)\n%s\nend,\n' % (path, source))
    parts.append("}\n\n")
    parts.append(library.replace(BUNDLE_MARKER, "local Bundle = __LUMEN_BUNDLE"))
    return "".join(parts)


# --------------------------------------------------------------------------- lexer
class Token:
    __slots__ = ("kind", "value", "line", "first")

    def __init__(self, kind, value, line, first):
        self.kind, self.value, self.line, self.first = kind, value, line, first


NUMBER = re.compile(
    r"0[xX][0-9a-fA-F]+(?:\.[0-9a-fA-F]*)?(?:[pP][+-]?\d+)?|\d+\.?\d*(?:[eE][+-]?\d+)?|\.\d+(?:[eE][+-]?\d+)?"
)
NAME = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
LONG_OPEN = re.compile(r"\[(=*)\[")
OPS3, OPS2 = ("...",), ("..", "==", "~=", "<=", ">=", "::")


def lex(source):
    tokens, i, line, n = [], 0, 1, len(source)
    first = True  # next token is the first on its line

    def push(kind, value):
        nonlocal first
        tokens.append(Token(kind, value, line, first))
        first = False

    while i < n:
        c = source[i]
        if c == "\n":
            line += 1
            first = True
            i += 1
        elif c in " \t\r":
            i += 1
        elif source.startswith("--", i):
            m = LONG_OPEN.match(source, i + 2)
            if m:
                close = "]" + m.group(1) + "]"
                end = source.find(close, m.end())
                if end < 0:
                    raise SystemExit("unterminated long comment at line %d" % line)
                line += source.count("\n", i, end)
                i = end + len(close)
            else:
                end = source.find("\n", i)
                i = n if end < 0 else end
        elif c in "\"'":
            j = i + 1
            while j < n and source[j] != c:
                if source[j] == "\\":
                    j += 1
                if source[j] == "\n":
                    line += 1
                j += 1
            push("str", source[i : j + 1])
            i = j + 1
        elif c == "[" and LONG_OPEN.match(source, i):
            m = LONG_OPEN.match(source, i)
            close = "]" + m.group(1) + "]"
            end = source.find(close, m.end())
            if end < 0:
                raise SystemExit("unterminated long string at line %d" % line)
            text = source[i : end + len(close)]
            push("str", text)
            line += text.count("\n")
            i = end + len(close)
        elif c.isdigit() or (c == "." and i + 1 < n and source[i + 1].isdigit()):
            m = NUMBER.match(source, i)
            push("num", m.group(0))
            i = m.end()
        elif c.isalpha() or c == "_":
            m = NAME.match(source, i)
            push("kw" if m.group(0) in KEYWORDS else "name", m.group(0))
            i = m.end()
        else:
            if source.startswith(OPS3, i):
                op = "..."
            elif source[i : i + 2] in OPS2:
                op = source[i : i + 2]
            else:
                op = c
            push("op", op)
            i += len(op)
    return tokens


# --------------------------------------------------------------------------- renamer
# Tokens that continue an expression when they START a line ...
CONTINUATION = {
    "and", "or", "..", "+", "-", "*", "/", "%", "^", "==", "~=", "<", ">", "<=", ">=", ".", ":", ",", ")", "]", "}", "=",
}
# ... and tokens that leave an expression unfinished when they END a line.
DANGLING = CONTINUATION - {")", "]", "}"}
OPEN_TO_CLOSE = {"{": "}", "(": ")", "[": "]"}


def obfuscate(source):
    tokens = lex(source)
    for token in tokens:
        if token.kind == "kw" and token.value in ("repeat", "until", "goto"):
            raise SystemExit("'%s' is not supported by the obfuscator (line %d)" % (token.value, token.line))

    counter = [0]

    def fresh():
        counter[0] += 1
        return "v0_%d" % counter[0]

    scopes = [{}]
    stack = []  # '{' '(' '[' or 'block'
    declared = {}  # token index -> new name (declaration sites)
    pending = []  # [(map, depth)] for `local` statements whose expression has not ended yet
    for_pending = []  # [(map, depth)] waiting for their `do`
    fn_state = None  # 'name' | 'params'
    out_names = {}

    def declare(mapping):
        scopes[-1].update(mapping)

    def lookup(name):
        for scope in reversed(scopes):
            if name in scope:
                return scope[name]
        return None

    def collect_names(start):
        """Names in a `local a, b` / `for a, b in` list starting at token index `start`."""
        names, j = [], start
        while j < len(tokens) and tokens[j].kind == "name":
            names.append(j)
            if tokens[j + 1].kind == "op" and tokens[j + 1].value == ",":
                j += 2
            else:
                break
        return names

    for i, token in enumerate(tokens):
        value, kind = token.value, token.kind
        prev = tokens[i - 1] if i else None

        # Declarations of a `local` statement become visible after its expression ends.
        # Statements nested inside the expression (function bodies) keep their own entries.
        while pending:
            mapping, depth = pending[-1]
            closing = kind == "kw" and value in ("end", "else", "elseif")
            starts_statement = (
                token.first
                and len(stack) == depth
                and value not in CONTINUATION
                and not (prev and prev.value in DANGLING and prev.kind in ("op", "kw"))
            )
            if (closing and len(stack) == depth) or starts_statement or len(stack) < depth:
                declare(mapping)
                pending.pop()
            else:
                break

        if kind == "kw":
            if value == "local":
                nxt = tokens[i + 1]
                if nxt.kind == "kw" and nxt.value == "function":
                    name_index = i + 2
                    new = fresh()
                    declared[name_index] = new
                    declare({tokens[name_index].value: new})
                else:
                    mapping = {}
                    for j in collect_names(i + 1):
                        new = fresh()
                        declared[j] = new
                        mapping[tokens[j].value] = new
                    pending.append((mapping, len(stack)))
            elif value == "for":
                mapping = {}
                j = i + 1
                for j in collect_names(i + 1):
                    new = fresh()
                    declared[j] = new
                    mapping[tokens[j].value] = new
                for_pending.append((mapping, len(stack)))
            elif value == "do":
                stack.append("block")
                scopes.append({})
                if for_pending and for_pending[-1][1] == len(stack) - 1:
                    declare(for_pending.pop()[0])
            elif value == "function":
                stack.append("block")
                scopes.append({})
                fn_state = "name"
            elif value == "if":
                stack.append("block")
                scopes.append({})
            elif value in ("elseif", "else"):
                scopes[-1] = {}
            elif value == "end":
                if not stack or stack.pop() != "block":
                    raise SystemExit("unbalanced 'end' at line %d" % token.line)
                scopes.pop()
            continue

        if kind == "op":
            if value in OPEN_TO_CLOSE:
                stack.append(value)
                if value == "(" and fn_state == "name":
                    fn_state = "params"
            elif value in (")", "}", "]"):
                if not stack or OPEN_TO_CLOSE.get(stack.pop()) != value:
                    raise SystemExit("unbalanced '%s' at line %d" % (value, token.line))
                if value == ")" and fn_state == "params":
                    fn_state = None
            continue

        if kind != "name":
            continue

        if i in declared:
            out_names[i] = declared[i]
            continue

        if fn_state == "params":
            new = fresh()
            scopes[-1][value] = new
            out_names[i] = new
            continue

        if prev and prev.kind == "op" and prev.value in (".", ":"):
            continue  # field or method name
        nxt = tokens[i + 1] if i + 1 < len(tokens) else None
        if (
            stack
            and stack[-1] == "{"
            and nxt
            and nxt.kind == "op"
            and nxt.value == "="
            and prev
            and prev.kind == "op"
            and prev.value in ("{", ",", ";")
        ):
            continue  # table constructor key
        renamed = lookup(value)
        if renamed:
            out_names[i] = renamed

    if stack:
        raise SystemExit("unbalanced blocks at end of input")

    # Emit: one line per original line, spaces only where needed.
    NO_SPACE_BEFORE = {",", ";", ")", "]", "}", ".", ":"}
    NO_SPACE_AFTER = {"(", "[", "{", ".", ":"}
    pieces = []
    for i, token in enumerate(tokens):
        text = out_names.get(i, token.value)
        if i:
            previous = tokens[i - 1]
            if token.line != previous.line:
                pieces.append("\n")
            elif not (
                (token.kind == "op" and token.value in NO_SPACE_BEFORE)
                or (previous.kind == "op" and previous.value in NO_SPACE_AFTER)
            ):
                pieces.append(" ")
        pieces.append(text)
    return "".join(pieces) + "\n", counter[0]


# --------------------------------------------------------------------------- main
def find_lua():
    for name in ("texlua", "lua5.4", "lua5.3", "lua5.1", "lua", "luajit"):
        path = shutil.which(name)
        if path:
            return path
    return None


def run_smoke(lua, target, log_name):
    log = os.path.join(DIST, log_name)
    result = subprocess.run([lua, "tests/smoke.lua", target, log], cwd=ROOT, capture_output=True, text=True)
    tail = [line for line in result.stdout.splitlines() if "failure" in line or "FAIL" in line or "FATAL" in line]
    return result.returncode == 0, tail, log


def verify():
    lua = find_lua()
    if not lua:
        print("verify: no Lua interpreter found (tried texlua, lua, luajit) - skipped")
        return True
    results = []
    for label, target, log in (
        ("src", "src", "smoke-src.log"),
        ("Lumen.lua", "dist/Lumen.lua", "smoke-bundle.log"),
        ("Lumen.min.lua", "dist/Lumen.min.lua", "smoke-min.log"),
    ):
        ok, tail, path = run_smoke(lua, target, log)
        print("verify: %-14s %s  %s" % (label, "PASS" if ok else "FAIL", " | ".join(tail)))
        results.append((ok, path))
    logs = [open(path, "rb").read() for _, path in results]
    identical = logs[0] == logs[1] == logs[2]
    print("verify: instance/property logs identical across builds: %s" % ("YES" if identical else "NO"))
    for _, path in results:
        os.remove(path)
    return all(ok for ok, _ in results) and identical


def main():
    os.makedirs(DIST, exist_ok=True)
    bundled = bundle()
    minified, renamed = obfuscate(bundled)
    with open(os.path.join(DIST, "Lumen.lua"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(bundled)
    with open(os.path.join(DIST, "Lumen.min.lua"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(minified)
    print("built dist/Lumen.lua      %7d bytes" % len(bundled.encode()))
    print("built dist/Lumen.min.lua  %7d bytes (%d locals renamed)" % (len(minified.encode()), renamed))
    if "--verify" in sys.argv and not verify():
        sys.exit(1)


if __name__ == "__main__":
    main()
