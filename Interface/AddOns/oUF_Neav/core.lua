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

local _, ns = ...
local config = ns.config

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

    -- create the drop downmenu of our unitframes
    
local dropdown = CreateFrame('Frame', 'CustomUnitDropDownMenu', UIParent, 'UIDropDownMenuTemplate')

UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if (not unit) then 
        return 
    end

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
	-- ToggleDropDownMenu(1, nil, dropdown, self, self:GetWidth() * 0.75, -5)
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

    self.Name.Bg:Hide()

    self.Name:SetWidth(100)
    self.Name:SetPoint('CENTER', self.Texture, 30, 23)
    
    if (self.Portrait.Bg) then
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 52, -19)
        self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 23, -12)
    else
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 23, -12)
    end
    
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
    
    if (config.units.player.style == 'NORMAL') then
		self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame')
	elseif (config.units.player.style == 'RARE') then
		self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Rare')
	elseif (config.units.player.style == 'ELITE') then
		self.Texture:SetTexture('Interface\\TargetingFrame\\UI-TargetingFrame-Elite')
    elseif (config.units.player.style == 'CUSTOM') then
        self.Texture:SetTexture(config.units.player.customTexture)
    end

    self.Health:SetHeight(12)
    self.Health:SetWidth(119)
    self.Health:SetPoint('TOPLEFT', self.Texture, 106, -41)

    self.Name.Bg:Show()

    self.Name:SetWidth(110)
    self.Name:SetPoint('CENTER', self.Texture, 50, 19)
    
    if (self.Portrait.Bg) then
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 49, -19)
        self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 42, -12)
    else
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 42, -12)
    end
    
    self.Leader:SetPoint('TOPLEFT', self.Portrait, 3, 2)
    self.MasterLooter:SetPoint('TOPRIGHT', self.Portrait, -3, 3)
    self.PvP:SetPoint('TOPLEFT', self.Texture, 18, -20)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    
    self.TabMiddle:SetPoint('BOTTOM', self.Name.Bg, 'TOP', -1, 0)
end

local function UpdateFlashStatus(self)
    if (UnitHasVehicleUI('player') or UnitIsDeadOrGhost('player')) then
        ns.StopFlash(self.StatusFlash)
        return
    end
            
    if (UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.1, 0.1, 1)
                
        if (not ns.IsFlashing(self.StatusFlash)) then
            ns.StartFlash(self.StatusFlash, 0.75, 0.75, 0.1, 0.1)
        end
    elseif (IsResting() and not UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.88, 0.25, 1)
                
        if (not ns.IsFlashing(self.StatusFlash)) then
            ns.StartFlash(self.StatusFlash, 0.75, 0.75, 0.1, 0.1)
        end
    else
        ns.StopFlash(self.StatusFlash)
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

local function SetTabAlpha(self, alpha)
    self.TabMiddle:SetAlpha(alpha)
    self.TabLeft:SetAlpha(alpha)
    self.TabRight:SetAlpha(alpha)
    self.TabText:SetAlpha(alpha)
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
    self.TabText:SetFont(config.font.normal, config.font.normalSize - 1)
    self.TabText:SetShadowOffset(1, -1)
    self.TabText:SetPoint('BOTTOM', self.TabMiddle, 0, 1)
    self.TabText:SetAlpha(0.5)
end

    -- group indicator above the playerframe

local function UpdatePartyStatus(self)
    for i = 1, MAX_RAID_MEMBERS do
        if (GetNumRaidMembers() > 0) then
            local unitName, _, groupNumber = GetRaidRosterInfo(i)
            if (unitName == UnitName('player')) then
                self.TabText:SetText(GROUP..' '..groupNumber)
                self.TabMiddle:SetWidth(self.TabText:GetWidth())
                
                SetTabAlpha(self, 0.5)
            end
        else
            SetTabAlpha(self, 0)
        end
    end
end

local function UpdatePortraitColor(self, unit, min, max)
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
end

    -- update target and focus texture
    
local texPath = 'Interface\\TargetingFrame\\UI-TargetingFrame'
local texTable = {
    ['elite'] = texPath..'-Elite',
    ['rareelite'] = texPath..'-Rare-Elite',
    ['rare'] = texPath..'-Rare',
    ['worldboss'] = texPath..'-Elite',
    ['normal'] = texPath,
}

