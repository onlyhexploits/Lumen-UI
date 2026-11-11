--[[
    Lumen UI - Icons

    Roblox cannot load Lucide SVGs directly, so icons come from an image provider:

        Lumen.Icons.Register("home", "rbxassetid://123456")
        Lumen.Icons.Register("sword", { Image = "rbxassetid://1", RectOffset = Vector2.new(0, 0), RectSize = Vector2.new(48, 48) })
        Lumen.Icons.SetProvider(function(name) return "rbxassetid://..." end)   -- or a spec table, or nil

    Names that are already asset ids ("rbxassetid://..", "rbxasset://..", numbers) work as-is.
    A few glyphs the library itself needs (chevrons, search, close, minus) are drawn with frames,
    so the UI is usable with no provider at all. Unknown names fall back to a small dot.
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme

local Icons = { Registry = {}, Provider = nil }

function Icons.Register(name, spec)
    Icons.Registry[name] = spec
end

function Icons.SetProvider(provider)
    Icons.Provider = provider
end

local function normalize(spec)
    if type(spec) == "number" then
        return { Image = "rbxassetid://" .. spec }
    elseif type(spec) == "string" then
        return { Image = spec }
    elseif type(spec) == "table" and spec.Image then
        return spec
    end
    return nil
end

function Icons.Resolve(name)
    if name == nil then
        return nil
    end
    if Icons.Registry[name] then
        return normalize(Icons.Registry[name])
    end
    if type(name) == "number" then
        return normalize(name)
    end
    if type(name) == "string" and string.find(name, "^rbxasset") then
        return normalize(name)
    end
    if Icons.Provider then
        local ok, spec = pcall(Icons.Provider, name)
        if ok then
            return normalize(spec)
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- Drawn glyphs. Each builder returns (container, parts); parts get recolored.
---------------------------------------------------------------------------

local function bar(parent, length, thickness, x, y, rotation, color)
    local part = U.Box({
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(length, thickness),
        Rotation = rotation,
        BackgroundColor3 = color,
        Parent = parent,
    })
    U.Corner(part, 1)
    return part
end

local Drawn = {}

local function chevron(parent, size, color)
    local box = U.Frame({ Size = UDim2.fromOffset(size, size), Parent = parent })
    local s = size / 12
    local parts = {
        bar(box, 7 * s, 2, 3.5 * s, 5 * s, 45, color),
        bar(box, 7 * s, 2, 8.5 * s, 5 * s, -45, color),
    }
    return box, parts
end

Drawn["chevron-down"] = chevron

Drawn["chevron-right"] = function(parent, size, color)
    local box, parts = chevron(parent, size, color)
    box.Rotation = -90
    return box, parts
end

Drawn.minus = function(parent, size, color)
    local box = U.Frame({ Size = UDim2.fromOffset(size, size), Parent = parent })
    return box, { bar(box, size * 0.7, 2, size / 2, size / 2, 0, color) }
end

Drawn.close = function(parent, size, color)
    local box = U.Frame({ Size = UDim2.fromOffset(size, size), Parent = parent })
    local length = size * 0.85
    return box, {
        bar(box, length, 2, size / 2, size / 2, 45, color),
        bar(box, length, 2, size / 2, size / 2, -45, color),
    }
end

Drawn.search = function(parent, size, color)
    local box = U.Frame({ Size = UDim2.fromOffset(size, size), Parent = parent })
    local ring = U.Frame({ Size = UDim2.fromOffset(size * 0.66, size * 0.66), Parent = box })
    U.Corner(ring, "full")
    local stroke = U.Stroke(ring, color, 2)
    local handle = bar(box, size * 0.38, 2, size * 0.82, size * 0.82, 45, color)
    return box, { stroke, handle }
end

local function recolor(part, color)
    if part:IsA("UIStroke") then
        part.Color = color
    else
        part.BackgroundColor3 = color
    end
end

---------------------------------------------------------------------------
-- Public builder
---------------------------------------------------------------------------

-- Returns { Instance = <GuiObject>, SetColor = fn, Destroy = fn }.
-- `props` are applied to Instance (Position, AnchorPoint, LayoutOrder, ...).
function Icons.Create(parent, name, size, color, props)
    size = size or 16
    color = color or Theme.Muted

    local obj = {}
    local spec = Icons.Resolve(name)

    if spec then
        local image = U.Image({
            Size = UDim2.fromOffset(size, size),
            Image = spec.Image,
            ImageColor3 = color,
            Parent = parent,
        })
        if spec.RectOffset then
            image.ImageRectOffset = spec.RectOffset
            image.ImageRectSize = spec.RectSize or Vector2.new(0, 0)
        end
        obj.Instance = image
        function obj:SetColor(c)
            image.ImageColor3 = c
        end
    elseif Drawn[name] then
        local box, parts = Drawn[name](parent, size, color)
        obj.Instance = box
        function obj:SetColor(c)
            for _, part in ipairs(parts) do
                recolor(part, c)
            end
        end
    else
        local box = U.Frame({ Size = UDim2.fromOffset(size, size), Parent = parent })
        local dot = U.Box({
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(4, 4),
            BackgroundColor3 = color,
            Parent = box,
        })
        U.Corner(dot, "full")
        obj.Instance = box
        function obj:SetColor(c)
            dot.BackgroundColor3 = c
        end
    end

    for key, value in pairs(props or {}) do
        obj.Instance[key] = value
    end

    function obj:Destroy()
        obj.Instance:Destroy()
    end

    return obj
end

Lumen.Icons = Icons
