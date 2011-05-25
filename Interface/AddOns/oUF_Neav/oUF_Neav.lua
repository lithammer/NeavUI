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
		oUF_CombatFeedback
		oUF_Smooth
        oUF_SpellRange
        oUF_Swing
        oUF_Vengeance
        
	Features:
		Aggro highlighting
        PvP Timer on the Playerframe
        Combat & Resting Flashing
        Combat & Resting Icons
        Leader-, MasterLooter- and Raidicons
        Role Icon (DD, Tank or Healer)
        Castbars for Player, Target, Focus and Pet
        Raidicons
        Class coloring

--]]

local floor = math.floor

    -- fork off the original UIFrameFlash function, and fit it to our needs

local flashObjects = {}
    
local f = CreateFrame('Frame')

local function IsFlashing(frame)
    for index, value in pairs(flashObjects) do
        if (value == frame) then
            return 1
        end
    end
    
    return nil
end

local function Flash_OnUpdate(self, elapsed)
    local frame
    local index = #flashObjects
        
    while flashObjects[index] do
        frame = flashObjects[index]
        frame.flashTimer = frame.flashTimer + elapsed

        local flashTime = frame.flashTimer
        local alpha

        flashTime = flashTime%(frame.fadeInTime + frame.fadeOutTime + (frame.flashInHoldTime or 0) + (frame.flashOutHoldTime or 0))
        
        if (flashTime < frame.fadeInTime) then
            alpha = flashTime/frame.fadeInTime;
        elseif (flashTime < frame.fadeInTime + (frame.flashInHoldTime or 0)) then
            alpha = 1
        elseif (flashTime < frame.fadeInTime + (frame.flashInHoldTime or 0)+frame.fadeOutTime) then
            alpha = 1 - ((flashTime - frame.fadeInTime - (frame.flashInHoldTime or 0))/frame.fadeOutTime);
        else
            alpha = 0
        end
            
        frame:SetAlpha(alpha)

        index = index - 1
    end
        
    if (#flashObjects == 0) then
        self:SetScript('OnUpdate', nil)
    end
end

local function StopFlash(frame)
    tDeleteItem(flashObjects, frame)
    frame.flashTimer = nil
    
    frame:SetAlpha(0)
end
        
local function StartFlash(frame, fadeInTime, fadeOutTime, flashInHoldTime, flashOutHoldTime)
    if (frame) then
        local index = 1

        while flashObjects[index] do
            if (flashObjects[index] == frame) then
                return
            end
            
            index = index + 1
        end

        frame.flashTimer = 0 
        frame.fadeInTime = fadeInTime
        frame.fadeOutTime = fadeOutTime
        frame.flashInHoldTime = flashInHoldTime
        frame.flashOutHoldTime = flashOutHoldTime
            
        tinsert(flashObjects, frame)
            
        f:SetScript('OnUpdate', Flash_OnUpdate)
    end
end

    -- remove all blizz stuff that doesnt work while other unitframes are active
    
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

    -- remove the set/clear focus of the default unitdrop down, because only the blizz ui can use this function
    
do 
    for k, v in pairs(UnitPopupMenus) do
        for x, i in pairs(UnitPopupMenus[k]) do
            if (i == 'SET_FOCUS' or i == 'CLEAR_FOCUS') then
                table.remove(UnitPopupMenus[k],x)
            end
        end
    end
end

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

    -- create the drop downmenu of our unitframes
    
local dropdown = CreateFrame('Frame', 'CustomUnitDropDownMenu', UIParent, 'UIDropDownMenuTemplate')

UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if not unit then return end

	local menu, name, id
	if (UnitIsUnit(unit, 'player')) then
		menu = 'SELF'
	elseif (UnitIsUnit(unit, 'vehicle')) then
		menu = 'VEHICLE'
	elseif (UnitIsUnit(unit, 'pet')) then
		menu = 'PET'
	elseif (UnitIsPlayer(unit)) then
		id = UnitInRaid(unit)
		if (id) then
			menu = 'RAID_PLAYER'
			name = GetRaidRosterInfo(id)
		elseif UnitInParty(unit) then
			menu = 'PARTY'
		else
			menu = 'PLAYER'
		end
	else
		menu = 'TARGET'
		name = RAID_TARGET_ICON
	end
	if (menu) then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end, 'MENU')

