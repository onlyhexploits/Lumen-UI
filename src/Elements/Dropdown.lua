--[[ Lumen UI - Dropdown (expands inline, so it is never clipped by its section)
    Section:Dropdown({ Name, Options = {"A","B"}, Default = "A" | {"A","B"}, Multi = false, Opened = false,
                       Flag, Callback = function(value) end })
    Single mode returns a string (or nil); Multi mode returns an array of strings.
    Methods: Set(value, silent), Get(), Refresh(options, keepSelection), SetOpen(bool), Fire(), SetVisible(bool), Destroy()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Base = Lumen.Base
local Icons = Lumen.Icons

local ROW = 26
local MAX_LIST = 164

Lumen.Elements.Dropdown = function(section, opts)
    opts = Base.Opts(opts, "Dropdown")

    local multi = opts.Multi == true
    local options = {}
    for _, option in ipairs(opts.Options or opts.Values or {}) do
        table.insert(options, tostring(option))
    end
    local selected = {}
    local open = false
    local rows = {}

    local card, stroke = Base.Card(section, 40, false, true)
    card.ClipsDescendants = true
    U.List(card, 0)

    local header = U.Button({
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        LayoutOrder = 1,
        Parent = card,
    })

    U.Label({
        Name = "Name",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.new(1, -170, 0, 16),
        Text = tostring(opts.Name or "Dropdown"),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })

    local valueLabel = U.Label({
        Name = "Value",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.fromOffset(130, 16),
        Font = Theme.FontRegular,
        TextColor3 = Theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })

    local chevron = Icons.Create(header, "chevron-down", 12, Theme.Muted, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
    })

    local list = U.New("ScrollingFrame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.StrokeHover,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = false,
        LayoutOrder = 2,
        Parent = card,
    })
    U.Pad(list, 6, 6, 0, 6)
    U.List(list, 2)

    local obj = {}

    local function ordered()
        local result = {}
        for _, option in ipairs(options) do
            if selected[option] then
                table.insert(result, option)
            end
        end
        return result
    end

    local function summary()
        local chosen = ordered()
        if #chosen == 0 then
            return "None"
        elseif #chosen > 2 then
            return #chosen .. " selected"
        end
        return table.concat(chosen, ", ")
    end

    local function paintRows()
        for _, row in ipairs(rows) do
            local on = selected[row.Option] == true
            row.Background.BackgroundTransparency = on and 0.85 or 1
            row.Label.TextColor3 = on and Theme.Accent or Theme.Text
        end
        valueLabel.Text = summary()
    end

    local function fire()
        U.Safe(opts.Callback, obj:Get())
    end

    local function pick(option)
        if multi then
            selected[option] = not selected[option] or nil
        else
            selected = { [option] = true }
        end
        paintRows()
        fire()
        if not multi then
            obj:SetOpen(false)
        end
    end

    local function build()
        for _, row in ipairs(rows) do
            row.Button:Destroy()
        end
        rows = {}
        for index, option in ipairs(options) do
            local button = U.Button({
                Name = "Option",
                Size = UDim2.new(1, 0, 0, ROW),
                LayoutOrder = index,
                Parent = list,
            })
            local background = U.Box({
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                Parent = button,
            })
            U.Corner(background, 6)
            local label = U.Label({
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Theme.FontRegular,
                Text = option,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = button,
            })
            U.Connect(button.MouseButton1Click, function()
                pick(option)
            end)
            U.Connect(button.MouseEnter, function()
                if not selected[option] then
                    background.BackgroundColor3 = Theme.ElementHover
                    background.BackgroundTransparency = 0.4
                end
            end)
            U.Connect(button.MouseLeave, function()
                background.BackgroundColor3 = Theme.Accent
                background.BackgroundTransparency = selected[option] and 0.85 or 1
            end)
            table.insert(rows, { Option = option, Button = button, Background = background, Label = label })
        end
        local height = math.min(#options * (ROW + 2) + 6, MAX_LIST)
        list.Size = UDim2.new(1, 0, 0, height)
        paintRows()
    end

    local function applyValue(value)
        selected = {}
        if multi then
            if type(value) == "table" then
                for _, option in ipairs(value) do
                    selected[tostring(option)] = true
                end
            end
        elseif value ~= nil then
            selected[tostring(value)] = true
        end
    end

    function obj:SetOpen(state)
        open = state and true or false
        list.Visible = open
        U.Tween(chevron.Instance, { Rotation = open and 180 or 0 }, 0.15)
        U.Tween(stroke, { Color = open and Theme.StrokeHover or Theme.Stroke }, 0.15)
    end

    function obj:Get()
        if multi then
            return ordered()
        end
        return ordered()[1]
    end

    function obj:Set(value, silent)
        applyValue(value)
        paintRows()
        if not silent then
            fire()
        end
    end

    function obj:Refresh(newOptions, keepSelection)
        options = {}
        for _, option in ipairs(newOptions or {}) do
            table.insert(options, tostring(option))
        end
        if keepSelection then
            local kept = {}
            for _, option in ipairs(options) do
                kept[option] = selected[option]
            end
            selected = kept
        else
            selected = {}
        end
        build()
    end

    applyValue(opts.Default or opts.Value)
    build()

    U.Connect(header.MouseButton1Click, function()
        obj:SetOpen(not open)
    end)
    U.Hover(header, function()
        if not open then
            U.Tween(stroke, { Color = Theme.StrokeHover }, 0.12)
        end
    end, function()
        if not open then
            U.Tween(stroke, { Color = Theme.Stroke }, 0.2)
        end
    end)

    if opts.Opened then
        obj:SetOpen(true)
    end

    return Base.Finish(section, opts, obj, card, "Dropdown")
end
