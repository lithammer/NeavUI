
local interruptTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'
        
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
                self.Castbar.SafeZone:SetTexture(unpack(oUF_Neav.castbar.player.safezoneColor))
            end
                
            if (oUF_Neav.castbar.player.showLatency) then
                self.Castbar.Latency = self:CreateFontString(nil, 'OVERLAY')
                self.Castbar.Latency:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetParent(self.Castbar)
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6, 1)
            end
        end
        
        CreateBorder(self.Castbar, 11, 1, 1, 1, 3)
        
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
        
        -- ----------------------------------------------------------------
        -- A new/better interrupt indicator (than the old one)
        -- ----------------------------------------------------------------
    
        self.Castbar.PostCastStart = function(Castbar, unit, spell, spellrank)
            if (unit == 'player') then
                if (Castbar.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats();
                    local avgLag = (lagHome + lagWorld) / 2
                    
                    Castbar.Latency:ClearAllPoints()
                    Castbar.Latency:SetPoint('RIGHT', Castbar, 'BOTTOMRIGHT', -1, -2) 
                    Castbar.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end
            
            if (unit == 'target' or unit == 'focus') then
                if (Castbar.interrupt) then
                    -- Castbar:SetStatusBarColor(unpack(config.interruptColor))
                    -- Castbar.Bg:SetVertexColor(config.interruptColor[1]*0.3, config.interruptColor[2]*0.3, config.interruptColor[3]*0.3, 0.8)
                    self.Castbar:SetBorderTexture(interruptTexture)
                    self.Castbar:SetBorderColor(unpack(config.interruptColor))
                    self.Castbar:SetBorderShadowColor(unpack(config.interruptColor))
                else
                    -- Castbar:SetStatusBarColor(unpack(config.color))
                    -- Castbar.Bg:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)
                    self.Castbar:SetBorderTexture(normalTexture)
                    self.Castbar:SetBorderColor(1, 1, 1)
                    self.Castbar:SetBorderShadowColor(0, 0, 0)
                end
            end
        end    

        self.Castbar.PostChannelStart = function(Castbar, unit, spell, spellrank)
            if (unit == 'player') then
                if (Castbar.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats();
                    local avgLag = (lagHome + lagWorld) / 2
                    
                    Castbar.Latency:ClearAllPoints()
                    Castbar.Latency:SetPoint('LEFT', self.Castbar, 'BOTTOMLEFT', 1, -2) 
                    Castbar.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end
    
            if (unit == 'target' or unit == 'focus') then
                if (Castbar.interrupt) then
                    -- Castbar:SetStatusBarColor(unpack(config.interruptColor))
                    -- Castbar.Bg:SetVertexColor(config.interruptColor[1]*0.3, config.interruptColor[2]*0.3, config.interruptColor[3]*0.3, 0.8)
                    self.Castbar:SetBorderTexture(interruptTexture)
                    self.Castbar:SetBorderColor(unpack(config.interruptColor))
                    self.Castbar:SetBorderShadowColor(unpack(config.interruptColor))
                else
                    -- Castbar:SetStatusBarColor(unpack(config.color))
                    -- Castbar.Bg:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)
                    self.Castbar:SetBorderTexture(normalTexture)
                    self.Castbar:SetBorderColor(1, 1, 1)
                    self.Castbar:SetBorderShadowColor(0, 0, 0)
                end
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

    -- mirrortimers

for i = 1, MIRRORTIMER_NUMTIMERS do
    local bar = _G['MirrorTimer' .. i]
    bar:SetParent(UIParent)
    bar:SetScale(1.132)
    bar:SetHeight(18)
    bar:SetWidth(220)
    
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
    text:SetFont(CastingBarFrameText:GetFont(), 14)
    text:ClearAllPoints()
    text:SetPoint('CENTER', bar)
    
    CreateBorder(bar, 11, 1, 1, 1, 3)
end

	-- battleground timer

local BattlegroundTimer = CreateFrame('Frame')
BattlegroundTimer:RegisterEvent('START_TIMER')

BattlegroundTimer:SetScript('OnEvent', function(self, event)
	for _, b in pairs(TimerTracker.timerList) do
		if not b['bar'].skinned then

			local bar = b['bar']

			bar:SetScale(1.132)
			bar:SetHeight(18)
			bar:SetWidth(220)

			for i = 1, bar:GetNumRegions() do
				local region = select(i, bar:GetRegions())

				if (region:GetObjectType() == 'Texture') then
					region:SetTexture(nil)
				elseif (region:GetObjectType() == 'FontString') then
					region:SetFont(CastingBarFrameText:GetFont(), 14)
					region:ClearAllPoints()
					region:SetPoint('CENTER', bar)
				end
			end

			bar:SetStatusBarTexture(oUF_Neav.media.statusbar)

			local backdrop = select(1, bar:GetRegions())
			backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
			backdrop:SetVertexColor(0, 0, 0, 0.5)
			backdrop:SetAllPoints(bar)

			CreateBorder(bar, 11, 1, 1, 1, 3)

			b['bar'].skinned = true
		end
	end

end)
