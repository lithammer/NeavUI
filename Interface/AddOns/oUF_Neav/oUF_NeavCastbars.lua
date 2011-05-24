
local interruptTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'

local function UpdateCastbarColor(self, unit, config)
    if (self.interrupt) then
        -- Castbar:SetStatusBarColor(unpack(config.interruptColor))
        -- Castbar.Bg:SetVertexColor(config.interruptColor[1]*0.3, config.interruptColor[2]*0.3, config.interruptColor[3]*0.3, 0.8)
        
        self:SetBorderTexture(interruptTexture)
        self:SetBorderColor(unpack(config.interruptColor))
        self:SetBorderShadowColor(unpack(config.interruptColor))
        
        if (self.IconOverlay) then
            self.IconOverlay:SetBorderTexture(interruptTexture)
            self.IconOverlay:SetBorderColor(unpack(config.interruptColor))
            self.IconOverlay:SetBorderShadowColor(unpack(config.interruptColor))
        end
    else
        -- Castbar:SetStatusBarColor(unpack(config.color))
        -- Castbar.Bg:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)
        
        self:SetBorderTexture(normalTexture)
        self:SetBorderColor(1, 1, 1)
        self:SetBorderShadowColor(0, 0, 0)
        
        if (self.IconOverlay) then
            self.IconOverlay:SetBorderTexture(normalTexture)
            self.IconOverlay:SetBorderColor(1, 1, 1)
            self.IconOverlay:SetBorderShadowColor(0, 0, 0)
        end
    end
end

    -- create the castbars
    