local function CreateDropDown(self)
	dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, 'cursor', 15, -15)
	-- ToggleDropDownMenu(1, nil, dropdown, self, self:GetWidth()*0.75, -5)
end

local function PlayerToVehicleTexture(self, event, unit)
    self.ThreatGlow:Hide()
    self.Level:Hide()
    
    self.LFDRole:SetAlpha(0)
    
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

    self.BarBackground:SetPoint('TOPRIGHT', self.Health)
    self.BarBackground:SetPoint('BOTTOMLEFT', self.Power)

    self.Name:SetWidth(100)
    self.Name:SetPoint('CENTER', self.Texture, 30, 23)

    self.Portrait:SetPoint('TOPLEFT', self.Texture, 23, -12)
    self.Leader:SetPoint('TOPLEFT', self.Texture, 23, -14)
    self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 74, -14)
    self.PvP:SetPoint('TOPLEFT', self.Texture, 3, -28)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -5)
    
    self.TabMiddle:SetPoint('BOTTOM', self.Name, 'TOP', 0, 10)
end

local function VehicleToPlayerTexture(self, event, unit)
    self.Level:Show()
    self.ThreatGlow:Show()

    self.LFDRole:SetAlpha(1)

    self.Texture:SetHeight(100)
    self.Texture:SetWidth(232)
    self.Texture:SetPoint('CENTER', self, -20, -7)
    self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
    
    if (oUF_Neav.units.player.style == 'NORMAL') then
		self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame')
	elseif (oUF_Neav.units.player.style == 'RARE') then
		self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Rare')
	elseif (oUF_Neav.units.player.style == 'ELITE') then
		self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Elite')
    elseif (oUF_Neav.units.player.style == 'CUSTOM') then
        self.Texture:SetTexture(oUF_Neav.units.player.customTexture)
    end

    self.Health:SetHeight(12)
    self.Health:SetWidth(119)
    self.Health:SetPoint('TOPLEFT', self.Texture, 106, -41)

    self.BarBackground:SetPoint('TOPRIGHT', self.Health, 0, 19)
    self.BarBackground:SetPoint('BOTTOMLEFT', self.Power)

    self.Name:SetWidth(110)
    self.Name:SetPoint('CENTER', self.Texture, 50, 19)

    self.Portrait:SetPoint('TOPLEFT', self.Texture, 42, -12)
    self.Leader:SetPoint('TOPLEFT', self.Portrait, 3, 2)
    self.MasterLooter:SetPoint('TOPRIGHT', self.Portrait, -3, 3)
    self.PvP:SetPoint('TOPLEFT', self.Texture, 18, -20)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    
    self.TabMiddle:SetPoint('BOTTOM', self.BarBackground, 'TOP', -1, 0)
end

local function UpdateFlashStatus(self)
    if (UnitHasVehicleUI('player') or UnitIsDeadOrGhost('player')) then
        StopFlash(self.StatusFlash)
        return
    end
            
    if (UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.1, 0.1, 1)
                
        if (not IsFlashing(self.StatusFlash)) then
            StartFlash(self.StatusFlash, 0.75, 0.75, 0.1, 0.1)
        end
    elseif (IsResting() and not UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.88, 0.25, 1)
                
        if (not IsFlashing(self.StatusFlash)) then
            StartFlash(self.StatusFlash, 0.75, 0.75, 0.1, 0.1)
        end
    else
        StopFlash(self.StatusFlash)
    end
end

    -- vehicle check

local function CheckVehicleStatus(self, event, unit)
    if (UnitHasVehicleUI('player')) then
        PlayerToVehicleTexture(self, event, unit)
    else
        VehicleToPlayerTexture(self, event, unit)
    end
    
    if (self.StatusFlash) then
        UpdateFlashStatus(self)
    end
end

    -- group indicator above the playerframe
    
