--[[ Lumen UI - Button
    Section:Button({ Name, Description, Icon, Style = "Primary"|nil, Callback = function() end })
    Methods: SetName(text), SetDescription(text), Fire(), SetVisible(bool), Destroy()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Base = Lumen.Base
local Icons = Lumen.Icons

Lumen.Elements.Button = function(section, opts)
    opts = Base.Opts(opts, "Button")
    local primary = opts.Style == "Primary"

    local card, stroke = Base.Card(section, 40, true)
    local _, nameLabel, descLabel = Base.Text(card, opts, 28)

    local restColor = Theme.Stroke
    local iconColor = Theme.Muted
    if primary then
        card.BackgroundColor3 = Theme.Accent
        card.BackgroundTransparency = 0.08
        stroke.Color = Theme.Accent
        stroke.Transparency = 0.4
        nameLabel.TextColor3 = Theme.AccentDark
        descLabel.TextColor3 = Theme.AccentDark
        restColor = Theme.Accent
        iconColor = Theme.AccentDark
    end

    Icons.Create(card, opts.Icon or "chevron-right", 14, iconColor, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
    })

    local obj = {}

    function obj:SetName(text)
        nameLabel.Text = tostring(text)
    end

    function obj:SetDescription(text)
        descLabel.Text = tostring(text or "")
        descLabel.Visible = text ~= nil and text ~= ""
    end

    function obj:Get()
        return nil
    end

    U.Connect(card.MouseButton1Click, function()
        stroke.Color = Theme.Accent
        U.Tween(stroke, { Color = restColor }, 0.35)
        U.Safe(opts.Callback)
    end)

    U.Hover(card, function()
        U.Tween(card, { BackgroundTransparency = primary and 0 or 0.1 }, 0.12)
        if not primary then
            U.Tween(stroke, { Color = Theme.StrokeHover }, 0.12)
        end
    end, function()
        U.Tween(card, { BackgroundTransparency = primary and 0.08 or 0.3 }, 0.2)
        U.Tween(stroke, { Color = restColor }, 0.2)
    end)

    return Base.Finish(section, opts, obj, card, "Button")
end
