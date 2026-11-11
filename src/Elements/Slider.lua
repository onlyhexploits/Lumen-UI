--[[ Lumen UI - Slider
    Section:Slider({ Name, Description, Min, Max, Default, Increment, Suffix, Flag, Callback = function(value) end })
    Methods: Set(value, silent), Get(), Fire(), SetVisible(bool), Destroy()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Base = Lumen.Base

local UserInputService = game:GetService("UserInputService")

Lumen.Elements.Slider = function(section, opts)
    opts = Base.Opts(opts, "Slider")

    local min = opts.Min or 0
    local max = opts.Max or 100
    if max <= min then
        max = min + 1
    end
    local increment = opts.Increment or 1
    local suffix = opts.Suffix and tostring(opts.Suffix) or ""

    local card, stroke = Base.Card(section, 40, false)
    local holder, nameLabel = Base.Text(card, opts, 0)
    nameLabel.Size = UDim2.new(1, -80, 0, 16)

    local valueLabel = U.Label({
        Name = "Value",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(76, 16),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextColor3 = Theme.Muted,
        Parent = card,
    })

    local hit = U.Button({
        Name = "Hit",
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 3,
        Parent = holder,
    })

    local bar = U.Box({
        Name = "Bar",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 2),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Theme.Track,
        Parent = hit,
    })
    U.Corner(bar, "full")

    local fill = U.Box({
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = bar,
    })
    U.Corner(fill, "full")

    local knob = U.Box({
        Name = "Knob",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Theme.Text,
        Parent = fill,
    })
    U.Corner(knob, "full")

    local value = U.Clamp(opts.Default or opts.Value or min, min, max)
    value = U.Round(value, increment)
    local obj = {}

    local function render()
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        valueLabel.Text = U.Number(value) .. suffix
    end
    render()

    function obj:Set(newValue, silent)
        newValue = U.Round(U.Clamp(newValue, min, max), increment)
        if newValue == value then
            return
        end
        value = newValue
        render()
        if not silent then
            U.Safe(opts.Callback, value)
        end
    end

    function obj:Get()
        return value
    end

    local dragging = false

    local function fromX(x)
        local width = bar.AbsoluteSize.X
        if width <= 0 then
            return
        end
        local percent = U.Clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
        obj:Set(min + (max - min) * percent)
    end

    U.Connect(hit.InputBegan, function(input)
        if U.IsPointer(input) then
            dragging = true
            U.Tween(knob, { Size = UDim2.fromOffset(15, 15) }, 0.1)
            U.Tween(stroke, { Color = Theme.StrokeHover }, 0.1)
            fromX(input.Position.X)
        end
    end)

    U.Connect(UserInputService.InputChanged, function(input)
        if dragging and U.IsMove(input) then
            fromX(input.Position.X)
        end
    end)

    U.Connect(UserInputService.InputEnded, function(input)
        if dragging and U.IsPointer(input) then
            dragging = false
            U.Tween(knob, { Size = UDim2.fromOffset(12, 12) }, 0.1)
            U.Tween(stroke, { Color = Theme.Stroke }, 0.2)
        end
    end)

    return Base.Finish(section, opts, obj, card, "Slider")
end
