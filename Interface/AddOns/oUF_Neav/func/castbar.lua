
local _, ns = ...
local config = ns.Config

function ns.ColorBorder(self, ...)
    local texture, r, g, b, s = ...
    self:SetBeautyBorderTexture(texture)
    self:SetBeautyBorderColor(r, g, b)
end

function ns.CustomTimeText(self, duration)
    self.Time:SetFormattedText("%.1f/%.1f", duration, self.max)
end

function ns.CustomDelayText(self, duration)
    self.Time:SetFormattedText("[|cffff0000-%.1f|r] %.1f/%.1f", self.delay, duration, self.max)
end

function ns.CreateCastbarStrings(self, size)
    self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY")

    if (size) then
        self.Castbar.Time:SetFont(config.font.normal, 21)
        self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -2, 0)
    else
        self.Castbar.Time:SetFont(config.font.normal, config.font.normalSize)
        self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -5, 0)
    end

    self.Castbar.Time:SetShadowOffset(1, -1)
    self.Castbar.Time:SetHeight(10)
    self.Castbar.Time:SetJustifyH("RIGHT")
    self.Castbar.Time:SetParent(self.Castbar)

    self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY")
    self.Castbar.Text:SetFont(config.font.normal, config.font.normalSize)
    self.Castbar.Text:SetPoint("LEFT", self.Castbar, 4, 0)

    if (size) then
        self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", -7, 0)
    else
        self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", -4, 0)
    end

    self.Castbar.Text:SetShadowOffset(1, -1)
    self.Castbar.Text:SetHeight(10)
    self.Castbar.Text:SetJustifyH("LEFT")
    self.Castbar.Text:SetParent(self.Castbar)
end
