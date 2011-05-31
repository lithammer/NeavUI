--[[

	Supported Units:
        Arena
        Arenatargets
        
	Supported Plugins:
        oUF_Smooth
        oUF_Trinkets

	Features:
        Castbars
        Debuff icons
        Raid icons
        Class colored background

--]]

if (not oUF_Neav.units.arena.show) then
    return
end

local function FormatValue(self)
    if (self >= 1000000) then
		return ('%.2fm'):format(self / 1e6)
    elseif (self >= 100000) then
		return ('%.1fk'):format(self / 1e3)
    else
        return self
    end
end

local function UpdateHealth(Health, unit, min, max)
    local self = Health:GetParent()

    if (Health.Value) then
        if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
            Health.Value:SetText((UnitIsDead(unit) and 'Dead') or (UnitIsGhost(unit) and 'Ghost') or (not UnitIsConnected(unit) and PLAYER_OFFLINE))
        else
            if (min == max) then
                Health.Value:SetText(FormatValue(min))
            else
                Health.Value:SetText(FormatValue(min)..' - '..format('%d%%', min/max * 100))
            end
        end
    end
    
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end
    
    if (self.Name.Background) then
        self.Name.Background:SetVertexColor(UnitSelectionColor(unit))
    end
end

local function UpdatePower(Power, unit, min, max)
    local self = Power:GetParent()

	local _, powerType, altR, altG, altB = UnitPowerType(unit)
	local unitPower = PowerBarColor[powerType]
    
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Power:SetValue(0)
    end
    
    if (Health.Value) then
        if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
            Power.Value:SetText('')
        elseif (min == 0) then
            Power.Value:SetText('')   
        else
            Power.Value:SetText(FormatValue(min))
        end
    end
    
    if (unitPower) then
        Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
	else
        Power:SetStatusBarColor(altR, altG, altB)
	end
end

local function UpdateAuraIcons(auras, button)
    button.icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)

	button.overlay:SetTexture(oUF_Neav.media.border)
	button.overlay:SetTexCoord(0, 1, 0, 1)
    button.overlay:ClearAllPoints()
    button.overlay:SetPoint('TOPRIGHT', button, 1.35, 1.35)
    button.overlay:SetPoint('BOTTOMLEFT', button, -1.35, -1.35)

    button.cd:SetReverse()
    button.cd:ClearAllPoints()
    button.cd:SetPoint('TOPRIGHT', button.icon, 'TOPRIGHT', -1, -1)
    button.cd:SetPoint('BOTTOMLEFT', button.icon, 'BOTTOMLEFT', 1, 1)

    button.count:SetFont('Fonts\\ARIALN.ttf', 13, 'OUTLINE')
    button.count:ClearAllPoints()
    button.count:SetPoint('BOTTOMRIGHT', 1, 1)

    if (not button.background) then
        button.background = button:CreateTexture(nil, 'BACKGROUND')
        button.background:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
        button.background:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
        button.background:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderBackground')
        button.background:SetVertexColor(0, 0, 0, 1)
    end

	button.overlay.Hide = function(self)
        self:SetVertexColor(1, 0, 0) -- 0.45, 0.45, 0.45, 1)
    end
end

