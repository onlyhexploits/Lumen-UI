--[[ Lumen UI - Tab: sidebar entry + scrolling page with Top (dashboard) area and Left/Right columns
    Window:Tab({ Name, Icon, Title })
    tab:Section({ Name, Icon, Side })   tab:Dashboard({...})   tab:Select()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Icons = Lumen.Icons

local Tab = {}
Tab.__index = Tab

function Tab:Section(opts)
    return Lumen.NewSection(self, opts)
end

function Tab:Dashboard(opts)
    return Lumen.Dashboard.Create(self, opts)
end

function Tab:Select()
    self.Window:SelectTab(self)
end

function Tab:Filter(query)
    for _, section in ipairs(self.Sections) do
        section:Filter(query)
    end
end

function Tab:_setActive(active)
    self.Active = active
    U.Tween(self._background, { BackgroundTransparency = active and 0.1 or 1 }, 0.15)
    U.Tween(self._label, { TextColor3 = active and Theme.Text or Theme.Muted }, 0.15)
    self._icon:SetColor(active and Theme.Accent or Theme.Muted)
    self.Page.Visible = active
end

function Tab:Destroy()
    self.Window:_removeTab(self)
    self.Button:Destroy()
    self.Page:Destroy()
end

function Lumen.NewTab(window, opts)
    if type(opts) == "string" then
        opts = { Name = opts }
    end
    opts = opts or {}

    local name = tostring(opts.Name or "Tab")
    local tab = setmetatable({
        Name = name,
        Title = tostring(opts.Title or name),
        Icon = opts.Icon,
        Window = window,
        Sections = {},
        Active = false,
        _counts = { Left = 0, Right = 0 },
    }, Tab)

    -- Sidebar button
    local button = U.Button({
        Name = name,
        Size = UDim2.new(1, 0, 0, 34),
        LayoutOrder = #window.Tabs + 1,
        Parent = window._tabList,
    })
    local background = U.Box({
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = 1,
        Parent = button,
    })
    U.Corner(background, Theme.SmallRadius)
    local icon = Icons.Create(button, opts.Icon, 16, Theme.Muted, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
    })
    local label = U.Label({
        Name = "Label",
        Position = UDim2.fromOffset(38, 0),
        Size = UDim2.new(1, -46, 1, 0),
        Text = name,
        TextColor3 = Theme.Muted,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = button,
    })

    U.Connect(button.MouseEnter, function()
        if not tab.Active then
            U.Tween(background, { BackgroundTransparency = 0.6 }, 0.12)
        end
    end)
    U.Connect(button.MouseLeave, function()
        if not tab.Active then
            U.Tween(background, { BackgroundTransparency = 1 }, 0.2)
        end
    end)
    U.Connect(button.MouseButton1Click, function()
        window:SelectTab(tab)
    end)

    -- Page
    local page = U.New("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.StrokeHover,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = false,
        Parent = window._pages,
    })
    U.Pad(page, 16, 12, 2, 16)
    U.List(page, 10)

    tab.Top = U.Frame({
        Name = "Top",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Parent = page,
    })
    U.List(tab.Top, 10)

    local columns = U.Frame({
        Name = "Columns",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Parent = page,
    })
    U.List(columns, 10, {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    })

    for index, side in ipairs({ "Left", "Right" }) do
        local column = U.Frame({
            Name = side,
            Size = UDim2.new(0.5, -5, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = index,
            Parent = columns,
        })
        U.List(column, 10)
        tab[side] = column
    end

    tab.Button = button
    tab.Page = page
    tab._background = background
    tab._label = label
    tab._icon = icon

    return tab
end
