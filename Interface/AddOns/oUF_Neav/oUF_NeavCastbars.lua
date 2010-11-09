
    -- custom channeling function
    
local function UpdateChannelStart(self, event, unit, name, rank, text) 
    if (self.Castbar.Latency) then
        self.Castbar.Latency:ClearAllPoints()
        self.Castbar.Latency:SetPoint('LEFT', self.Castbar, 'BOTTOMLEFT', 1, -1) 
        
        local _, _, ms = GetNetStats()
        self.Castbar.Latency:SetText(ms..'ms')
    end

	if (self.Castbar.SafeZone) then
        self.Castbar.SafeZone:SetDrawLayer('ARTWORK')
        self.Castbar.SafeZone:SetPoint('TOPLEFT', self.Castbar)
        self.Castbar.SafeZone:SetPoint('BOTTOMLEFT', self.Castbar)
	end
end

    -- custom casting function
    
local function UpdateCastStart(self, event, unit, name, rank, text, castid)
    if (self.Castbar.Latency and unit == 'player') then
        self.Castbar.Latency:ClearAllPoints()
        self.Castbar.Latency:SetPoint('RIGHT', self.Castbar, 'BOTTOMRIGHT', -1, -1) 
        
        local _, _, ms = GetNetStats()
        self.Castbar.Latency:SetText(ms..'ms')
    end

	if (self.Castbar.SafeZone) then
        self.Castbar.SafeZone:SetDrawLayer('BORDER')
        self.Castbar.SafeZone:SetPoint('TOPRIGHT', self.Castbar)
        self.Castbar.SafeZone:SetPoint('BOTTOMRIGHT', self.Castbar)
	end
end

    -- create the castbars
    
