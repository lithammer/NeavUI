--[[

	Supported Units:
		Player
		Pet
		Target
		Target Target
		Focus
		Focus Target
		Party 

	Supported Plugins:
        oUF MoveableFrames 
		oUF_CombatFeedback
		oUF_Smooth
        oUF_SpellRange

	Features:
		Aggro highlighting
        PvP Timer on the Playerframe
        Combat/Resting Flashing
        Combat and Resting Icons
        Leader-, MasterLooter- and Raidicons
        Role Icon (DD, Tank or Healer)

--]]

for _, button in pairs({
    'UnitFramePanelPartyBackground',
    'UnitFramePanelPartyPets',
	'UnitFramePanelFullSizeFocusFrame',

    'CombatPanelTargetOfTarget',
    'CombatPanelTOTDropDown',
    'CombatPanelTOTDropDownButton',
    'CombatPanelEnemyCastBarsOnPortrait',

    'DisplayPanelShowAggroPercentage',

    'FrameCategoriesButton9',
}) do
    _G['InterfaceOptions'..button]:SetAlpha(0.35)
    _G['InterfaceOptions'..button]:Disable()
    _G['InterfaceOptions'..button]:EnableMouse(false)
end

local function FormatValue(self)
    if (self >= 1000000) then
		return ('%.2fm'):format(self / 1e6)
        --return ('%.3fK'):format(self / 1e6):gsub('%.', 'M ')
    elseif (self >= 100000) then
		return ('%.1fk'):format(self / 1e3)
        --return ('%.3f'):format(self / 1e3):gsub('%.', 'K ')
    else
        return self
    end
end

local function CreateDropDown(self)
	local unit = self.unit:gsub('(.)', string.upper, 1)
	if _G[unit..'FrameDropDown'] then
		ToggleDropDownMenu(1, nil, _G[unit..'FrameDropDown'], 'cursor')
	elseif (self.unit:match('Party')) then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
	end
end 

local function PlayerToVehicleTexture(self, event, unit)
    self.Glow:Hide()
    self.Level:Hide()
    self.LFDRole:SetAlpha(0)

    UIFrameFlashStop(self.Status)
    self.Status:Hide()
    self.Status:SetAlpha(0)

    self.Texture:SetHeight(121)
    self.Texture:SetWidth(240)
    self.Texture:SetPoint('CENTER', self, 0, -8)
    self.Texture:SetTexCoord(0, 1, 0, 1)

    self.Health:SetHeight(9)
	if (UnitVehicleSkin('player') == 'Natural') then
        self.Health:SetWidth(103)
        self.Health:SetPoint('TOPLEFT', self.Texture, 100, -54)

        self.Texture:SetTexture('Interface\\Vehicles\\UI-Vehicle-Frame-Organic')
	else
        self.Health:SetWidth(100)
        self.Health:SetPoint('TOPLEFT', self.Texture, 103, -54)

        self.Texture:SetTexture('Interface\\Vehicles\\UI-Vehicle-Frame')
	end

    self.Background:SetPoint('TOPRIGHT', self.Health)
    self.Background:SetPoint('BOTTOMLEFT', self.Power)

    self.Name:SetWidth(100)
    self.Name:SetPoint('CENTER', self.Texture, 30, 23)

    self.Portrait:SetPoint('TOPLEFT', self.Texture, 23, -12)
    self.Leader:SetPoint('TOPLEFT', self.Texture, 23, -14)
    self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 74, -14)
    self.PvP:SetPoint('TOPLEFT', self.Texture, 3, -28)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -5)
    self.Group[3]:SetPoint('BOTTOMLEFT', self, 'TOP', -40, 9)
end

local function VehicleToPlayerTexture(self, event, unit)
    self.Level:Show()
    self.Glow:Show()
    self.Status:Show()
    self.LFDRole:SetAlpha(1)

    self.Texture:SetHeight(100)
    self.Texture:SetWidth(232)
    self.Texture:SetPoint('CENTER', self, -20, -7)
    self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame')
    self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)

    self.Health:SetHeight(12)
    self.Health:SetWidth(119)
    self.Health:SetPoint('TOPLEFT', self.Texture, 108, -41)

    self.Background:SetPoint('TOPRIGHT', self.Health, 0, 19)
    self.Background:SetPoint('BOTTOMLEFT', self.Power)

    self.Name:SetWidth(110)
    self.Name:SetPoint('CENTER', self.Texture, 50, 19)

    self.Portrait:SetPoint('TOPLEFT', self.Texture, 42, -12)
    self.Leader:SetPoint('TOPLEFT', self.Portrait, 3, 2)
    self.MasterLooter:SetPoint('TOPRIGHT', self.Portrait, -3, 3)
    self.PvP:SetPoint('TOPLEFT', self.Texture, 18, -20)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.Group[3]:SetPoint('BOTTOMLEFT', self, 'TOP', -40, 0)
end

    -- check if the player is in a vehicle

local function CheckVehicleStatus(self, event, unit)
    if (UnitHasVehicleUI('player')) then
        PlayerToVehicleTexture(self, event, unit)
    else
        VehicleToPlayerTexture(self, event, unit)
    end
end

local function UpdatePartyStatus(self)
    for i = 1, MAX_RAID_MEMBERS do
        if (GetNumRaidMembers() > 0) then
            local unitName, _, groupNumber = GetRaidRosterInfo(i)
            if (unitName == UnitName('player')) then
                self.Group[4]:SetText(GROUP..' '..groupNumber)
                self.Group[2]:SetWidth(self.Group[4]:GetWidth())
                for i = 1, 4 do
                    self.Group[i]:SetAlpha(0.5)
                end
            end
        else
            for i = 1, 4 do
                self.Group[i]:SetAlpha(0)
            end
        end
    end
