--[[ Lumen UI - Paragraph (title + wrapped, rich-text body)
    Section:Paragraph({ Title = "About", Content = "Supports <b>rich</b> text." })
    Methods: Set(content), SetTitle(text), SetVisible(bool), Destroy()
]]
local Lumen = ...
local U = Lumen.Utility
local Theme = Lumen.Theme
local Base = Lumen.Base

Lumen.Elements.Paragraph = function(section, opts)
    opts = Base.Opts(opts, "Paragraph")
    opts.Description = opts.Content or opts.Description or ""

    local card = Base.Card(section, 0, false)
    card.BackgroundTransparency = 0.5
    local _, titleLabel, bodyLabel = Base.Text(card, opts, 0)
    bodyLabel.TextSize = 13
    bodyLabel.Visible = true

    local obj = {}

    function obj:Set(content)
        bodyLabel.Text = tostring(content or "")
    end

    function obj:SetTitle(text)
        titleLabel.Text = tostring(text or "")
    end

    function obj:Get()
        return bodyLabel.Text
    end

    return Base.Finish(section, opts, obj, card, "Paragraph")
end
