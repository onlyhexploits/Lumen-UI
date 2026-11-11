--[[ Lumen UI - Toggle
    Section:Toggle({ Name, Description, Default, Flag, Callback = function(value) end })
    Methods: Set(value, silent), Get(), Fire(), SetVisible(bool), Destroy()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Base = Lumen.Base

local TRACK_W, TRACK_H, KNOB = 36, 20, 14

Lumen.Elements.Toggle = function(section, opts)
    opts = Base.Opts(opts, "Toggle")

    local card, stroke = Base.Card(section, 40, true)
    Base.Text(card, opts, TRACK_W + 16)

    local track = U.Box({
        Name = "Track",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(TRACK_W, TRACK_H),
        BackgroundColor3 = Theme.Track,
        Parent = card,
    })
    U.Corner(track, "full")

    local knob = U.Box({
        Name = "Knob",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(KNOB, KNOB),
        BackgroundColor3 = Theme.Muted,
        Parent = track,
    })
    U.Corner(knob, "full")

    local state = opts.Default == true or opts.Value == true
    local obj = {}

    local function render(animate)
        local position = UDim2.new(0, state and (TRACK_W - 3 - KNOB) or 3, 0.5, 0)
        local trackColor = state and Theme.Accent or Theme.Track
        local knobColor = state and Theme.AccentDark or Theme.Muted
        if animate then
            U.Tween(knob, { Position = position, BackgroundColor3 = knobColor }, 0.15)
            U.Tween(track, { BackgroundColor3 = trackColor }, 0.15)
        else
            knob.Position = position
            knob.BackgroundColor3 = knobColor
            track.BackgroundColor3 = trackColor
        end
    end
    render(false)

    function obj:Set(value, silent)
        value = value and true or false
        if value == state then
            return
        end
        state = value
        render(true)
        if not silent then
            U.Safe(opts.Callback, state)
        end
    end

    function obj:Get()
        return state
    end

    function obj:Toggle()
        self:Set(not state)
    end

    U.Connect(card.MouseButton1Click, function()
        obj:Set(not state)
    end)
    Base.Hover(card, stroke, card)

    return Base.Finish(section, opts, obj, card, "Toggle")
end
