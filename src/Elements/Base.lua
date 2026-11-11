--[[ Lumen UI - Base: shared row/card builder and common element behavior ]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme

local Base = {}

-- Accepts "Name" or { Name = ..., Description = ... }; Title/Text/Desc are aliases.
function Base.Opts(opts, fallbackName)
    if type(opts) == "string" then
        opts = { Name = opts }
    end
    local out = {}
    for key, value in pairs(opts or {}) do
        out[key] = value
    end
    out.Name = out.Name or out.Title or out.Text or fallbackName
    out.Description = out.Description or out.Desc
    return out
end

-- The rounded row every element lives in. Pass asButton for clickable rows.
-- noPad lets the element manage its own inner padding (Dropdown).
function Base.Card(section, minHeight, asButton, noPad)
    local props = {
        Name = "Element",
        Size = UDim2.new(1, 0, 0, minHeight or 40),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = 0.3,
        LayoutOrder = section:_nextOrder(),
        Parent = section.Content,
    }
    local card = asButton and U.Button(props) or U.Box(props)
    if asButton then
        card.BackgroundTransparency = 0.3
    end
    U.Corner(card, Theme.SmallRadius)
    local stroke = U.Stroke(card, Theme.Stroke, 1)
    if not noPad then
        U.Pad(card, 12, 12, 12, 12)
    end
    return card, stroke
end

-- Name + optional description stacked on the left. Returns holder, name, description.
function Base.Text(card, opts, rightReserve)
    local holder = U.Frame({
        Name = "Text",
        Size = UDim2.new(1, -(rightReserve or 0), 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    U.List(holder, 2)

    local name = U.Label({
        Name = "Name",
        Size = UDim2.new(1, 0, 0, 16),
        Text = tostring(opts.Name or ""),
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        Parent = holder,
    })

    local desc = U.Label({
        Name = "Description",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Theme.FontRegular,
        Text = tostring(opts.Description or ""),
        TextSize = 12,
        TextColor3 = Theme.Muted,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        RichText = true,
        Visible = opts.Description ~= nil and opts.Description ~= "",
        LayoutOrder = 2,
        Parent = holder,
    })

    return holder, name, desc
end

-- Border highlight on hover, shared by all clickable rows.
function Base.Hover(target, stroke, card)
    U.Hover(target, function()
        U.Tween(stroke, { Color = Theme.StrokeHover }, 0.12)
        U.Tween(card, { BackgroundTransparency = 0.1 }, 0.12)
    end, function()
        U.Tween(stroke, { Color = Theme.Stroke }, 0.2)
        U.Tween(card, { BackgroundTransparency = 0.3 }, 0.2)
    end)
end

-- Adds the behavior every element shares and registers it with its section.
function Base.Finish(section, opts, obj, card, kind)
    obj.Kind = kind
    obj.Frame = card
    obj.Section = section
    obj.Flag = opts.Flag
    obj._callback = opts.Callback
    obj._name = string.lower(tostring(opts.Name or ""))
    obj._desc = string.lower(tostring(opts.Description or opts.Content or ""))
    obj._visible = opts.Visible ~= false
    obj._match = true

    function obj:_apply()
        self.Frame.Visible = self._visible and self._match
    end

    function obj:SetVisible(visible)
        self._visible = visible and true or false
        self:_apply()
    end

    function obj:Fire()
        U.Safe(self._callback, self:Get())
    end

    function obj:Destroy()
        for index, item in ipairs(section.Items) do
            if item == self then
                table.remove(section.Items, index)
                break
            end
        end
        if self.Flag and Lumen.Flags[self.Flag] == self then
            Lumen.Flags[self.Flag] = nil
        end
        self.Frame:Destroy()
    end

    if obj.Get == nil then
        function obj:Get()
            return nil
        end
    end

    table.insert(section.Items, obj)
    if opts.Flag then
        Lumen.Flags[opts.Flag] = obj
    end
    obj:_apply()
    return obj
end

Lumen.Base = Base