function oUF_Neav.CreateCastbars(self, unit)
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

    if (unit == 'player' or unit == 'target' or unit == 'focus' or unit == 'pet' and config.show) then 
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture(oUF_Neav.media.statusbar)
        self.Castbar:SetScale(0.93)
        self.Castbar:SetSize(config.width, config.height)
        self.Castbar:SetStatusBarColor(unpack(config.color))
        
        if (unit == 'focus') then
            self.Castbar:SetPoint('BOTTOM', self, 'TOP', 0, 25)
        else
            self.Castbar:SetPoint(unpack(config.position))
        end

        self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Bg:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Bg:SetAllPoints(self.Castbar)
        self.Castbar.Bg:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)
        
        if (unit == 'player') then
            local playerColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
            
            if (config.classcolor) then
                self.Castbar:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
                self.Castbar.Bg:SetVertexColor(playerColor.r*0.3, playerColor.g*0.3, playerColor.b*0.3, 0.8)
            end
            
            if (config.safezone) then
                self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, 'BORDER') 
                self.Castbar.SafeZone:SetTexture(unpack(config.safezoneColor))
            end
                
            if (config.showLatency) then
                self.Castbar.Latency = self.Castbar:CreateFontString(nil, 'OVERLAY')
                self.Castbar.Latency:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6, 1)
            end
        end
        
        self.Castbar:CreateBorder(11)
        self.Castbar:SetBorderPadding(3)
        
        self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Time:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
        self.Castbar.Time:SetShadowOffset(1, -1)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, 'RIGHT', -7, 0)  
        self.Castbar.Time:SetHeight(10)
        self.Castbar.Time:SetJustifyH('RIGHT')
        
        self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
        self.Castbar.Text:SetShadowOffset(1, -1)
        self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -7, 0)
        self.Castbar.Text:SetHeight(10)
        self.Castbar.Text:SetJustifyH('LEFT')
        
        if (config.icon.show) then
            self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
            self.Castbar.Icon:SetSize(config.height + 2, config.height + 2)
            self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            
            if (config.icon.position == 'LEFT') then
                self.Castbar.Icon:SetPoint('RIGHT', self.Castbar, 'LEFT', (config.icon.positionOutside and -8) or 0, 0)
            else
                self.Castbar.Icon:SetPoint('LEFT', self.Castbar, 'RIGHT', (config.icon.positionOutside and 8) or 0, 0)
            end

            if (config.icon.positionOutside) then
                self.Castbar.IconOverlay = CreateFrame('Frame', nil, self.Castbar)
                self.Castbar.IconOverlay:SetAllPoints(self.Castbar.Icon)
                self.Castbar.IconOverlay:CreateBorder(10)
                self.Castbar.IconOverlay:SetBorderPadding(2)
            else
                self.Castbar:SetBorderPadding(4 + config.height, 3, 3, 3, 4 + config.height, 3, 3, 3, 3)
            end
        end

            -- a interrupt indicator
    
        self.Castbar.PostCastStart = function(Castbar, unit)
            if (unit == 'player') then
                if (Castbar.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2
                    
                    Castbar.Latency:ClearAllPoints()
                    Castbar.Latency:SetPoint('RIGHT', Castbar, 'BOTTOMRIGHT', -1, -2) 
                    Castbar.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end
            
            if (unit == 'target' or unit == 'focus') then
                UpdateCastbarColor(Castbar, unit, config)
            end

                -- hide some specials spells like waterbold or firtebold (pets) because it gets really spammy
                
			if (unit == 'pet' and oUF_Neav.castbar.pet.ignoreSpells) then
				for _, spellId in pairs(oUF_Neav.castbar.pet.ignoreList) do
                    if (UnitCastingInfo('pet') == GetSpellInfo(spellId)) then
                        Castbar:Hide()
                    end
				end
			end
        end    

        self.Castbar.PostChannelStart = function(Castbar, unit)
            if (unit == 'player') then
                if (Castbar.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2
                    
                    Castbar.Latency:ClearAllPoints()
                    Castbar.Latency:SetPoint('LEFT', self.Castbar, 'BOTTOMLEFT', 1, -2) 
                    Castbar.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end
    
            if (unit == 'target' or unit == 'focus') then
                UpdateCastbarColor(Castbar, unit, config)
            end
        end    
        
        self.Castbar.CustomDelayText = function(self, duration)
            self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
        end
        
        self.Castbar.CustomTimeText = function(self, duration)
            self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
        end
    end
end

    -- mirror timers

for i = 1, MIRRORTIMER_NUMTIMERS do
    local bar = _G['MirrorTimer' .. i]
    bar:SetParent(UIParent)
    bar:SetScale(1.132)
    bar:SetHeight(18)
    bar:SetWidth(220)
    bar:CreateBorder(11)
    bar:SetBorderPadding(3)
    
    if (i > 1) then
        local p1, p2, p3, p4, p5 = bar:GetPoint()
        bar:SetPoint(p1, p2, p3, p4, p5 - 15)
    end
                    
    local statusbar = _G['MirrorTimer' .. i .. 'StatusBar']
    statusbar:SetStatusBarTexture(oUF_Neav.media.statusbar)
    statusbar:SetAllPoints(bar)
    
    local backdrop = select(1, bar:GetRegions())
    backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
    backdrop:SetVertexColor(0, 0, 0, 0.5)
    backdrop:SetAllPoints(bar)
    
    local border = _G['MirrorTimer' .. i .. 'Border']
    border:Hide()
    
    local text = _G['MirrorTimer' .. i .. 'Text']
    text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
    text:ClearAllPoints()
    text:SetPoint('CENTER', bar)
end

	-- battleground timer

local f = CreateFrame('Frame')
f:RegisterEvent('START_TIMER')
f:SetScript('OnEvent', function(self, event)
	for _, b in pairs(TimerTracker.timerList) do
		if (not b['bar'].beautyBorder) then
			local bar = b['bar']
			bar:SetScale(1.132)
			bar:SetHeight(18)
			bar:SetWidth(220)
            
            for i = 1, select('#', bar:GetRegions()) do
                local region = select(i, bar:GetRegions())
                
                if (region and region:GetObjectType() == 'Texture') then
                    region:SetTexture(nil)
                end
                
                if (region and region:GetObjectType() == 'FontString') then
                    region:ClearAllPoints()
                    region:SetPoint('CENTER', bar)
                    region:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig)
                end
            end
            
            bar:CreateBorder(11)
            bar:SetBorderPadding(3)
            bar:SetStatusBarTexture(oUF_Neav.media.statusbar)
            
			local backdrop = select(1, bar:GetRegions())
			backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
			backdrop:SetVertexColor(0, 0, 0, 0.5)
			backdrop:SetAllPoints(bar)
		end
	end
end)