end

local function UpdateFrame(self, event, unit)
	if (self.unit ~= unit) then 
        return
    end

    if (self.Name.Bg) then
        self.Name.Bg:SetVertexColor(UnitSelectionColor(unit))
    end

    if (self.OfflineStatus) then
        if (UnitIsConnected(unit)) then
            self.OfflineStatus:Hide()
        else
            self.OfflineStatus:Show()
        end
    end

    local texturePath = 'Interface\\TargetingFrame\\UI-TargetingFrame'
    if (unit == 'target' or unit == 'focus') then
        if (UnitClassification(unit) == 'elite') then
            self.Texture:SetTexture(texturePath..'-Elite')
        elseif (UnitClassification(unit) == 'rareelite') then
            self.Texture:SetTexture(texturePath..'-Rare-Elite')
        elseif (UnitClassification(unit) == 'rare') then
            self.Texture:SetTexture(texturePath..'-Rare')
        elseif (UnitClassification(unit) == 'worldboss') then
            self.Texture:SetTexture(texturePath..'-Elite')
        else
            self.Texture:SetTexture(texturePath)
        end
    end
end

local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then 
        return 
    end

    if (self.Glow) then
        local threat
        if (unit == 'target') then
            threat = UnitThreatSituation('player', 'target')
        else
            threat = UnitThreatSituation(self.unit)
        end

        if (threat and threat > 0) then
            local r, g, b
            r, g, b = GetThreatStatusColor(threat)
            self.Glow:SetVertexColor(r, g, b, 1)
        else
            self.Glow:SetVertexColor(0, 0, 0, 0)
        end
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
        self:SetVertexColor(0.45, 0.45, 0.45, 1)
    end
end

local function UpdateHealth(Health, unit, min, max)
    local self = Health:GetParent()

    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health.Value:SetText((UnitIsDead(unit) and 'Dead') or (UnitIsGhost(unit) and 'Ghost') or (not UnitIsConnected(unit) and 'Offline'))
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        if (self.targetUnit) then
            Health.Value:SetText((min/max * 100 < 100 and format('%d%%', min/max * 100)) or '')
        else
            if (unit == 'player' and oUF_Neav.units.player.showHealthPercent or unit == 'target' and oUF_Neav.units.target.showHealthPercent or unit == 'focus' and oUF_Neav.units.focus.showHealthPercent or unit == 'pet' and oUF_Neav.units.pet.showHealthPercent) then
                if (unit == 'target' and oUF_Neav.units.target.showHealthAndPercent or unit == 'focus' and oUF_Neav.units.focus.showHealthAndPercent) then
                    Health.Value:SetText((min/max * 100 < 100 and format('%s - %d%%', FormatValue(min), min/max * 100)) or FormatValue(min))
                else
                    Health.Value:SetText((min/max * 100 < 100 and format('%d%%', min/max * 100)) or '')
                end
            else
                if (min == max) then
                    Health.Value:SetText(FormatValue(min))
                else
                    Health.Value:SetText(FormatValue(min)..'/'..FormatValue(max))
                end
            end
        end

        Health:SetStatusBarColor(0, 1, 0)
    end

    if (not UnitIsConnected(unit)) then
        self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.85)
    elseif (UnitIsDead(unit)) then
        self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.85)
    elseif (UnitIsGhost(unit)) then
        self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.85)
    elseif (min/max * 100 < 25) then
        if (UnitIsPlayer(unit)) then
            if (unit ~= 'player') then
                self.Portrait:SetVertexColor(1, 0, 0, 0.9)
            end
        end
    else
        self.Portrait:SetVertexColor(1, 1, 1, 1)
    end

    self:UNIT_NAME_UPDATE(event, unit)
end

local function UpdatePower(Power, unit, min, max)
    local self = Power:GetParent()

    local unitHappiness = self.colors.happiness[GetPetHappiness()]
	local _, powerType, altR, altG, altB = UnitPowerType(unit)
	local unitPower = PowerBarColor[powerType]

    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Power:SetValue(0)
        Power.Value:SetText('')
    elseif (min == 0) then
        Power.Value:SetText('')   
    elseif (not UnitHasMana(unit)) then
        Power.Value:SetText(min)
    elseif (min == max) then
        Power.Value:SetText(FormatValue(min))
    else
        Power.Value:SetText(FormatValue(min)..'/'..FormatValue(max))
    end

    if (unit == 'player' and oUF_Neav.units.player.showPowerPercent or unit == 'target' and oUF_Neav.units.target.showPowerPercent or unit == 'focus' and oUF_Neav.units.focus.showPowerPercent or unit == 'pet' and oUF_Neav.units.pet.showPowerPercent) then
        Power.Value:SetText((min/max * 100 < 100 and format('%d%%', min/max * 100)) or '')
    end

    if (unit == 'pet' and GetPetHappiness()) then
        Power:SetStatusBarColor(unitHappiness[1], unitHappiness[2], unitHappiness[3])
	elseif (unitPower) then
        Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
	else
        Power:SetStatusBarColor(altR, altG, altB)
	end
end