local function UpdateTarFoFrame(self, _, unit)
    if (unit == 'target' or unit == 'focus') then
        self.Texture:SetTexture(texTable[UnitClassification(unit)] or texTable['normal'])
    end
end

    -- generic frame update
    
local function UpdateFrame(self, unit)
	if (self.unit ~= unit) then 
        return
    end
    
    if (self.Portrait.Bg) then
        self.Portrait.Bg:SetVertexColor(UnitSelectionColor(unit))
    end
    
    if (unit == 'target' or unit == 'focus') then
        if (self.Name.Bg) then
            self.Name.Bg:SetVertexColor(UnitSelectionColor(unit))
        end
    end
    
    if (unit == 'target') then
        if (self.TabText) then
            local utype = UnitCreatureType(unit)
            local urace = UnitRace(unit)
            
            if (utype or urace) then
                self.TabText:SetText(UnitIsPlayer(unit) and urace or utype)
                self.TabMiddle:SetWidth(self.TabText:GetWidth())
            else
                SetTabAlpha(self, 0)
            end
        end
    end

    if (config.show.classPortraits and not self.Portrait.Bg) then
        if (self.Portrait) then
            if (UnitIsPlayer(unit)) then
                local _, unitClass = UnitClass(unit)
                self.Portrait:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
                self.Portrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[unitClass]))
            else
                self.Portrait:SetTexCoord(0, 1, 0, 1)
            end
        end
    end
    
    if (self.AFKText) then
        self.AFKText:Hide()
        
        if (UnitIsAFK(unit)) then
            self.AFKText:Show()
        end
    end
end

    -- druid power bar function 
    
local function UpdateDruidPower(self, event, unit)
    if (not self.Druid) then
        return
    end
    
    if (ns.MultiCheck(GetShapeshiftForm(), 1, 3)) then
        local unitPower = PowerBarColor['MANA']
        
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
            self.Druid.Value:SetText(ns.FormatValue(min))
        else
            self.Druid.Value:SetText(ns.FormatValue(min)..'/'..ns.FormatValue(max))
        end
    else
        self.Druid:SetAlpha(0)
        self.Druid.Value:SetAlpha(0)
        self.Druid.Texture:SetAlpha(0)
    end
end

local function EnableMouseOver(self)
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

local function UpdateHealth(Health, unit, min, max)
    local self = Health:GetParent()
 
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end
    
    Health.Value:SetText(ns.HealthString(self, unit))

    UpdateFrame(self, unit)
    
    if (not self.Portrait.Bg) then
        UpdatePortraitColor(self, unit, min, max)
    end
end

local function UpdatePower(Power, unit, min, max)
    local self = Power:GetParent()
    
    local powerString
    
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Power:SetValue(0)
        powerString = ''
    elseif (min == 0) then
        powerString = ''
    elseif (not UnitHasMana(unit)) then
        powerString = min
    elseif (config.units[ns.cUnit(unit)].showPowerPercent) then
        powerString = (min/max * 100 < 100 and format('%d%%', min/max * 100)) or ''
    else
        if (min == max) then
            powerString = ns.FormatValue(min)
        else
            powerString = ns.FormatValue(min)..'/'..ns.FormatValue(max)
        end
    end
    
    -- local altPower = UnitPower(unit, ALTERNATE_POWER_INDEX)
    -- Power.Value:SetText(powerString..(altPower > 0 and (' ['..altPower..']') or ''))
    Power.Value:SetText(powerString)
end

local focusAnchor = CreateFrame('Frame', 'oUF_Neav_Focus_Anchor', UIParent)
focusAnchor:SetSize(1, 1)
focusAnchor:SetPoint('CENTER')
focusAnchor:SetMovable(true)
focusAnchor:SetClampedToScreen(true)
focusAnchor:SetUserPlaced(true)

