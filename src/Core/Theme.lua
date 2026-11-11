--[[ Lumen UI - Theme: colors, fonts and radii shared by every component ]]
local Lumen = ...

local Theme = {
    Background = Color3.fromRGB(21, 21, 23),
    Sidebar = Color3.fromRGB(25, 25, 27),
    Card = Color3.fromRGB(30, 30, 32),
    Element = Color3.fromRGB(38, 38, 41),
    ElementHover = Color3.fromRGB(48, 48, 52),
    Track = Color3.fromRGB(62, 62, 68),
    Stroke = Color3.fromRGB(46, 46, 50),
    StrokeHover = Color3.fromRGB(74, 74, 80),

    Text = Color3.fromRGB(242, 242, 244),
    Muted = Color3.fromRGB(139, 139, 148),

    Accent = Color3.fromRGB(163, 217, 43),
    AccentDark = Color3.fromRGB(20, 28, 6),

    Success = Color3.fromRGB(87, 214, 120),
    Warning = Color3.fromRGB(245, 183, 64),
    Danger = Color3.fromRGB(236, 86, 86),
    Online = Color3.fromRGB(70, 200, 100),

    Radius = 10,
    SmallRadius = 8,

    FontRegular = Enum.Font.Gotham,
    FontMedium = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
}

Theme.Presets = {
    Lime = { Accent = Color3.fromRGB(163, 217, 43), AccentDark = Color3.fromRGB(20, 28, 6) },
    Ocean = { Accent = Color3.fromRGB(64, 160, 255), AccentDark = Color3.fromRGB(4, 18, 34) },
    Rose = { Accent = Color3.fromRGB(255, 94, 140), AccentDark = Color3.fromRGB(38, 6, 16) },
    Amber = { Accent = Color3.fromRGB(255, 183, 66), AccentDark = Color3.fromRGB(36, 22, 2) },
    Violet = { Accent = Color3.fromRGB(150, 110, 255), AccentDark = Color3.fromRGB(14, 8, 36) },
}

-- Theme:Apply("Ocean")  or  Theme:Apply({ Accent = Color3.fromRGB(...) })
-- Call it BEFORE creating a window; components read the theme when they are built.
function Theme:Apply(preset)
    local values = type(preset) == "string" and self.Presets[preset] or preset
    if type(values) ~= "table" then
        return false
    end
    for key, value in pairs(values) do
        self[key] = value
    end
    return true
end

Lumen.Theme = Theme