local function CreateArenaLayout(self, unit)
	self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

    self:SetFrameStrata('MEDIUM')
    
    if (unit == 'arena1target' or unit == 'arena2target' or unit == 'arena3target' or unit == 'arena4target' or unit == 'arena5target') then
        self.targetUnit = true
    else
        self.arenaUnit = true
    end
    
        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	
        -- texture

    self.Texture = self.Health:CreateTexture('$parentTextureFrame', 'ARTWORK')
    self.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\arenaFrameTexture')
    self.Texture:SetSize(250, 129)
    self.Texture:SetPoint('CENTER', self, 31, -24)

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')
    self.Health:SetSize(115, 8)
    self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -43)
    
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')
    self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -3)
    self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -3)
    self.Power:SetHeight(self.Health:GetHeight())
    self.Power.frequentUpdates = true
    self.Power.Smooth = true

    self.Power.PostUpdate = UpdatePower

        -- background

    self.Background = self.Power:CreateTexture(nil, 'BACKGROUND')
    self.Background:SetTexture(oUF_Neav.media.statusbar)
    self.Background:SetVertexColor(0, 0, 0, 0.55)
    self.Background:SetPoint('TOPRIGHT', self.Health)
    self.Background:SetPoint('BOTTOMLEFT', self.Power)

        -- name

    self.Name = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Name:SetFont(oUF_Neav.media.fontThick, oUF_Neav.font.fontBig)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH('CENTER')
    self.Name:SetSize(110, 10)
    self.Name:SetPoint('BOTTOM', self.Health, 'TOP', 0, 6)

    self:Tag(self.Name, '[name]')
    self.UNIT_NAME_UPDATE = UpdateFrame
    
    if (self.arenaUnit) then
    
            -- health text

        self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Health.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
        self.Health.Value:SetShadowOffset(1, -1)
        self.Health.Value:SetPoint('CENTER', self.Health)
        
                -- power text

        self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Power.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
        self.Power.Value:SetShadowOffset(1, -1)
        self.Power.Value:SetPoint('CENTER', self.Power)
    
            -- colored name background
            
        self.Name.Background = self.Health:CreateTexture('$parentNameBackground', 'BACKGROUND')
        self.Name.Background:SetHeight(18)
        self.Name.Background:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.Name.Background:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Background:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Background:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')

            -- raidicons

        self.RaidIcon = self.Health:CreateTexture('$parentRaidIcon', 'OVERLAY', self)
        self.RaidIcon:SetPoint('CENTER', self, 'TOPRIGHT', -9, -5)
        self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
        self.RaidIcon:SetSize(26, 26)
        
        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs.size = oUF_Neav.units.arena.auraSize
        self.Debuffs:SetHeight(self.Debuffs.size * 3)
        self.Debuffs:SetWidth(self.Debuffs.size * 5)
        self.Debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 6, -6)
        self.Debuffs.initialAnchor = 'TOPLEFT'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs.num = 8
        self.Debuffs.spacing = 4.5

        self.Debuffs.PostCreateIcon = UpdateAuraIcons
    
        if (oUF_Neav.castbar.arena.icon.size) then
            self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
            self.Castbar:SetStatusBarTexture(oUF_Neav.media.statusbar)
            self.Castbar:SetParent(self)
            self.Castbar:SetHeight(21)
            self.Castbar:SetWidth(200)
            self.Castbar:SetStatusBarColor(unpack(oUF_Neav.castbar.arena.color))
            self.Castbar:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -16, 4)

            self.Castbar.Background = self.Castbar:CreateTexture(nil, 'BACKGROUND')
            self.Castbar.Background:SetTexture('Interface\\Buttons\\WHITE8x8')
            self.Castbar.Background:SetAllPoints(self.Castbar)
            self.Castbar.Background:SetVertexColor(oUF_Neav.castbar.arena.color[1]*0.3, oUF_Neav.castbar.arena.color[2]*0.3, oUF_Neav.castbar.arena.color[3]*0.3, 0.8)
                
            self.Castbar:CreateBorder(11)
            self.Castbar:SetBorderPadding(3)
            
            self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'BACKGROUND')
            self.Castbar.Icon:SetSize(oUF_Neav.castbar.arena.icon.size, oUF_Neav.castbar.arena.icon.size)
            self.Castbar.Icon:SetPoint('TOPRIGHT', self.Castbar, 'TOPLEFT', -10, 0.45)
            self.Castbar.Icon:SetTexture(1, 1, 1)
            
            self.Castbar.Icon.Overlay = self.Castbar:CreateTexture(nil, 'ARTWORK')
            self.Castbar.Icon.Overlay:SetPoint('TOPRIGHT', self.Castbar.Icon, 3, 3)
            self.Castbar.Icon.Overlay:SetPoint('BOTTOMLEFT', self.Castbar.Icon, -3, -3)
            self.Castbar.Icon.Overlay:SetTexture(oUF_Neav.media.border)
            self.Castbar.Icon.Overlay:SetVertexColor(1, 0, 0)

            self.Castbar.Icon.Shadow = self.Castbar:CreateTexture(nil, 'BACKGROUND')
            self.Castbar.Icon.Shadow:SetPoint('TOPRIGHT', self.Castbar.Icon, 6, 6)
            self.Castbar.Icon.Shadow:SetPoint('BOTTOMLEFT', self.Castbar.Icon, -6, -6)
            self.Castbar.Icon.Shadow:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderBackground')
            self.Castbar.Icon.Shadow:SetVertexColor(0, 0, 0, 1)

            self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')
            self.Castbar.Time:SetFont(oUF_Neav.media.font, 21)
            self.Castbar.Time:SetShadowOffset(1, -1)
            self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -2, 0)  
            self.Castbar.Time:SetHeight(10)
            self.Castbar.Time:SetJustifyH('RIGHT')
                
            self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
            self.Castbar.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 2)
            self.Castbar.Text:SetShadowOffset(1, -1)
            self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
            self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -4, 0)
            self.Castbar.Text:SetHeight(10)
            self.Castbar.Text:SetJustifyH('LEFT')

            self.Castbar.CustomDelayText = function(self, duration)
                self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
            end
            
            self.Castbar.CustomTimeText = function(self, duration)
                self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
            end
        end
        
            -- oUF_Trinket support
            
        self.Trinket = CreateFrame('Frame', nil, self)
        self.Trinket:SetSize(30, 30)
        self.Trinket:SetPoint('RIGHT', self, 'LEFT', -10, 1)
        self.Trinket.trinketUseAnnounce = true
        self.Trinket.trinketUpAnnounce = true
        
            -- oUF_Talents support
        --[[    
        self.Talents = self.Health:CreateFontString(nil, 'OVERLAY')
        self.Talents:SetFont(oUF_Neav.media.font, 16)
        self.Talents:SetTextColor(1, 0, 0)
        self.Talents:SetPoint('BOTTOM', self.Health, 'TOP', 0, 12)
        --]]
        
        self:SetSize(132, 46)
    end
    
    if (self.targetUnit) then
		self:SetSize(110, 20)
        
        self.Portrait = self:CreateTexture('$parentPortrait', 'BACKGROUND')
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)

        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-SmallTargetingFrame')
        self.Texture:SetPoint('CENTER', self, 0, -2)
        self.Texture:SetSize(128, 64)

        self.Name:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 2, -4)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetSize(100, 10)

        self.Health:SetSize(70, 5)
        self.Health:ClearAllPoints()
        self.Health:SetPoint('CENTER', self.Texture, 15, 8)
        
        self.Power:SetHeight(self.Health:GetHeight())
    end
    
    self:SetScale(oUF_Neav.units.arena.scale)
    
	return self
end

oUF:RegisterStyle('oUF_Neav_Arena', CreateArenaLayout)
oUF:Factory(function(self)
	oUF:SetActiveStyle('oUF_Neav_Arena')

	local arena = {}
    local arenaTarget = {}
    for i = 1, 5 do
        arena[i] = self:Spawn('arena'..i, 'oUF_Neav_ArenaFrame'..i)

        if (i == 1) then
            arena[i]:SetPoint(unpack(oUF_Neav.units.arena.position))
        else
            arena[i]:SetPoint('TOPLEFT', arena[i-1], 'BOTTOMLEFT', 0, (oUF_Neav.castbar.arena.icon.size and -80) or -50)
        end
    
        arenaTarget[i] = self:Spawn('arena'..i..'target', 'oUF_Neav_ArenaFrame'..i..'Target')
        arenaTarget[i]:SetPoint('TOPRIGHT', arena[i], 'BOTTOMLEFT', 71, -7)
    end
end)
