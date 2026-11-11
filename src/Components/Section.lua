--[[ Lumen UI - Section: a titled card that holds elements
    Tab:Section({ Name, Icon, Side = "Left" | "Right" })   -- no Side = balance between the columns
    Elements: section:Toggle / :Button / :Slider / :Dropdown / :Paragraph
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Icons = Lumen.Icons

local Section = {}
Section.__index = Section

function Section:_nextOrder()
    self._order = self._order + 1
    return self._order
end

-- Shows only matching elements. Returns true when anything in the section is visible.
function Section:Filter(query)
    query = string.lower(query or "")
    local sectionHit = query == "" or string.find(string.lower(self.Name), query, 1, true) ~= nil
    local any = sectionHit
    for _, item in ipairs(self.Items) do
        local hit = sectionHit
            or string.find(item._name, query, 1, true) ~= nil
            or string.find(item._desc, query, 1, true) ~= nil
        item._match = hit
        item:_apply()
        if hit then
            any = true
        end
    end
    self._match = any
    self.Frame.Visible = any and self._visible
    return any
end

function Section:SetVisible(visible)
    self._visible = visible and true or false
    self.Frame.Visible = self._visible and self._match
end

function Section:SetName(text)
    self.Name = tostring(text)
    self._title.Text = self.Name
end

function Section:Destroy()
    for index, section in ipairs(self.Tab.Sections) do
        if section == self then
            table.remove(self.Tab.Sections, index)
            break
        end
    end
    self.Frame:Destroy()
end

function Lumen.NewSection(tab, opts)
    if type(opts) == "string" then
        opts = { Name = opts }
    end
    opts = opts or {}

    local side = string.lower(tostring(opts.Side or ""))
    local column = nil
    if side == "left" then
        column = "Left"
    elseif side == "right" then
        column = "Right"
    else
        column = tab._counts.Left <= tab._counts.Right and "Left" or "Right"
    end
    tab._counts[column] = tab._counts[column] + 1

    local section = setmetatable({
        Name = tostring(opts.Name or "Section"),
        Side = column,
        Tab = tab,
        Items = {},
        _order = 0,
        _visible = opts.Visible ~= false,
        _match = true,
    }, Section)

    local frame = U.Box({
        Name = "Section",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Card,
        LayoutOrder = tab._counts[column],
        Parent = tab[column],
    })
    U.Corner(frame, Theme.Radius)
    U.Stroke(frame, Theme.Stroke, 1)
    U.List(frame, 0)

    local header = U.Frame({
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        LayoutOrder = 1,
        Parent = frame,
    })
    local textX = 16
    if opts.Icon then
        Icons.Create(header, opts.Icon, 14, Theme.Accent, {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 16, 0.5, 0),
        })
        textX = 38
    end
    section._title = U.Label({
        Name = "Title",
        Position = UDim2.fromOffset(textX, 0),
        Size = UDim2.new(1, -(textX + 16), 1, 0),
        Text = section.Name,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })

    local content = U.Frame({
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Parent = frame,
    })
    U.Pad(content, 12, 12, 0, 12)
    U.List(content, 8)

    section.Frame = frame
    section.Content = content
    frame.Visible = section._visible

    for name, builder in pairs(Lumen.Elements) do
        section[name] = builder
    end

    table.insert(tab.Sections, section)
    return section
end
