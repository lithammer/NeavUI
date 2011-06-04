--[[

	Supported Units:
        Boss
        
	Supported Plugins:
        oUF_Smooth

	Features:
        Castbars
        Buff icons (for boss abilities)
        Raid icons

--]]

local _, ns = ...
local config = ns.config

local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then 
        return 
    end

    if (self.Glow) then
        local threat = UnitThreatSituation('player', unit or self.unit)

        if (threat and threat > 0) then
            local r, g, b
            r, g, b = GetThreatStatusColor(threat)
            self.Glow:SetVertexColor(r, g, b, 1)
        else
            self.Glow:SetVertexColor(0, 0, 0, 0)
        end
	end
end

local function UpdateHealth(Health, unit, min, max)
    local self = Health:GetParent()

    if (UnitIsDead(unit)) then
        Health.Value:SetText(ns.sText(unit))
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        if (min == max) then
            Health.Value:SetText(ns.FormatValue(min))
        else
            Health.Value:SetText(ns.FormatValue(min)..' - '..format('%d%%', min/max * 100))
        end
    end

    Health:SetStatusBarColor(0, 1, 0)

    if (self.Name.Background) then
        self.Name.Background:SetVertexColor(UnitSelectionColor(unit))
    end
end

local function UpdatePower(Power, unit, min, max)
    if (UnitIsDead(unit)) then
        Power:SetValue(0)
        Power.Value:SetText('')
    elseif (min == 0) then
        Power.Value:SetText('')   
    else
        Power.Value:SetText(ns.FormatValue(min))
    end
end

local function CreateBossLayout(self, unit)
	self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

    self:SetFrameStrata('MEDIUM')

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	
        -- texture

    self.Texture = self.Health:CreateTexture('$parentTextureFrame', 'ARTWORK')
    self.Texture:SetSize(250, 129)
    self.Texture:SetPoint('CENTER', self, 31, -24)
    self.Texture:SetTexture('Interface\\TargetingFrame\\UI-UnitFrame-Boss')

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(config.media.statusbar, 'BORDER')
    self.Health:SetSize(115, 8)
    self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -43)
    
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Health.Value:SetFont('Fonts\\ARIALN.ttf', config.font.fontSmall, nil)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint('CENTER', self.Health)

        -- powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture(config.media.statusbar, 'BORDER')
    self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -4)
    self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -4)
    self.Power:SetHeight(self.Health:GetHeight())
    
    self.Power.PostUpdate = UpdatePower
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
        
    self.Power.colorPower = true

        -- power text

    self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Power.Value:SetFont('Fonts\\ARIALN.ttf', config.font.fontSmall, nil)
    self.Power.Value:SetShadowOffset(1, -1)
    self.Power.Value:SetPoint('CENTER', self.Power)

        -- background

    self.Background = self.Power:CreateTexture(nil, 'BACKGROUND')
    self.Background:SetTexture(config.media.statusbar)
    self.Background:SetVertexColor(0, 0, 0, 0.55)
    self.Background:SetPoint('TOPRIGHT', self.Health)
    self.Background:SetPoint('BOTTOMLEFT', self.Power)

        -- name

    self.Name = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Name:SetFont(config.media.fontThick, config.font.fontBig)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH('CENTER')
    self.Name:SetSize(110, 10)
    self.Name:SetPoint('BOTTOM', self.Health, 'TOP', 0, 6)
    
    self:Tag(self.Name, '[name]')

        -- colored name background

    self.Name.Background = self.Health:CreateTexture('$parentNameBackground', 'BACKGROUND')
    self.Name.Background:SetHeight(18)
    self.Name.Background:SetTexCoord(0.2, 0.8, 0.3, 0.85)
    self.Name.Background:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
    self.Name.Background:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
    self.Name.Background:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')

        -- level

    self.Level = self.Health:CreateFontString(nil, 'ARTWORK')
    self.Level:SetFont('Interface\\AddOns\\oUF_Neav\\media\\fontNumber.ttf', 16, 'OUTLINE')
    self.Level:SetShadowOffset(0, 0)
    self.Level:SetPoint('CENTER', self.Texture, 24, -2)
    
    self:Tag(self.Level, '[level]')

        -- raidicons

    self.RaidIcon = self.Health:CreateTexture('$parentRaidIcon', 'OVERLAY', self)
    self.RaidIcon:SetPoint('CENTER', self, 'TOPRIGHT', -9, -5)
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
    self.RaidIcon:SetSize(26, 26)

        -- threat glow textures
    
    self.Glow = self:CreateTexture('$parentGlow', 'OVERLAY')
    self.Glow:SetAlpha(0)
    self.Glow:SetSize(241, 100)
    self.Glow:SetPoint('TOPRIGHT', self.Texture, -11, 3)
	self.Glow:SetTexture('Interface\\TargetingFrame\\UI-UnitFrame-Boss-Flash')
	self.Glow:SetTexCoord(0.0, 0.945, 0.0, 0.73125)

    table.insert(self.__elements, UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
    
    self.Buffs = CreateFrame('Frame', nil, self)
    self.Buffs.size = config.units.target.auraSize
    self.Buffs:SetHeight(self.Buffs.size * 3)
    self.Buffs:SetWidth(self.Buffs.size * 5)
    self.Buffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 3, -6)
    self.Buffs.initialAnchor = 'TOPLEFT'
    self.Buffs['growth-x'] = 'RIGHT'
    self.Buffs['growth-y'] = 'DOWN'
    self.Buffs.numBuffs = 8
    self.Buffs.spacing = 4.5
    
    self.Buffs.customColor = {1, 0, 0}
    
    self.Buffs.PostCreateIcon = ns.UpdateAuraIcons
    self.Buffs.PostUpdateIcon = ns.PostUpdateIcon
        
    self:SetSize(132, 46)
    self:SetScale(config.units.boss.scale)
    
    if (ns.config.units.boss.castbar.show) then  
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture(config.media.statusbar)
        self.Castbar:SetSize(150, 18)
        self.Castbar:SetStatusBarColor(unpack(ns.config.units.boss.castbar.color))
        self.Castbar:SetPoint('BOTTOM', self, 'TOP', 10, 13)

        self.Castbar.Background = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Background:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Background:SetAllPoints(self.Castbar)
        self.Castbar.Background:SetVertexColor(ns.config.units.boss.castbar.color[1]*0.3, ns.config.units.boss.castbar.color[2]*0.3, ns.config.units.boss.castbar.color[3]*0.3, 0.8)
            
        self.Castbar:CreateBorder(11)
        self.Castbar:SetBorderPadding(3)
        
        ns.CreateCastbarStrings(self, true)

        self.Castbar.CustomDelayText = ns.CustomDelayText
        self.Castbar.CustomTimeText = ns.CustomTimeText
    end
    
	return self
end

oUF:RegisterStyle('oUF_Neav_Boss', CreateBossLayout)
oUF:Factory(function(self)
	oUF:SetActiveStyle('oUF_Neav_Boss')

	local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
        boss[i] = self:Spawn('boss'..i, 'oUF_Neav_BossFrame'..i)

        if (i == 1) then
            boss[i]:SetPoint(unpack(config.units.boss.position))
        else
            boss[i]:SetPoint('TOPLEFT', boss[i-1], 'BOTTOMLEFT', 0, (ns.config.units.boss.castbar.show and -80) or -50)
        end
    end
end)