
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
        local threat = UnitThreatSituation(self.unit)

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

    if (self.Name.Bg) then
        self.Name.Bg:SetVertexColor(UnitSelectionColor(unit))
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

    self.Name.Bg = self.Health:CreateTexture('$parentNameBackground', 'BACKGROUND')
    self.Name.Bg:SetHeight(18)
    self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
    self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
    self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
    self.Name.Bg:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')

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

        -- glow textures

    self.Glow = self:CreateTexture('$parentGlow', 'BACKGROUND')
    self.Glow:SetAlpha(0)
    self.Glow:SetSize(241, 100)
    self.Glow:SetPoint('TOPRIGHT', self.Texture, -11, 3)
	self.Glow:SetTexture("Interface\\TargetingFrame\\UI-UnitFrame-Boss-Flash");
	self.Glow:SetTexCoord(0.0, 0.945, 0.0, 0.73125);

    table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)

    self:SetSize(132, 46)
    self:SetScale(oUF_Neav.units.bossframes.scale)
        
    self.MoveableFrames = true

	return self
end

oUF:RegisterStyle('oUF_Neav_Boss', CreateBossLayout)

oUF:Factory(function(self)
	oUF:SetActiveStyle("oUF_Neav_Boss")

	local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
        boss[i] = self:Spawn("boss"..i, "oUF_Neav_BossFrame"..i)

        if (i == 1) then
            boss[i]:SetPoint(unpack(oUF_Neav.units.bossframes.position))
        else
            boss[i]:SetPoint("TOPLEFT", boss[i-1], "BOTTOMLEFT", 0, -50)
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
end
--]]
