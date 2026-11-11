getgenv().LumenUIBase = "https://raw.githubusercontent.com/onlyhexploits/Lumen-UI/main/"
local env = (getgenv and getgenv()) or _G

local BASE = env.LumenUIBase or "https://raw.githubusercontent.com/onlyhexploits/Lumen-UI/main/"

local Bundle = nil
local MODULES = {
    "src/Core/Theme.lua",
    "src/Core/Utility.lua",
    "src/Core/Icons.lua",
    "src/Elements/Base.lua",
    "src/Elements/Toggle.lua",
    "src/Elements/Button.lua",
    "src/Elements/Slider.lua",
    "src/Elements/Dropdown.lua",
    "src/Elements/Paragraph.lua",
    "src/Components/Notification.lua",
    "src/Components/Section.lua",
    "src/Components/Tab.lua",
    "src/Components/Dashboard.lua",
    "src/Components/Window.lua",
}

local function fetch(path)
    if env.LumenUILocalPath and readfile then
        return readfile(env.LumenUILocalPath .. "/" .. path)
    end
    return game:HttpGet(BASE .. path, true)
end

local function loadModule(path)
    if Bundle then
        return Bundle[path]
    end
    local fn, err = loadstring(fetch(path), "=" .. path)
    if not fn then
        error("[Lumen] failed to compile " .. path .. ": " .. tostring(err), 0)
    end
    return fn
end

-- Re-executing the script replaces the previous instance.
if env.LumenUI and type(env.LumenUI.Destroy) == "function" then
    pcall(function()
        env.LumenUI:Destroy()
    end)
end

local Lumen = {
    Version = "1.0.0",
    Flags = {},
    Windows = {},
    Elements = {},
    _connections = {},
    _guis = {},
}

function Lumen:Destroy()
    for _, conn in ipairs(self._connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    for _, gui in ipairs(self._guis) do
        pcall(function()
            gui:Destroy()
        end)
    end
    self._connections = {}
    self._guis = {}
    self.Flags = {}
    self.Windows = {}
    if self.Privacy then
        self.Privacy._binds = {}
    end
    if env.LumenUI == self then
        env.LumenUI = nil
    end
end

for _, path in ipairs(MODULES) do
    loadModule(path)(Lumen)
end

env.LumenUI = Lumen

return Lumen