local function UpdateDruidPower(self, event, unit)
    if (unit and unit ~= self.unit) then
        return 
    end

	local unitPower = PowerBarColor['MANA']
    local mana = UnitPowerType('player') == 0
    local index = GetShapeshiftForm()

    if (index == 1 or index == 3) then
        if (unitPower) then
            self.Druid.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
        end

        self.Druid.Power:SetAlpha(1)
        self.Druid.Power.Value:SetAlpha(1)
        self.Druid.Texture:SetAlpha(1)

        local min, max = UnitPower('player', 0), UnitPowerMax('player', 0)

        self.Druid.Power:SetMinMaxValues(0, max)
        self.Druid.Power:SetValue(min)

        if (min == max) then
            self.Druid.Power.Value:SetText(FormatValue(min))
        else
            self.Druid.Power.Value:SetText(FormatValue(min)..'/'..FormatValue(max))
        end
    else
        self.Druid.Power:SetAlpha(0)
        self.Druid.Power.Value:SetAlpha(0)
        self.Druid.Texture:SetAlpha(0)
    end
end

local function CreateUnitLayout(self, unit)
	self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

    self.menu = CreateDropDown
    self:SetAttribute('*type2', 'menu')

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

    if (unit == 'player' or unit == 'target' or unit == 'focus') then
        self.mainUnit = true
    elseif (unit == 'targettarget' or unit == 'focustarget') then
        self.targetUnit = true
    elseif (self:GetParent():GetName():match('oUF_Neav_Party')) then
        self.partyUnit = true
    end

    self:SetFrameStrata((self.targetUnit) and 'MEDIUM' or 'LOW')

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	
        -- texture

    self.Texture = self.Health:CreateTexture('$parentTextureFrame', 'ARTWORK')

    if (self.targetUnit) then
        self.Texture:SetHeight(45)
        self.Texture:SetWidth(93)
        self.Texture:SetPoint('CENTER', self, 0, 0)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetofTargetFrame')
        self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    elseif (unit == 'pet') then
        self.Texture:SetHeight(64)
        self.Texture:SetWidth(128)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-SmallTargetingFrame')
        self.Texture.SetTexture = function() end
    elseif (unit == 'target' or unit == 'focus') then
        self.Texture:SetHeight(100)
        self.Texture:SetWidth(232)
        self.Texture:SetPoint('CENTER', self, 20, -7)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame')
        self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    elseif (self.partyUnit) then
        self.Texture:SetHeight(64)
        self.Texture:SetWidth(128)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame')
    end

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')

    if (unit == 'player') then
        self.Health:SetHeight(12)
        self.Health:SetWidth(119)
    elseif (unit == 'pet') then
        self.Health:SetHeight(8)
        self.Health:SetWidth(69)
        self.Health:SetPoint('TOPLEFT', self.Texture, 46, -22)
    elseif (unit == 'target' or unit == 'focus') then
        self.Health:SetHeight(12)
        self.Health:SetWidth(119)
        self.Health:SetPoint('TOPRIGHT', self.Texture, -107, -41)
    elseif (self.targetUnit) then
        self.Health:SetHeight(7)
        self.Health:SetWidth(47)
        self.Health:SetPoint('CENTER', self, 22, 4)
    elseif (self.partyUnit) then   
        self.Health:SetPoint('TOPLEFT', self.Texture, 47, -12)
        self.Health:SetHeight(7)
        self.Health:SetWidth(70) 
    elseif (unit == 'partypet1' or unit == 'partypet2' or unit == 'partypet3' or unit == 'partypet4') then
        self.Health:SetHeight(8)
        self.Health:SetWidth(69)
        self.Health:SetPoint('TOPLEFT', self.f, 46, -22)
    end

    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Health.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
    self.Health.Value:SetShadowOffset(1, -1)

    if (self.targetUnit) then
        self.Health.Value:SetPoint('CENTER', self, 23, 1)
    elseif (self.partyUnit) then
        self.Health.Value:SetPoint('CENTER', self.Health, 0, 2)
    else
        self.Health.Value:SetPoint('CENTER', self.Health, 0, 1)
    end

        -- powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')
    self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
    self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
    self.Power:SetHeight((self.Health:GetHeight() - 1))
    self.Power.frequentUpdates = true
    self.Power.Smooth = true

    self.Power.PostUpdate = UpdatePower

        -- power text

    self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Power.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
    self.Power.Value:SetShadowOffset(1, -1)

    if (self.mainUnit) then
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 2)
    elseif (self.targetUnit) then
        self.Power.Value:Hide()
    else
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 1)
    end

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
    self.Name:SetHeight(10)
	 
    if (unit == 'pet') then
        self.Name:SetWidth(110)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 5)
    elseif (unit == 'target' or unit == 'focus') then
        self.Name:SetWidth(110)
        self.Name:SetPoint('CENTER', self, 'CENTER', -30, 12)
    elseif (self.targetUnit) then
        self.Name:SetWidth(110)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('TOPLEFT', self, 'CENTER', -3, -11)
    elseif (self.partyUnit) then    
        self.Name:SetJustifyH('CENTER')
        self.Name:SetHeight(10)
        self.Name:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
    end

    self:Tag(self.Name, '[name]')
    self.UNIT_NAME_UPDATE = UpdateFrame

        -- colored name background

    if (unit == 'target' or unit == 'focus') then
        self.Name.Bg = self.Health:CreateTexture('$parentNameBackground', 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')
    end

        -- level

    if (self.mainUnit) then
        self.Level = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Level:SetFont('Interface\\AddOns\\oUF_Neav\\media\\fontNumber.ttf', 17, 'OUTLINE')
        self.Level:SetShadowOffset(0, 0)
        self.Level:SetPoint('CENTER', self.Texture, (unit == 'player' and -63) or 63.5, -15)
        self:Tag(self.Level, '[level]')
    end

        -- portrait

    self.Portrait = self:CreateTexture('$parentPortrait', 'BACKGROUND')
    if (unit == 'player') then
        self.Portrait:SetWidth(64)
        self.Portrait:SetHeight(64)
    elseif (unit == 'pet') then
        self.Portrait:SetWidth(37)
        self.Portrait:SetHeight(37)
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
    elseif (unit == 'target' or unit == 'focus') then
        self.Portrait:SetWidth(64)
        self.Portrait:SetHeight(64)
        self.Portrait:SetPoint('TOPRIGHT', self.Texture, -42, -12)
    elseif (self.targetUnit) then
        self.Portrait:SetWidth(37)
        self.Portrait:SetHeight(37)
        self.Portrait:SetPoint('LEFT', self, 'CENTER', -43, 0)
    elseif (self.partyUnit) then
        self.Portrait:SetWidth(37)
        self.Portrait:SetHeight(37)
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
    end

        -- pvp icons

    if (oUF_Neav.show.pvpicons) then
        self.PvP = self.Health:CreateTexture('$parentPVPIcon', 'OVERLAY', self)
        if (unit == 'player') then
            self.PvP:SetHeight(64)
            self.PvP:SetWidth(64)
        elseif (unit == 'pet') then
            self.PvP:SetHeight(50)
            self.PvP:SetWidth(50)
            self.PvP:SetPoint('CENTER', self.Portrait, 'LEFT', 7, -7)
        elseif (unit == 'target' or unit == 'focus') then
            self.PvP:SetHeight(64)
            self.PvP:SetWidth(64)
            self.PvP:SetPoint('TOPRIGHT', self.Texture, 3, -20)
        elseif (self.partyUnit) then
            self.PvP:SetHeight(40)
            self.PvP:SetWidth(40)
            self.PvP:SetPoint('TOPLEFT', self.Texture, -9, -10)
        end
    end

        -- masterlooter icon

    self.MasterLooter = self.Health:CreateTexture('$parentMasterLooterIcon', 'OVERLAY', self)
    self.MasterLooter:SetHeight(16)
    self.MasterLooter:SetWidth(16)

    if (unit == 'target' or unit == 'focus') then
        self.MasterLooter:SetPoint('TOPLEFT', self.Portrait, 3, 3)
    elseif (self.targetUnit) then
        self.MasterLooter:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 3, -3)
    elseif (self.partyUnit) then  
        self.MasterLooter:SetHeight(14)
        self.MasterLooter:SetWidth(14)
        self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 29, 0)
    end

        -- groupleader icon

    self.Leader = self.Health:CreateTexture('$parentLeaderIcon', 'OVERLAY', self)
    self.Leader:SetHeight(16)
    self.Leader:SetWidth(16)

    if (unit == 'target' or unit == 'focus') then
        self.Leader:SetPoint('TOPRIGHT', self.Portrait, -3, 2)
    elseif (self.targetUnit) then
        self.Leader:SetPoint('TOPLEFT', self.Portrait, -3, 4)
    elseif (self.partyUnit) then
        self.Leader:SetHeight(14)
        self.Leader:SetWidth(14)
        self.Leader:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 1, -1)
    end

        -- raidicons

    self.RaidIcon = self.Health:CreateTexture('$parentRaidIcon', 'OVERLAY', self)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')

    if (self.mainUnit) then
        self.RaidIcon:SetHeight(26)
        self.RaidIcon:SetWidth(26)
    else
        self.RaidIcon:SetHeight(20)
        self.RaidIcon:SetWidth(20)
    end

        -- offline icons

    self.OfflineStatus = self.Health:CreateTexture(nil, 'OVERLAY')
    self.OfflineStatus:SetPoint('TOPRIGHT', self.Portrait, 7, 7)
    self.OfflineStatus:SetPoint('BOTTOMLEFT', self.Portrait, -7, -7)
    self.OfflineStatus:SetTexture('Interface\\CharacterFrame\\Disconnect-Icon')

        -- ready check icons

    if (unit == 'player' or self.partyUnit) then
        self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
        self.ReadyCheck:SetPoint('TOPRIGHT', self.Portrait, -7, -7)
        self.ReadyCheck:SetPoint('BOTTOMLEFT', self.Portrait, 7, 7)
        self.ReadyCheck.delayTime = 4
        self.ReadyCheck.fadeTime = 1
    end

        -- glow textures

    self.Glow = self:CreateTexture('$parentGlow', 'BACKGROUND')
    self.Glow:SetAlpha(0)

    if (unit == 'player') then
        self.Glow:SetHeight(92)
        self.Glow:SetWidth(242)
        self.Glow:SetPoint('TOPLEFT', self.Texture, 13, 0)
        self.Glow:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Flash')
        self.Glow:SetTexCoord(0.945, 0, 0, 0.182)
    elseif (unit == 'pet') then
        self.Glow:SetHeight(64)
        self.Glow:SetWidth(128)
        self.Glow:SetPoint('TOPLEFT', self.Texture, -4, 12)
        self.Glow:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame-Flash')
        self.Glow:SetTexCoord(0, 1, 1, 0)
    elseif (unit == 'target' or unit == 'focus') then
        self.Glow:SetHeight(92)
        self.Glow:SetWidth(241)
        self.Glow:SetPoint('TOPRIGHT', self.Texture, -14, 0)
        self.Glow:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Flash')
        self.Glow:SetTexCoord(0, 0.945, 0, 0.182)
    elseif (self.partyUnit) then
        self.Glow:SetHeight(63)
        self.Glow:SetWidth(128)
        self.Glow:SetPoint('TOPLEFT', self.Texture, -3, 4)
        self.Glow:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame-Flash')
    end

    table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)

        -- lfg role icon

    if (self.partyUnit or unit == 'player') then
        self.LFDRole = self.Health:CreateTexture('$parentGlow', 'OVERLAY')
        self.LFDRole:SetHeight(20)
        self.LFDRole:SetWidth(20)

        if (unit == 'player') then
            self.LFDRole:SetPoint('BOTTOMRIGHT', self.Portrait, -2, -3)
        else
            self.LFDRole:SetPoint('BOTTOMLEFT', self.Portrait, -5, -5)
        end
    end

        -- playerframe

    if (unit == 'player') then
		self:SetSize(175, 42)

			-- warlock soulshard bar
		if (select(2, UnitClass('player')) == 'WARLOCK') then
			ShardBarFrame:SetParent(oUF_Neav_Player)
			ShardBarFrame:SetScale(oUF_Neav.units.player.scale * 0.8)
			ShardBar_OnLoad(ShardBarFrame)
			ShardBarFrame:ClearAllPoints()
			ShardBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, -1)
			ShardBarFrame:Show()
		end

			-- holy power bar
		if (select(2, UnitClass('player')) == 'PALADIN') then
			PaladinPowerBar:SetParent(oUF_Neav_Player)
			PaladinPowerBar:SetScale(oUF_Neav.units.player.scale * 0.81)
			PaladinPowerBar_OnLoad(PaladinPowerBar)
			PaladinPowerBar:ClearAllPoints()
			PaladinPowerBar:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 25, 2)
			PaladinPowerBar:Show()
		end

			-- druid eclipse bar
		if (select(2, UnitClass('player')) == 'DRUID') then
			EclipseBarFrame:SetParent(oUF_Neav_Player)
			EclipseBarFrame:SetScale(oUF_Neav.units.player.scale * 0.82)
			EclipseBar_OnLoad(EclipseBarFrame)
			EclipseBarFrame:ClearAllPoints()
			EclipseBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 4)
			EclipseBarFrame:Show()
		end
		
            -- runebar

        if (RuneFrame:IsShown() and RuneButtonIndividual1:IsShown()) then
            RuneFrame:ClearAllPoints()
            RuneFrame:SetPoint('TOP', self.Power, 'BOTTOM', 2, -2)
            RuneFrame:SetParent(self)
        end

            -- raidgroup

        self.Group = {}

        for i = 1, 3 do
            self.Group[i] = self:CreateTexture(nil, 'BACKGROUND')
            self.Group[i]:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
            self.Group[i]:SetAlpha(0.5)
            self.Group[i]:SetHeight(18)
            self.Group[i]:SetWidth(24)
            self.Group[i]:SetTexCoord((i == 1 and 0.53125) or (i == 2 and 0.1875) or 0, (i == 1 and 0.71875) or (i == 2 and 0.53125) or 0.1875, 0, 1)
        end

        self.Group[1]:SetPoint('LEFT', self.Group[2], 'RIGHT')
        self.Group[2]:SetPoint('LEFT', self.Group[3], 'RIGHT')
        self.Group[3]:SetPoint('BOTTOMLEFT', self, 'TOP', -40, 0)

        self.Group[4] = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Group[4]:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall)
        self.Group[4]:SetShadowOffset(1, -1)
        self.Group[4]:SetPoint('CENTER', self.Group[2], 0, -1)

        table.insert(self.__elements, UpdatePartyStatus)
        self:RegisterEvent('RAID_ROSTER_UPDATE', UpdatePartyStatus)
        self:RegisterEvent('PARTY_MEMBER_CHANGED', UpdatePartyStatus)

            -- statusflashing

        self.Status = self.Health:CreateTexture('$parentStatusTexture', 'OVERLAY', self)
        self.Status:SetHeight(66)
        self.Status:SetWidth(191)
        self.Status:SetBlendMode('ADD')
        self.Status:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')
        self.Status:SetTexCoord(0, 0.74609375, 0, 0.53125)
        self.Status:SetPoint('TOPLEFT', self.Texture, 35, -8)
        self.Status:SetAlpha(0)

        self.EventFrame = CreateFrame('Frame')
        self.EventFrame:RegisterEvent('PLAYER_DEAD')
        self.EventFrame:RegisterEvent('PLAYER_UNGHOST')
        self.EventFrame:RegisterEvent('PLAYER_ALIVE')
        self.EventFrame:RegisterEvent('PLAYER_UPDATE_RESTING')
        self.EventFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
        self.EventFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
        self.EventFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
        self.EventFrame:SetScript('OnEvent', function(_, event, unit)
            if (event == 'PLAYER_ENTERING_WORLD') then
                CheckVehicleStatus(self, event, unit)
                UpdatePartyStatus(self, event)
            end

            self.Status:Hide()

            if (UnitHasVehicleUI('player')) then
                UIFrameFlashStop(self.Status)
                self.Status:Hide()
            elseif (IsResting()) then
                self.Status:SetVertexColor(1, 0.88, 0.25, 1)
                UIFrameFlash(self.Status, 0.5, 0.5, 10^10, false, 0.1, 0.1)
                self.Status:Show();
            elseif (UnitAffectingCombat('player') and InCombatLockdown()) then
                self.Status:SetVertexColor(1, 0.1, 0.1, 1)
                UIFrameFlash(self.Status, 0.5, 0.5, 10^10, false, 0.1, 0.1)
                self.Status:Show();
            elseif (UnitIsDeadOrGhost('player')) then
                UIFrameFlashStop(self.Status)
                self.Status:Hide();
            else
                UIFrameFlashStop(self.Status)
                self.Status:Hide();
            end
        end)

        table.insert(self.__elements, CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERED_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITED_VEHICLE', CheckVehicleStatus)

            -- pvptimer

        if (oUF_Neav.show.pvpicons) then
            self.PvPTimer = self.Health:CreateFontString('$parentPVPTimer', 'OVERLAY')
            self.PvPTimer:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, oUF_Neav.font.fontSmallOutline and 'OUTLINE' or nil)
            self.PvPTimer:SetShadowOffset(1, -1)
            self.PvPTimer:SetPoint('BOTTOM', self.PvP, 'TOP', -12, 0)

            self.LastUpdate = 0
            self:HookScript('OnUpdate', function(self, elapsed)
                local time = nil
                if (IsPVPTimerRunning()) then
                    time = GetPVPTimer()
                end

                if (time) then
                    time = time - elapsed * 1000
                    local timeLeft = time
                    if (timeLeft < 0) then
                        self.PvPTimer:SetText('')
                    end
                    self.PvPTimer:SetFormattedText(SecondsToTimeAbbrev(floor(timeLeft/1000)))
                else
                    self.PvPTimer:SetText('')
                end
            end)
        end

            -- combat text

        self.CombatFeedbackText = self.Health:CreateFontString(nil, 'ARTWORK')
        self.CombatFeedbackText:SetFont(oUF_Neav.media.font, 23, 'OUTLINE')
        self.CombatFeedbackText:SetShadowOffset(0, 0)
        self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)

           -- restingicon

		self.Resting = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Resting:SetPoint('CENTER', self.Level, -0.5, -0.5)
		self.Resting:SetWidth(31)
		self.Resting:SetHeight(33)

            -- combaticon

        self.Combat = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Combat:SetPoint('CENTER', self.Level, 1, -1)
		self.Combat:SetWidth(31)
		self.Combat:SetHeight(33)

            -- druidmana

        if (select(2, UnitClass('player')) == 'DRUID') then
            self.Druid = CreateFrame('Frame')
            self.Druid:SetParent(self) 
            self.Druid:SetFrameStrata('LOW')

            self.Druid.Texture = self.Druid:CreateTexture(nil, 'BACKGROUND')
            self.Druid.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\druidmanaTexture')
            self.Druid.Texture:SetHeight(28)
            self.Druid.Texture:SetWidth(104)
            self.Druid.Texture:SetPoint('TOP', self.Power, 'BOTTOM', -1, 8)

            self.Druid.Power = CreateFrame('StatusBar', nil, self)
            self.Druid.Power:SetPoint('TOP', self.Power, 'BOTTOM')
            self.Druid.Power:SetStatusBarTexture(oUF_Neav.media.statusbar)
            self.Druid.Power:SetFrameStrata('LOW')
            self.Druid.Power:SetFrameLevel(self.Druid:GetFrameLevel() - 1)
            self.Druid.Power:SetHeight(10)
            self.Druid.Power:SetWidth(100)
            self.Druid.Power:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
            self.Druid.Power:SetBackdropColor(0, 0, 0, 0.5)

            self.Druid.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
            self.Druid.Power.Value:SetFont('Fonts\\ARIALN.ttf', oUF_Neav.font.fontSmall, nil)
            self.Druid.Power.Value:SetShadowOffset(1, -1)
            self.Druid.Power.Value:SetPoint('CENTER', self.Druid.Power, 0, 0.5)

            table.insert(self.__elements, UpdateDruidPower)
            self:RegisterEvent('UNIT_MANA', UpdateDruidPower)
            self:RegisterEvent('UNIT_RAGE', UpdateDruidPower)
            self:RegisterEvent('UNIT_ENERGY', UpdateDruidPower)
            self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', UpdateDruidPower)

            if (oUF_Neav.units.player.mouseoverText) then
                self.Druid.Power.Value:Hide()

                self:HookScript('OnEnter', function(self)
                    self.Druid.Power.Value:Show()
                end)

                self:HookScript('OnLeave', function(self)
                    self.Druid.Power.Value:Hide()
                end)
            end
        end
    end

        -- petframe

    if (unit == 'pet') then
		self:SetSize(175, 42)

        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs.size = oUF_Neav.units.pet.auraSize
        self.Debuffs:SetWidth(self.Debuffs.size * 4)
        self.Debuffs:SetHeight(self.Debuffs.size)
        self.Debuffs.spacing = 4
        self.Debuffs:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 1, -3)
        self.Debuffs.initialAnchor = 'TOPLEFT'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs.num = 9
    end

        -- target + focusframe

    if (unit == 'target') then
        self.Auras = CreateFrame('Frame', nil, self)
        self.Auras.gap = true
        self.Auras.size = oUF_Neav.units.target.auraSize
        self.Auras:SetHeight(self.Auras.size * 3)
        self.Auras:SetWidth(self.Auras.size * 5)
        self.Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -3, -5)
        self.Auras.initialAnchor = 'TOPLEFT'
        self.Auras['growth-x'] = 'RIGHT'
        self.Auras['growth-y'] = 'DOWN'
        self.Auras.numBuffs = 40
        self.Auras.numDebuffs = 18
        self.Auras.spacing = 4.5
		if (oUF_Neav.units.target.colorPlayerDebuffsOnly) then
			self.Auras.PostUpdateIcon = function(self, unit, icon, index, offset)
				if (unit ~= 'target') then return end
				
				if (icon.debuff) then
					if (not UnitIsFriend('player', unit) and icon.owner ~= 'player' and icon.owner ~= 'vehicle') then
						icon.overlay:SetVertexColor(0.45, 0.45, 0.45)
						icon.icon:SetDesaturated(true)
					else
						icon.icon:SetDesaturated(false)
					end
				end
			end
		end

    elseif (unit == 'focus') then
        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs.size = oUF_Neav.units.focus.auraSize + 7
        self.Debuffs:SetHeight(self.Debuffs.size * 3)
        self.Debuffs:SetWidth(self.Debuffs.size * 3)
        self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -3.5, -5)
        self.Debuffs.initialAnchor = 'TOPLEFT'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs.num = 6
        self.Debuffs.spacing = 4

        self.Header = {}

        for i = 1, 3 do
            self.Header[i] = self.Health:CreateTexture(nil, 'BACKGROUND', self)
            self.Header[i]:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
            self.Header[i]:SetHeight(18)
            self.Header[i]:SetWidth((i == 2 and 32) or 24)
            self.Header[i]:SetAlpha(0.5)
            self.Header[i]:SetTexCoord((i == 1 and 0.53125) or (i == 2 and 0.1875) or 0, (i == 1 and 0.71875) or (i == 2 and 0.53125) or 0.1875, 0, 1)
            self.Header[i]:SetPoint((i == 1 and 'BOTTOMRIGHT') or 'RIGHT', (i == 1 and self) or (i == 2 and self.Header[1]) or (i == 3 and self.Header[2]), (i == 1 and 'TOP') or 'LEFT', (i == 1 and 40) or 0, 0)
        end

        self.Header[4] = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Header[4]:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall)
        self.Header[4]:SetShadowOffset(1, -1)
        self.Header[4]:SetPoint('CENTER', self.Header[2], 0, -1)
        self.Header[4]:SetText('Focus')
        self.Header[4]:SetAlpha(0.7)
    end

    if (unit == 'target' or unit == 'focus') then
		self:SetSize(175, 42)

        self.CombatFeedbackText = self.Health:CreateFontString(nil, 'ARTWORK')
        self.CombatFeedbackText:SetFont(oUF_Neav.media.font, 23, 'OUTLINE')
        self.CombatFeedbackText:SetShadowOffset(0, 0)
        self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
    end

    if (unit == 'target' or unit == 'focus') then
        if (oUF_Neav.units.target.showComboPoints) then
            if (oUF_Neav.units.target.showComboPointsAsNumber) then
                self.CPoints = self.Health:CreateFontString(nil, 'ARTWORK')
                self.CPoints:SetFont(DAMAGE_TEXT_FONT, 22, 'OUTLINE')
                self.CPoints:SetShadowOffset(0, 0)
                self.CPoints:SetPoint('LEFT', self.Portrait, 'RIGHT', 8, 4)
                self.CPoints:SetTextColor(unpack(oUF_Neav.units.target.numComboPointsColor))
            else
                self.CPoints = {}

                for i = 1, 5 do
                    self.CPoints[i] = self.Health:CreateFontString(nil, 'OVERLAY')
                    self.CPoints[i]:SetFont(DAMAGE_TEXT_FONT, 18, 'OUTLINE')
                    self.CPoints[i]:SetShadowOffset(0, 0)
                    self.CPoints[i]:SetText('*')
                    self.CPoints[i]:SetTextColor(0, 1, 0)
                end

                self.CPoints[1]:SetPoint('TOPRIGHT', self.Texture, -44, -8)

                self.CPoints[2]:SetPoint('TOP', self.CPoints[1], 'BOTTOM', 8, 9)

                self.CPoints[3]:SetPoint('TOP', self.CPoints[2], 'BOTTOM', 5, 7)
                self.CPoints[3]:SetTextColor(1, 1, 0)

                self.CPoints[4]:SetPoint('TOP', self.CPoints[3], 'BOTTOM', 1, 6)
                self.CPoints[4]:SetTextColor(1, 0.5, 0)

                self.CPoints[5]:SetPoint('TOP', self.CPoints[4], 'BOTTOM', -2, 6)
                self.CPoints[5]:SetTextColor(1, 0, 0)
            end
        end
    end

    if (self.targetUnit) then
		self:SetSize(85, 20)

        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs:SetHeight(20)
        self.Debuffs:SetWidth(20 * 3)
        self.Debuffs.size = 22
        self.Debuffs.spacing = 4
        self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 5, 0)
        self.Debuffs.initialAnchor = 'LEFT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs.num = 4
    end

    if (self.partyUnit) then
		self:SetSize(105, 30)

        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs:SetFrameStrata('BACKGROUND')
        self.Debuffs:SetHeight(20)
        self.Debuffs:SetWidth(20 * 3)
        self.Debuffs.size = oUF_Neav.units.party.auraSize
        self.Debuffs.spacing = 4
        self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 5, 1)
        self.Debuffs.initialAnchor = 'LEFT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs.num = 3
    end

    if (unit == 'partypet1' or unit == 'partypet2' or unit == 'partypet3' or unit == 'partypet4') then
		self:SetSize(128, 53)

        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-SmallTargetingFrame')
        self.Texture:SetPoint('TOPLEFT', self.f, 0, -2)
        self.Texture:SetHeight(64)
        self.Texture:SetWidth(128)

        self.Name:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 5)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetWidth(100)
        self.Name:SetHeight(10)

        self.Portrait:SetPoint('TOPLEFT', self.f, 7, -6)
    end

  --  for i = 1, MAX_BOSS_FRAMES do
        -- if (unit:match('boss'..i)) then
       -- if (self:GetParent():GetName():match('boss')) then

      --  end
   -- end

        -- mouseover texts

    if (unit == 'player' and oUF_Neav.units.player.mouseoverText or unit == 'pet' and oUF_Neav.units.pet.mouseoverText or unit == 'target' and oUF_Neav.units.target.mouseoverText or unit == 'focus' and oUF_Neav.units.focus.mouseoverText or self.partyUnit and oUF_Neav.units.party.mouseoverText) then
        self.Health.Value:Hide()
        self.Power.Value:Hide()

        self:HookScript('OnEnter', function(self)
            self.Health.Value:Show()
            self.Power.Value:Show()

            UnitFrame_OnEnter(self)
        end)

        self:HookScript('OnLeave', function(self)
            self.Health.Value:Hide()
            self.Power.Value:Hide()

            UnitFrame_OnLeave(self)
        end)
    end

    if (unit == 'pet' or self.partyUnit) then
        self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }

        self.SpellRange = true

        self.SpellRange = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }
    end

    if (oUF_Neav.show.castbars) then
        CreateCastbars(self, unit)
    end

    self.MoveableFrames = true

    if (self.Auras) then
        self.Auras.PostCreateIcon = UpdateAuraIcons
        self.Auras.showDebuffType = true
    elseif (self.Buffs) then
        self.Buffs.PostCreateIcon = UpdateAuraIcons
    elseif (self.Debuffs) then
        self.Debuffs.PostCreateIcon = UpdateAuraIcons
        self.Debuffs.showDebuffType = true
    end

	return self
