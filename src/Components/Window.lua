--[[ Lumen UI - Window: draggable shell with sidebar, header + search, pages and profile card
    local Window = Lumen:CreateWindow({
        Title = "Example UI", Version = "v1.0", Size = UDim2.fromOffset(780, 540),
        Keybind = Enum.KeyCode.RightShift, Logo = nil, Profile = true, Subtitle = nil,
    })
    Window:Home({...})            -- dashboard tab ("Welcome to <Title>!")
    Window:Tab({ Name, Icon })    -- regular tab
    Window:SelectTab(tab)  Window:Toggle()  Window:Notify({...})  Window:Destroy()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Icons = Lumen.Icons

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local SIDEBAR = 188
local HEADER = 60

local Window = {}
Window.__index = Window

function Window:Tab(opts)
    local tab = Lumen.NewTab(self, opts)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab
end

function Window:Home(opts)
    opts = opts or {}
    local tab = self:Tab({
        Name = opts.Name or "Home",
        Icon = opts.Icon or "home",
        Title = opts.Title or ("Welcome to " .. self.Title .. "!"),
    })
    local dashboardOpts = {}
    for key, value in pairs(opts) do
        dashboardOpts[key] = value
    end
    dashboardOpts.Version = dashboardOpts.Version or self.Version
    tab:Dashboard(dashboardOpts)
    self.HomeTab = tab
    return tab
end

function Window:_setHeader(tab)
    self._headerTitle.Text = tab.Title
    if self._headerIcon then
        self._headerIcon:Destroy()
    end
    self._headerIcon = Icons.Create(self._header, tab.Icon, 20, Theme.Accent, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 24, 0.5, 0),
    })
end

function Window:SelectTab(tab)
    if self.ActiveTab == tab then
        return
    end
    if self.ActiveTab then
        self.ActiveTab:Filter("")
        self.ActiveTab:_setActive(false)
    end
    self.ActiveTab = tab
    tab:_setActive(true)
    self._search.Text = ""
    self:_setHeader(tab)
end

function Window:_removeTab(tab)
    for index, item in ipairs(self.Tabs) do
        if item == tab then
            table.remove(self.Tabs, index)
            break
        end
    end
    if self.ActiveTab == tab then
        self.ActiveTab = nil
        if self.Tabs[1] then
            self:SelectTab(self.Tabs[1])
        end
    end
end

function Window:Notify(opts)
    Lumen:Notify(opts)
end

function Window:SetVisible(visible)
    self.Main.Visible = visible and true or false
    self._restore.Visible = not self.Main.Visible
end

function Window:Toggle()
    self:SetVisible(not self.Main.Visible)
end

function Window:Destroy()
    for index, window in ipairs(Lumen.Windows) do
        if window == self then
            table.remove(Lumen.Windows, index)
            break
        end
    end
    self.Gui:Destroy()
end

