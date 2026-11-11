--[[ Lumen UI - Utility: instance helpers, tweening, dragging, shared state ]]
local Lumen = ...
local Theme = Lumen.Theme

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local U = {}

local function merge(defaults, props)
    local out = {}
    for key, value in pairs(defaults) do
        out[key] = value
    end
    for key, value in pairs(props or {}) do
        out[key] = value
    end
    return out
end

---------------------------------------------------------------------------
-- Instances
---------------------------------------------------------------------------

-- Parent is always assigned last so properties are not replicated one by one.
function U.New(class, props, children)
    local inst = Instance.new(class)
    local parent = nil
    for key, value in pairs(props or {}) do
        if key == "Parent" then
            parent = value
        else
            inst[key] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

-- Transparent container.
function U.Frame(props, children)
    return U.New("Frame", merge({ BackgroundTransparency = 1, BorderSizePixel = 0 }, props), children)
end

-- Filled box.
function U.Box(props, children)
    return U.New(
        "Frame",
        merge({ BackgroundColor3 = Theme.Element, BackgroundTransparency = 0, BorderSizePixel = 0 }, props),
        children
    )
end

function U.Label(props, children)
    return U.New(
        "TextLabel",
        merge({
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Font = Theme.FontMedium,
            Text = "",
            TextSize = 13,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        }, props),
        children
    )
end

function U.Button(props, children)
    return U.New(
        "TextButton",
        merge({
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
        }, props),
        children
    )
end

function U.Image(props, children)
    return U.New(
        "ImageLabel",
        merge({ BackgroundTransparency = 1, BorderSizePixel = 0, ScaleType = Enum.ScaleType.Fit }, props),
        children
    )
end

function U.Corner(inst, radius)
    local value = radius
    if radius == "full" then
        value = UDim.new(1, 0)
    elseif type(radius) == "number" then
        value = UDim.new(0, radius)
    end
    return U.New("UICorner", { CornerRadius = value, Parent = inst })
end

function U.Stroke(inst, color, thickness, transparency)
    return U.New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = inst,
    })
end

function U.Pad(inst, left, right, top, bottom)
    return U.New("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or left or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or top or 0),
        Parent = inst,
    })
end

function U.List(inst, padding, props)
    return U.New(
        "UIListLayout",
        merge({
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, padding or 0),
            Parent = inst,
        }, props)
    )
end

---------------------------------------------------------------------------
-- Animation, signals, input
---------------------------------------------------------------------------

function U.Tween(inst, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.15,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(inst, info, props)
    tween:Play()
    return tween
end

-- Connections made through here are disconnected by Lumen:Destroy().
function U.Connect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(Lumen._connections, conn)
    return conn
end

function U.Safe(callback, ...)
    if type(callback) ~= "function" then
        return false
    end
    local ok, err = pcall(callback, ...)
    if not ok then
        warn("[Lumen] callback error: " .. tostring(err))
    end
    return ok, err
end

local function isPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
end

U.IsPointer = isPointer
U.IsMove = isMove

function U.Drag(handle, target)
    local dragging = false
    local origin = nil
    local startPos = nil

    U.Connect(handle.InputBegan, function(input)
        if not isPointer(input) then
            return
        end
        dragging = true
        origin = input.Position
        startPos = target.Position
        local conn = nil
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end)

    U.Connect(UserInputService.InputChanged, function(input)
        if dragging and isMove(input) then
            local delta = input.Position - origin
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Hover with stroke + background feedback shared by most elements.
function U.Hover(button, onEnter, onLeave)
    U.Connect(button.MouseEnter, onEnter)
    U.Connect(button.MouseLeave, onLeave)
end

---------------------------------------------------------------------------
-- Math / text
---------------------------------------------------------------------------

function U.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function U.Round(value, increment)
    increment = increment or 1
    if increment <= 0 then
        return value
    end
    local rounded = math.floor(value / increment + 0.5) * increment
    return tonumber(string.format("%.6g", rounded))
end

function U.Number(value)
    return string.format("%g", value)
end

function U.Shorten(text, head, tail)
    text = tostring(text)
    if #text <= head + tail + 1 then
        return text
    end
    return string.sub(text, 1, head) .. "..." .. string.sub(text, -tail)
end

function U.Duration(seconds)
    seconds = math.floor(seconds)
    if seconds < 60 then
        return seconds .. "s"
    elseif seconds < 3600 then
        return math.floor(seconds / 60) .. "m " .. (seconds % 60) .. "s"
    end
    return math.floor(seconds / 3600) .. "h " .. math.floor((seconds % 3600) / 60) .. "m"
end

function U.Hex(color)
    return string.format(
        "#%02x%02x%02x",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

---------------------------------------------------------------------------
-- Environment
---------------------------------------------------------------------------

-- Where ScreenGuis should live: gethui() > CoreGui > PlayerGui.
function U.GuiParent()
    local ok, hidden = pcall(function()
        return gethui and gethui()
    end)
    if ok and hidden then
        return hidden
    end

    local okCore, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    if okCore and core then
        local probe = Instance.new("Folder")
        local wrote = pcall(function()
            probe.Parent = core
        end)
        local usable = wrote and probe.Parent == core
        probe:Destroy()
        if usable then
            return core
        end
    end

    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

function U.NewGui(name, displayOrder)
    local gui = U.New("ScreenGui", {
        Name = name,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = displayOrder or 100,
        IgnoreGuiInset = true,
        Parent = U.GuiParent(),
    })
    table.insert(Lumen._guis, gui)
    return gui
end

-- Asynchronous, cached place info: callback({ Name = ..., Creator = ... }).
local gameInfo = nil
function U.GameInfo(callback)
    if gameInfo then
        callback(gameInfo)
        return
    end
    task.spawn(function()
        local info = { Name = game.Name, Creator = "Unknown" }
        local ok, product = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if ok and type(product) == "table" then
            info.Name = product.Name or info.Name
            if type(product.Creator) == "table" and product.Creator.Name then
                info.Creator = product.Creator.Name
            end
        end
        gameInfo = info
        callback(info)
    end)
end

---------------------------------------------------------------------------
-- Privacy (the "Name" / "Avatar" chips on the dashboard)
---------------------------------------------------------------------------

local Privacy = { HideName = false, HideAvatar = false, _binds = {} }

function Privacy:Bind(callback)
    table.insert(self._binds, callback)
    callback(self.HideName, self.HideAvatar)
end

function Privacy:Set(kind, value)
    if kind == "Name" then
        self.HideName = value and true or false
    else
        self.HideAvatar = value and true or false
    end
    for _, callback in ipairs(self._binds) do
        U.Safe(callback, self.HideName, self.HideAvatar)
    end
end

Lumen.Privacy = Privacy
Lumen.Utility = U