end

oUF:RegisterStyle('oUF_Neav', CreateUnitLayout)
oUF:Factory(function(self)
    local player = self:Spawn('player', 'oUF_Neav_Player')
    player:SetPoint(unpack(oUF_Neav.units.player.position))
    player:SetScale(oUF_Neav.units.player.scale)

    local pet = self:Spawn('pet', 'oUF_Neav_Pet')
    pet:SetPoint('TOPLEFT', oUF_Neav_Player, 'BOTTOMLEFT', unpack(oUF_Neav.units.pet.position))
    pet:SetScale(oUF_Neav.units.pet.scale)

    local target = self:Spawn('target', 'oUF_Neav_Target')
    target:SetPoint(unpack(oUF_Neav.units.target.position))
    target:SetScale(oUF_Neav.units.target.scale)

    local targettarget = self:Spawn('targettarget', 'oUF_Neav_TargetTarget')
    targettarget:SetPoint('TOPLEFT', oUF_Neav_Target, 'BOTTOMRIGHT', -78, -15)
    targettarget:SetScale(oUF_Neav.units.targettarget.scale)

    local focus = self:Spawn('focus', 'oUF_Neav_Focus')
    focus:SetPoint('LEFT', UIParent, 45, -50.35)
    focus:SetScale(oUF_Neav.units.focus.scale)

    focus:SetMovable(true)
    focus:RegisterForDrag('LeftButton')
    focus:SetUserPlaced(true)

    focus:SetScript('OnDragStart', function(self)
        if (IsShiftKeyDown()) then
            self:StartMoving() 
        end
    end)

    focus:SetScript('OnDragStop', function(self) 
        self:StopMovingOrSizing()
    end)

    local focustarget = self:Spawn('focustarget', 'oUF_Neav_FocusTarget')
    focustarget:SetPoint('TOPLEFT', oUF_Neav_Focus, 'BOTTOMRIGHT', -78, -15)
    focustarget:SetScale(oUF_Neav.units.focustarget.scale)

	if (oUF_Neav.show.party) then
		local party = oUF:SpawnHeader('oUF_Neav_Party', nil, (oUF_Neav.units.party.hideInRaid and 'party') or 'party,raid',
			'oUF-initialConfigFunction', [[
				self:SetWidth(105)
				self:SetHeight(30)
			]],
			'showParty', true,
			'yOffset', -30
		)
		--party:SetPoint('TOPLEFT', 70, -20)
		party:SetPoint(unpack(oUF_Neav.units.party.position))
		party:SetScale(oUF_Neav.units.party.scale)
    end
end)