function CreateCastbars(self, unit)
    local config
    if (unit == 'player') then
        config = oUF_Neav.castbar.player
    elseif (unit == 'target') then
        config = oUF_Neav.castbar.target
    elseif (unit == 'focus') then
        config = oUF_Neav.castbar.focus
    elseif (unit == 'pet') then
        config = oUF_Neav.castbar.pet
    end

    if (unit == 'player' or unit == 'target' or unit == 'focus' or unit == 'pet') then 
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture(oUF_Neav.media.statusbar)
        self.Castbar:SetParent(UIParent)
        self.Castbar:SetScale(1.132)
        self.Castbar:SetHeight(config.height)
        self.Castbar:SetWidth(config.width)
        self.Castbar:SetStatusBarColor(unpack(config.color))
        if (unit == 'focus') then
            self.Castbar:SetPoint('BOTTOM', self, 'TOP', 0, 25)
        else
            self.Castbar:SetPoint(unpack(config.position))
        end
        
        if (unit == 'target') then
            self:HookScript('OnHide', function(self)
                self.Castbar:Hide()
            end)
        end
        
        self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Bg:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Bg:SetAllPoints(self.Castbar)
        self.Castbar.Bg:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)
        
        if (unit == 'player') then
            local playerColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
            if (oUF_Neav.castbar.player.classcolor) then
                self.Castbar:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
                self.Castbar.Bg:SetVertexColor(playerColor.r*0.3, playerColor.g*0.3, playerColor.b*0.3, 0.8)
            end
            
            if (oUF_Neav.castbar.player.safezone) then
                self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, 'BORDER') 
                self.Castbar.SafeZone:SetTexture('Interface\\Buttons\\WHITE8x8')
                self.Castbar.SafeZone:SetVertexColor(1, 0.5, 0, 1)
            end
                
            if (oUF_Neav.castbar.player.showLatency) then
                self.Castbar.Latency = self:CreateFontString(nil, 'ARTWORK')
                self.Castbar.Latency:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetParent(self.Castbar)
                self.Castbar.Latency:SetDrawLayer('OVERLAY')
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6)
                self.Castbar.Latency:SetAlpha(1)
            end
            
            self.PostCastStart = UpdateCastStart
            self.PostChannelStart = UpdateChannelStart
        end
        
        --CreateBorder(self.Castbar, 11, 1, 1, 1, 3)
		CreateBorder(self.Castbar, 11, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

        self.Castbar.CustomDelayText = function(self, duration)
            self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
        end
        
        self.Castbar.CustomTimeText = function(self, duration)
            self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
        end
        
        self.Castbar.Time = self:CreateFontString(nil, 'ARTWORK')
        self.Castbar.Time:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
        self.Castbar.Time:SetShadowOffset(1, -1)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, 'RIGHT', -7, 0)  
        self.Castbar.Time:SetHeight(10)
        self.Castbar.Time:SetJustifyH('RIGHT')
        self.Castbar.Time:SetParent(self.Castbar)
        
        self.Castbar.Text = self:CreateFontString(nil, 'ARTWORK')
        self.Castbar.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
        self.Castbar.Text:SetShadowOffset(1, -1)
        self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -7, 0)
        self.Castbar.Text:SetHeight(10)
        self.Castbar.Text:SetJustifyH('LEFT')
        self.Castbar.Text:SetParent(self.Castbar)  

        if (unit == 'target' or unit == 'focus') then
            if ((unit == 'target' and oUF_Neav.castbar.target.showInterruptHighlight) or (unit == 'focus' and oUF_Neav.castbar.focus.showInterruptHighlight)) then
                self.Shadow = {}
                
                for i = 1, 8 do
                    self.Shadow[i] = self.Castbar:CreateTexture(nil, 'BACKGROUND')
                    self.Shadow[i]:SetParent(self.Castbar)
                    self.Shadow[i]:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\error')
                    self.Shadow[i]:SetWidth(20) 
                    self.Shadow[i]:SetHeight(20)
                    self.Shadow[i]:SetVertexColor(unpack(config.interruptColor))
                end
                
                self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
                self.Shadow[1]:SetPoint('TOPLEFT', self.Castbar, -10, 10)

                self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
                self.Shadow[2]:SetPoint('TOPRIGHT', self.Castbar, 10, 10)

                self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
                self.Shadow[3]:SetPoint('BOTTOMLEFT', self.Castbar, -10, -10)

                self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
                self.Shadow[4]:SetPoint('BOTTOMRIGHT', self.Castbar, 10, -10)

                self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
                self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
                self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')

                self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
                self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
                self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')

                self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
                self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
                self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')

                self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
                self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
                self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
                
                self.hasShadow = true
            else
                self.hasShadow = false
            end
            
            local interruptFrame = CreateFrame('Frame')

			interruptFrame:RegisterEvent('UNIT_SPELLCAST_START')
			interruptFrame:RegisterEvent('UNIT_SPELLCAST_DELAYED')
			interruptFrame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
			interruptFrame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE')
            interruptFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
            interruptFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
            
            interruptFrame:SetScript('OnEvent', function()
                local name, _, _, _, _, _, _, _, interrupt = UnitCastingInfo(unit) 
            
                if (self.hasShadow) then   
                    for i = 1, 8 do
                        self.Shadow[i]:Hide()
                    end
                end
                
                if (name) then
                    if (interrupt) then
                        self.Castbar:SetStatusBarColor(unpack(config.interruptColor))
                        self.Castbar.Bg:SetVertexColor(config.interruptColor[1]*0.3, config.interruptColor[2]*0.3, config.interruptColor[3]*0.3, 0.8)

                        if (self.hasShadow) then
                            for i = 1, 8 do
                                self.Shadow[i]:Show()
                            end
                        end
                    else
                        self.Castbar:SetStatusBarColor(unpack(config.color))
                        self.Castbar.Bg:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)

                        if (self.hasShadow) then
                            for i = 1, 8 do
                                self.Shadow[i]:Hide()
                            end
                        end
                    end
                end
            end)
        end
    end
end

    -- mirrortimers
    
for _, bar in pairs({
    'MirrorTimer1',
    'MirrorTimer2',
    'MirrorTimer3',
}) do   
    for i, region in pairs({_G[bar]:GetRegions()}) do
        if (region.GetTexture and region:GetTexture() == 'SolidTexture') then
            region:Hide()
        end
    end

    CreateBorder(_G[bar], 11, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

    _G[bar..'Border']:Hide()
    
    _G[bar]:SetParent(UIParent)
    _G[bar]:SetScale(1.132)
    _G[bar]:SetHeight(18)
    _G[bar]:SetWidth(220)
      
    _G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
    _G[bar..'Background']:SetTexture('Interface\\Buttons\\WHITE8x8')
    _G[bar..'Background']:SetAllPoints(bar)
    _G[bar..'Background']:SetVertexColor(0, 0, 0, 0.5)
        
    _G[bar..'Text']:SetFont(CastingBarFrameText:GetFont(), 14)
    _G[bar..'Text']:ClearAllPoints()
    _G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 1)
        
    _G[bar..'StatusBar']:SetAllPoints(_G[bar])
end