local function UpdatePartyStatus(self)
    for i = 1, MAX_RAID_MEMBERS do
        if (GetNumRaidMembers() > 0) then
            local unitName, _, groupNumber = GetRaidRosterInfo(i)
            if (unitName == UnitName('player')) then
                self.TabText:SetText(GROUP..' '..groupNumber)
                self.TabMiddle:SetWidth(self.TabText:GetWidth())
                
                self.TabMiddle:SetAlpha(0.5)
                self.TabLeft:SetAlpha(0.5)
                self.TabRight:SetAlpha(0.5)
                self.TabText:SetAlpha(0.5)
            end
        else
            self.TabMiddle:SetAlpha(0)
            self.TabLeft:SetAlpha(0)
            self.TabRight:SetAlpha(0)
            self.TabText:SetAlpha(0)
        end
    end
end

    -- function for create a tab-like texture
    
local function CreateUnitTabTexture(self)
    self.TabMiddle = self:CreateTexture(nil, 'BACKGROUND')
    self.TabMiddle:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
    self.TabMiddle:SetAlpha(0.5)
    self.TabMiddle:SetSize(24, 18)
    self.TabMiddle:SetTexCoord(0.1875, 0.53125, 0, 1)
        
    self.TabLeft = self:CreateTexture(nil, 'BACKGROUND')
    self.TabLeft:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
    self.TabLeft:SetPoint('LEFT', self.TabMiddle, 'RIGHT')
    self.TabLeft:SetAlpha(0.5)
    self.TabLeft:SetSize(24, 18)
    self.TabLeft:SetTexCoord(0.53125, 0.71875, 0, 1)
                
    self.TabRight = self:CreateTexture(nil, 'BACKGROUND')
    self.TabRight:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
    self.TabRight:SetPoint('RIGHT', self.TabMiddle, 'LEFT')
    self.TabRight:SetAlpha(0.5)
    self.TabRight:SetSize(24, 18)
    self.TabRight:SetTexCoord(0, 0.1875, 0, 1)

    self.TabText = self.Health:CreateFontString(nil, 'ARTWORK')
    self.TabText:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall - 2)
    self.TabText:SetShadowOffset(1, -1)
    self.TabText:SetPoint('CENTER', self.TabMiddle, 0, -1)
    self.TabText:SetAlpha(0.5)
end

    -- generic frame update
    
local function UpdateFrame(self, _, unit)
	if (self.unit ~= unit) then 
        return
    end

    if (self.NameBackground) then
        self.NameBackground:SetVertexColor(UnitSelectionColor(unit))
    end
    
    if (oUF_Neav.show.classPortraits) then
        if (self.Portrait) then
            if (UnitIsPlayer(unit)) then
                local _, class = UnitClass(unit)
                self.Portrait:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
                self.Portrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
            else
                self.Portrait:SetTexCoord(0, 1, 0, 1)
            end
        end
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

    -- druid power bar function 
    
local function UpdateDruidPower(self, event, unit)
    if (unit and unit ~= self.unit) then
        return 
    end
    
    if (self.Druid) then
        local unitPower = PowerBarColor['MANA']
        local mana = UnitPowerType('player', SPELL_POWER_MANA)
        local index = GetShapeshiftForm()

        if (index == 1 or index == 3) then
            if (unitPower) then
                self.Druid:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
            end

            self.Druid:SetAlpha(1)
            self.Druid.Value:SetAlpha(1)
            self.Druid.Texture:SetAlpha(1)

            local min, max = UnitPower('player', 0), UnitPowerMax('player', 0)
            self.Druid:SetMinMaxValues(0, max)
            self.Druid:SetValue(min)

            if (min == max) then
                self.Druid.Value:SetText(FormatValue(min))
            else
                self.Druid.Value:SetText(FormatValue(min)..'/'..FormatValue(max))
            end
        else
            self.Druid:SetAlpha(0)
            self.Druid.Value:SetAlpha(0)
            self.Druid.Texture:SetAlpha(0)
        end
    end
end