local function CreateUnitLayout(self, unit)
    self.IsMainFrame = ns.MultiCheck(unit, 'player', 'target', 'focus')
    self.IsTargetFrame = ns.MultiCheck(unit, 'targettarget', 'focustarget')
    self.IsPartyFrame = unit:match('party')

    if (self.IsTargetFrame) then
        self:SetFrameStrata('MEDIUM')
    else
        self:SetFrameStrata('LOW')
    end

	self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

    self.menu = CreateDropDown
    self:SetAttribute('*type2', 'menu')

    if (config.units.focus.enableFocusToggleKeybind) then
        if (unit == 'focus') then
            self:SetAttribute(config.units.focus.focusToggleKey, 'macro')
            self:SetAttribute('macrotext', '/clearfocus')
        else
            self:SetAttribute(config.units.focus.focusToggleKey, 'focus')
        end
    end
    
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

        -- create the castbars
        
    if (config.show.castbars) then
        ns.CreateCastbars(self, unit)
    end
    
        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	
        -- texture

    self.Texture = self.Health:CreateTexture(nil, 'ARTWORK')

    if (self.IsTargetFrame) then
        self.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\customTargetTargetTexture_2')
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('CENTER', self, 16, -10)
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
    elseif (self.IsPartyFrame) then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame')
    end

        -- healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(config.media.statusbar, 'BORDER')

    if (unit == 'player') then
        self.Health:SetSize(119, 12)
    elseif (unit == 'pet') then
        self.Health:SetSize(69, 8)
        self.Health:SetPoint('TOPLEFT', self.Texture, 46, -22)
    elseif (unit == 'target' or unit == 'focus') then
        self.Health:SetSize(119, 12)
        self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -41)
    elseif (self.IsTargetFrame) then
        self.Health:SetSize(45, 6)
        self.Health:SetPoint('CENTER', self, 20, 4)
    elseif (self.IsPartyFrame) then   
        self.Health:SetPoint('TOPLEFT', self.Texture, 47, -12)
        self.Health:SetSize(70, 7) 
    end
    
    self.Health:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)
    
    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'ARTWORK')
    
    if (self.IsTargetFrame) then
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize - 1)
        self.Health.Value:SetPoint('CENTER', self.Health, 'BOTTOM', -4, -0.5)
    else
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize)
        self.Health.Value:SetPoint('CENTER', self.Health, 1, 1)
    end
    
    self.Health.Value:SetShadowOffset(1, -1)

        -- powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture(config.media.statusbar, 'BORDER')

    if (self.IsTargetFrame) then
        self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', -10, 0)
        self.Power:SetHeight(self.Health:GetHeight() + 1)
    else
        self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, 0)
        self.Power:SetHeight(self.Health:GetHeight())
    end

    self.Power:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Power:SetBackdropColor(0, 0, 0, 0.55)
    
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
        
    self.Power.colorPower = true
    
        -- power text
        
    if (not self.IsTargetFrame) then
        self.Power.Value = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Power.Value:SetFont(config.font.normal, config.font.normalSize)
        self.Power.Value:SetShadowOffset(1, -1)
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 1)
        
        self.Power.PostUpdate = UpdatePower
    end

        -- name

    self.Name = self.Health:CreateFontString(nil, 'ARTWORK')
	self.Name:SetFont(config.font.normalBig, config.font.normalBigSize)
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
    elseif (self.IsTargetFrame) then
        self.Name:SetWidth(65)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('TOPLEFT', self, 'CENTER', -3, -12)
    elseif (self.IsPartyFrame) then    
        self.Name:SetJustifyH('CENTER')
        self.Name:SetHeight(10)
        self.Name:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
    end

    self:Tag(self.Name, '[name]')

        -- level

    if (self.IsMainFrame) then
        self.Level = self.Health:CreateFontString(nil, 'ARTWORK')
        self.Level:SetFont('Interface\\AddOns\\oUF_Neav\\media\\fontNumber.ttf', 17, 'THINOUTLINE')
        self.Level:SetShadowOffset(0, 0)
        self.Level:SetPoint('CENTER', self.Texture, (unit == 'player' and -63) or 63.5, -16)
        self:Tag(self.Level, '[level]')
    end

        -- portrait
        
    if (config.show.ThreeDPortraits) then    
        self.Portrait = CreateFrame('PlayerModel', nil, self.Health)
        self.Portrait:SetFrameStrata('BACKGROUND')
        
        self.Portrait.Bg = self:CreateTexture(nil, 'BACKGROUND')
        self.Portrait.Bg:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\portraitBackground')
        self.Portrait.Bg:SetParent(self.Portrait)
        
        if (unit == 'player') then
            self.Portrait:SetSize(50, 50)
            self.Portrait.Bg:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
            
            self.Portrait.Bg:SetSize(37, 37)
            self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 7, -6)
        elseif (unit == 'target' or unit == 'focus') then
            self.Portrait:SetSize(50, 50)
            self.Portrait:SetPoint('TOPRIGHT', self.Texture, -50, -19)
            
            self.Portrait.Bg:SetSize(64, 64)
            self.Portrait.Bg:SetPoint('TOPRIGHT', self.Texture, -42, -12)
        elseif (self.IsTargetFrame) then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('LEFT', self, 'CENTER', -38, -1)
            
            self.Portrait.Bg:SetSize(40, 40)
            self.Portrait.Bg:SetPoint('LEFT', self, 'CENTER', -43, 0)
        elseif (self.IsPartyFrame) then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 9, -8)
            
            self.Portrait.Bg:SetSize(37, 37)
            self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 7, -6)
        end
    else
        self.Portrait = self:CreateTexture(nil, 'BACKGROUND')
        
        if (unit == 'player') then
            self.Portrait:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.Portrait:SetSize(37, 37)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
        elseif (unit == 'target' or unit == 'focus') then
            self.Portrait:SetSize(64, 64)
            self.Portrait:SetPoint('TOPRIGHT', self.Texture, -42, -12)
        elseif (self.IsTargetFrame) then
            self.Portrait:SetSize(40, 40)
            self.Portrait:SetPoint('LEFT', self, 'CENTER', -43, 0)
        elseif (self.IsPartyFrame) then
            self.Portrait:SetSize(37, 37)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
        end
    end
    
        -- pvp icons

    if (config.show.pvpicons) then
        self.PvP = self.Health:CreateTexture(nil, 'OVERLAY', self)
        
        if (unit == 'player') then
            self.PvP:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.PvP:SetSize(50, 50)
            self.PvP:SetPoint('CENTER', self.Portrait, 'LEFT', 7, -7)
        elseif (unit == 'target' or unit == 'focus') then
            self.PvP:SetSize(64, 64)
            self.PvP:SetPoint('TOPRIGHT', self.Texture, 3, -20)
        elseif (self.IsPartyFrame) then
            self.PvP:SetSize(40, 40)
            self.PvP:SetPoint('TOPLEFT', self.Texture, -9, -10)
        end
    end

        -- masterlooter icon

    self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY', self)
    self.MasterLooter:SetSize(16, 16)
    
    if (unit == 'target' or unit == 'focus') then
        self.MasterLooter:SetPoint('TOPLEFT', self.Portrait, 3, 3)
    elseif (self.IsTargetFrame) then
        self.MasterLooter:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 3, -3)
    elseif (self.IsPartyFrame) then  
        self.MasterLooter:SetSize(14, 14)
        self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 29, 0)
    end

        -- groupleader icon

    self.Leader = self.Health:CreateTexture(nil, 'OVERLAY', self)
    self.Leader:SetSize(16, 16)

    if (unit == 'target' or unit == 'focus') then
        self.Leader:SetPoint('TOPRIGHT', self.Portrait, -3, 2)
    elseif (self.IsTargetFrame) then
        self.Leader:SetPoint('TOPLEFT', self.Portrait, -3, 4)
    elseif (self.IsPartyFrame) then
        self.Leader:SetSize(14, 14)
        self.Leader:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 1, -1)
    end

        -- raidicons

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY', self)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')

    if (self.IsMainFrame) then
        self.RaidIcon:SetSize(26, 26)
    else
        self.RaidIcon:SetSize(20, 20)
    end
    
        -- phase text
    
    --[[
    if (unit == 'target' or unit == 'focus' or self.IsPartyFrame) then
        self.PhaseText = self.Health:CreateFontString(nil, 'OVERLAY')
        self.PhaseText:SetFont(config.font.normal, config.font.normalSize)
        self.PhaseText:SetShadowOffset(1, -1)
        self.PhaseText:SetPoint('CENTER', self.Name, 0, 10)
        self.PhaseText:SetTextColor(1, 0, 0)
        self:Tag(self.PhaseText, '[phase]')
    end
    --]]
        -- afk text

    self.AFKText = self.Health:CreateFontString(nil, 'OVERLAY')
    self.AFKText:SetTextColor(0, 1, 0)
	self.AFKText:SetFont(config.font.normalBig, self.Portrait.Bg and (self.Portrait.Bg:GetSize() / 3.5) or (self.Portrait:GetSize() / 3.5))
    self.AFKText:SetShadowOffset(1, -1)
    self.AFKText:SetJustifyH('CENTER')
    self.AFKText:SetPoint('BOTTOM', self.Portrait, 'CENTER', 0, 2)
    self.AFKText:SetText('AFK')
    self.AFKText:Hide()
    
    self:RegisterEvent('PLAYER_FLAGS_CHANGED', function()
        UpdateFrame(self, unit)
    end)
    
        -- offline icons

    self.OfflineIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.OfflineIcon:SetPoint('TOPRIGHT', self.Portrait, 7, 7)
    self.OfflineIcon:SetPoint('BOTTOMLEFT', self.Portrait, -7, -7)

        -- ready check icons

    if (unit == 'player' or self.IsPartyFrame) then
        self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
        self.ReadyCheck:SetPoint('TOPRIGHT', self.Portrait, -7, -7)
        self.ReadyCheck:SetPoint('BOTTOMLEFT', self.Portrait, 7, 7)
        self.ReadyCheck.delayTime = 2
        self.ReadyCheck.fadeTime = 0.7
    end

        -- threat textures - dont like the oUF threat function, create my own!

    self.ThreatGlow = self:CreateTexture(nil, 'BACKGROUND')

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
    elseif (self.IsPartyFrame) then
        self.ThreatGlow:SetSize(128, 63)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -3, 4)
        self.ThreatGlow:SetTexture('Interface\\TargetingFrame\\UI-PartyFrame-Flash')
    end

        -- lfg role icon

    if (self.IsPartyFrame or unit == 'player' or unit == 'target') then
        self.LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
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
        
        self.Name.Bg = self.Health:CreateTexture(nil, 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Name.Bg:SetVertexColor(0, 0, 0, 0.55)

			-- warlock soulshard bar
            
            
		if (select(2, UnitClass('player')) == 'WARLOCK') then
			ShardBarFrame:SetParent(oUF_Neav_Player)
			ShardBarFrame:SetScale(config.units.player.scale * 0.8)
			ShardBar_OnLoad(ShardBarFrame)
			ShardBarFrame:ClearAllPoints()
			ShardBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, -1)
			ShardBarFrame:Show()
		end

			-- holy power bar
            
		if (select(2, UnitClass('player')) == 'PALADIN') then
			PaladinPowerBar:SetParent(oUF_Neav_Player)
			PaladinPowerBar:SetScale(config.units.player.scale * 0.81)
			PaladinPowerBar_OnLoad(PaladinPowerBar)
			PaladinPowerBar:ClearAllPoints()
			PaladinPowerBar:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 25, 2)
			PaladinPowerBar:Show()
		end
            
		if (select(2, UnitClass('player')) == 'DRUID') then
        
                -- druid eclipse bar
            
			EclipseBarFrame:SetParent(oUF_Neav_Player)
			EclipseBarFrame:SetScale(config.units.player.scale * 0.82)
			EclipseBar_OnLoad(EclipseBarFrame)
			EclipseBarFrame:ClearAllPoints()
			EclipseBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 4)
			EclipseBarFrame:Show()
            
                -- druid powerbar
    
            self.Druid = CreateFrame('StatusBar', nil, self)
            self.Druid:SetPoint('TOP', self.Power, 'BOTTOM')
            self.Druid:SetStatusBarTexture(config.media.statusbar)
            self.Druid:SetFrameLevel(self:GetFrameLevel() - 1)
            self.Druid:SetSize(100, 10)
            self.Druid:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
            self.Druid:SetBackdropColor(0, 0, 0, 0.5)

            self.Druid.Value = self.Health:CreateFontString(nil, 'ARTWORK')
            self.Druid.Value:SetFont(config.font.normal, config.font.normalSize)
            self.Druid.Value:SetShadowOffset(1, -1)
            self.Druid.Value:SetPoint('CENTER', self.Druid, 0, 0.5)
            
            self.Druid.Texture = self:CreateTexture(nil, 'BACKGROUND')
            self.Druid.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\druidmanaTexture')
            self.Druid.Texture:SetSize(104, 28)
            self.Druid.Texture:SetPoint('TOP', self.Power, 'BOTTOM', -1, 8)
            
                -- on update timer for the druid mana
                
            if (config.units.player.druidManaFrequentUpdates) then
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

                UpdateDruidPower(self, _, unit)
                
                self:RegisterEvent('UNIT_POWER', UpdateDruidPower)
                self:RegisterEvent('UNIT_DISPLAYPOWER', UpdateDruidPower)
            end
            
            if (config.units.player.mouseoverText) then
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

        if (select(2, UnitClass('player')) == 'DEATHKNIGHT') then
            RuneFrame:ClearAllPoints()
            RuneFrame:SetPoint('TOP', self.Power, 'BOTTOM', 2, -2)
            RuneFrame:SetParent(self)
        end

            -- raidgroup indicator

        CreateUnitTabTexture(self)
        UpdatePartyStatus(self) 
    
        self:RegisterEvent('RAID_ROSTER_UPDATE', UpdatePartyStatus)
        self:RegisterEvent('PARTY_MEMBER_CHANGED', UpdatePartyStatus)

            -- resting/combat status flashing

        if (config.units.player.showStatusFlash) then
            self.StatusFlash = self.Health:CreateTexture(nil, 'OVERLAY', self)
            self.StatusFlash:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')
            self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
            self.StatusFlash:SetBlendMode('ADD')
            self.StatusFlash:SetSize(191, 66)
            self.StatusFlash:SetPoint('TOPLEFT', self.Texture, 35, -8)
            self.StatusFlash:SetAlpha(0)
            
            UpdateFlashStatus(self, _, unit) 

            self:RegisterEvent('PLAYER_DEAD', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UNGHOST', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_ALIVE', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UPDATE_RESTING', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateFlashStatus)
        end

            -- pvptimer

        if (config.show.pvpicons) then
            self.PvPTimer = self.Health:CreateFontString(nil, 'OVERLAY')
            self.PvPTimer:SetFont(config.font.normal, config.font.normalSize)
            self.PvPTimer:SetShadowOffset(1, -1)
            self.PvPTimer:SetPoint('BOTTOM', self.PvP, 'TOP', -12, -1)
            
            self.updateTimer = 0
            self:HookScript('OnUpdate', function(self, elapsed)
                self.updateTimer = self.updateTimer + elapsed
                    
                if (self.updateTimer > 0.33) then
                    if (IsPVPTimerRunning() and GetPVPTimer() ~= 0 and self.PvP:IsShown()) then
                        self.PvPTimer:SetText(ns.FormatTime(math.floor(GetPVPTimer()/1000)))
                    else
                        self.PvPTimer:SetText(nil)
                    end
                    
                    self.updateTimer = 0
                end
            end)
        end
    
            -- oUF_Swing support 
            
        if (config.units.player.showSwingTimer) then
            self.Swing = CreateFrame('Frame', nil, self)
            self.Swing:SetFrameStrata('LOW')
            -- self.Swing:SetSize(200, 7)
            self.Swing:SetHeight(7)
            self.Swing:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Swing:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Swing:Hide()
                
            self.Swing.texture = config.media.statusbar
            self.Swing.color = {0, 0.8, 1, 1}
                
            self.Swing.textureBG = config.media.statusbar
            self.Swing.colorBG = {0, 0, 0, 0.55}
         
            self.Swing:CreateBeautyBorder(11)
            self.Swing:SetBeautyBorderPadding(3)
                
            self.Swing.f = CreateFrame('Frame', nil, self.Swing)
            self.Swing.f:SetFrameStrata('HIGH')       
                
            self.Swing.Text = self.Swing.f:CreateFontString(nil, 'OVERLAY')
            self.Swing.Text:SetFont(config.font.normal, config.font.normalSize)
            self.Swing.Text:SetPoint('CENTER', self.Swing)

            self.Swing.disableMelee = false
            self.Swing.disableRanged = false
            self.Swing.hideOoc = true
        end
        
            -- oUF_Vengeance support 
         
        if (config.units.player.showVengeance) then
            self.Vengeance = CreateFrame('StatusBar', nil, self)
            self.Vengeance:SetHeight(7)
            self.Vengeance:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Vengeance:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Vengeance:SetStatusBarTexture(config.media.statusbar)
            self.Vengeance:SetStatusBarColor(1, 0, 0)
            
            self.Vengeance:CreateBeautyBorder(11)
            self.Vengeance:SetBeautyBorderPadding(3)
            
            self.Vengeance.Bg = self.Vengeance:CreateTexture(nil, 'BACKGROUND')
            self.Vengeance.Bg:SetAllPoints(self.Vengeance)
            self.Vengeance.Bg:SetTexture(0, 0, 0, 0.55)
        
            self.Vengeance.Text = self.Vengeance:CreateFontString(nil, 'OVERLAY')
            self.Vengeance.Text:SetFont(config.font.normal, config.font.normalSize)
            self.Vengeance.Text:SetPoint('CENTER', self.Vengeance)
        end
        
            -- combat text
        
        if (config.units.player.showCombatFeedback) then
            self.CombatFeedbackText = self.Health:CreateFontString(nil, 'ARTWORK')
            self.CombatFeedbackText:SetFont(config.font.normal, 22, 'OUTLINE')
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
        
        CheckVehicleStatus(self, _, unit)
        
        self:RegisterEvent('UNIT_ENTERED_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITED_VEHICLE', CheckVehicleStatus)
    end

        -- petframe

    if (unit == 'pet') then
		self:SetSize(175, 42)

        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs.size = 20
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
        
        self.Name.Bg = self.Health:CreateTexture(nil, 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')

            -- combat feedback text
            
        if (config.units.target.showCombatFeedback or config.units.focus.showCombatFeedback) then
            self.CombatFeedbackText = self.Health:CreateFontString(nil, 'ARTWORK')
            self.CombatFeedbackText:SetFont(config.font.normal, 22, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end
        
            -- questmob icon
            
        self.QuestIcon = self.Health:CreateTexture(nil, 'OVERLAY')
        self.QuestIcon:SetSize(32, 32)
        self.QuestIcon:SetPoint('CENTER', self.Health, 'TOPRIGHT', 1, 10)
        
        table.insert(self.__elements, UpdateTarFoFrame)
    end

    if (unit == 'target') then
        if (config.units.target.showUnitTypeTab) then
            CreateUnitTabTexture(self)
            self.TabMiddle:SetPoint('BOTTOM', self.Name.Bg, 'TOP', 0, 1)
        end
        
        self.Auras = CreateFrame('Frame', nil, self)
        self.Auras.gap = true
        self.Auras.size = 20
        self.Auras:SetHeight(self.Auras.size * 3)
        self.Auras:SetWidth(self.Auras.size * 5)
        self.Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -3, -5)
        self.Auras.initialAnchor = 'TOPLEFT'
        self.Auras['growth-x'] = 'RIGHT'
        self.Auras['growth-y'] = 'DOWN'
        self.Auras.numBuffs = config.units.target.numBuffs
        self.Auras.numDebuffs = config.units.target.numDebuffs
        self.Auras.spacing = 4.5
        
        self.Auras.customBreak = true

        if (config.units.target.showComboPoints) then
            if (config.units.target.showComboPointsAsNumber) then
                self.ComboPoints = self.Health:CreateFontString(nil, 'OVERLAY')
                self.ComboPoints:SetFont(DAMAGE_TEXT_FONT, 26, 'OUTLINE')
                self.ComboPoints:SetShadowOffset(0, 0)
                self.ComboPoints:SetPoint('LEFT', self.Portrait, 'RIGHT', 8, 4)
                self.ComboPoints:SetTextColor(unpack(config.units.target.numComboPointsColor))
                self:Tag(self.ComboPoints, '[combopoints]')
            else
                self.CPoints = {}
    
                for i = 1, 5 do
                    self.CPoints[i] = self.Health:CreateTexture(nil, 'OVERLAY')
                    self.CPoints[i]:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\ComboPoint')
                    self.CPoints[i]:SetSize(15, 15)
                end

                self.CPoints[1]:SetPoint('TOPRIGHT', self.Texture, -42, -8)
                self.CPoints[2]:SetPoint('TOP', self.CPoints[1], 'BOTTOM', 7.33, 6.66)
                self.CPoints[3]:SetPoint('TOP', self.CPoints[2], 'BOTTOM', 4.66, 4.33)
                self.CPoints[4]:SetPoint('TOP', self.CPoints[3], 'BOTTOM', 1.33 , 3.66)
                self.CPoints[5]:SetPoint('TOP', self.CPoints[4], 'BOTTOM', -1.66, 3.66)
            end
        end
    end
    
    if (unit == 'focus') then
        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs.size = 26
        self.Debuffs:SetHeight(self.Debuffs.size * 3)
        self.Debuffs:SetWidth(self.Debuffs.size * 3)
        self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -3.5, -5)
        self.Debuffs.initialAnchor = 'TOPLEFT'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs.num = config.units.focus.numDebuffs
        self.Debuffs.spacing = 4
        
        CreateUnitTabTexture(self)
        
        self.TabText:SetText(FOCUS)
        self.TabMiddle:SetPoint('BOTTOM', self.Name.Bg, 'TOP', 0, 1)
        self.TabMiddle:SetWidth(self.TabText:GetWidth())
        
            -- the drag frame

        self.DragFrame = CreateFrame('Frame')
        self.DragFrame:SetPoint('TOP', self.TabMiddle)
        self.DragFrame:SetPoint('BOTTOM', self.TabMiddle)
        self.DragFrame:SetPoint('LEFT', self.TabMiddle, -15, 0)
        self.DragFrame:SetPoint('RIGHT', self.TabMiddle, 15, 0)
        self.DragFrame:RegisterForDrag('LeftButton')
        self.DragFrame:EnableMouse(true)
        
        self.DragFrame:SetScript('OnDragStart', function() 
            focusAnchor:StartMoving()
        end)

        self.DragFrame:SetScript('OnDragStop', function() 
            focusAnchor:StopMovingOrSizing()
        end)
    end
    
    if (self.IsTargetFrame) then
		self:SetSize(85, 20)

        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs:SetHeight(20)
        self.Debuffs:SetWidth(20 * 3)
        self.Debuffs.size = 20
        self.Debuffs.spacing = 4
        self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 5, 0)
        self.Debuffs.initialAnchor = 'LEFT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs.num = 4
    end

    if (self.IsPartyFrame) then
		self:SetSize(105, 30)

        self.Debuffs = CreateFrame('Frame', nil, self)
        self.Debuffs:SetFrameStrata('BACKGROUND')
        self.Debuffs:SetHeight(20)
        self.Debuffs:SetWidth(20 * 3)
        self.Debuffs.size = 20
        self.Debuffs.spacing = 4
        self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 5, 1)
        self.Debuffs.initialAnchor = 'LEFT'
        self.Debuffs['growth-y'] = 'DOWN'
        self.Debuffs['growth-x'] = 'RIGHT'
        self.Debuffs.num = 3
    end

        -- mouseover text

    if (config.units[ns.cUnit(unit)].mouseoverText) then
        EnableMouseOver(self)
    end
    
        -- oor and oUF_SpellRange settings
        
    if (unit == 'pet' or self.IsPartyFrame) then
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
        self.Auras.PostCreateIcon = ns.UpdateAuraIcons
        self.Auras.PostUpdateIcon = ns.PostUpdateIcon
        self.Auras.showDebuffType = true
    elseif (self.Buffs) then
        self.Buffs.PostCreateIcon = ns.UpdateAuraIcons
        self.Buffs.PostUpdateIcon = ns.PostUpdateIcon
    elseif (self.Debuffs) then
        self.Debuffs.PostCreateIcon = ns.UpdateAuraIcons
        self.Debuffs.PostUpdateIcon = ns.PostUpdateIcon
        self.Debuffs.showDebuffType = true
    end
    
    self:SetScale(config.units[ns.cUnit(unit)].scale or 1)
            
	return self
