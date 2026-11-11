--[[ Lumen UI - Notifications (stacked top-right)
    Lumen:Notify({ Title, Content, Type = "Info"|"Success"|"Warning"|"Error", Duration = 4 })
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme

local TextService = game:GetService("TextService")

local WIDTH = 300
local holder = nil

local function ensureHolder()
    if holder and holder.Parent then
        return holder
    end
    local gui = U.NewGui("LumenNotifications", 101)
    holder = U.Frame({
        Name = "Holder",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.new(0, WIDTH, 1, -32),
        Parent = gui,
    })
    U.List(holder, 8)
    return holder
end

local function typeColor(kind)
    kind = string.lower(tostring(kind or "info"))
    if kind == "success" then
        return Theme.Success
    elseif kind == "warning" then
        return Theme.Warning
    elseif kind == "error" or kind == "danger" then
        return Theme.Danger
    end
    return Theme.Accent
end

function Lumen:Notify(opts)
    if type(opts) == "string" then
        opts = { Content = opts }
    end
    opts = opts or {}

    local root = ensureHolder()
    local duration = opts.Duration or 4
    local color = typeColor(opts.Type)
    local content = tostring(opts.Content or "")
    local textWidth = WIDTH - 30

    local contentHeight = 0
    if content ~= "" then
        local ok, size = pcall(function()
            return TextService:GetTextSize(content, 12, Theme.FontRegular, Vector2.new(textWidth, 10000))
        end)
        contentHeight = ok and size.Y or 16
    end
    local height = 12 + 16 + (contentHeight > 0 and (4 + contentHeight) or 0) + 14

    local slot = U.Frame({
        Name = "Slot",
        Size = UDim2.new(1, 0, 0, height),
        Parent = root,
    })

    local card = U.Box({
        Name = "Notification",
        Position = UDim2.new(1, WIDTH + 20, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Card,
        ClipsDescendants = true,
        Parent = slot,
    })
    U.Corner(card, Theme.SmallRadius + 2)
    U.Stroke(card, Theme.Stroke, 1)

    U.Box({
        Name = "Accent",
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        Parent = card,
    })

    U.Label({
        Name = "Title",
        Position = UDim2.fromOffset(16, 11),
        Size = UDim2.new(1, -30, 0, 16),
        Text = tostring(opts.Title or "Notification"),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = card,
    })

    if contentHeight > 0 then
        U.Label({
            Name = "Content",
            Position = UDim2.fromOffset(16, 31),
            Size = UDim2.new(1, -30, 0, contentHeight),
            Font = Theme.FontRegular,
            Text = content,
            TextSize = 12,
            TextColor3 = Theme.Muted,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = card,
        })
    end

    local progress = U.Box({
        Name = "Progress",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.5,
        Parent = card,
    })

    U.Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
    U.Tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        if not slot.Parent then
            return
        end
        local tween = U.Tween(card, { Position = UDim2.new(1, WIDTH + 20, 0, 0) }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        tween.Completed:Wait()
        slot:Destroy()
    end)
end