local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then 
        return 
    end

    if (self.ThreatGlow) then
        local threat
        if (unit == 'target') then
            threat = UnitThreatSituation('player', 'target')
        else
            threat = UnitThreatSituation(self.unit)
        end

        if (threat and threat > 0) then
            local r, g, b = GetThreatStatusColor(threat)
            self.ThreatGlow:SetVertexColor(r, g, b, 1)
        else
            self.ThreatGlow:SetVertexColor(0, 0, 0, 0)
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

    button.count:SetFont(oUF_Neav.media.font, 13, 'OUTLINE')
    button.count:ClearAllPoints()
    button.count:SetPoint('BOTTOMRIGHT', 1, 1)

    if (not button.Shadow) then
        button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
        button.Shadow:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
        button.Shadow:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
        button.Shadow:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderBackground')
        button.Shadow:SetVertexColor(0, 0, 0, 1)
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
        self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
    elseif (UnitIsDead(unit)) then
        self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
    elseif (UnitIsGhost(unit)) then
        self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
    elseif (min/max * 100 < 25) then
        if (UnitIsPlayer(unit)) then
            if (unit ~= 'player') then
                self.Portrait:SetVertexColor(1, 0, 0, 0.7)
            end
        end
    else
        self.Portrait:SetVertexColor(1, 1, 1, 1)
    end

    self:UNIT_NAME_UPDATE(event, unit)
end

local function UpdatePower(Power, unit, min, max)
    local self = Power:GetParent()

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

	if (unitPower) then
        Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
	else
        Power:SetStatusBarColor(altR, altG, altB)
	end
end