--[[
    local partypet1 = oUF:Spawn('partypet1', 'oUF_PartyPet1')   
    partypet1:SetPoint(unpack(oUF_Neav.units.party.position))


    partypet1:Show()
    partypet1.Hide = function(self)
        self:Show()
    end


    local partypet2 = oUF:Spawn('partypet2', 'oUF_PartyPet2')   
    partypet2:SetPoint(unpack(oUF_Neav.units.party.position))

    local partypet3 = oUF:Spawn('partypet3', 'oUF_PartyPet3')   
    partypet3:SetPoint(unpack(oUF_Neav.units.party.position))

    local partypet4 = oUF:Spawn('partypet4', 'oUF_PartyPet4')   
    partypet4:SetPoint(unpack(oUF_Neav.units.party.position))
        --]]
    --[[
    local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = self:Spawn('boss'..i, 'oUF_Neav_Boss'..i)

		if (i == 1) then
			boss[i]:SetPoint('CENTER', UIParent, 50, 100)
		else
			boss[i]:SetPoint('TOP', boss[i-1], 'BOTTOM', 0, -40)
		end
	end

    for i, k in ipairs(boss) do 
        k:Show() 
    end
    -- if (not unit:match('boss%d')) then
    -- if (not unit:match('boss(%d)')) then
    --]]

--[[

/run Boss1TargetFrame:Show()
/run Boss2TargetFrame:Show()
/run Boss3TargetFrame:Show()

--]]