end

oUF:RegisterStyle('oUF_Neav', CreateUnitLayout)
oUF:Factory(function(self)
    local player = self:Spawn('player', 'oUF_Neav_Player')
    player:SetPoint(unpack(config.units.player.position))

    local pet = self:Spawn('pet', 'oUF_Neav_Pet')
    pet:SetPoint('TOPLEFT', player, 'BOTTOMLEFT', unpack(config.units.pet.position))

    local target = self:Spawn('target', 'oUF_Neav_Target')
    target:SetPoint(unpack(config.units.target.position))

    local targettarget = self:Spawn('targettarget', 'oUF_Neav_TargetTarget')
    targettarget:SetPoint('TOPLEFT', target, 'BOTTOMRIGHT', -78, -15)

    local focus = self:Spawn('focus', 'oUF_Neav_Focus')
    focus:SetPoint('CENTER', focusAnchor, 3, 0)
    focus:SetClampedToScreen(true)

    local focustarget = self:Spawn('focustarget', 'oUF_Neav_FocusTarget')
    focustarget:SetPoint('TOPLEFT', focus, 'BOTTOMRIGHT', -78, -15)

	if (config.units.party.show) then
		local party = oUF:SpawnHeader('oUF_Neav_Party', nil, (config.units.party.hideInRaid and 'party') or 'party,raid',
			'oUF-initialConfigFunction', [[
				self:SetWidth(105)
				self:SetHeight(30)
			]],
			'showParty', true,
			'yOffset', -30
		)
        party:SetPoint(unpack(config.units.party.position))
    end
end)