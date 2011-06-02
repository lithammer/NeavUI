
local _, ns = ...

function ns.ColorBorder(self, ...)
    local texture, r, g, b, s = ...
    self:SetBorderTexture(texture)
    self:SetBorderColor(r, g, b)
    self:SetBorderShadowColor(s or r, s or g, s or b)
end

function ns.CustomTimeText(self, duration)
    self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
end

function ns.CustomDelayText(self, duration)
    self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
end

function ns.CreateCastbarStrings(self, size)
    self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')
        
    if (size) then
        self.Castbar.Time:SetFont(oUF_Neav.media.font, 21)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -2, 0)  
    else   
        self.Castbar.Time:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -5, 0)  
    end
        
    self.Castbar.Time:SetShadowOffset(1, -1)
    self.Castbar.Time:SetHeight(10)
    self.Castbar.Time:SetJustifyH('RIGHT')
    self.Castbar.Time:SetParent(self.Castbar)
        
    self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
        
    if (size) then
        self.Castbar.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 2)
        self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -7, 0)
    else
        self.Castbar.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
        self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -4, 0)
    end
    
    self.Castbar.Text:SetShadowOffset(1, -1)
    self.Castbar.Text:SetHeight(10)
    self.Castbar.Text:SetJustifyH('LEFT')
    self.Castbar.Text:SetParent(self.Castbar)  
end