local function CreateUnitLayout(self, unit)
	self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

    self.menu = CreateDropDown
    self:SetAttribute('*type2', 'menu')

    if (oUF_Neav.units.focus.enableFocusToggleKeybind) then
        if (self.unit == 'focus') then
            self:SetAttribute(oUF_Neav.units.focus.focusToggleKey, 'macro')
            self:SetAttribute('macrotext', '/clearfocus')
        else
            self:SetAttribute(oUF_Neav.units.focus.focusToggleKey, 'focus')
        end
    end
    
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
    
        -- create the castbars
        
    if (oUF_Neav.show.castbars) then
        oUF_Neav.CreateCastbars(self, unit)
    end
    
        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	
        -- texture

    self.Texture = self.Health:CreateTexture('$parentTextureFrame', 'ARTWORK')

    if (self.targetUnit) then
        self.Texture:SetSize(93, 45)
        self.Texture:SetPoint('CENTER', self, 0, 0)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetofTargetFrame')
        self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    elseif (unit == 'pet') then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-SmallTargetingFrame')
        self.Texture.SetTexture = function() end
    elseif (unit == 'target' or unit == 'focus') then
        self.Texture:SetSize(230, 100)
        self.Texture:SetPoint('CENTER', self, 20, -7)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame')
        self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    elseif (self.partyUnit) then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame')
    end

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(oUF_Neav.media.statusbar, 'BORDER')

    if (unit == 'player') then
        self.Health:SetSize(119, 12)
    elseif (unit == 'pet') then
        self.Health:SetSize(69, 8)
        self.Health:SetPoint('TOPLEFT', self.Texture, 46, -22)
    elseif (unit == 'target' or unit == 'focus') then
        self.Health:SetSize(119, 12)
        self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -41)
    elseif (self.targetUnit) then
        self.Health:SetSize(47, 7)
        self.Health:SetPoint('CENTER', self, 22, 4)
    elseif (self.partyUnit) then   
        self.Health:SetPoint('TOPLEFT', self.Texture, 47, -12)
        self.Health:SetSize(70, 7) 
    end
    
    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Health.Value:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall, nil)
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
    
    self.Power.PostUpdate = UpdatePower
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    
        -- power text

    self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Power.Value:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall, nil)
    self.Power.Value:SetShadowOffset(1, -1)

    if (self.mainUnit) then
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 2)
    elseif (self.targetUnit) then
        self.Power.Value:Hide()
    else
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 1)
    end

        -- health- and powerbar background

    self.BarBackground = self.Power:CreateTexture(nil, 'BACKGROUND')
    self.BarBackground:SetPoint('TOPRIGHT', self.Health)
    self.BarBackground:SetPoint('BOTTOMLEFT', self.Power)
    self.BarBackground:SetTexture(0, 0, 0, 0.55)

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

        -- level

    if (self.mainUnit) then
        self.Level = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Level:SetFont('Interface\\AddOns\\oUF_Neav\\media\\fontNumber.ttf', 17, 'OUTLINE')
        self.Level:SetShadowOffset(0, 0)
        self.Level:SetPoint('CENTER', self.Texture, (unit == 'player' and -63) or 63.5, -16)
        self:Tag(self.Level, '[level]')
    end

        -- portrait

    self.Portrait = self:CreateTexture('$parentPortrait', 'BACKGROUND')
    
    if (unit == 'player') then
        self.Portrait:SetSize(64, 64)
    elseif (unit == 'pet') then
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
    elseif (unit == 'target' or unit == 'focus') then
        self.Portrait:SetSize(64, 64)
        self.Portrait:SetPoint('TOPRIGHT', self.Texture, -42, -12)
    elseif (self.targetUnit) then
        self.Portrait:SetSize(40, 40)
        self.Portrait:SetPoint('LEFT', self, 'CENTER', -43, 0)
    elseif (self.partyUnit) then
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
    end

        -- pvp icons

    if (oUF_Neav.show.pvpicons) then
        self.PvP = self.Health:CreateTexture('$parentPVPIcon', 'OVERLAY', self)
        
        if (unit == 'player') then
            self.PvP:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.PvP:SetSize(50, 50)
            self.PvP:SetPoint('CENTER', self.Portrait, 'LEFT', 7, -7)
        elseif (unit == 'target' or unit == 'focus') then
            self.PvP:SetSize(64, 64)
            self.PvP:SetPoint('TOPRIGHT', self.Texture, 3, -20)
        elseif (self.partyUnit) then
            self.PvP:SetSize(40, 40)
            self.PvP:SetPoint('TOPLEFT', self.Texture, -9, -10)
        end
    end

        -- masterlooter icon

    self.MasterLooter = self.Health:CreateTexture('$parentMasterLooterIcon', 'OVERLAY', self)
    self.MasterLooter:SetSize(16, 16)
    
    if (unit == 'target' or unit == 'focus') then
        self.MasterLooter:SetPoint('TOPLEFT', self.Portrait, 3, 3)
    elseif (self.targetUnit) then
        self.MasterLooter:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 3, -3)
    elseif (self.partyUnit) then  
        self.MasterLooter:SetSize(14, 14)
        self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 29, 0)
    end

        -- groupleader icon

    self.Leader = self.Health:CreateTexture('$parentLeaderIcon', 'OVERLAY', self)
    self.Leader:SetSize(16, 16)

    if (unit == 'target' or unit == 'focus') then
        self.Leader:SetPoint('TOPRIGHT', self.Portrait, -3, 2)
    elseif (self.targetUnit) then
        self.Leader:SetPoint('TOPLEFT', self.Portrait, -3, 4)
    elseif (self.partyUnit) then
        self.Leader:SetSize(14, 14)
        self.Leader:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 1, -1)
    end

        -- raidicons

    self.RaidIcon = self.Health:CreateTexture('$parentRaidIcon', 'OVERLAY', self)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')

    if (self.mainUnit) then
        self.RaidIcon:SetSize(26, 26)
    else
        self.RaidIcon:SetSize(20, 20)
    end
    
        -- phase text, not ready yet
    
    --[[
    if (unit == 'target' or unit == 'focus' or self.partyUnit) then
        self.PhaseText = self.Health:CreateFontString(nil, 'OVERLAY')
        self.PhaseText:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall)
        self.PhaseText:SetShadowOffset(1, -1)
        self.PhaseText:SetPoint('CENTER', self.Name, 0, 10)
        self.PhaseText:SetTextColor(1, 0, 0)
        self:Tag(self.PhaseText, '[phase]')
    end
    --]]
    
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

        -- threat textures - dont like the oUF threat function, create my own!

    self.ThreatGlow = self:CreateTexture('$parentThreatGlowTexture', 'BACKGROUND')
    self.ThreatGlow:SetAlpha(0)

    if (unit == 'player') then
        self.ThreatGlow:SetSize(242, 92)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, 13, 0)
        self.ThreatGlow:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Flash')
        self.ThreatGlow:SetTexCoord(0.945, 0, 0 , 0.182)
    elseif (unit == 'pet') then
        self.ThreatGlow:SetSize(128, 64)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -4, 12)
        self.ThreatGlow:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame-Flash')
        self.ThreatGlow:SetTexCoord(0, 1, 1, 0)
    elseif (unit == 'target' or unit == 'focus') then
        self.ThreatGlow:SetSize(239, 94)
        self.ThreatGlow:SetPoint('TOPRIGHT', self.Texture, -14, 1)
        self.ThreatGlow:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Flash')
        self.ThreatGlow:SetTexCoord(0, 0.945, 0, 0.182)
    elseif (self.partyUnit) then
        self.ThreatGlow:SetSize(128, 63)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -3, 4)
        self.ThreatGlow:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame-Flash')
    end

    table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)

        -- lfg role icon

    if (self.partyUnit or unit == 'player' or unit == 'target') then
        self.LFDRole = self.Health:CreateTexture('$parentRoleIcon', 'OVERLAY')
        self.LFDRole:SetSize(20, 20)
        
        if (unit == 'player') then
            self.LFDRole:SetPoint('BOTTOMRIGHT', self.Portrait, -2, -3)
        elseif (unit == 'target') then
            self.LFDRole:SetPoint('TOPLEFT', self.Portrait, -10, -2)
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
            
		if (select(2, UnitClass('player')) == 'DRUID') then
        
                -- druid eclipse bar
            
			EclipseBarFrame:SetParent(oUF_Neav_Player)
			EclipseBarFrame:SetScale(oUF_Neav.units.player.scale * 0.82)
			EclipseBar_OnLoad(EclipseBarFrame)
			EclipseBarFrame:ClearAllPoints()
			EclipseBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 4)
			EclipseBarFrame:Show()
            
                -- druid powerbar
    
            self.Druid = CreateFrame('StatusBar', nil, self)
            self.Druid:SetPoint('TOP', self.Power, 'BOTTOM')
            self.Druid:SetStatusBarTexture(oUF_Neav.media.statusbar)
            self.Druid:SetFrameLevel(self:GetFrameLevel() - 1)
            self.Druid:SetSize(100, 10)
            self.Druid:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
            self.Druid:SetBackdropColor(0, 0, 0, 0.5)

            self.Druid.Value = self.Health:CreateFontString(nil, 'ARTWORK')
            self.Druid.Value:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall, nil)
            self.Druid.Value:SetShadowOffset(1, -1)
            self.Druid.Value:SetPoint('CENTER', self.Druid, 0, 0.5)
            
            self.Druid.Texture = self:CreateTexture(nil, 'BACKGROUND')
            self.Druid.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\druidmanaTexture')
            self.Druid.Texture:SetSize(104, 28)
            self.Druid.Texture:SetPoint('TOP', self.Power, 'BOTTOM', -1, 8)
            
                -- on update timer for the druid mana
                
            if (oUF_Neav.units.player.druidManaFrequentUpdates) then
                self.updateTimer = 0
                self:HookScript('OnUpdate', function(self, elapsed)
                    self.updateTimer = self.updateTimer + elapsed
                    
                    if (self.updateTimer > TOOLTIP_UPDATE_TIME/2) then
                        UpdateDruidPower(self, event, unit)
                        self.updateTimer = 0
                    end
                end)
            else
                    -- events for the druid mana
            
                self:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateDruidPower)
                self:RegisterEvent('UNIT_POWER', UpdateDruidPower)
                self:RegisterEvent('UNIT_DISPLAYPOWER', UpdateDruidPower)
            end
            
            if (oUF_Neav.units.player.mouseoverText) then
                self.Druid.Value:Hide()

                self:HookScript('OnEnter', function(self)
                    self.Druid.Value:Show()
                end)

                self:HookScript('OnLeave', function(self)
                    self.Druid.Value:Hide()
                end)
            end
		end
		
            -- deathknight runebar

        if (RuneFrame:IsShown() and RuneButtonIndividual1:IsShown()) then
            RuneFrame:ClearAllPoints()
            RuneFrame:SetPoint('TOP', self.Power, 'BOTTOM', 2, -2)
            RuneFrame:SetParent(self)
        end

            -- raidgroup indicator

        CreateUnitTabTexture(self)
        
        table.insert(self.__elements, UpdatePartyStatus)
        self:RegisterEvent('RAID_ROSTER_UPDATE', UpdatePartyStatus)
        self:RegisterEvent('PARTY_MEMBER_CHANGED', UpdatePartyStatus)

            -- resting/combat status flashing

        if (oUF_Neav.units.player.showStatusFlash) then
            self.StatusFlash = self.Health:CreateTexture('$parentStatusFlashTexture', 'OVERLAY', self)
            self.StatusFlash:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')
            self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
            self.StatusFlash:SetBlendMode('ADD')
            self.StatusFlash:SetSize(191, 66)
            self.StatusFlash:SetPoint('TOPLEFT', self.Texture, 35, -8)
            self.StatusFlash:SetAlpha(0)
            
            table.insert(self.__elements, UpdateFlashStatus)
            self:RegisterEvent('PLAYER_DEAD', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UNGHOST', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_ALIVE', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UPDATE_RESTING', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateFlashStatus)
        end

            -- pvptimer

        if (oUF_Neav.show.pvpicons) then
            self.PvPTimer = self.Health:CreateFontString('$parentPVPTimer', 'OVERLAY')
            self.PvPTimer:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall - 2, oUF_Neav.font.fontSmallOutline and 'OUTLINE' or nil)
            self.PvPTimer:SetShadowOffset(1, -1)
            self.PvPTimer:SetPoint('BOTTOM', self.PvP, 'TOP', -12, -1)
            
            self.updateTimer = 0
            self:HookScript('OnUpdate', function(self, elapsed)
                self.updateTimer = self.updateTimer + elapsed
                    
                if (self.updateTimer > TOOLTIP_UPDATE_TIME/2) then
                    if (IsPVPTimerRunning()) then
                        local sec = floor(GetPVPTimer()/1000) 
                        self.PvPTimer:SetText(floor(sec/60)..'m')
                    else
                        self.PvPTimer:SetText(nil)
                    end
                    
                    self.updateTimer = 0
                end
            end)
        end
    
            -- oUF_Swing support 
            
        if (oUF_Neav.units.player.showSwingTimer) then
            self.Swing = CreateFrame('Frame', nil, self)
            self.Swing:SetFrameStrata('LOW')
            -- self.Swing:SetSize(200, 7)
            self.Swing:SetHeight(7)
            self.Swing:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Swing:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Swing:Hide()
                
            self.Swing.texture = oUF_Neav.media.statusbar
            self.Swing.color = {0, 0.8, 1, 1}
                
            self.Swing.textureBG = oUF_Neav.media.statusbar
            self.Swing.colorBG = {0, 0, 0, 0.55}
         
            self.Swing:CreateBorder(11)
            self.Swing:SetBorderPadding(3)
                
            self.Swing.f = CreateFrame('Frame', nil, self)
            self.Swing.f:SetParent(self.Swing)
            self.Swing.f:SetFrameStrata('HIGH')       
                
            self.Swing.Text = self.Swing.f:CreateFontString(nil, 'OVERLAY')
            self.Swing.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall - 2)
            self.Swing.Text:SetPoint('CENTER', self.Swing)

            self.Swing.disableMelee = false
            self.Swing.disableRanged = false
            self.Swing.hideOoc = true
        end
        
            -- oUF_Vengeance support 
         
        if (oUF_Neav.units.player.showVengeance) then
            self.Vengeance = CreateFrame("StatusBar", nil, self)
            self.Vengeance:SetHeight(7)
            self.Vengeance:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Vengeance:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Vengeance:SetStatusBarTexture(oUF_Neav.media.statusbar)
            self.Vengeance:SetStatusBarColor(1, 0, 0)
            
            self.Vengeance:CreateBorder(11)
            self.Vengeance:SetBorderPadding(3)
            
            self.Vengeance.Background = self.Vengeance:CreateTexture(nil, 'BACKGROUND')
            self.Vengeance.Background:SetAllPoints(self.Vengeance)
            self.Vengeance.Background:SetTexture(0, 0, 0, 0.55)
        
            self.Vengeance.Text = self.Vengeance:CreateFontString(nil, 'OVERLAY')
            self.Vengeance.Text:SetFont(oUF_Neav.media.font, oUF_Neav.font.fontSmall - 2)
            self.Vengeance.Text:SetPoint('CENTER', self.Vengeance)
        end
        
            -- combat text
        
        if (oUF_Neav.units.player.showCombatFeedback) then
            self.CombatFeedbackText = self.Health:CreateFontString(nil, 'ARTWORK')
            self.CombatFeedbackText:SetFont(oUF_Neav.media.font, 23, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end
        
           -- resting icon

		self.Resting = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Resting:SetPoint('CENTER', self.Level, -0.5, 0)
		self.Resting:SetSize(31, 34)
        
            -- combat icon

        self.Combat = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Combat:SetPoint('CENTER', self.Level, 1, 0)
		self.Combat:SetSize(31, 33)
        
            -- player frame vehicle/normal update
            
        table.insert(self.__elements, CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERED_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITED_VEHICLE', CheckVehicleStatus)
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
    
    if (unit == 'target' or unit == 'focus') then
        self:SetSize(175, 42)
        
            -- colored name background
        
        self.NameBackground = self.Health:CreateTexture('$parentNameBackground', 'BACKGROUND')
        self.NameBackground:SetHeight(18)
        self.NameBackground:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.NameBackground:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.NameBackground:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.NameBackground:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')

            -- combat feedback text
            
        if (oUF_Neav.units.target.showCombatFeedback or oUF_Neav.units.focus.showCombatFeedback) then
            self.CombatFeedbackText = self.Health:CreateFontString(nil, 'ARTWORK')
            self.CombatFeedbackText:SetFont(oUF_Neav.media.font, 23, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end
        
            -- questmob icon
            
        self.QuestIcon = self.Health:CreateTexture('$parentQuestMobIcon', 'OVERLAY')
        self.QuestIcon:SetSize(32, 32)
        self.QuestIcon:SetPoint('CENTER', self.Health, 'TOPRIGHT', 1, 10)
    end
    
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
        self.Auras.numBuffs = oUF_Neav.units.target.numBuffs
        self.Auras.numDebuffs = oUF_Neav.units.target.numDebuffs
        self.Auras.spacing = 4.5
        self.Auras.customBreak = true
        
		if (oUF_Neav.units.target.colorPlayerDebuffsOnly) then
			self.Auras.PostUpdateIcon = function(self, unit, icon)
				if (unit ~= 'target') then 
                    return 
                end
				
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
        
        if (oUF_Neav.units.target.showComboPoints) then
            if (oUF_Neav.units.target.showComboPointsAsNumber) then
                self.ComboPoints = self.Health:CreateFontString(nil, 'ARTWORK')
                self.ComboPoints:SetFont(DAMAGE_TEXT_FONT, 26, 'OUTLINE')
                self.ComboPoints:SetShadowOffset(0, 0)
                self.ComboPoints:SetPoint('LEFT', self.Portrait, 'RIGHT', 8, 4)
                self.ComboPoints:SetTextColor(unpack(oUF_Neav.units.target.numComboPointsColor))
                self:Tag(self.ComboPoints, '[combopoints]')
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
    
    if (unit == 'focus') then
        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs.size = oUF_Neav.units.focus.auraSize + 7
        self.Debuffs:SetHeight(self.Debuffs.size * 3)
        self.Debuffs:SetWidth(self.Debuffs.size * 3)
        self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -3.5, -5)
        self.Debuffs.initialAnchor = 'TOPLEFT'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs.num = oUF_Neav.units.focus.numDebuffs
        self.Debuffs.spacing = 4
        
        CreateUnitTabTexture(self)

        self.TabText:SetText(FOCUS)
        self.TabMiddle:SetPoint('BOTTOM', self.NameBackground, 'TOP', 0, 1)
        self.TabMiddle:SetWidth(self.TabMiddle:GetWidth() + 8)
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

        -- mouseover text

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

    local focustarget = self:Spawn('focustarget', 'oUF_Neav_FocusTarget')
    focustarget:SetPoint('TOPLEFT', oUF_Neav_Focus, 'BOTTOMRIGHT', -78, -15)
    focustarget:SetScale(oUF_Neav.units.focustarget.scale)

	if (oUF_Neav.units.party.show) then
		local party = oUF:SpawnHeader('oUF_Neav_Party', nil, (oUF_Neav.units.party.hideInRaid and 'party') or 'party,raid',
			'oUF-initialConfigFunction', [[
				self:SetWidth(105)
				self:SetHeight(30)
			]],
			'showParty', true,
			'yOffset', -30
		)
        party:SetPoint(unpack(oUF_Neav.units.party.position))
        party:SetScale(oUF_Neav.units.party.scale)
    end
end)
