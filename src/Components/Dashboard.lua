--[[ Lumen UI - Dashboard: welcome card, FPS / ping graphs, server card with quick actions
    tab:Dashboard({
        Welcome   = "Welcome back",     -- small caption above the player name
        Version   = "v1.0",             -- accent chip
        Thumbnail = "rbxassetid://...", -- optional game icon override
        Actions   = {                   -- every key optional
            Rejoin = function() end, Hop = function() end, Lowest = function() end, JobId = function() end,
        },
    })
    Rejoin and JobId have working defaults. Hop defaults to teleporting to the place again.
    Lowest needs your own server-list logic, so it only notifies until you provide Actions.Lowest.
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Icons = Lumen.Icons

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local SAMPLES = 36

local Dashboard = {}

---------------------------------------------------------------------------
-- Shared bits
---------------------------------------------------------------------------

-- The ring logo. Set Lumen.LogoImage (or the Logo window option) to use an image instead.
function Lumen.Logo(parent, size, props)
    local logo = nil
    if Lumen.LogoImage then
        logo = U.Image({ Size = UDim2.fromOffset(size, size), Image = Lumen.LogoImage, Parent = parent })
    else
        logo = U.Frame({ Size = UDim2.fromOffset(size, size), Parent = parent })
        U.Corner(logo, "full")
        U.Stroke(logo, Theme.Accent, math.max(2, math.floor(size / 9)))
    end
    for key, value in pairs(props or {}) do
        logo[key] = value
    end
    return logo
end

local function card(parent, order, height)
    local frame = U.Box({
        Name = "Card",
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.Card,
        LayoutOrder = order,
        ClipsDescendants = true,
        Parent = parent,
    })
    U.Corner(frame, Theme.Radius)
    U.Stroke(frame, Theme.Stroke, 1)
    return frame
end

local function chip(parent, order, iconName, text, color, onClick)
    local button = U.Button({
        Name = text,
        Size = UDim2.fromOffset(0, 26),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = 0.2,
        LayoutOrder = order,
        Parent = parent,
    })
    U.Corner(button, 6)
    local stroke = U.Stroke(button, Theme.Stroke, 1)
    U.Pad(button, 8, 10, 0, 0)
    U.List(button, 6, {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    local icon = nil
    if iconName == "logo" then
        icon = { Instance = Lumen.Logo(button, 13, { LayoutOrder = 1 }), SetColor = function() end }
    else
        icon = Icons.Create(button, iconName, 13, color, { LayoutOrder = 1 })
    end
    local label = U.Label({
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        TextSize = 12,
        TextColor3 = color,
        LayoutOrder = 2,
        Parent = button,
    })

    local chipObj = {}
    function chipObj.SetActive(active)
        local tint = active and Theme.Accent or Theme.Muted
        label.TextColor3 = tint
        icon:SetColor(tint)
        stroke.Color = active and Theme.Accent or Theme.Stroke
    end

    if onClick then
        U.Connect(button.MouseButton1Click, onClick)
    else
        button.Active = false
    end
    return button, chipObj
end

---------------------------------------------------------------------------
-- Welcome card
---------------------------------------------------------------------------

local function buildWelcome(top, opts)
    local frame = card(top, 1, 142)

    local avatar = U.Image({
        Name = "Avatar",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, 0),
        Size = UDim2.fromOffset(150, 150),
        Image = "rbxthumb://type=AvatarBust&id=" .. LocalPlayer.UserId .. "&w=420&h=420",
        Parent = frame,
    })
    U.New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.45, 0),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Parent = avatar,
    })

    U.Label({
        Name = "Caption",
        Position = UDim2.fromOffset(22, 20),
        Size = UDim2.new(1, -200, 0, 14),
        Text = string.upper(opts.Welcome or "Welcome back"),
        TextSize = 11,
        TextColor3 = Theme.Muted,
        Parent = frame,
    })
    local nameLabel = U.Label({
        Name = "DisplayName",
        Position = UDim2.fromOffset(22, 36),
        Size = UDim2.new(1, -200, 0, 30),
        Font = Theme.FontBold,
        TextSize = 24,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    })
    local userLabel = U.Label({
        Name = "Username",
        Position = UDim2.fromOffset(22, 67),
        Size = UDim2.new(1, -200, 0, 16),
        Font = Theme.FontRegular,
        TextColor3 = Theme.Muted,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    })

    local chips = U.Frame({
        Name = "Chips",
        Position = UDim2.new(0, 22, 1, -40),
        Size = UDim2.new(1, -44, 0, 26),
        Parent = frame,
    })
    U.List(chips, 6, {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    local _, versionChip = chip(chips, 1, "logo", tostring(opts.Version or "v1.0"), Theme.Accent, nil)
    versionChip.SetActive(true)
    local _, nameChip = chip(chips, 2, "eye-off", "Name", Theme.Muted, function()
        Lumen.Privacy:Set("Name", not Lumen.Privacy.HideName)
    end)
    local _, avatarChip = chip(chips, 3, "user-x", "Avatar", Theme.Muted, function()
        Lumen.Privacy:Set("Avatar", not Lumen.Privacy.HideAvatar)
    end)

    Lumen.Privacy:Bind(function(hideName, hideAvatar)
        nameLabel.Text = hideName and "Hidden" or LocalPlayer.DisplayName
        userLabel.Text = hideName and "@hidden" or ("@" .. LocalPlayer.Name)
        avatar.ImageTransparency = hideAvatar and 1 or 0
        nameChip.SetActive(hideName)
        avatarChip.SetActive(hideAvatar)
    end)
    return frame
end

---------------------------------------------------------------------------
-- FPS / Ping graphs
---------------------------------------------------------------------------

local function readPing()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then
        return value
    end
    return 0
end

local function metric(parent, position, caption, unit, dim, bright, scaleFloor)
    local frame = U.Frame({
        Name = caption,
        Position = position,
        Size = UDim2.new(0.5, -28, 0, 94),
        Parent = parent,
    })

    U.Label({
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0.3, 0, 0, 14),
        Font = Theme.FontMedium,
        Text = caption,
        TextSize = 11,
        TextColor3 = Theme.Muted,
        Parent = frame,
    })
    local rangeLabel = U.Label({
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0.7, 0, 0, 14),
        Font = Theme.FontRegular,
        TextSize = 11,
        TextColor3 = Theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Right,
        RichText = true,
        Parent = frame,
    })

    local valueRow = U.Frame({
        Position = UDim2.fromOffset(0, 18),
        Size = UDim2.new(1, 0, 0, 26),
        Parent = frame,
    })
    U.List(valueRow, 4, {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
    local valueLabel = U.Label({
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Theme.FontBold,
        Text = "0",
        TextSize = 22,
        LayoutOrder = 1,
        Parent = valueRow,
    })
    U.Label({
        Size = UDim2.new(0, 0, 0, 20),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Theme.FontRegular,
        Text = unit,
        TextSize = 12,
        TextColor3 = Theme.Muted,
        LayoutOrder = 2,
        Parent = valueRow,
    })

    local graph = U.Frame({
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(1, 0, 0, 42),
        Parent = frame,
    })
    U.List(graph, 2, {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
    local bars = {}
    for index = 1, SAMPLES do
        local bar = U.Box({
            Name = "Bar",
            Size = UDim2.new(1 / SAMPLES, -2, 0.03, 0),
            BackgroundColor3 = dim,
            BackgroundTransparency = 1,
            LayoutOrder = index,
            Parent = graph,
        })
        U.Corner(bar, 1)
        bars[index] = bar
    end

    local history = {}
    local lowest = nil
    local highest = 0
    local textHex = U.Hex(Theme.Text)

    local m = {}
    function m.Push(value)
        table.insert(history, value)
        if #history > SAMPLES then
            table.remove(history, 1)
        end
        lowest = lowest and math.min(lowest, value) or value
        highest = math.max(highest, value)

        local sum = 0
        local scale = scaleFloor
        for _, sample in ipairs(history) do
            sum = sum + sample
            scale = math.max(scale, sample)
        end

        valueLabel.Text = tostring(math.floor(value + 0.5))
        rangeLabel.Text = string.format(
            'min <font color="%s"><b>%d</b></font>   avg <font color="%s"><b>%d</b></font>   max <font color="%s"><b>%d</b></font>',
            textHex, math.floor(lowest + 0.5),
            textHex, math.floor(sum / #history + 0.5),
            textHex, math.floor(highest + 0.5)
        )

        local offset = SAMPLES - #history
        for index, bar in ipairs(bars) do
            local sample = history[index - offset]
            if sample then
                bar.BackgroundTransparency = 0
                bar.BackgroundColor3 = index == SAMPLES and bright or dim
                bar.Size = UDim2.new(1 / SAMPLES, -2, math.max(0.03, math.min(1, sample / scale)), 0)
            end
        end
    end
    return m
end

local function statBlock(parent, position, caption)
    local frame = U.Frame({
        Name = caption,
        Position = position,
        Size = UDim2.new(0.5, -28, 0, 36),
        Parent = parent,
    })
    local value = U.Label({
        Size = UDim2.new(1, 0, 0, 18),
        Font = Theme.FontBold,
        Text = "-",
        TextSize = 15,
        Parent = frame,
    })
    U.Label({
        Position = UDim2.fromOffset(0, 20),
        Size = UDim2.new(1, 0, 0, 14),
        Font = Theme.FontRegular,
        Text = caption,
        TextSize = 11,
        TextColor3 = Theme.Muted,
        Parent = frame,
    })
    return value
end

local function buildStats(top)
    local frame = card(top, 2, 158)

    local fps = metric(frame, UDim2.fromOffset(16, 14), "FPS", "fps", Color3.fromRGB(62, 122, 72), Color3.fromRGB(128, 224, 140), 60)
    local ping = metric(frame, UDim2.new(0.5, 12, 0, 14), "Ping", "ms", Color3.fromRGB(150, 62, 62), Color3.fromRGB(240, 96, 96), 120)
    local players = statBlock(frame, UDim2.fromOffset(16, 114), "Players")
    local session = statBlock(frame, UDim2.new(0.5, 12, 0, 114), "Session")

    local frames = 0
    local last = os.clock()
    local started = last
    U.Connect(RunService.RenderStepped, function()
        frames = frames + 1
    end)

    task.spawn(function()
        while frame:IsDescendantOf(game) do
            task.wait(0.5)
            local now = os.clock()
            fps.Push(frames / math.max(now - last, 0.001))
            frames = 0
            last = now
            ping.Push(readPing())
            players.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            session.Text = U.Duration(now - started)
        end
    end)
    return frame
end

---------------------------------------------------------------------------
-- Server card
---------------------------------------------------------------------------

local function notify(title, content, kind)
    Lumen:Notify({ Title = title, Content = content, Type = kind, Duration = 3 })
end

local function defaultActions(custom)
    local actions = {}
    for key, value in pairs(custom or {}) do
        actions[key] = value
    end

    actions.Rejoin = actions.Rejoin or function()
        notify("Rejoining", "Teleporting back into this server")
        task.spawn(function()
            local ok, err = pcall(function()
                if #Players:GetPlayers() <= 1 or game.JobId == "" then
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                else
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end
            end)
            if not ok then
                notify("Rejoin failed", tostring(err), "Error")
            end
        end)
    end

    actions.Hop = actions.Hop or function()
        notify("Server hop", "Joining another server")
        task.spawn(function()
            local ok, err = pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
            if not ok then
                notify("Server hop failed", tostring(err), "Error")
            end
        end)
    end

    actions.Lowest = actions.Lowest or function()
        notify("Lowest server", "Provide Actions.Lowest in tab:Dashboard({...}) to enable this button", "Warning")
    end

    actions.JobId = actions.JobId or function()
        local copy = setclipboard or toclipboard
        if copy then
            pcall(copy, game.JobId)
            notify("Copied", "Job ID copied to clipboard", "Success")
        else
            notify("Job ID", game.JobId ~= "" and game.JobId or "Studio session", "Warning")
        end
    end

    return actions
end

local function actionButton(parent, order, iconName, text, callback)
    local button = U.Button({
        Name = text,
        Size = UDim2.new(0.25, -6, 1, 0),
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = 0.3,
        LayoutOrder = order,
        Parent = parent,
    })
    U.Corner(button, Theme.SmallRadius)
    local stroke = U.Stroke(button, Theme.Stroke, 1)
    Icons.Create(button, iconName, 16, Theme.Muted, {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 11),
    })
    U.Label({
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -9),
        Size = UDim2.new(1, -8, 0, 14),
        Font = Theme.FontRegular,
        Text = text,
        TextSize = 12,
        TextColor3 = Theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = button,
    })
    U.Hover(button, function()
        U.Tween(stroke, { Color = Theme.StrokeHover }, 0.12)
        U.Tween(button, { BackgroundTransparency = 0.1 }, 0.12)
    end, function()
        U.Tween(stroke, { Color = Theme.Stroke }, 0.2)
        U.Tween(button, { BackgroundTransparency = 0.3 }, 0.2)
    end)
    U.Connect(button.MouseButton1Click, function()
        stroke.Color = Theme.Accent
        U.Tween(stroke, { Color = Theme.Stroke }, 0.35)
        U.Safe(callback)
    end)
end

local function buildServer(top, opts)
    local frame = card(top, 3, 168)

    local thumbnail = opts.Thumbnail or ("rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150")
    local icon = U.Image({
        Name = "Thumbnail",
        Position = UDim2.fromOffset(16, 16),
        Size = UDim2.fromOffset(56, 56),
        Image = thumbnail,
        ScaleType = Enum.ScaleType.Crop,
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = 0,
        Parent = frame,
    })
    U.Corner(icon, 8)

    local nameLabel = U.Label({
        Name = "GameName",
        Position = UDim2.fromOffset(84, 20),
        Size = UDim2.new(1, -100, 0, 20),
        Text = game.Name,
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    })
    local subLabel = U.Label({
        Name = "Creator",
        Position = UDim2.fromOffset(84, 42),
        Size = UDim2.new(1, -100, 0, 16),
        Font = Theme.FontRegular,
        TextSize = 12,
        TextColor3 = Theme.Muted,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    })

    local creator = "..."
    local function refreshSub()
        subLabel.Text = "by " .. creator .. "  -  " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. " players"
    end
    refreshSub()
    U.GameInfo(function(info)
        nameLabel.Text = opts.GameName or info.Name
        creator = info.Creator
        refreshSub()
    end)
    U.Connect(Players.PlayerAdded, refreshSub)
    U.Connect(Players.PlayerRemoving, function()
        task.defer(refreshSub)
    end)

    local row = U.Frame({
        Name = "Actions",
        Position = UDim2.fromOffset(16, 86),
        Size = UDim2.new(1, -32, 0, 56),
        Parent = frame,
    })
    U.List(row, 8, {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    })

    local actions = defaultActions(opts.Actions)
    actionButton(row, 1, "refresh-cw", "Rejoin", actions.Rejoin)
    actionButton(row, 2, "shuffle", "Hop", actions.Hop)
    actionButton(row, 3, "users", "Lowest", actions.Lowest)
    actionButton(row, 4, "copy", "Job ID", actions.JobId)

    local jobId = game.JobId ~= "" and U.Shorten(game.JobId, 8, 4) or "Studio"
    U.Label({
        Name = "Footer",
        Position = UDim2.fromOffset(16, 148),
        Size = UDim2.new(1, -32, 0, 14),
        Font = Theme.FontRegular,
        Text = "Job " .. jobId .. "  -  Place " .. game.PlaceId,
        TextSize = 11,
        TextColor3 = Theme.Muted,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    })
    return frame
end

---------------------------------------------------------------------------

function Dashboard.Create(tab, opts)
    opts = opts or {}
    local top = tab.Top

    local obj = {
        Welcome = buildWelcome(top, opts),
        Stats = buildStats(top),
        Server = buildServer(top, opts),
    }

    function obj:Destroy()
        for _, name in ipairs({ "Welcome", "Stats", "Server" }) do
            if self[name] then
                self[name]:Destroy()
            end
        end
    end

    return obj
end

Lumen.Dashboard = Dashboard
