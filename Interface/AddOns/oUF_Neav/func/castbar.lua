
local _, ns = ...
local config = ns.Config

function ns.ColorBorder(self, ...)
    local texture, r, g, b = ...
    self:SetBeautyBorderTexture(texture)
    self:SetBeautyBorderColor(r, g, b)
end

function ns.UpdateCastbarColor(self)
    local startColor = self.channeling and self.channeledColor or self.castColor or {1.0, 0.7, 0.0}
    local nonInterruptibleColor = self.nonInterruptibleColor or {0.7, 0.0, 0.0}

    self:SetStatusBarColor(unpack(startColor))
    self.Background:SetVertexColor(startColor[1]*0.3, startColor[2]*0.3, startColor[3]*0.3)

    if self.unit ~= "player" then
        if self.notInterruptible then
            ns.ColorBorder(self, "white", unpack(nonInterruptibleColor))

            if self.IconOverlay then
                ns.ColorBorder(self.IconOverlay, "white", unpack(nonInterruptibleColor))
            end
        else
            ns.ColorBorder(self, "default", 1.0, 1.0, 1.0)

            if self.IconOverlay then
                ns.ColorBorder(self.IconOverlay, "default", 1.0, 1.0, 1.0)
            end
        end
    else
        ns.ColorBorder(self, "default", 1.0, 1.0, 1.0)

        if self.IconOverlay then
            ns.ColorBorder(self.IconOverlay, "default", 1.0, 1.0, 1.0)
        end
    end
end

function ns.CustomTimeText(self, duration)
    if self.max > 86400 then
        self.Time:SetFormattedText("%.1f/%.1f", floor(duration/86400 + 0.5), floor(self.max/86400 + 0.5))
    else
        self.Time:SetFormattedText("%.1f/%.1f", duration, self.max)
    end
end

function ns.CustomDelayText(self, duration)
    self.Time:SetFormattedText("[|cffff0000-%.1f|r] %.1f/%.1f", self.delay, duration, self.max)
end

function ns.CreateCastbarStrings(self, size)
    self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY")

    if size then
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

    if size then
        self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", -7, 0)
    else
        self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", -4, 0)
    end

    self.Castbar.Text:SetShadowOffset(1, -1)
    self.Castbar.Text:SetHeight(10)
    self.Castbar.Text:SetJustifyH("LEFT")
    self.Castbar.Text:SetParent(self.Castbar)
end