function Lumen:CreateWindow(opts)
    if type(opts) == "string" then
        opts = { Title = opts }
    end
    opts = opts or {}

    if opts.Logo then
        Lumen.LogoImage = opts.Logo
    end

    local window = setmetatable({
        Title = tostring(opts.Title or "Lumen UI"),
        Version = tostring(opts.Version or "v1.0"),
        Keybind = opts.Keybind or Enum.KeyCode.RightShift,
        Tabs = {},
    }, Window)

    local size = opts.Size or UDim2.fromOffset(780, 540)
    local camera = workspace.CurrentCamera
    if camera and size.X.Scale == 0 and size.Y.Scale == 0 then
        local view = camera.ViewportSize
        size = UDim2.fromOffset(math.min(size.X.Offset, view.X - 24), math.min(size.Y.Offset, view.Y - 24))
    end

    local gui = U.NewGui("LumenUI", 100)
    window.Gui = gui

    local main = U.Box({
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Parent = gui,
    })
    U.Corner(main, 12)
    U.Stroke(main, Theme.Stroke, 1)
    window.Main = main

    -------------------------------------------------------------------
    -- Sidebar
    -------------------------------------------------------------------
    local sidebar = U.Box({
        Name = "Sidebar",
        Size = UDim2.new(0, SIDEBAR, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        Parent = main,
    })
    U.Box({
        Name = "Divider",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = Theme.Stroke,
        Parent = sidebar,
    })

    local brand = U.Frame({
        Name = "Brand",
        Size = UDim2.new(1, 0, 0, 68),
        Parent = sidebar,
    })
    Lumen.Logo(brand, 28, { Position = UDim2.fromOffset(16, 18) })
    U.Label({
        Position = UDim2.fromOffset(54, 17),
        Size = UDim2.new(1, -62, 0, 16),
        Text = window.Title,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = brand,
    })
    U.Label({
        Position = UDim2.fromOffset(54, 33),
        Size = UDim2.new(1, -62, 0, 14),
        Font = Theme.FontRegular,
        Text = window.Version,
        TextSize = 11,
        TextColor3 = Theme.Muted,
        Parent = brand,
    })

    local showProfile = opts.Profile ~= false
    window._tabList = U.New("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(10, 74),
        Size = UDim2.new(1, -20, 1, showProfile and -146 or -84),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar,
    })
    U.List(window._tabList, 4)

    -------------------------------------------------------------------
    -- Profile card
    -------------------------------------------------------------------
    if showProfile then
        local profile = U.Button({
            Name = "Profile",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 10, 1, -10),
            Size = UDim2.new(1, -20, 0, 52),
            BackgroundColor3 = Theme.Element,
            BackgroundTransparency = 0.3,
            Parent = sidebar,
        })
        U.Corner(profile, 10)
        local profileStroke = U.Stroke(profile, Theme.Stroke, 1)

        local avatar = U.Image({
            Position = UDim2.fromOffset(10, 10),
            Size = UDim2.fromOffset(32, 32),
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0,
            Parent = profile,
        })
        U.Corner(avatar, "full")
        local dot = U.Box({
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 1, 1, 1),
            Size = UDim2.fromOffset(10, 10),
            BackgroundColor3 = Theme.Online,
            Parent = avatar,
        })
        U.Corner(dot, "full")
        U.Stroke(dot, Theme.Sidebar, 2)

        local nameLabel = U.Label({
            Position = UDim2.fromOffset(52, 10),
            Size = UDim2.new(1, -78, 0, 16),
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = profile,
        })
        local subLabel = U.Label({
            Position = UDim2.fromOffset(52, 27),
            Size = UDim2.new(1, -78, 0, 14),
            Font = Theme.FontRegular,
            Text = tostring(opts.Subtitle or game.Name),
            TextSize = 11,
            TextColor3 = Theme.Muted,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = profile,
        })
        Icons.Create(profile, "chevron-right", 12, Theme.Muted, {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -12, 0.5, 0),
        })

        if not opts.Subtitle then
            U.GameInfo(function(info)
                subLabel.Text = info.Name
            end)
        end
        Lumen.Privacy:Bind(function(hideName, hideAvatar)
            nameLabel.Text = hideName and "Hidden" or LocalPlayer.DisplayName
            avatar.ImageTransparency = hideAvatar and 1 or 0
        end)

        U.Hover(profile, function()
            U.Tween(profileStroke, { Color = Theme.StrokeHover }, 0.12)
        end, function()
            U.Tween(profileStroke, { Color = Theme.Stroke }, 0.2)
        end)
        U.Connect(profile.MouseButton1Click, function()
            local target = window.HomeTab or window.Tabs[1]
            if target then
                window:SelectTab(target)
            end
        end)
    end

    -------------------------------------------------------------------
    -- Content: header + pages
    -------------------------------------------------------------------
    local content = U.Frame({
        Name = "Content",
        Position = UDim2.fromOffset(SIDEBAR, 0),
        Size = UDim2.new(1, -SIDEBAR, 1, 0),
        Parent = main,
    })

    local header = U.Frame({
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER),
        Parent = content,
    })
    window._header = header
    window._headerTitle = U.Label({
        Position = UDim2.fromOffset(54, 0),
        Size = UDim2.new(1, -330, 1, 0),
        Font = Theme.FontMedium,
        TextSize = 20,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })

    -- Search
    local search = U.Box({
        Name = "Search",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -60, 0.5, 0),
        Size = UDim2.fromOffset(210, 34),
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = 0.3,
        Parent = header,
    })
    U.Corner(search, 8)
    local searchStroke = U.Stroke(search, Theme.Stroke, 1)
    Icons.Create(search, "search", 14, Theme.Muted, {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
    })
    local box = U.New("TextBox", {
        Name = "Input",
        Position = UDim2.fromOffset(34, 0),
        Size = UDim2.new(1, -44, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Theme.FontRegular,
        PlaceholderText = "Search",
        PlaceholderColor3 = Theme.Muted,
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = search,
    })
    window._search = box
    U.Connect(box:GetPropertyChangedSignal("Text"), function()
        if window.ActiveTab then
            window.ActiveTab:Filter(box.Text)
        end
    end)
    U.Connect(box.Focused, function()
        U.Tween(searchStroke, { Color = Theme.Accent }, 0.15)
    end)
    U.Connect(box.FocusLost, function()
        U.Tween(searchStroke, { Color = Theme.Stroke }, 0.2)
    end)

    -- Collapse button
    local collapse = U.Button({
        Name = "Collapse",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -20, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        Parent = header,
    })
    local collapseIcon = Icons.Create(collapse, Icons.Resolve("minimize-2") and "minimize-2" or "minus", 16, Theme.Muted, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
    })
    U.Hover(collapse, function()
        collapseIcon:SetColor(Theme.Text)
    end, function()
        collapseIcon:SetColor(Theme.Muted)
    end)
    U.Connect(collapse.MouseButton1Click, function()
        window:SetVisible(false)
    end)

    window._pages = U.Frame({
        Name = "Pages",
        Position = UDim2.fromOffset(0, HEADER),
        Size = UDim2.new(1, 0, 1, -HEADER),
        ClipsDescendants = true,
        Parent = content,
    })

    -------------------------------------------------------------------
    -- Restore button, dragging, keybind
    -------------------------------------------------------------------
    local restore = U.Button({
        Name = "Restore",
        Position = UDim2.fromOffset(16, 16),
        Size = UDim2.fromOffset(44, 44),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0,
        Visible = false,
        Parent = gui,
    })
    U.Corner(restore, 12)
    U.Stroke(restore, Theme.Stroke, 1)
    Lumen.Logo(restore, 24, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
    })
    U.Connect(restore.MouseButton1Click, function()
        window:SetVisible(true)
    end)
    window._restore = restore

    U.Drag(header, main)
    U.Drag(brand, main)

    U.Connect(UserInputService.InputBegan, function(input, processed)
        if not processed and input.KeyCode == window.Keybind then
            window:Toggle()
        end
    end)

    table.insert(Lumen.Windows, window)
    return window
end
