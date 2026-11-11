local v0_1 = {
["src/Core/Theme.lua"] = function (...)
local v0_2 = ...
local v0_3 = {
Background = Color3.fromRGB (21, 21, 23),
Sidebar = Color3.fromRGB (25, 25, 27),
Card = Color3.fromRGB (30, 30, 32),
Element = Color3.fromRGB (38, 38, 41),
ElementHover = Color3.fromRGB (48, 48, 52),
Track = Color3.fromRGB (62, 62, 68),
Stroke = Color3.fromRGB (46, 46, 50),
StrokeHover = Color3.fromRGB (74, 74, 80),
Text = Color3.fromRGB (242, 242, 244),
Muted = Color3.fromRGB (139, 139, 148),
Accent = Color3.fromRGB (163, 217, 43),
AccentDark = Color3.fromRGB (20, 28, 6),
Success = Color3.fromRGB (87, 214, 120),
Warning = Color3.fromRGB (245, 183, 64),
Danger = Color3.fromRGB (236, 86, 86),
Online = Color3.fromRGB (70, 200, 100),
Radius = 10,
SmallRadius = 8,
FontRegular = Enum.Font.Gotham,
FontMedium = Enum.Font.GothamMedium,
FontBold = Enum.Font.GothamBold,
}
v0_3.Presets = {
Lime = {Accent = Color3.fromRGB (163, 217, 43), AccentDark = Color3.fromRGB (20, 28, 6)},
Ocean = {Accent = Color3.fromRGB (64, 160, 255), AccentDark = Color3.fromRGB (4, 18, 34)},
Rose = {Accent = Color3.fromRGB (255, 94, 140), AccentDark = Color3.fromRGB (38, 6, 16)},
Amber = {Accent = Color3.fromRGB (255, 183, 66), AccentDark = Color3.fromRGB (36, 22, 2)},
Violet = {Accent = Color3.fromRGB (150, 110, 255), AccentDark = Color3.fromRGB (14, 8, 36)},
}
function v0_3:Apply (v0_4)
local v0_5 = type (v0_4) == "string" and self.Presets [v0_4] or v0_4
if type (v0_5) ~= "table" then
return false
end
for v0_6, v0_7 in pairs (v0_5) do
self [v0_6] = v0_7
end
return true
end
v0_2.Theme = v0_3
end,
["src/Core/Utility.lua"] = function (...)
local v0_8 = ...
local v0_9 = v0_8.Theme
local v0_10 = game:GetService ("TweenService")
local v0_11 = game:GetService ("UserInputService")
local v0_12 = game:GetService ("MarketplaceService")
local v0_13 = game:GetService ("Players")
local v0_14 = {}
local function v0_15 (v0_16, v0_17)
local v0_18 = {}
for v0_19, v0_20 in pairs (v0_16) do
v0_18 [v0_19] = v0_20
end
for v0_21, v0_22 in pairs (v0_17 or {}) do
v0_18 [v0_21] = v0_22
end
return v0_18
end
function v0_14.New (v0_23, v0_24, v0_25)
local v0_26 = Instance.new (v0_23)
local v0_27 = nil
for v0_28, v0_29 in pairs (v0_24 or {}) do
if v0_28 == "Parent" then
v0_27 = v0_29
else
v0_26 [v0_28] = v0_29
end
end
for v0_30, v0_31 in ipairs (v0_25 or {}) do
v0_31.Parent = v0_26
end
if v0_27 then
v0_26.Parent = v0_27
end
return v0_26
end
function v0_14.Frame (v0_32, v0_33)
return v0_14.New ("Frame", v0_15 ({BackgroundTransparency = 1, BorderSizePixel = 0}, v0_32), v0_33)
end
function v0_14.Box (v0_34, v0_35)
return v0_14.New (
"Frame",
v0_15 ({BackgroundColor3 = v0_9.Element, BackgroundTransparency = 0, BorderSizePixel = 0}, v0_34),
v0_35
)
end
function v0_14.Label (v0_36, v0_37)
return v0_14.New (
"TextLabel",
v0_15 ({
BackgroundTransparency = 1,
BorderSizePixel = 0,
Font = v0_9.FontMedium,
Text = "",
TextSize = 13,
TextColor3 = v0_9.Text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Center,
}, v0_36),
v0_37
)
end
function v0_14.Button (v0_38, v0_39)
return v0_14.New (
"TextButton",
v0_15 ({
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
}, v0_38),
v0_39
)
end
function v0_14.Image (v0_40, v0_41)
return v0_14.New (
"ImageLabel",
v0_15 ({BackgroundTransparency = 1, BorderSizePixel = 0, ScaleType = Enum.ScaleType.Fit}, v0_40),
v0_41
)
end
function v0_14.Corner (v0_42, v0_43)
local v0_44 = v0_43
if v0_43 == "full" then
v0_44 = UDim.new (1, 0)
elseif type (v0_43) == "number" then
v0_44 = UDim.new (0, v0_43)
end
return v0_14.New ("UICorner", {CornerRadius = v0_44, Parent = v0_42})
end
function v0_14.Stroke (v0_45, v0_46, v0_47, v0_48)
return v0_14.New ("UIStroke", {
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
Color = v0_46 or v0_9.Stroke,
Thickness = v0_47 or 1,
Transparency = v0_48 or 0,
Parent = v0_45,
})
end
function v0_14.Pad (v0_49, v0_50, v0_51, v0_52, v0_53)
return v0_14.New ("UIPadding", {
PaddingLeft = UDim.new (0, v0_50 or 0),
PaddingRight = UDim.new (0, v0_51 or v0_50 or 0),
PaddingTop = UDim.new (0, v0_52 or 0),
PaddingBottom = UDim.new (0, v0_53 or v0_52 or 0),
Parent = v0_49,
})
end
function v0_14.List (v0_54, v0_55, v0_56)
return v0_14.New (
"UIListLayout",
v0_15 ({
SortOrder = Enum.SortOrder.LayoutOrder,
Padding = UDim.new (0, v0_55 or 0),
Parent = v0_54,
}, v0_56)
)
end
function v0_14.Tween (v0_57, v0_58, v0_59, v0_60, v0_61)
local v0_62 = TweenInfo.new (
v0_59 or 0.15,
v0_60 or Enum.EasingStyle.Quad,
v0_61 or Enum.EasingDirection.Out
)
local v0_63 = v0_10:Create (v0_57, v0_62, v0_58)
v0_63:Play ()
return v0_63
end
function v0_14.Connect (v0_64, v0_65)
local v0_66 = v0_64:Connect (v0_65)
table.insert (v0_8._connections, v0_66)
return v0_66
end
function v0_14.Safe (v0_67, ...)
if type (v0_67) ~= "function" then
return false
end
local v0_68, v0_69 = pcall (v0_67, ...)
if not v0_68 then
warn ("[Lumen] callback error: " .. tostring (v0_69))
end
return v0_68, v0_69
end
local function v0_70 (v0_71)
return v0_71.UserInputType == Enum.UserInputType.MouseButton1
or v0_71.UserInputType == Enum.UserInputType.Touch
end
local function v0_72 (v0_73)
return v0_73.UserInputType == Enum.UserInputType.MouseMovement
or v0_73.UserInputType == Enum.UserInputType.Touch
end
v0_14.IsPointer = v0_70
v0_14.IsMove = v0_72
function v0_14.Drag (v0_74, v0_75)
local v0_76 = false
local v0_77 = nil
local v0_78 = nil
v0_14.Connect (v0_74.InputBegan, function (v0_79)
if not v0_70 (v0_79) then
return
end
v0_76 = true
v0_77 = v0_79.Position
v0_78 = v0_75.Position
local v0_80 = nil
v0_80 = v0_79.Changed:Connect (function ()
if v0_79.UserInputState == Enum.UserInputState.End then
v0_76 = false
v0_80:Disconnect ()
end
end)
end)
v0_14.Connect (v0_11.InputChanged, function (v0_81)
if v0_76 and v0_72 (v0_81) then
local v0_82 = v0_81.Position - v0_77
v0_75.Position = UDim2.new (
v0_78.X.Scale,
v0_78.X.Offset + v0_82.X,
v0_78.Y.Scale,
v0_78.Y.Offset + v0_82.Y
)
end
end)
end
function v0_14.Hover (v0_83, v0_84, v0_85)
v0_14.Connect (v0_83.MouseEnter, v0_84)
v0_14.Connect (v0_83.MouseLeave, v0_85)
end
function v0_14.Clamp (v0_86, v0_87, v0_88)
return math.max (v0_87, math.min (v0_88, v0_86))
end
function v0_14.Round (v0_89, v0_90)
v0_90 = v0_90 or 1
if v0_90 <= 0 then
return v0_89
end
local v0_91 = math.floor (v0_89 / v0_90 + 0.5) * v0_90
return tonumber (string.format ("%.6g", v0_91))
end
function v0_14.Number (v0_92)
return string.format ("%g", v0_92)
end
function v0_14.Shorten (v0_93, v0_94, v0_95)
v0_93 = tostring (v0_93)
if # v0_93 <= v0_94 + v0_95 + 1 then
return v0_93
end
return string.sub (v0_93, 1, v0_94) .. "..." .. string.sub (v0_93, - v0_95)
end
function v0_14.Duration (v0_96)
v0_96 = math.floor (v0_96)
if v0_96 < 60 then
return v0_96 .. "s"
elseif v0_96 < 3600 then
return math.floor (v0_96 / 60) .. "m " .. (v0_96 % 60) .. "s"
end
return math.floor (v0_96 / 3600) .. "h " .. math.floor ((v0_96 % 3600) / 60) .. "m"
end
function v0_14.Hex (v0_97)
return string.format (
"#%02x%02x%02x",
math.floor (v0_97.R * 255 + 0.5),
math.floor (v0_97.G * 255 + 0.5),
math.floor (v0_97.B * 255 + 0.5)
)
end
function v0_14.GuiParent ()
local v0_98, v0_99 = pcall (function ()
return gethui and gethui ()
end)
if v0_98 and v0_99 then
return v0_99
end
local v0_100, v0_101 = pcall (function ()
return game:GetService ("CoreGui")
end)
if v0_100 and v0_101 then
local v0_102 = Instance.new ("Folder")
local v0_103 = pcall (function ()
v0_102.Parent = v0_101
end)
local v0_104 = v0_103 and v0_102.Parent == v0_101
v0_102:Destroy ()
if v0_104 then
return v0_101
end
end
return v0_13.LocalPlayer:WaitForChild ("PlayerGui")
end
function v0_14.NewGui (v0_105, v0_106)
local v0_107 = v0_14.New ("ScreenGui", {
Name = v0_105,
ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
DisplayOrder = v0_106 or 100,
IgnoreGuiInset = true,
Parent = v0_14.GuiParent (),
})
table.insert (v0_8._guis, v0_107)
return v0_107
end
local v0_108 = nil
function v0_14.GameInfo (v0_109)
if v0_108 then
v0_109 (v0_108)
return
end
task.spawn (function ()
local v0_110 = {Name = game.Name, Creator = "Unknown"}
local v0_111, v0_112 = pcall (function ()
return v0_12:GetProductInfo (game.PlaceId)
end)
if v0_111 and type (v0_112) == "table" then
v0_110.Name = v0_112.Name or v0_110.Name
if type (v0_112.Creator) == "table" and v0_112.Creator.Name then
v0_110.Creator = v0_112.Creator.Name
end
end
v0_108 = v0_110
v0_109 (v0_110)
end)
end
local v0_113 = {HideName = false, HideAvatar = false, _binds = {}}
function v0_113:Bind (v0_114)
table.insert (self._binds, v0_114)
v0_114 (self.HideName, self.HideAvatar)
end
function v0_113:Set (v0_115, v0_116)
if v0_115 == "Name" then
self.HideName = v0_116 and true or false
else
self.HideAvatar = v0_116 and true or false
end
for v0_117, v0_118 in ipairs (self._binds) do
v0_14.Safe (v0_118, self.HideName, self.HideAvatar)
end
end
v0_8.Privacy = v0_113
v0_8.Utility = v0_14
end,
["src/Core/Icons.lua"] = function (...)
local v0_119 = ...
local v0_120 = v0_119.Utility
local v0_121 = v0_119.Theme
local v0_122 = {Registry = {}, Provider = nil}
function v0_122.Register (v0_123, v0_124)
v0_122.Registry [v0_123] = v0_124
end
function v0_122.SetProvider (v0_125)
v0_122.Provider = v0_125
end
local function v0_126 (v0_127)
if type (v0_127) == "number" then
return {Image = "rbxassetid://" .. v0_127}
elseif type (v0_127) == "string" then
return {Image = v0_127}
elseif type (v0_127) == "table" and v0_127.Image then
return v0_127
end
return nil
end
function v0_122.Resolve (v0_128)
if v0_128 == nil then
return nil
end
if v0_122.Registry [v0_128] then
return v0_126 (v0_122.Registry [v0_128])
end
if type (v0_128) == "number" then
return v0_126 (v0_128)
end
if type (v0_128) == "string" and string.find (v0_128, "^rbxasset") then
return v0_126 (v0_128)
end
if v0_122.Provider then
local v0_129, v0_130 = pcall (v0_122.Provider, v0_128)
if v0_129 then
return v0_126 (v0_130)
end
end
return nil
end
local function v0_131 (v0_132, v0_133, v0_134, v0_135, v0_136, v0_137, v0_138)
local v0_139 = v0_120.Box ({
AnchorPoint = Vector2.new (0.5, 0.5),
Position = UDim2.fromOffset (v0_135, v0_136),
Size = UDim2.fromOffset (v0_133, v0_134),
Rotation = v0_137,
BackgroundColor3 = v0_138,
Parent = v0_132,
})
v0_120.Corner (v0_139, 1)
return v0_139
end
local v0_140 = {}
local function v0_141 (v0_142, v0_143, v0_144)
local v0_145 = v0_120.Frame ({Size = UDim2.fromOffset (v0_143, v0_143), Parent = v0_142})
local v0_146 = v0_143 / 12
local v0_147 = {
v0_131 (v0_145, 7 * v0_146, 2, 3.5 * v0_146, 5 * v0_146, 45, v0_144),
v0_131 (v0_145, 7 * v0_146, 2, 8.5 * v0_146, 5 * v0_146, - 45, v0_144),
}
return v0_145, v0_147
end
v0_140 ["chevron-down"] = v0_141
v0_140 ["chevron-right"] = function (v0_148, v0_149, v0_150)
local v0_151, v0_152 = v0_141 (v0_148, v0_149, v0_150)
v0_151.Rotation = - 90
return v0_151, v0_152
end
v0_140.minus = function (v0_153, v0_154, v0_155)
local v0_156 = v0_120.Frame ({Size = UDim2.fromOffset (v0_154, v0_154), Parent = v0_153})
return v0_156, {v0_131 (v0_156, v0_154 * 0.7, 2, v0_154 / 2, v0_154 / 2, 0, v0_155)}
end
v0_140.close = function (v0_157, v0_158, v0_159)
local v0_160 = v0_120.Frame ({Size = UDim2.fromOffset (v0_158, v0_158), Parent = v0_157})
local v0_161 = v0_158 * 0.85
return v0_160, {
v0_131 (v0_160, v0_161, 2, v0_158 / 2, v0_158 / 2, 45, v0_159),
v0_131 (v0_160, v0_161, 2, v0_158 / 2, v0_158 / 2, - 45, v0_159),
}
end
v0_140.search = function (v0_162, v0_163, v0_164)
local v0_165 = v0_120.Frame ({Size = UDim2.fromOffset (v0_163, v0_163), Parent = v0_162})
local v0_166 = v0_120.Frame ({Size = UDim2.fromOffset (v0_163 * 0.66, v0_163 * 0.66), Parent = v0_165})
v0_120.Corner (v0_166, "full")
local v0_167 = v0_120.Stroke (v0_166, v0_164, 2)
local v0_168 = v0_131 (v0_165, v0_163 * 0.38, 2, v0_163 * 0.82, v0_163 * 0.82, 45, v0_164)
return v0_165, {v0_167, v0_168}
end
local function v0_169 (v0_170, v0_171)
if v0_170:IsA ("UIStroke") then
v0_170.Color = v0_171
else
v0_170.BackgroundColor3 = v0_171
end
end
function v0_122.Create (v0_172, v0_173, v0_174, v0_175, v0_176)
v0_174 = v0_174 or 16
v0_175 = v0_175 or v0_121.Muted
local v0_177 = {}
local v0_178 = v0_122.Resolve (v0_173)
if v0_178 then
local v0_179 = v0_120.Image ({
Size = UDim2.fromOffset (v0_174, v0_174),
Image = v0_178.Image,
ImageColor3 = v0_175,
Parent = v0_172,
})
if v0_178.RectOffset then
v0_179.ImageRectOffset = v0_178.RectOffset
v0_179.ImageRectSize = v0_178.RectSize or Vector2.new (0, 0)
end
v0_177.Instance = v0_179
function v0_177:SetColor (v0_180)
v0_179.ImageColor3 = v0_180
end
elseif v0_140 [v0_173] then
local v0_181, v0_182 = v0_140 [v0_173] (v0_172, v0_174, v0_175)
v0_177.Instance = v0_181
function v0_177:SetColor (v0_183)
for v0_184, v0_185 in ipairs (v0_182) do
v0_169 (v0_185, v0_183)
end
end
else
local v0_186 = v0_120.Frame ({Size = UDim2.fromOffset (v0_174, v0_174), Parent = v0_172})
local v0_187 = v0_120.Box ({
AnchorPoint = Vector2.new (0.5, 0.5),
Position = UDim2.fromScale (0.5, 0.5),
Size = UDim2.fromOffset (4, 4),
BackgroundColor3 = v0_175,
Parent = v0_186,
})
v0_120.Corner (v0_187, "full")
v0_177.Instance = v0_186
function v0_177:SetColor (v0_188)
v0_187.BackgroundColor3 = v0_188
end
end
for v0_189, v0_190 in pairs (v0_176 or {}) do
v0_177.Instance [v0_189] = v0_190
end
function v0_177:Destroy ()
v0_177.Instance:Destroy ()
end
return v0_177
end
v0_119.Icons = v0_122
end,
["src/Elements/Base.lua"] = function (...)
local v0_191 = ...
local v0_192 = v0_191.Utility
local v0_193 = v0_191.Theme
local v0_194 = {}
function v0_194.Opts (v0_195, v0_196)
if type (v0_195) == "string" then
v0_195 = {Name = v0_195}
end
local v0_197 = {}
for v0_198, v0_199 in pairs (v0_195 or {}) do
v0_197 [v0_198] = v0_199
end
v0_197.Name = v0_197.Name or v0_197.Title or v0_197.Text or v0_196
v0_197.Description = v0_197.Description or v0_197.Desc
return v0_197
end
function v0_194.Card (v0_200, v0_201, v0_202, v0_203)
local v0_204 = {
Name = "Element",
Size = UDim2.new (1, 0, 0, v0_201 or 40),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = v0_193.Element,
BackgroundTransparency = 0.3,
LayoutOrder = v0_200:_nextOrder (),
Parent = v0_200.Content,
}
local v0_205 = v0_202 and v0_192.Button (v0_204) or v0_192.Box (v0_204)
if v0_202 then
v0_205.BackgroundTransparency = 0.3
end
v0_192.Corner (v0_205, v0_193.SmallRadius)
local v0_206 = v0_192.Stroke (v0_205, v0_193.Stroke, 1)
if not v0_203 then
v0_192.Pad (v0_205, 12, 12, 12, 12)
end
return v0_205, v0_206
end
function v0_194.Text (v0_207, v0_208, v0_209)
local v0_210 = v0_192.Frame ({
Name = "Text",
Size = UDim2.new (1, - (v0_209 or 0), 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
Parent = v0_207,
})
v0_192.List (v0_210, 2)
local v0_211 = v0_192.Label ({
Name = "Name",
Size = UDim2.new (1, 0, 0, 16),
Text = tostring (v0_208.Name or ""),
TextTruncate = Enum.TextTruncate.AtEnd,
LayoutOrder = 1,
Parent = v0_210,
})
local v0_212 = v0_192.Label ({
Name = "Description",
Size = UDim2.new (1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
Font = v0_193.FontRegular,
Text = tostring (v0_208.Description or ""),
TextSize = 12,
TextColor3 = v0_193.Muted,
TextWrapped = true,
TextYAlignment = Enum.TextYAlignment.Top,
RichText = true,
Visible = v0_208.Description ~= nil and v0_208.Description ~= "",
LayoutOrder = 2,
Parent = v0_210,
})
return v0_210, v0_211, v0_212
end
function v0_194.Hover (v0_213, v0_214, v0_215)
v0_192.Hover (v0_213, function ()
v0_192.Tween (v0_214, {Color = v0_193.StrokeHover}, 0.12)
v0_192.Tween (v0_215, {BackgroundTransparency = 0.1}, 0.12)
end, function ()
v0_192.Tween (v0_214, {Color = v0_193.Stroke}, 0.2)
v0_192.Tween (v0_215, {BackgroundTransparency = 0.3}, 0.2)
end)
end
function v0_194.Finish (v0_216, v0_217, v0_218, v0_219, v0_220)
v0_218.Kind = v0_220
v0_218.Frame = v0_219
v0_218.Section = v0_216
v0_218.Flag = v0_217.Flag
v0_218._callback = v0_217.Callback
v0_218._name = string.lower (tostring (v0_217.Name or ""))
v0_218._desc = string.lower (tostring (v0_217.Description or v0_217.Content or ""))
v0_218._visible = v0_217.Visible ~= false
v0_218._match = true
function v0_218:_apply ()
self.Frame.Visible = self._visible and self._match
end
function v0_218:SetVisible (v0_221)
self._visible = v0_221 and true or false
self:_apply ()
end
function v0_218:Fire ()
v0_192.Safe (self._callback, self:Get ())
end
function v0_218:Destroy ()
for v0_222, v0_223 in ipairs (v0_216.Items) do
if v0_223 == self then
table.remove (v0_216.Items, v0_222)
break
end
end
if self.Flag and v0_191.Flags [self.Flag] == self then
v0_191.Flags [self.Flag] = nil
end
self.Frame:Destroy ()
end
if v0_218.Get == nil then
function v0_218:Get ()
return nil
end
end
table.insert (v0_216.Items, v0_218)
if v0_217.Flag then
v0_191.Flags [v0_217.Flag] = v0_218
end
v0_218:_apply ()
return v0_218
end
v0_191.Base = v0_194
end,
["src/Elements/Toggle.lua"] = function (...)
local v0_224 = ...
local v0_225 = v0_224.Utility
local v0_226 = v0_224.Theme
local v0_227 = v0_224.Base
local v0_228, v0_229, v0_230 = 36, 20, 14
v0_224.Elements.Toggle = function (v0_231, v0_232)
v0_232 = v0_227.Opts (v0_232, "Toggle")
local v0_233, v0_234 = v0_227.Card (v0_231, 40, true)
v0_227.Text (v0_233, v0_232, v0_228 + 16)
local v0_235 = v0_225.Box ({
Name = "Track",
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, 0, 0.5, 0),
Size = UDim2.fromOffset (v0_228, v0_229),
BackgroundColor3 = v0_226.Track,
Parent = v0_233,
})
v0_225.Corner (v0_235, "full")
local v0_236 = v0_225.Box ({
Name = "Knob",
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 3, 0.5, 0),
Size = UDim2.fromOffset (v0_230, v0_230),
BackgroundColor3 = v0_226.Muted,
Parent = v0_235,
})
v0_225.Corner (v0_236, "full")
local v0_237 = v0_232.Default == true or v0_232.Value == true
local v0_238 = {}
local function v0_239 (v0_240)
local v0_241 = UDim2.new (0, v0_237 and (v0_228 - 3 - v0_230) or 3, 0.5, 0)
local v0_242 = v0_237 and v0_226.Accent or v0_226.Track
local v0_243 = v0_237 and v0_226.AccentDark or v0_226.Muted
if v0_240 then
v0_225.Tween (v0_236, {Position = v0_241, BackgroundColor3 = v0_243}, 0.15)
v0_225.Tween (v0_235, {BackgroundColor3 = v0_242}, 0.15)
else
v0_236.Position = v0_241
v0_236.BackgroundColor3 = v0_243
v0_235.BackgroundColor3 = v0_242
end
end
v0_239 (false)
function v0_238:Set (v0_244, v0_245)
v0_244 = v0_244 and true or false
if v0_244 == v0_237 then
return
end
v0_237 = v0_244
v0_239 (true)
if not v0_245 then
v0_225.Safe (v0_232.Callback, v0_237)
end
end
function v0_238:Get ()
return v0_237
end
function v0_238:Toggle ()
self:Set (not v0_237)
end
v0_225.Connect (v0_233.MouseButton1Click, function ()
v0_238:Set (not v0_237)
end)
v0_227.Hover (v0_233, v0_234, v0_233)
return v0_227.Finish (v0_231, v0_232, v0_238, v0_233, "Toggle")
end
end,
["src/Elements/Button.lua"] = function (...)
local v0_246 = ...
local v0_247 = v0_246.Utility
local v0_248 = v0_246.Theme
local v0_249 = v0_246.Base
local v0_250 = v0_246.Icons
v0_246.Elements.Button = function (v0_251, v0_252)
v0_252 = v0_249.Opts (v0_252, "Button")
local v0_253 = v0_252.Style == "Primary"
local v0_254, v0_255 = v0_249.Card (v0_251, 40, true)
local v0_256, v0_257, v0_258 = v0_249.Text (v0_254, v0_252, 28)
local v0_259 = v0_248.Stroke
local v0_260 = v0_248.Muted
if v0_253 then
v0_254.BackgroundColor3 = v0_248.Accent
v0_254.BackgroundTransparency = 0.08
v0_255.Color = v0_248.Accent
v0_255.Transparency = 0.4
v0_257.TextColor3 = v0_248.AccentDark
v0_258.TextColor3 = v0_248.AccentDark
v0_259 = v0_248.Accent
v0_260 = v0_248.AccentDark
end
v0_250.Create (v0_254, v0_252.Icon or "chevron-right", 14, v0_260, {
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, 0, 0.5, 0),
})
local v0_261 = {}
function v0_261:SetName (v0_262)
v0_257.Text = tostring (v0_262)
end
function v0_261:SetDescription (v0_263)
v0_258.Text = tostring (v0_263 or "")
v0_258.Visible = v0_263 ~= nil and v0_263 ~= ""
end
function v0_261:Get ()
return nil
end
v0_247.Connect (v0_254.MouseButton1Click, function ()
v0_255.Color = v0_248.Accent
v0_247.Tween (v0_255, {Color = v0_259}, 0.35)
v0_247.Safe (v0_252.Callback)
end)
v0_247.Hover (v0_254, function ()
v0_247.Tween (v0_254, {BackgroundTransparency = v0_253 and 0 or 0.1}, 0.12)
if not v0_253 then
v0_247.Tween (v0_255, {Color = v0_248.StrokeHover}, 0.12)
end
end, function ()
v0_247.Tween (v0_254, {BackgroundTransparency = v0_253 and 0.08 or 0.3}, 0.2)
v0_247.Tween (v0_255, {Color = v0_259}, 0.2)
end)
return v0_249.Finish (v0_251, v0_252, v0_261, v0_254, "Button")
end
end,
["src/Elements/Slider.lua"] = function (...)
local v0_264 = ...
local v0_265 = v0_264.Utility
local v0_266 = v0_264.Theme
local v0_267 = v0_264.Base
local v0_268 = game:GetService ("UserInputService")
v0_264.Elements.Slider = function (v0_269, v0_270)
v0_270 = v0_267.Opts (v0_270, "Slider")
local v0_271 = v0_270.Min or 0
local v0_272 = v0_270.Max or 100
if v0_272 <= v0_271 then
v0_272 = v0_271 + 1
end
local v0_273 = v0_270.Increment or 1
local v0_274 = v0_270.Suffix and tostring (v0_270.Suffix) or ""
local v0_275, v0_276 = v0_267.Card (v0_269, 40, false)
local v0_277, v0_278 = v0_267.Text (v0_275, v0_270, 0)
v0_278.Size = UDim2.new (1, - 80, 0, 16)
local v0_279 = v0_265.Label ({
Name = "Value",
AnchorPoint = Vector2.new (1, 0),
Position = UDim2.new (1, 0, 0, 0),
Size = UDim2.fromOffset (76, 16),
TextXAlignment = Enum.TextXAlignment.Right,
TextColor3 = v0_266.Muted,
Parent = v0_275,
})
local v0_280 = v0_265.Button ({
Name = "Hit",
Size = UDim2.new (1, 0, 0, 22),
LayoutOrder = 3,
Parent = v0_277,
})
local v0_281 = v0_265.Box ({
Name = "Bar",
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 0, 0.5, 2),
Size = UDim2.new (1, 0, 0, 6),
BackgroundColor3 = v0_266.Track,
Parent = v0_280,
})
v0_265.Corner (v0_281, "full")
local v0_282 = v0_265.Box ({
Name = "Fill",
Size = UDim2.new (0, 0, 1, 0),
BackgroundColor3 = v0_266.Accent,
Parent = v0_281,
})
v0_265.Corner (v0_282, "full")
local v0_283 = v0_265.Box ({
Name = "Knob",
AnchorPoint = Vector2.new (0.5, 0.5),
Position = UDim2.new (1, 0, 0.5, 0),
Size = UDim2.fromOffset (12, 12),
BackgroundColor3 = v0_266.Text,
Parent = v0_282,
})
v0_265.Corner (v0_283, "full")
local v0_284 = v0_265.Clamp (v0_270.Default or v0_270.Value or v0_271, v0_271, v0_272)
v0_284 = v0_265.Round (v0_284, v0_273)
local v0_285 = {}
local function v0_286 ()
v0_282.Size = UDim2.new ((v0_284 - v0_271) / (v0_272 - v0_271), 0, 1, 0)
v0_279.Text = v0_265.Number (v0_284) .. v0_274
end
v0_286 ()
function v0_285:Set (v0_287, v0_288)
v0_287 = v0_265.Round (v0_265.Clamp (v0_287, v0_271, v0_272), v0_273)
if v0_287 == v0_284 then
return
end
v0_284 = v0_287
v0_286 ()
if not v0_288 then
v0_265.Safe (v0_270.Callback, v0_284)
end
end
function v0_285:Get ()
return v0_284
end
local v0_289 = false
local function v0_290 (v0_291)
local v0_292 = v0_281.AbsoluteSize.X
if v0_292 <= 0 then
return
end
local v0_293 = v0_265.Clamp ((v0_291 - v0_281.AbsolutePosition.X) / v0_292, 0, 1)
v0_285:Set (v0_271 + (v0_272 - v0_271) * v0_293)
end
v0_265.Connect (v0_280.InputBegan, function (v0_294)
if v0_265.IsPointer (v0_294) then
v0_289 = true
v0_265.Tween (v0_283, {Size = UDim2.fromOffset (15, 15)}, 0.1)
v0_265.Tween (v0_276, {Color = v0_266.StrokeHover}, 0.1)
v0_290 (v0_294.Position.X)
end
end)
v0_265.Connect (v0_268.InputChanged, function (v0_295)
if v0_289 and v0_265.IsMove (v0_295) then
v0_290 (v0_295.Position.X)
end
end)
v0_265.Connect (v0_268.InputEnded, function (v0_296)
if v0_289 and v0_265.IsPointer (v0_296) then
v0_289 = false
v0_265.Tween (v0_283, {Size = UDim2.fromOffset (12, 12)}, 0.1)
v0_265.Tween (v0_276, {Color = v0_266.Stroke}, 0.2)
end
end)
return v0_267.Finish (v0_269, v0_270, v0_285, v0_275, "Slider")
end
end,
["src/Elements/Dropdown.lua"] = function (...)
local v0_297 = ...
local v0_298 = v0_297.Utility
local v0_299 = v0_297.Theme
local v0_300 = v0_297.Base
local v0_301 = v0_297.Icons
local v0_302 = 26
local v0_303 = 164
v0_297.Elements.Dropdown = function (v0_304, v0_305)
v0_305 = v0_300.Opts (v0_305, "Dropdown")
local v0_306 = v0_305.Multi == true
local v0_307 = {}
for v0_308, v0_309 in ipairs (v0_305.Options or v0_305.Values or {}) do
table.insert (v0_307, tostring (v0_309))
end
local v0_310 = {}
local v0_311 = false
local v0_312 = {}
local v0_313, v0_314 = v0_300.Card (v0_304, 40, false, true)
v0_313.ClipsDescendants = true
v0_298.List (v0_313, 0)
local v0_315 = v0_298.Button ({
Name = "Header",
Size = UDim2.new (1, 0, 0, 40),
LayoutOrder = 1,
Parent = v0_313,
})
v0_298.Label ({
Name = "Name",
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 12, 0.5, 0),
Size = UDim2.new (1, - 170, 0, 16),
Text = tostring (v0_305.Name or "Dropdown"),
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_315,
})
local v0_316 = v0_298.Label ({
Name = "Value",
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, - 34, 0.5, 0),
Size = UDim2.fromOffset (130, 16),
Font = v0_299.FontRegular,
TextColor3 = v0_299.Muted,
TextXAlignment = Enum.TextXAlignment.Right,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_315,
})
local v0_317 = v0_301.Create (v0_315, "chevron-down", 12, v0_299.Muted, {
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, - 12, 0.5, 0),
})
local v0_318 = v0_298.New ("ScrollingFrame", {
Name = "Options",
Size = UDim2.new (1, 0, 0, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 2,
ScrollBarImageColor3 = v0_299.StrokeHover,
CanvasSize = UDim2.new (),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
Visible = false,
LayoutOrder = 2,
Parent = v0_313,
})
v0_298.Pad (v0_318, 6, 6, 0, 6)
v0_298.List (v0_318, 2)
local v0_319 = {}
local function v0_320 ()
local v0_321 = {}
for v0_322, v0_323 in ipairs (v0_307) do
if v0_310 [v0_323] then
table.insert (v0_321, v0_323)
end
end
return v0_321
end
local function v0_324 ()
local v0_325 = v0_320 ()
if # v0_325 == 0 then
return "None"
elseif # v0_325 > 2 then
return # v0_325 .. " selected"
end
return table.concat (v0_325, ", ")
end
local function v0_326 ()
for v0_327, v0_328 in ipairs (v0_312) do
local v0_329 = v0_310 [v0_328.Option] == true
v0_328.Background.BackgroundTransparency = v0_329 and 0.85 or 1
v0_328.Label.TextColor3 = v0_329 and v0_299.Accent or v0_299.Text
end
v0_316.Text = v0_324 ()
end
local function v0_330 ()
v0_298.Safe (v0_305.Callback, v0_319:Get ())
end
local function v0_331 (v0_332)
if v0_306 then
v0_310 [v0_332] = not v0_310 [v0_332] or nil
else
v0_310 = {[v0_332] = true}
end
v0_326 ()
v0_330 ()
if not v0_306 then
v0_319:SetOpen (false)
end
end
local function v0_333 ()
for v0_334, v0_335 in ipairs (v0_312) do
v0_335.Button:Destroy ()
end
v0_312 = {}
for v0_336, v0_337 in ipairs (v0_307) do
local v0_338 = v0_298.Button ({
Name = "Option",
Size = UDim2.new (1, 0, 0, v0_302),
LayoutOrder = v0_336,
Parent = v0_318,
})
local v0_339 = v0_298.Box ({
Size = UDim2.new (1, 0, 1, 0),
BackgroundColor3 = v0_299.Accent,
BackgroundTransparency = 1,
Parent = v0_338,
})
v0_298.Corner (v0_339, 6)
local v0_340 = v0_298.Label ({
Position = UDim2.fromOffset (10, 0),
Size = UDim2.new (1, - 20, 1, 0),
Font = v0_299.FontRegular,
Text = v0_337,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_338,
})
v0_298.Connect (v0_338.MouseButton1Click, function ()
v0_331 (v0_337)
end)
v0_298.Connect (v0_338.MouseEnter, function ()
if not v0_310 [v0_337] then
v0_339.BackgroundColor3 = v0_299.ElementHover
v0_339.BackgroundTransparency = 0.4
end
end)
v0_298.Connect (v0_338.MouseLeave, function ()
v0_339.BackgroundColor3 = v0_299.Accent
v0_339.BackgroundTransparency = v0_310 [v0_337] and 0.85 or 1
end)
table.insert (v0_312, {Option = v0_337, Button = v0_338, Background = v0_339, Label = v0_340})
end
local v0_341 = math.min (# v0_307 * (v0_302 + 2) + 6, v0_303)
v0_318.Size = UDim2.new (1, 0, 0, v0_341)
v0_326 ()
end
local function v0_342 (v0_343)
v0_310 = {}
if v0_306 then
if type (v0_343) == "table" then
for v0_344, v0_345 in ipairs (v0_343) do
v0_310 [tostring (v0_345)] = true
end
end
elseif v0_343 ~= nil then
v0_310 [tostring (v0_343)] = true
end
end
function v0_319:SetOpen (v0_346)
v0_311 = v0_346 and true or false
v0_318.Visible = v0_311
v0_298.Tween (v0_317.Instance, {Rotation = v0_311 and 180 or 0}, 0.15)
v0_298.Tween (v0_314, {Color = v0_311 and v0_299.StrokeHover or v0_299.Stroke}, 0.15)
end
function v0_319:Get ()
if v0_306 then
return v0_320 ()
end
return v0_320 () [1]
end
function v0_319:Set (v0_347, v0_348)
v0_342 (v0_347)
v0_326 ()
if not v0_348 then
v0_330 ()
end
end
function v0_319:Refresh (v0_349, v0_350)
v0_307 = {}
for v0_351, v0_352 in ipairs (v0_349 or {}) do
table.insert (v0_307, tostring (v0_352))
end
if v0_350 then
local v0_353 = {}
for v0_354, v0_355 in ipairs (v0_307) do
v0_353 [v0_355] = v0_310 [v0_355]
end
v0_310 = v0_353
else
v0_310 = {}
end
v0_333 ()
end
v0_342 (v0_305.Default or v0_305.Value)
v0_333 ()
v0_298.Connect (v0_315.MouseButton1Click, function ()
v0_319:SetOpen (not v0_311)
end)
v0_298.Hover (v0_315, function ()
if not v0_311 then
v0_298.Tween (v0_314, {Color = v0_299.StrokeHover}, 0.12)
end
end, function ()
if not v0_311 then
v0_298.Tween (v0_314, {Color = v0_299.Stroke}, 0.2)
end
end)
if v0_305.Opened then
v0_319:SetOpen (true)
end
return v0_300.Finish (v0_304, v0_305, v0_319, v0_313, "Dropdown")
end
end,
["src/Elements/Paragraph.lua"] = function (...)
local v0_356 = ...
local v0_357 = v0_356.Utility
local v0_358 = v0_356.Theme
local v0_359 = v0_356.Base
v0_356.Elements.Paragraph = function (v0_360, v0_361)
v0_361 = v0_359.Opts (v0_361, "Paragraph")
v0_361.Description = v0_361.Content or v0_361.Description or ""
local v0_362 = v0_359.Card (v0_360, 0, false)
v0_362.BackgroundTransparency = 0.5
local v0_363, v0_364, v0_365 = v0_359.Text (v0_362, v0_361, 0)
v0_365.TextSize = 13
v0_365.Visible = true
local v0_366 = {}
function v0_366:Set (v0_367)
v0_365.Text = tostring (v0_367 or "")
end
function v0_366:SetTitle (v0_368)
v0_364.Text = tostring (v0_368 or "")
end
function v0_366:Get ()
return v0_365.Text
end
return v0_359.Finish (v0_360, v0_361, v0_366, v0_362, "Paragraph")
end
end,
["src/Components/Notification.lua"] = function (...)
local v0_369 = ...
local v0_370 = v0_369.Utility
local v0_371 = v0_369.Theme
local v0_372 = game:GetService ("TextService")
local v0_373 = 300
local v0_374 = nil
local function v0_375 ()
if v0_374 and v0_374.Parent then
return v0_374
end
local v0_376 = v0_370.NewGui ("LumenNotifications", 101)
v0_374 = v0_370.Frame ({
Name = "Holder",
AnchorPoint = Vector2.new (1, 0),
Position = UDim2.new (1, - 16, 0, 16),
Size = UDim2.new (0, v0_373, 1, - 32),
Parent = v0_376,
})
v0_370.List (v0_374, 8)
return v0_374
end
local function v0_377 (v0_378)
v0_378 = string.lower (tostring (v0_378 or "info"))
if v0_378 == "success" then
return v0_371.Success
elseif v0_378 == "warning" then
return v0_371.Warning
elseif v0_378 == "error" or v0_378 == "danger" then
return v0_371.Danger
end
return v0_371.Accent
end
function v0_369:Notify (v0_379)
if type (v0_379) == "string" then
v0_379 = {Content = v0_379}
end
v0_379 = v0_379 or {}
local v0_380 = v0_375 ()
local v0_381 = v0_379.Duration or 4
local v0_382 = v0_377 (v0_379.Type)
local v0_383 = tostring (v0_379.Content or "")
local v0_384 = v0_373 - 30
local v0_385 = 0
if v0_383 ~= "" then
local v0_386, v0_387 = pcall (function ()
return v0_372:GetTextSize (v0_383, 12, v0_371.FontRegular, Vector2.new (v0_384, 10000))
end)
v0_385 = v0_386 and v0_387.Y or 16
end
local v0_388 = 12 + 16 + (v0_385 > 0 and (4 + v0_385) or 0) + 14
local v0_389 = v0_370.Frame ({
Name = "Slot",
Size = UDim2.new (1, 0, 0, v0_388),
Parent = v0_380,
})
local v0_390 = v0_370.Box ({
Name = "Notification",
Position = UDim2.new (1, v0_373 + 20, 0, 0),
Size = UDim2.new (1, 0, 1, 0),
BackgroundColor3 = v0_371.Card,
ClipsDescendants = true,
Parent = v0_389,
})
v0_370.Corner (v0_390, v0_371.SmallRadius + 2)
v0_370.Stroke (v0_390, v0_371.Stroke, 1)
v0_370.Box ({
Name = "Accent",
Size = UDim2.new (0, 3, 1, 0),
BackgroundColor3 = v0_382,
Parent = v0_390,
})
v0_370.Label ({
Name = "Title",
Position = UDim2.fromOffset (16, 11),
Size = UDim2.new (1, - 30, 0, 16),
Text = tostring (v0_379.Title or "Notification"),
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_390,
})
if v0_385 > 0 then
v0_370.Label ({
Name = "Content",
Position = UDim2.fromOffset (16, 31),
Size = UDim2.new (1, - 30, 0, v0_385),
Font = v0_371.FontRegular,
Text = v0_383,
TextSize = 12,
TextColor3 = v0_371.Muted,
TextWrapped = true,
TextYAlignment = Enum.TextYAlignment.Top,
Parent = v0_390,
})
end
local v0_391 = v0_370.Box ({
Name = "Progress",
AnchorPoint = Vector2.new (0, 1),
Position = UDim2.new (0, 0, 1, 0),
Size = UDim2.new (1, 0, 0, 2),
BackgroundColor3 = v0_382,
BackgroundTransparency = 0.5,
Parent = v0_390,
})
v0_370.Tween (v0_390, {Position = UDim2.new (0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
v0_370.Tween (v0_391, {Size = UDim2.new (0, 0, 0, 2)}, v0_381, Enum.EasingStyle.Linear)
task.delay (v0_381, function ()
if not v0_389.Parent then
return
end
local v0_392 = v0_370.Tween (v0_390, {Position = UDim2.new (1, v0_373 + 20, 0, 0)}, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
v0_392.Completed:Wait ()
v0_389:Destroy ()
end)
end
end,
["src/Components/Section.lua"] = function (...)
local v0_393 = ...
local v0_394 = v0_393.Utility
local v0_395 = v0_393.Theme
local v0_396 = v0_393.Icons
local v0_397 = {}
v0_397.__index = v0_397
function v0_397:_nextOrder ()
self._order = self._order + 1
return self._order
end
function v0_397:Filter (v0_398)
v0_398 = string.lower (v0_398 or "")
local v0_399 = v0_398 == "" or string.find (string.lower (self.Name), v0_398, 1, true) ~= nil
local v0_400 = v0_399
for v0_401, v0_402 in ipairs (self.Items) do
local v0_403 = v0_399
or string.find (v0_402._name, v0_398, 1, true) ~= nil
or string.find (v0_402._desc, v0_398, 1, true) ~= nil
v0_402._match = v0_403
v0_402:_apply ()
if v0_403 then
v0_400 = true
end
end
self._match = v0_400
self.Frame.Visible = v0_400 and self._visible
return v0_400
end
function v0_397:SetVisible (v0_404)
self._visible = v0_404 and true or false
self.Frame.Visible = self._visible and self._match
end
function v0_397:SetName (v0_405)
self.Name = tostring (v0_405)
self._title.Text = self.Name
end
function v0_397:Destroy ()
for v0_406, v0_407 in ipairs (self.Tab.Sections) do
if v0_407 == self then
table.remove (self.Tab.Sections, v0_406)
break
end
end
self.Frame:Destroy ()
end
function v0_393.NewSection (v0_408, v0_409)
if type (v0_409) == "string" then
v0_409 = {Name = v0_409}
end
v0_409 = v0_409 or {}
local v0_410 = string.lower (tostring (v0_409.Side or ""))
local v0_411 = nil
if v0_410 == "left" then
v0_411 = "Left"
elseif v0_410 == "right" then
v0_411 = "Right"
else
v0_411 = v0_408._counts.Left <= v0_408._counts.Right and "Left" or "Right"
end
v0_408._counts [v0_411] = v0_408._counts [v0_411] + 1
local v0_412 = setmetatable ({
Name = tostring (v0_409.Name or "Section"),
Side = v0_411,
Tab = v0_408,
Items = {},
_order = 0,
_visible = v0_409.Visible ~= false,
_match = true,
}, v0_397)
local v0_413 = v0_394.Box ({
Name = "Section",
Size = UDim2.new (1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = v0_395.Card,
LayoutOrder = v0_408._counts [v0_411],
Parent = v0_408 [v0_411],
})
v0_394.Corner (v0_413, v0_395.Radius)
v0_394.Stroke (v0_413, v0_395.Stroke, 1)
v0_394.List (v0_413, 0)
local v0_414 = v0_394.Frame ({
Name = "Header",
Size = UDim2.new (1, 0, 0, 40),
LayoutOrder = 1,
Parent = v0_413,
})
local v0_415 = 16
if v0_409.Icon then
v0_396.Create (v0_414, v0_409.Icon, 14, v0_395.Accent, {
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 16, 0.5, 0),
})
v0_415 = 38
end
v0_412._title = v0_394.Label ({
Name = "Title",
Position = UDim2.fromOffset (v0_415, 0),
Size = UDim2.new (1, - (v0_415 + 16), 1, 0),
Text = v0_412.Name,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_414,
})
local v0_416 = v0_394.Frame ({
Name = "Content",
Size = UDim2.new (1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 2,
Parent = v0_413,
})
v0_394.Pad (v0_416, 12, 12, 0, 12)
v0_394.List (v0_416, 8)
v0_412.Frame = v0_413
v0_412.Content = v0_416
v0_413.Visible = v0_412._visible
for v0_417, v0_418 in pairs (v0_393.Elements) do
v0_412 [v0_417] = v0_418
end
table.insert (v0_408.Sections, v0_412)
return v0_412
end
end,
["src/Components/Tab.lua"] = function (...)
local v0_419 = ...
local v0_420 = v0_419.Utility
local v0_421 = v0_419.Theme
local v0_422 = v0_419.Icons
local v0_423 = {}
v0_423.__index = v0_423
function v0_423:Section (v0_424)
return v0_419.NewSection (self, v0_424)
end
function v0_423:Dashboard (v0_425)
return v0_419.Dashboard.Create (self, v0_425)
end
function v0_423:Select ()
self.Window:SelectTab (self)
end
function v0_423:Filter (v0_426)
for v0_427, v0_428 in ipairs (self.Sections) do
v0_428:Filter (v0_426)
end
end
function v0_423:_setActive (v0_429)
self.Active = v0_429
v0_420.Tween (self._background, {BackgroundTransparency = v0_429 and 0.1 or 1}, 0.15)
v0_420.Tween (self._label, {TextColor3 = v0_429 and v0_421.Text or v0_421.Muted}, 0.15)
self._icon:SetColor (v0_429 and v0_421.Accent or v0_421.Muted)
self.Page.Visible = v0_429
end
function v0_423:Destroy ()
self.Window:_removeTab (self)
self.Button:Destroy ()
self.Page:Destroy ()
end
function v0_419.NewTab (v0_430, v0_431)
if type (v0_431) == "string" then
v0_431 = {Name = v0_431}
end
v0_431 = v0_431 or {}
local v0_432 = tostring (v0_431.Name or "Tab")
local v0_433 = setmetatable ({
Name = v0_432,
Title = tostring (v0_431.Title or v0_432),
Icon = v0_431.Icon,
Window = v0_430,
Sections = {},
Active = false,
_counts = {Left = 0, Right = 0},
}, v0_423)
local v0_434 = v0_420.Button ({
Name = v0_432,
Size = UDim2.new (1, 0, 0, 34),
LayoutOrder = # v0_430.Tabs + 1,
Parent = v0_430._tabList,
})
local v0_435 = v0_420.Box ({
Name = "Background",
Size = UDim2.new (1, 0, 1, 0),
BackgroundColor3 = v0_421.Element,
BackgroundTransparency = 1,
Parent = v0_434,
})
v0_420.Corner (v0_435, v0_421.SmallRadius)
local v0_436 = v0_422.Create (v0_434, v0_431.Icon, 16, v0_421.Muted, {
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 12, 0.5, 0),
})
local v0_437 = v0_420.Label ({
Name = "Label",
Position = UDim2.fromOffset (38, 0),
Size = UDim2.new (1, - 46, 1, 0),
Text = v0_432,
TextColor3 = v0_421.Muted,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_434,
})
v0_420.Connect (v0_434.MouseEnter, function ()
if not v0_433.Active then
v0_420.Tween (v0_435, {BackgroundTransparency = 0.6}, 0.12)
end
end)
v0_420.Connect (v0_434.MouseLeave, function ()
if not v0_433.Active then
v0_420.Tween (v0_435, {BackgroundTransparency = 1}, 0.2)
end
end)
v0_420.Connect (v0_434.MouseButton1Click, function ()
v0_430:SelectTab (v0_433)
end)
local v0_438 = v0_420.New ("ScrollingFrame", {
Name = v0_432,
Size = UDim2.new (1, 0, 1, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 3,
ScrollBarImageColor3 = v0_421.StrokeHover,
CanvasSize = UDim2.new (),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
Visible = false,
Parent = v0_430._pages,
})
v0_420.Pad (v0_438, 16, 12, 2, 16)
v0_420.List (v0_438, 10)
v0_433.Top = v0_420.Frame ({
Name = "Top",
Size = UDim2.new (1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 1,
Parent = v0_438,
})
v0_420.List (v0_433.Top, 10)
local v0_439 = v0_420.Frame ({
Name = "Columns",
Size = UDim2.new (1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 2,
Parent = v0_438,
})
v0_420.List (v0_439, 10, {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Top,
})
for v0_440, v0_441 in ipairs ({"Left", "Right"}) do
local v0_442 = v0_420.Frame ({
Name = v0_441,
Size = UDim2.new (0.5, - 5, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = v0_440,
Parent = v0_439,
})
v0_420.List (v0_442, 10)
v0_433 [v0_441] = v0_442
end
v0_433.Button = v0_434
v0_433.Page = v0_438
v0_433._background = v0_435
v0_433._label = v0_437
v0_433._icon = v0_436
return v0_433
end
end,
["src/Components/Dashboard.lua"] = function (...)
local v0_443 = ...
local v0_444 = v0_443.Utility
local v0_445 = v0_443.Theme
local v0_446 = v0_443.Icons
local v0_447 = game:GetService ("Players")
local v0_448 = game:GetService ("RunService")
local v0_449 = game:GetService ("Stats")
local v0_450 = game:GetService ("TeleportService")
local v0_451 = v0_447.LocalPlayer
local v0_452 = 36
local v0_453 = {}
function v0_443.Logo (v0_454, v0_455, v0_456)
local v0_457 = nil
if v0_443.LogoImage then
v0_457 = v0_444.Image ({Size = UDim2.fromOffset (v0_455, v0_455), Image = v0_443.LogoImage, Parent = v0_454})
else
v0_457 = v0_444.Frame ({Size = UDim2.fromOffset (v0_455, v0_455), Parent = v0_454})
v0_444.Corner (v0_457, "full")
v0_444.Stroke (v0_457, v0_445.Accent, math.max (2, math.floor (v0_455 / 9)))
end
for v0_458, v0_459 in pairs (v0_456 or {}) do
v0_457 [v0_458] = v0_459
end
return v0_457
end
local function v0_460 (v0_461, v0_462, v0_463)
local v0_464 = v0_444.Box ({
Name = "Card",
Size = UDim2.new (1, 0, 0, v0_463),
BackgroundColor3 = v0_445.Card,
LayoutOrder = v0_462,
ClipsDescendants = true,
Parent = v0_461,
})
v0_444.Corner (v0_464, v0_445.Radius)
v0_444.Stroke (v0_464, v0_445.Stroke, 1)
return v0_464
end
local function v0_465 (v0_466, v0_467, v0_468, v0_469, v0_470, v0_471)
local v0_472 = v0_444.Button ({
Name = v0_469,
Size = UDim2.fromOffset (0, 26),
AutomaticSize = Enum.AutomaticSize.X,
BackgroundColor3 = v0_445.Element,
BackgroundTransparency = 0.2,
LayoutOrder = v0_467,
Parent = v0_466,
})
v0_444.Corner (v0_472, 6)
local v0_473 = v0_444.Stroke (v0_472, v0_445.Stroke, 1)
v0_444.Pad (v0_472, 8, 10, 0, 0)
v0_444.List (v0_472, 6, {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
})
local v0_474 = nil
if v0_468 == "logo" then
v0_474 = {Instance = v0_443.Logo (v0_472, 13, {LayoutOrder = 1}), SetColor = function () end}
else
v0_474 = v0_446.Create (v0_472, v0_468, 13, v0_470, {LayoutOrder = 1})
end
local v0_475 = v0_444.Label ({
Size = UDim2.new (0, 0, 1, 0),
AutomaticSize = Enum.AutomaticSize.X,
Text = v0_469,
TextSize = 12,
TextColor3 = v0_470,
LayoutOrder = 2,
Parent = v0_472,
})
local v0_476 = {}
function v0_476.SetActive (v0_477)
local v0_478 = v0_477 and v0_445.Accent or v0_445.Muted
v0_475.TextColor3 = v0_478
v0_474:SetColor (v0_478)
v0_473.Color = v0_477 and v0_445.Accent or v0_445.Stroke
end
if v0_471 then
v0_444.Connect (v0_472.MouseButton1Click, v0_471)
else
v0_472.Active = false
end
return v0_472, v0_476
end
local function v0_479 (v0_480, v0_481)
local v0_482 = v0_460 (v0_480, 1, 142)
local v0_483 = v0_444.Image ({
Name = "Avatar",
AnchorPoint = Vector2.new (1, 1),
Position = UDim2.new (1, - 10, 1, 0),
Size = UDim2.fromOffset (150, 150),
Image = "rbxthumb://type=AvatarBust&id=" .. v0_451.UserId .. "&w=420&h=420",
Parent = v0_482,
})
v0_444.New ("UIGradient", {
Transparency = NumberSequence.new ({
NumberSequenceKeypoint.new (0, 1),
NumberSequenceKeypoint.new (0.45, 0),
NumberSequenceKeypoint.new (1, 0),
}),
Parent = v0_483,
})
v0_444.Label ({
Name = "Caption",
Position = UDim2.fromOffset (22, 20),
Size = UDim2.new (1, - 200, 0, 14),
Text = string.upper (v0_481.Welcome or "Welcome back"),
TextSize = 11,
TextColor3 = v0_445.Muted,
Parent = v0_482,
})
local v0_484 = v0_444.Label ({
Name = "DisplayName",
Position = UDim2.fromOffset (22, 36),
Size = UDim2.new (1, - 200, 0, 30),
Font = v0_445.FontBold,
TextSize = 24,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_482,
})
local v0_485 = v0_444.Label ({
Name = "Username",
Position = UDim2.fromOffset (22, 67),
Size = UDim2.new (1, - 200, 0, 16),
Font = v0_445.FontRegular,
TextColor3 = v0_445.Muted,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_482,
})
local v0_486 = v0_444.Frame ({
Name = "Chips",
Position = UDim2.new (0, 22, 1, - 40),
Size = UDim2.new (1, - 44, 0, 26),
Parent = v0_482,
})
v0_444.List (v0_486, 6, {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
})
local v0_487, v0_488 = v0_465 (v0_486, 1, "logo", tostring (v0_481.Version or "v1.0"), v0_445.Accent, nil)
v0_488.SetActive (true)
local v0_489, v0_490 = v0_465 (v0_486, 2, "eye-off", "Name", v0_445.Muted, function ()
v0_443.Privacy:Set ("Name", not v0_443.Privacy.HideName)
end)
local v0_491, v0_492 = v0_465 (v0_486, 3, "user-x", "Avatar", v0_445.Muted, function ()
v0_443.Privacy:Set ("Avatar", not v0_443.Privacy.HideAvatar)
end)
v0_443.Privacy:Bind (function (v0_493, v0_494)
v0_484.Text = v0_493 and "Hidden" or v0_451.DisplayName
v0_485.Text = v0_493 and "@hidden" or ("@" .. v0_451.Name)
v0_483.ImageTransparency = v0_494 and 1 or 0
v0_490.SetActive (v0_493)
v0_492.SetActive (v0_494)
end)
return v0_482
end
local function v0_495 ()
local v0_496, v0_497 = pcall (function ()
return v0_449.Network.ServerStatsItem ["Data Ping"]:GetValue ()
end)
if v0_496 and type (v0_497) == "number" then
return v0_497
end
return 0
end
local function v0_498 (v0_499, v0_500, v0_501, v0_502, v0_503, v0_504, v0_505)
local v0_506 = v0_444.Frame ({
Name = v0_501,
Position = v0_500,
Size = UDim2.new (0.5, - 28, 0, 94),
Parent = v0_499,
})
v0_444.Label ({
Position = UDim2.fromOffset (0, 0),
Size = UDim2.new (0.3, 0, 0, 14),
Font = v0_445.FontMedium,
Text = v0_501,
TextSize = 11,
TextColor3 = v0_445.Muted,
Parent = v0_506,
})
local v0_507 = v0_444.Label ({
AnchorPoint = Vector2.new (1, 0),
Position = UDim2.new (1, 0, 0, 0),
Size = UDim2.new (0.7, 0, 0, 14),
Font = v0_445.FontRegular,
TextSize = 11,
TextColor3 = v0_445.Muted,
TextXAlignment = Enum.TextXAlignment.Right,
RichText = true,
Parent = v0_506,
})
local v0_508 = v0_444.Frame ({
Position = UDim2.fromOffset (0, 18),
Size = UDim2.new (1, 0, 0, 26),
Parent = v0_506,
})
v0_444.List (v0_508, 4, {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Bottom,
})
local v0_509 = v0_444.Label ({
Size = UDim2.new (0, 0, 1, 0),
AutomaticSize = Enum.AutomaticSize.X,
Font = v0_445.FontBold,
Text = "0",
TextSize = 22,
LayoutOrder = 1,
Parent = v0_508,
})
v0_444.Label ({
Size = UDim2.new (0, 0, 0, 20),
AutomaticSize = Enum.AutomaticSize.X,
Font = v0_445.FontRegular,
Text = v0_502,
TextSize = 12,
TextColor3 = v0_445.Muted,
LayoutOrder = 2,
Parent = v0_508,
})
local v0_510 = v0_444.Frame ({
Position = UDim2.fromOffset (0, 52),
Size = UDim2.new (1, 0, 0, 42),
Parent = v0_506,
})
v0_444.List (v0_510, 2, {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Bottom,
})
local v0_511 = {}
for v0_512 = 1, v0_452 do
local v0_513 = v0_444.Box ({
Name = "Bar",
Size = UDim2.new (1 / v0_452, - 2, 0.03, 0),
BackgroundColor3 = v0_503,
BackgroundTransparency = 1,
LayoutOrder = v0_512,
Parent = v0_510,
})
v0_444.Corner (v0_513, 1)
v0_511 [v0_512] = v0_513
end
local v0_514 = {}
local v0_515 = nil
local v0_516 = 0
local v0_517 = v0_444.Hex (v0_445.Text)
local v0_518 = {}
function v0_518.Push (v0_519)
table.insert (v0_514, v0_519)
if # v0_514 > v0_452 then
table.remove (v0_514, 1)
end
v0_515 = v0_515 and math.min (v0_515, v0_519) or v0_519
v0_516 = math.max (v0_516, v0_519)
local v0_520 = 0
local v0_521 = v0_505
for v0_522, v0_523 in ipairs (v0_514) do
v0_520 = v0_520 + v0_523
v0_521 = math.max (v0_521, v0_523)
end
v0_509.Text = tostring (math.floor (v0_519 + 0.5))
v0_507.Text = string.format (
'min <font color="%s"><b>%d</b></font>   avg <font color="%s"><b>%d</b></font>   max <font color="%s"><b>%d</b></font>',
v0_517, math.floor (v0_515 + 0.5),
v0_517, math.floor (v0_520 / # v0_514 + 0.5),
v0_517, math.floor (v0_516 + 0.5)
)
local v0_524 = v0_452 - # v0_514
for v0_525, v0_526 in ipairs (v0_511) do
local v0_527 = v0_514 [v0_525 - v0_524]
if v0_527 then
v0_526.BackgroundTransparency = 0
v0_526.BackgroundColor3 = v0_525 == v0_452 and v0_504 or v0_503
v0_526.Size = UDim2.new (1 / v0_452, - 2, math.max (0.03, math.min (1, v0_527 / v0_521)), 0)
end
end
end
return v0_518
end
local function v0_528 (v0_529, v0_530, v0_531)
local v0_532 = v0_444.Frame ({
Name = v0_531,
Position = v0_530,
Size = UDim2.new (0.5, - 28, 0, 36),
Parent = v0_529,
})
local v0_533 = v0_444.Label ({
Size = UDim2.new (1, 0, 0, 18),
Font = v0_445.FontBold,
Text = "-",
TextSize = 15,
Parent = v0_532,
})
v0_444.Label ({
Position = UDim2.fromOffset (0, 20),
Size = UDim2.new (1, 0, 0, 14),
Font = v0_445.FontRegular,
Text = v0_531,
TextSize = 11,
TextColor3 = v0_445.Muted,
Parent = v0_532,
})
return v0_533
end
local function v0_534 (v0_535)
local v0_536 = v0_460 (v0_535, 2, 158)
local v0_537 = v0_498 (v0_536, UDim2.fromOffset (16, 14), "FPS", "fps", Color3.fromRGB (62, 122, 72), Color3.fromRGB (128, 224, 140), 60)
local v0_538 = v0_498 (v0_536, UDim2.new (0.5, 12, 0, 14), "Ping", "ms", Color3.fromRGB (150, 62, 62), Color3.fromRGB (240, 96, 96), 120)
local v0_539 = v0_528 (v0_536, UDim2.fromOffset (16, 114), "Players")
local v0_540 = v0_528 (v0_536, UDim2.new (0.5, 12, 0, 114), "Session")
local v0_541 = 0
local v0_542 = os.clock ()
local v0_543 = v0_542
v0_444.Connect (v0_448.RenderStepped, function ()
v0_541 = v0_541 + 1
end)
task.spawn (function ()
while v0_536:IsDescendantOf (game) do
task.wait (0.5)
local v0_544 = os.clock ()
v0_537.Push (v0_541 / math.max (v0_544 - v0_542, 0.001))
v0_541 = 0
v0_542 = v0_544
v0_538.Push (v0_495 ())
v0_539.Text = # v0_447:GetPlayers () .. "/" .. v0_447.MaxPlayers
v0_540.Text = v0_444.Duration (v0_544 - v0_543)
end
end)
return v0_536
end
local function v0_545 (v0_546, v0_547, v0_548)
v0_443:Notify ({Title = v0_546, Content = v0_547, Type = v0_548, Duration = 3})
end
local function v0_549 (v0_550)
local v0_551 = {}
for v0_552, v0_553 in pairs (v0_550 or {}) do
v0_551 [v0_552] = v0_553
end
v0_551.Rejoin = v0_551.Rejoin or function ()
v0_545 ("Rejoining", "Teleporting back into this server")
task.spawn (function ()
local v0_554, v0_555 = pcall (function ()
if # v0_447:GetPlayers () <= 1 or game.JobId == "" then
v0_450:Teleport (game.PlaceId, v0_451)
else
v0_450:TeleportToPlaceInstance (game.PlaceId, game.JobId, v0_451)
end
end)
if not v0_554 then
v0_545 ("Rejoin failed", tostring (v0_555), "Error")
end
end)
end
v0_551.Hop = v0_551.Hop or function ()
v0_545 ("Server hop", "Joining another server")
task.spawn (function ()
local v0_556, v0_557 = pcall (function ()
v0_450:Teleport (game.PlaceId, v0_451)
end)
if not v0_556 then
v0_545 ("Server hop failed", tostring (v0_557), "Error")
end
end)
end
v0_551.Lowest = v0_551.Lowest or function ()
v0_545 ("Lowest server", "Provide Actions.Lowest in tab:Dashboard({...}) to enable this button", "Warning")
end
v0_551.JobId = v0_551.JobId or function ()
local v0_558 = setclipboard or toclipboard
if v0_558 then
pcall (v0_558, game.JobId)
v0_545 ("Copied", "Job ID copied to clipboard", "Success")
else
v0_545 ("Job ID", game.JobId ~= "" and game.JobId or "Studio session", "Warning")
end
end
return v0_551
end
local function v0_559 (v0_560, v0_561, v0_562, v0_563, v0_564)
local v0_565 = v0_444.Button ({
Name = v0_563,
Size = UDim2.new (0.25, - 6, 1, 0),
BackgroundColor3 = v0_445.Element,
BackgroundTransparency = 0.3,
LayoutOrder = v0_561,
Parent = v0_560,
})
v0_444.Corner (v0_565, v0_445.SmallRadius)
local v0_566 = v0_444.Stroke (v0_565, v0_445.Stroke, 1)
v0_446.Create (v0_565, v0_562, 16, v0_445.Muted, {
AnchorPoint = Vector2.new (0.5, 0),
Position = UDim2.new (0.5, 0, 0, 11),
})
v0_444.Label ({
AnchorPoint = Vector2.new (0.5, 1),
Position = UDim2.new (0.5, 0, 1, - 9),
Size = UDim2.new (1, - 8, 0, 14),
Font = v0_445.FontRegular,
Text = v0_563,
TextSize = 12,
TextColor3 = v0_445.Muted,
TextXAlignment = Enum.TextXAlignment.Center,
Parent = v0_565,
})
v0_444.Hover (v0_565, function ()
v0_444.Tween (v0_566, {Color = v0_445.StrokeHover}, 0.12)
v0_444.Tween (v0_565, {BackgroundTransparency = 0.1}, 0.12)
end, function ()
v0_444.Tween (v0_566, {Color = v0_445.Stroke}, 0.2)
v0_444.Tween (v0_565, {BackgroundTransparency = 0.3}, 0.2)
end)
v0_444.Connect (v0_565.MouseButton1Click, function ()
v0_566.Color = v0_445.Accent
v0_444.Tween (v0_566, {Color = v0_445.Stroke}, 0.35)
v0_444.Safe (v0_564)
end)
end
local function v0_567 (v0_568, v0_569)
local v0_570 = v0_460 (v0_568, 3, 168)
local v0_571 = v0_569.Thumbnail or ("rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150")
local v0_572 = v0_444.Image ({
Name = "Thumbnail",
Position = UDim2.fromOffset (16, 16),
Size = UDim2.fromOffset (56, 56),
Image = v0_571,
ScaleType = Enum.ScaleType.Crop,
BackgroundColor3 = v0_445.Element,
BackgroundTransparency = 0,
Parent = v0_570,
})
v0_444.Corner (v0_572, 8)
local v0_573 = v0_444.Label ({
Name = "GameName",
Position = UDim2.fromOffset (84, 20),
Size = UDim2.new (1, - 100, 0, 20),
Text = game.Name,
TextSize = 15,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_570,
})
local v0_574 = v0_444.Label ({
Name = "Creator",
Position = UDim2.fromOffset (84, 42),
Size = UDim2.new (1, - 100, 0, 16),
Font = v0_445.FontRegular,
TextSize = 12,
TextColor3 = v0_445.Muted,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_570,
})
local v0_575 = "..."
local function v0_576 ()
v0_574.Text = "by " .. v0_575 .. "  -  " .. # v0_447:GetPlayers () .. "/" .. v0_447.MaxPlayers .. " players"
end
v0_576 ()
v0_444.GameInfo (function (v0_577)
v0_573.Text = v0_569.GameName or v0_577.Name
v0_575 = v0_577.Creator
v0_576 ()
end)
v0_444.Connect (v0_447.PlayerAdded, v0_576)
v0_444.Connect (v0_447.PlayerRemoving, function ()
task.defer (v0_576)
end)
local v0_578 = v0_444.Frame ({
Name = "Actions",
Position = UDim2.fromOffset (16, 86),
Size = UDim2.new (1, - 32, 0, 56),
Parent = v0_570,
})
v0_444.List (v0_578, 8, {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Top,
})
local v0_579 = v0_549 (v0_569.Actions)
v0_559 (v0_578, 1, "refresh-cw", "Rejoin", v0_579.Rejoin)
v0_559 (v0_578, 2, "shuffle", "Hop", v0_579.Hop)
v0_559 (v0_578, 3, "users", "Lowest", v0_579.Lowest)
v0_559 (v0_578, 4, "copy", "Job ID", v0_579.JobId)
local v0_580 = game.JobId ~= "" and v0_444.Shorten (game.JobId, 8, 4) or "Studio"
v0_444.Label ({
Name = "Footer",
Position = UDim2.fromOffset (16, 148),
Size = UDim2.new (1, - 32, 0, 14),
Font = v0_445.FontRegular,
Text = "Job " .. v0_580 .. "  -  Place " .. game.PlaceId,
TextSize = 11,
TextColor3 = v0_445.Muted,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_570,
})
return v0_570
end
function v0_453.Create (v0_581, v0_582)
v0_582 = v0_582 or {}
local v0_583 = v0_581.Top
local v0_584 = {
Welcome = v0_479 (v0_583, v0_582),
Stats = v0_534 (v0_583),
Server = v0_567 (v0_583, v0_582),
}
function v0_584:Destroy ()
for v0_585, v0_586 in ipairs ({"Welcome", "Stats", "Server"}) do
if self [v0_586] then
self [v0_586]:Destroy ()
end
end
end
return v0_584
end
v0_443.Dashboard = v0_453
end,
["src/Components/Window.lua"] = function (...)
local v0_587 = ...
local v0_588 = v0_587.Utility
local v0_589 = v0_587.Theme
local v0_590 = v0_587.Icons
local v0_591 = game:GetService ("Players")
local v0_592 = game:GetService ("UserInputService")
local v0_593 = v0_591.LocalPlayer
local v0_594 = 188
local v0_595 = 60
local v0_596 = {}
v0_596.__index = v0_596
function v0_596:Tab (v0_597)
local v0_598 = v0_587.NewTab (self, v0_597)
table.insert (self.Tabs, v0_598)
if # self.Tabs == 1 then
self:SelectTab (v0_598)
end
return v0_598
end
function v0_596:Home (v0_599)
v0_599 = v0_599 or {}
local v0_600 = self:Tab ({
Name = v0_599.Name or "Home",
Icon = v0_599.Icon or "home",
Title = v0_599.Title or ("Welcome to " .. self.Title .. "!"),
})
local v0_601 = {}
for v0_602, v0_603 in pairs (v0_599) do
v0_601 [v0_602] = v0_603
end
v0_601.Version = v0_601.Version or self.Version
v0_600:Dashboard (v0_601)
self.HomeTab = v0_600
return v0_600
end
function v0_596:_setHeader (v0_604)
self._headerTitle.Text = v0_604.Title
if self._headerIcon then
self._headerIcon:Destroy ()
end
self._headerIcon = v0_590.Create (self._header, v0_604.Icon, 20, v0_589.Accent, {
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 24, 0.5, 0),
})
end
function v0_596:SelectTab (v0_605)
if self.ActiveTab == v0_605 then
return
end
if self.ActiveTab then
self.ActiveTab:Filter ("")
self.ActiveTab:_setActive (false)
end
self.ActiveTab = v0_605
v0_605:_setActive (true)
self._search.Text = ""
self:_setHeader (v0_605)
end
function v0_596:_removeTab (v0_606)
for v0_607, v0_608 in ipairs (self.Tabs) do
if v0_608 == v0_606 then
table.remove (self.Tabs, v0_607)
break
end
end
if self.ActiveTab == v0_606 then
self.ActiveTab = nil
if self.Tabs [1] then
self:SelectTab (self.Tabs [1])
end
end
end
function v0_596:Notify (v0_609)
v0_587:Notify (v0_609)
end
function v0_596:SetVisible (v0_610)
self.Main.Visible = v0_610 and true or false
self._restore.Visible = not self.Main.Visible
end
function v0_596:Toggle ()
self:SetVisible (not self.Main.Visible)
end
function v0_596:Destroy ()
for v0_611, v0_612 in ipairs (v0_587.Windows) do
if v0_612 == self then
table.remove (v0_587.Windows, v0_611)
break
end
end
self.Gui:Destroy ()
end
function v0_587:CreateWindow (v0_613)
if type (v0_613) == "string" then
v0_613 = {Title = v0_613}
end
v0_613 = v0_613 or {}
if v0_613.Logo then
v0_587.LogoImage = v0_613.Logo
end
local v0_614 = setmetatable ({
Title = tostring (v0_613.Title or "Lumen UI"),
Version = tostring (v0_613.Version or "v1.0"),
Keybind = v0_613.Keybind or Enum.KeyCode.RightShift,
Tabs = {},
}, v0_596)
local v0_615 = v0_613.Size or UDim2.fromOffset (780, 540)
local v0_616 = workspace.CurrentCamera
if v0_616 and v0_615.X.Scale == 0 and v0_615.Y.Scale == 0 then
local v0_617 = v0_616.ViewportSize
v0_615 = UDim2.fromOffset (math.min (v0_615.X.Offset, v0_617.X - 24), math.min (v0_615.Y.Offset, v0_617.Y - 24))
end
local v0_618 = v0_588.NewGui ("LumenUI", 100)
v0_614.Gui = v0_618
local v0_619 = v0_588.Box ({
Name = "Main",
AnchorPoint = Vector2.new (0.5, 0.5),
Position = UDim2.fromScale (0.5, 0.5),
Size = v0_615,
BackgroundColor3 = v0_589.Background,
ClipsDescendants = true,
Parent = v0_618,
})
v0_588.Corner (v0_619, 12)
v0_588.Stroke (v0_619, v0_589.Stroke, 1)
v0_614.Main = v0_619
local v0_620 = v0_588.Box ({
Name = "Sidebar",
Size = UDim2.new (0, v0_594, 1, 0),
BackgroundColor3 = v0_589.Sidebar,
Parent = v0_619,
})
v0_588.Box ({
Name = "Divider",
AnchorPoint = Vector2.new (1, 0),
Position = UDim2.new (1, 0, 0, 0),
Size = UDim2.new (0, 1, 1, 0),
BackgroundColor3 = v0_589.Stroke,
Parent = v0_620,
})
local v0_621 = v0_588.Frame ({
Name = "Brand",
Size = UDim2.new (1, 0, 0, 68),
Parent = v0_620,
})
v0_587.Logo (v0_621, 28, {Position = UDim2.fromOffset (16, 18)})
v0_588.Label ({
Position = UDim2.fromOffset (54, 17),
Size = UDim2.new (1, - 62, 0, 16),
Text = v0_614.Title,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_621,
})
v0_588.Label ({
Position = UDim2.fromOffset (54, 33),
Size = UDim2.new (1, - 62, 0, 14),
Font = v0_589.FontRegular,
Text = v0_614.Version,
TextSize = 11,
TextColor3 = v0_589.Muted,
Parent = v0_621,
})
local v0_622 = v0_613.Profile ~= false
v0_614._tabList = v0_588.New ("ScrollingFrame", {
Name = "Tabs",
Position = UDim2.fromOffset (10, 74),
Size = UDim2.new (1, - 20, 1, v0_622 and - 146 or - 84),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 0,
CanvasSize = UDim2.new (),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
Parent = v0_620,
})
v0_588.List (v0_614._tabList, 4)
if v0_622 then
local v0_623 = v0_588.Button ({
Name = "Profile",
AnchorPoint = Vector2.new (0, 1),
Position = UDim2.new (0, 10, 1, - 10),
Size = UDim2.new (1, - 20, 0, 52),
BackgroundColor3 = v0_589.Element,
BackgroundTransparency = 0.3,
Parent = v0_620,
})
v0_588.Corner (v0_623, 10)
local v0_624 = v0_588.Stroke (v0_623, v0_589.Stroke, 1)
local v0_625 = v0_588.Image ({
Position = UDim2.fromOffset (10, 10),
Size = UDim2.fromOffset (32, 32),
Image = "rbxthumb://type=AvatarHeadShot&id=" .. v0_593.UserId .. "&w=150&h=150",
BackgroundColor3 = v0_589.Card,
BackgroundTransparency = 0,
Parent = v0_623,
})
v0_588.Corner (v0_625, "full")
local v0_626 = v0_588.Box ({
AnchorPoint = Vector2.new (1, 1),
Position = UDim2.new (1, 1, 1, 1),
Size = UDim2.fromOffset (10, 10),
BackgroundColor3 = v0_589.Online,
Parent = v0_625,
})
v0_588.Corner (v0_626, "full")
v0_588.Stroke (v0_626, v0_589.Sidebar, 2)
local v0_627 = v0_588.Label ({
Position = UDim2.fromOffset (52, 10),
Size = UDim2.new (1, - 78, 0, 16),
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_623,
})
local v0_628 = v0_588.Label ({
Position = UDim2.fromOffset (52, 27),
Size = UDim2.new (1, - 78, 0, 14),
Font = v0_589.FontRegular,
Text = tostring (v0_613.Subtitle or game.Name),
TextSize = 11,
TextColor3 = v0_589.Muted,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_623,
})
v0_590.Create (v0_623, "chevron-right", 12, v0_589.Muted, {
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, - 12, 0.5, 0),
})
if not v0_613.Subtitle then
v0_588.GameInfo (function (v0_629)
v0_628.Text = v0_629.Name
end)
end
v0_587.Privacy:Bind (function (v0_630, v0_631)
v0_627.Text = v0_630 and "Hidden" or v0_593.DisplayName
v0_625.ImageTransparency = v0_631 and 1 or 0
end)
v0_588.Hover (v0_623, function ()
v0_588.Tween (v0_624, {Color = v0_589.StrokeHover}, 0.12)
end, function ()
v0_588.Tween (v0_624, {Color = v0_589.Stroke}, 0.2)
end)
v0_588.Connect (v0_623.MouseButton1Click, function ()
local v0_632 = v0_614.HomeTab or v0_614.Tabs [1]
if v0_632 then
v0_614:SelectTab (v0_632)
end
end)
end
local v0_633 = v0_588.Frame ({
Name = "Content",
Position = UDim2.fromOffset (v0_594, 0),
Size = UDim2.new (1, - v0_594, 1, 0),
Parent = v0_619,
})
local v0_634 = v0_588.Frame ({
Name = "Header",
Size = UDim2.new (1, 0, 0, v0_595),
Parent = v0_633,
})
v0_614._header = v0_634
v0_614._headerTitle = v0_588.Label ({
Position = UDim2.fromOffset (54, 0),
Size = UDim2.new (1, - 330, 1, 0),
Font = v0_589.FontMedium,
TextSize = 20,
TextTruncate = Enum.TextTruncate.AtEnd,
Parent = v0_634,
})
local v0_635 = v0_588.Box ({
Name = "Search",
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, - 60, 0.5, 0),
Size = UDim2.fromOffset (210, 34),
BackgroundColor3 = v0_589.Element,
BackgroundTransparency = 0.3,
Parent = v0_634,
})
v0_588.Corner (v0_635, 8)
local v0_636 = v0_588.Stroke (v0_635, v0_589.Stroke, 1)
v0_590.Create (v0_635, "search", 14, v0_589.Muted, {
AnchorPoint = Vector2.new (0, 0.5),
Position = UDim2.new (0, 12, 0.5, 0),
})
local v0_637 = v0_588.New ("TextBox", {
Name = "Input",
Position = UDim2.fromOffset (34, 0),
Size = UDim2.new (1, - 44, 1, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ClearTextOnFocus = false,
Font = v0_589.FontRegular,
PlaceholderText = "Search",
PlaceholderColor3 = v0_589.Muted,
Text = "",
TextColor3 = v0_589.Text,
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = v0_635,
})
v0_614._search = v0_637
v0_588.Connect (v0_637:GetPropertyChangedSignal ("Text"), function ()
if v0_614.ActiveTab then
v0_614.ActiveTab:Filter (v0_637.Text)
end
end)
v0_588.Connect (v0_637.Focused, function ()
v0_588.Tween (v0_636, {Color = v0_589.Accent}, 0.15)
end)
v0_588.Connect (v0_637.FocusLost, function ()
v0_588.Tween (v0_636, {Color = v0_589.Stroke}, 0.2)
end)
local v0_638 = v0_588.Button ({
Name = "Collapse",
AnchorPoint = Vector2.new (1, 0.5),
Position = UDim2.new (1, - 20, 0.5, 0),
Size = UDim2.fromOffset (28, 28),
Parent = v0_634,
})
local v0_639 = v0_590.Create (v0_638, v0_590.Resolve ("minimize-2") and "minimize-2" or "minus", 16, v0_589.Muted, {
AnchorPoint = Vector2.new (0.5, 0.5),
Position = UDim2.fromScale (0.5, 0.5),
})
v0_588.Hover (v0_638, function ()
v0_639:SetColor (v0_589.Text)
end, function ()
v0_639:SetColor (v0_589.Muted)
end)
v0_588.Connect (v0_638.MouseButton1Click, function ()
v0_614:SetVisible (false)
end)
v0_614._pages = v0_588.Frame ({
Name = "Pages",
Position = UDim2.fromOffset (0, v0_595),
Size = UDim2.new (1, 0, 1, - v0_595),
ClipsDescendants = true,
Parent = v0_633,
})
local v0_640 = v0_588.Button ({
Name = "Restore",
Position = UDim2.fromOffset (16, 16),
Size = UDim2.fromOffset (44, 44),
BackgroundColor3 = v0_589.Background,
BackgroundTransparency = 0,
Visible = false,
Parent = v0_618,
})
v0_588.Corner (v0_640, 12)
v0_588.Stroke (v0_640, v0_589.Stroke, 1)
v0_587.Logo (v0_640, 24, {
AnchorPoint = Vector2.new (0.5, 0.5),
Position = UDim2.fromScale (0.5, 0.5),
})
v0_588.Connect (v0_640.MouseButton1Click, function ()
v0_614:SetVisible (true)
end)
v0_614._restore = v0_640
v0_588.Drag (v0_634, v0_619)
v0_588.Drag (v0_621, v0_619)
v0_588.Connect (v0_592.InputBegan, function (v0_641, v0_642)
if not v0_642 and v0_641.KeyCode == v0_614.Keybind then
v0_614:Toggle ()
end
end)
table.insert (v0_587.Windows, v0_614)
return v0_614
end
end,
}
local v0_643 = (getgenv and getgenv ()) or _G
local v0_644 = v0_643.LumenUIBase or "https://raw.githubusercontent.com/YOUR_USER/Lumen-UI/main/"
local v0_645 = v0_1
local v0_646 = {
"src/Core/Theme.lua",
"src/Core/Utility.lua",
"src/Core/Icons.lua",
"src/Elements/Base.lua",
"src/Elements/Toggle.lua",
"src/Elements/Button.lua",
"src/Elements/Slider.lua",
"src/Elements/Dropdown.lua",
"src/Elements/Paragraph.lua",
"src/Components/Notification.lua",
"src/Components/Section.lua",
"src/Components/Tab.lua",
"src/Components/Dashboard.lua",
"src/Components/Window.lua",
}
local function v0_647 (v0_648)
if v0_643.LumenUILocalPath and readfile then
return readfile (v0_643.LumenUILocalPath .. "/" .. v0_648)
end
return game:HttpGet (v0_644 .. v0_648, true)
end
local function v0_649 (v0_650)
if v0_645 then
return v0_645 [v0_650]
end
local v0_651, v0_652 = loadstring (v0_647 (v0_650), "=" .. v0_650)
if not v0_651 then
error ("[Lumen] failed to compile " .. v0_650 .. ": " .. tostring (v0_652), 0)
end
return v0_651
end
if v0_643.LumenUI and type (v0_643.LumenUI.Destroy) == "function" then
pcall (function ()
v0_643.LumenUI:Destroy ()
end)
end
local v0_653 = {
Version = "1.0.0",
Flags = {},
Windows = {},
Elements = {},
_connections = {},
_guis = {},
}
function v0_653:Destroy ()
for v0_654, v0_655 in ipairs (self._connections) do
pcall (function ()
v0_655:Disconnect ()
end)
end
for v0_656, v0_657 in ipairs (self._guis) do
pcall (function ()
v0_657:Destroy ()
end)
end
self._connections = {}
self._guis = {}
self.Flags = {}
self.Windows = {}
if self.Privacy then
self.Privacy._binds = {}
end
if v0_643.LumenUI == self then
v0_643.LumenUI = nil
end
end
for v0_658, v0_659 in ipairs (v0_646) do
v0_649 (v0_659) (v0_653)
end
v0_643.LumenUI = v0_653
return v0_653
