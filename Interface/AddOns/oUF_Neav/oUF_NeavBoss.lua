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

--[[
local interruptTexture = 'Interface\\AddOns\\oUF_Neav\\media\\textureInterrupt'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'
--]]

local function FormatValue(self)
    if (self >= 1000000) then
		return ('%.2fm'):format(self / 1e6)
        -- return ('%.3fK'):format(self / 1e6):gsub('%.', 'M ')
    elseif (self >= 100000) then
		return ('%.1fk'):format(self / 1e3)
        -- return ('%.3f'):format(self / 1e3):gsub('%.', 'K ')
    else
        return self
    end
end

local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then 
        return 
    end

    if (self.Glow) then
        local threat = UnitThreatSituation('player', unit)

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
        Health.Value:SetText('Dead')
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        if (min == max) then
            Health.Value:SetText(FormatValue(min))
        else
            Health.Value:SetText(FormatValue(min)..' - '..format('%d%%', min/max * 100))
        end
    end

    Health:SetStatusBarColor(0, 1, 0)

    if (self.Name.Background) then
        self.Name.Background:SetVertexColor(UnitSelectionColor(unit))
    end
end

local function UpdatePower(Power, unit, min, max)
    local self = Power:GetParent()

	local _, powerType, altR, altG, altB = UnitPowerType(unit)
	local unitPower = PowerBarColor[powerType]

    if (UnitIsDead(unit)) then
        Power:SetValue(0)
        Power.Value:SetText('')
    elseif (min == 0) then
        Power.Value:SetText('')   
    else
        Power.Value:SetText(FormatValue(min))
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
	self.Health:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')
    self.Health:SetSize(115, 8)
    self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -43)
    
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Health.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint('CENTER', self.Health)

        -- powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')
    self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -4)
    self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -4)
    self.Power:SetHeight(self.Health:GetHeight())
    self.Power.frequentUpdates = true
    self.Power.Smooth = true

    self.Power.PostUpdate = UpdatePower

        -- power text

    self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Power.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
    self.Power.Value:SetShadowOffset(1, -1)
    self.Power.Value:SetPoint('CENTER', self.Power)

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
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
    
    self.Buffs = CreateFrame('Frame', nil, self)
    self.Buffs.size = oUF_Neav.units.target.auraSize
    self.Buffs:SetHeight(self.Buffs.size * 3)
    self.Buffs:SetWidth(self.Buffs.size * 5)
    self.Buffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 3, -6)
    self.Buffs.initialAnchor = 'TOPLEFT'
    self.Buffs['growth-x'] = 'RIGHT'
    self.Buffs['growth-y'] = 'DOWN'
    self.Buffs.numBuffs = 8
    self.Buffs.spacing = 4.5

    self.Buffs.PostCreateIcon = UpdateAuraIcons

    self:SetSize(132, 46)
    self:SetScale(oUF_Neav.units.boss.scale)
    
    if (oUF_Neav.units.boss.showCastbar) then
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture(oUF_Neav.media.statusbar)
        self.Castbar:SetParent(self)
        -- self.Castbar:SetScale(oUF_Neav.units.boss.scale)
        self.Castbar:SetHeight(18)
        self.Castbar:SetWidth(150)
        self.Castbar:SetStatusBarColor(unpack(oUF_Neav.castbar.boss.color))
        self.Castbar:SetPoint('BOTTOM', self, 'TOP', 10, 13)

        self.Castbar.Background = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Background:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Background:SetAllPoints(self.Castbar)
        self.Castbar.Background:SetVertexColor(oUF_Neav.castbar.boss.color[1]*0.3, oUF_Neav.castbar.boss.color[2]*0.3, oUF_Neav.castbar.boss.color[3]*0.3, 0.8)
            
        CreateBorder(self.Castbar, 11, 1, 1, 1, 3)  

        self.Castbar.Time = self:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Time:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 2)
        self.Castbar.Time:SetShadowOffset(1, -1)
        self.Castbar.Time:SetPoint('RIGHT', self.Castbar, 'RIGHT', -7, 0)  
        self.Castbar.Time:SetHeight(10)
        self.Castbar.Time:SetJustifyH('RIGHT')
        self.Castbar.Time:SetParent(self.Castbar)
            
        self.Castbar.Text = self:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontBig - 2)
        self.Castbar.Text:SetShadowOffset(1, -1)
        self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
        self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -4, 0)
        self.Castbar.Text:SetHeight(10)
        self.Castbar.Text:SetJustifyH('LEFT')
        self.Castbar.Text:SetParent(self.Castbar)  
        
        --[[
        self.Castbar.PostCastStart = function(Castbar, unit, spell, spellrank)
            if (Castbar.interrupt) then
                SetBorderTexture(self.Castbar, interruptTexture)
                ColorBorder(self.Castbar, 1, 0, 1)
                ColorBorderShadow(self.Castbar, 1, 0, 1)
            else
                SetBorderTexture(self.Castbar, normalTexture)
                ColorBorder(self.Castbar, 1, 1, 1)
                ColorBorderShadow(self.Castbar, 0, 0, 0)
            end
        end    

        self.Castbar.PostChannelStart = function(Castbar, unit, spell, spellrank)
            if (Castbar.interrupt) then
                SetBorderTexture(self.Castbar, interruptTexture)
                ColorBorder(self.Castbar, 1, 0, 1)
                ColorBorderShadow(self.Castbar, 1, 0, 1)
            else
                SetBorderTexture(self.Castbar, normalTexture)
                ColorBorder(self.Castbar, 1, 1, 1)
                ColorBorderShadow(self.Castbar, 0, 0, 0)
            end
        end    
        --]]
        
        self.Castbar.CustomDelayText = function(self, duration)
            self.Time:SetFormattedText('[|cffff0000-%.1f|r] %.1f/%.1f', self.delay, duration, self.max)
        end
        
        self.Castbar.CustomTimeText = function(self, duration)
            self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
        end
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
            boss[i]:SetPoint(unpack(oUF_Neav.units.boss.position))
        else
            boss[i]:SetPoint('TOPLEFT', boss[i-1], 'BOTTOMLEFT', 0, (oUF_Neav.units.boss.showCastbar and -80) or -50)
        end
    end
end)

--[[
    -- Just for testing the layout

function ma1()
    oUF_Neav_BossFrame1:Show() 
    oUF_Neav_BossFrame1.Hide = function() end

    
    oUF_Neav_BossFrame2:Show() 
    oUF_Neav_BossFrame2.Hide = function() end

    oUF_Neav_BossFrame3:Show() 
    oUF_Neav_BossFrame3.Hide = function() end
    
    oUF_Neav_BossFrame4:Show() 
    oUF_Neav_BossFrame4.Hide = function() end
end

function ma1_1()
    oUF_Neav_BossFrame1Castbar:Show() 
    oUF_Neav_BossFrame1Castbar.Hide = function() end

    oUF_Neav_BossFrame2Castbar:Show() 
    oUF_Neav_BossFrame2Castbar.Hide = function() end
    
    oUF_Neav_BossFrame3Castbar:Show() 
    oUF_Neav_BossFrame3Castbar.Hide = function() end
    
    oUF_Neav_BossFrame4Castbar:Show() 
    oUF_Neav_BossFrame4Castbar.Hide = function() end
end
    
--]]
