--[[

    !Disable raidframes if Grid or Aptechka are anabled
    
	return

	Supported Units:
        Party
        Raid

	Supported Plugins:
		oUF_AuraWatch
		oUF_Smooth

	Features:
		Threat highlighting
        DebuffIcons
        Leader-, MasterLooter- and Raidicons
        Raidicons
        Heal prediction
        Ready check
        Target hightlight
        Mouseover highlight (a decent dark overlay)
        Optional manabars
        
--]]

if (IsAddOnLoaded('Aptechka') or IsAddOnLoaded('Grid') or not oUF_Neav.units.raid.show) then
	return
end

    -- kill the Blizzard party/raid frames
    
for _, frame in pairs({
	CompactPartyFrame,
	CompactRaidFrameManager,
	CompactRaidFrameContainer,
}) do
	frame:UnregisterAllEvents()
    
    hooksecurefunc(frame, 'Show', function(self)
        self:Hide()
    end)
end

for _, button in pairs({
	'OptionsButton',
	'LockedModeToggle',
	'HiddenModeToggle',
}) do
    _G['CompactRaidFrameManagerDisplayFrame'..button]:Hide()
    _G['CompactRaidFrameManagerDisplayFrame'..button]:Disable()
    _G['CompactRaidFrameManagerDisplayFrame'..button]:EnableMouse(false)
end

for _, button in pairs({
    'UnitFramePanelRaidStylePartyFrames',
    'FrameCategoriesButton11',
}) do
    _G['InterfaceOptions'..button]:SetAlpha(0.35)
    _G['InterfaceOptions'..button]:Disable()
    _G['InterfaceOptions'..button]:EnableMouse(false)
end

local playerClass = select(2, UnitClass('player'))
local isHealer = (playerClass == 'DRUID' or playerClass == 'PALADIN' or playerClass == 'PRIEST' or playerClass == 'SHAMAN')
   
    -- oUF_AuraWatch
    -- Class buffs { spell ID, position [, {r, g, b, a}][, anyUnit][, hideCooldown][, hideCount] }
    
local indicatorList
do
	indicatorList = {
		DRUID = {
			{774, 'BOTTOMRIGHT', {1, 0.2, 1}}, -- Rejuvenation
			{33763, 'BOTTOM', {0.5, 1, 0.5}, false, false, true}, -- Lifebloom
			{48438, 'BOTTOMLEFT', {0.7, 1, 0}}, -- Wild Growth
		},
		MAGE = {
			{54648, 'BOTTOMRIGHT', {0.7, 0, 1}, true, true}, -- Focus Magic
		},
		PALADIN = {
			{53563, 'BOTTOMRIGHT', {0, 1, 0}}, -- Beacon of Light
		},
		PRIEST = {
			{6788, 'BOTTOMRIGHT', {0.6, 0, 0}, true}, -- Weakened Soul
			{17, 'BOTTOMRIGHT', {1, 1, 0}, true}, -- Power Word: Shield
			{33076, 'TOPRIGHT', {1, 0.6, 0.6}, true, true}, -- Prayer of Mending
			{139, 'BOTTOMLEFT', {0, 1, 0}}, -- Renew
		},
		SHAMAN = {
			{61295, 'TOPLEFT', {0.7, 0.3, 0.7}}, -- Riptide
			{51945, 'TOPRIGHT', {0.2, 0.7, 0.2}}, -- Earthliving
			{16177, 'BOTTOMLEFT', {0.4, 0.7, 0.2}}, -- Ancestral Fortitude
			{974, 'BOTTOMRIGHT', {0.7, 0.4, 0}, false, true}, -- Earth Shield
		},
		WARLOCK = {
			{20707, 'BOTTOMRIGHT', {0.7, 0, 1}, true, true}, -- Soulstone
			{85767, 'BOTTOMLEFT', {0.7, 0.5, 1}, true, true, true}, -- Dark Intent
		},
		ALL = {
            {23333, 'LEFT', {1, 0, 0}}, -- Warsong flag, Horde
            {23335, 'LEFT', {0, 0, 1}}, -- Warsong flag, Alliance 
		},
	}
end

local function GetSpellName(spellID)
    local name = GetSpellInfo(spellID)
    return name
end

local function auraIcon(self, icon)
	if (icon.cd) then
		icon.cd:SetReverse()
		icon.cd:SetAllPoints(icon.icon)
	end
end

local function CreateIndicators(self, unit)
    self.AuraWatch = CreateFrame('Frame', nil, self)
    self.AuraWatch.presentAlpha = 1
    self.AuraWatch.missingAlpha = 0
    self.AuraWatch.hideCooldown = false
    self.AuraWatch.noCooldownCount = true
    self.AuraWatch.icons = {}
	self.AuraWatch.PostCreateIcon = auraIcon

	local buffs = {}

	if (indicatorList['ALL']) then
		for key, value in pairs(indicatorList['ALL']) do
			tinsert(buffs, value)
		end
	end
	
	if (indicatorList[playerClass]) then
		for key, value in pairs(indicatorList[playerClass]) do
			tinsert(buffs, value)
		end
	end

	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame('Frame', nil, self.AuraWatch)
            icon:SetFrameStrata('HIGH')
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon.hideCooldown = spell[5]
			icon.hideCount = spell[6]
			icon:SetWidth(oUF_Neav.units.raid.indicatorSize)
			icon:SetHeight(oUF_Neav.units.raid.indicatorSize)
            
            local iconPad = 2 -- the distance for all indicators to the border
            local iconOffsets = {
				TOPLEFT = {iconPad, -iconPad},
				TOPRIGHT = {-iconPad, -iconPad},
				BOTTOMLEFT = {iconPad, iconPad},
				BOTTOMRIGHT = {-iconPad, iconPad},
				LEFT = {iconPad, 0},
				RIGHT = {-iconPad, 0},
				TOP = {0, -iconPad},
				BOTTOM = {0, iconPad},
			}
            
			icon:SetPoint(spell[2], self.Health, unpack(iconOffsets[spell[2]]))

                -- Exception to place PW:S above Weakened Soul
                
			if (spell[1] == 17) then
				icon:SetFrameLevel(icon:GetFrameLevel() + 5)
			end

			icon.icon = icon:CreateTexture(nil, 'OVERLAY')
			icon.icon:SetAllPoints(icon)
			icon.icon:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderIndicator')

			if (spell[3]) then
				icon.icon:SetVertexColor(unpack(spell[3]))
			else
				icon.icon:SetVertexColor(0.8, 0.8, 0.8)
			end
			
			local countOffsets = {
				TOPLEFT = {'TOP', icon, 'BOTTOM', 0, 0},
				TOPRIGHT = {'TOP', icon, 'BOTTOM', 0, 0},
				BOTTOMLEFT = {'LEFT', icon, 'RIGHT', 1, 0},
				BOTTOMRIGHT = {'RIGHT', icon, 'LEFT', -1, 0},
				LEFT = {'LEFT', icon, 'RIGHT', 1, 0},
				RIGHT = {'RIGHT', icon, 'LEFT', -1, 0},
				TOP = {'CENTER', icon, 0, 0},
				BOTTOM = {'CENTER', icon, 0, 0},
			}

			if (not icon.hideCount) then
				icon.count = icon:CreateFontString(nil, 'OVERLAY')
				icon.count:SetShadowColor(0, 0, 0)
				icon.count:SetShadowOffset(1, -1)
                icon.count:SetPoint(unpack(countOffsets[spell[2]]))
                icon.count:SetFont('Interface\\AddOns\\oUF_Neav\\media\\fontVisitor.ttf', 13)
			end

			self.AuraWatch.icons[spell[1]] = icon
		end
	end
end

local dispellPriority = {
    ['None'] = 0,
    ['Magic'] = 1,
    ['Curse'] = 3,
    ['Disease'] = 2,
    ['Poison'] = 4,
}

local dispellFilter = {
    ['PRIEST'] = {
        ['Magic'] = true,
        ['Disease'] = true,
    },
    ['SHAMAN'] = {
        ['Poison'] = true,
        ['Disease'] = true,
        ['Curse'] = true,
    },
    ['PALADIN'] = {
        ['Poison'] = true,
		['Magic'] = true,
        ['Disease'] = true,
    },
    ['MAGE'] = {
        ['Curse'] = true,
    },
    ['DRUID'] = {
        ['Curse'] = true,
        ['Poison'] = true,
		['Magic'] = true,
    },
    ['DEATHKNIGHT'] = {},
    ['HUNTER'] = {},
    ['ROGUE'] = {},
    ['WARLOCK'] = {},
    ['WARRIOR'] = {},
}

local dispellClass = {}
if (dispellFilter[playerClass]) then
    for k, v in pairs(dispellFilter[playerClass]) do
        dispellClass[k] = v
    end
    dispellFilter = nil
end

local debuffList = setmetatable({
	-- PvP
    [GetSpellName(5782)] = 3, -- Fear
    [GetSpellName(30108)] = 2, -- Unstable Affliction
	
	-- PvE
    
	-- Naxxramas
	[GetSpellName(27808)] = 9, -- Frost Blast, Kel'Thuzad
	
	-- Ulduar
	[GetSpellName(62717)] = 9, -- Slag Pot, Ignis
    
	-- ToC
    [GetSpellName(66869)] = 8, -- Burning Bile
    [GetSpellName(66823)] = 10, -- Paralizing Toxin
	[GetSpellName(67049)] = 9, -- Incinerate Flesh
    
	-- ICC
    [GetSpellName(69057)] = 9, -- Bone Spike Graveyard
    [GetSpellName(72448)] = 9, -- Rune of Blood
    [GetSpellName(72293)] = 10, -- Mark of the Fallen Champion, Deathbringer Saurfang
	
    [GetSpellName(71224)] = 9, -- Mutated Infection, Rotface
    [GetSpellName(72272)] = 9, -- Vile Gas, Festergut
    [GetSpellName(69279)] = 8, -- Gas Spore, Festergut
	
	[GetSpellName(70126)] = 9, -- Frost Beacon, Sindragosa
	
	[GetSpellName(70337)] = 9, -- Necrotic Plague, Lich King
	[GetSpellName(70541)] = 6, -- Infest, Lich King
	[GetSpellName(72754)] = 8, -- Defile, Lich King
	[GetSpellName(68980)] = 10, -- Harvest Soul, Lich King

	-- Suby Sanctum
	[GetSpellName(74562)] = 8, -- Fiery Combustion, Halion
	[GetSpellName(74792)] = 8, -- Soul Consumption, Halion

	-- Blackwing Descent
	[GetSpellName(91911)] = 8, -- Constricting Chains, Magmaw
	[GetSpellName(94617)] = 10, -- Mangle, Magmaw
	[GetSpellName(79505)] = 8, -- Aquiring target/flamethrower, Omnotron Defense System
	[GetSpellName(77699)] = 8, -- Flash Freeze, Maloriak
	[GetSpellName(89084)] = 8, -- Low Health, Chimaeron
	[GetSpellName(92956)] = 8, -- Wrack, Sinestra

	-- The Bastion of Twilight
	[GetSpellName(81836)] = 8, -- Corruption: Accelerated, Cho'gall

	-- Throne of the Four Winds

},{ __index = function() 
    return 0 
end})

    -- ----------------------------------------------------------------
    -- Copyright (c) 2009, Chris Bannister (oUF_Grid - zariel)
    -- All rights reserved.
    -- Start
    -- ----------------------------------------------------------------
    
local function UpdateAura(self, event, unit)
	if (self.unit ~= unit) then 
        return
    end
    
    local cur, tex, dis, co
    local debuffs = debuffList
    
	for i = 1, 40 do
		local name, _, buffTexture, count, dtype = UnitAura(unit, i, 'HARMFUL')
		if (not name) then 
            break 
        end

		if (not cur or (debuffs[name] >= debuffs[cur])) then
			if (debuffs[name] > 0 and debuffs[name] > debuffs[cur or 1]) then
				cur = name
				tex = buffTexture
				dis = dtype or 'none'
                co = count
			elseif (dtype and dtype ~= 'none') then
				if (not dis or (dispellPriority[dtype] > dispellPriority[dis])) then
					tex = buffTexture
					dis = dtype
                    co = count
				end
			end	
		end
	end

	if (dis) then
		if (dispellClass[dis] or cur) then
            self.Icon:Show()
            self.Icon.Icon:SetTexture(tex)
            self.Icon.Count:SetText(co > 0 and co or '')
            
            local col = DebuffTypeColor[dis]
            self.Icon.Border:SetVertexColor(col.r, col.g, col.b)

            -- self.Health.Value:Hide()
            self.Name:Hide()

            self.Dispell = true
		elseif (self.Dispell) then
            self.Icon:Hide()

            -- self.Health.Value:Show()
            self.Name:Show()

            self.Dispell = false
		end
	else
        self.Icon:Hide()

       --  self.Health.Value:Show()
        self.Name:Show()
	end
end

    -- ----------------------------------------------------------------
    -- Copyright (c) 2009, Chris Bannister (oUF_Grid - zariel)
    -- All rights reserved.
    -- End
    -- ----------------------------------------------------------------

local function UpdateThreat(self, _, unit)
	if (self.unit ~= unit) then
        return
    end

    local threatStatus = UnitThreatSituation(self.unit)
    if (threatStatus == 3) then

        self.Background:SetVertexColor(0.75, 0, 0)
        -- self.Name:SetTextColor(1, 0, 0)
        -- self.Shadow:SetVertexColor(1, 0, 0, 1)
        
        if (self.ThreatText) then
            self.ThreatText:SetText('|cFFFF0000THREAT')
        end
    else
        self.Background:SetVertexColor(0, 0, 0)
        -- self.Name:SetTextColor(1, 1, 1)
        -- self.Shadow:SetVertexColor(0, 0, 0, 0)
        
        if (self.ThreatText) then
            self.ThreatText:SetText('')
        end
    end
end

local function UpdateHealth(Health, unit)
	if (Health:GetParent().unit ~= unit) then
        return
    end
    
    if (UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
        if (color) then
            Health:SetStatusBarColor(color.r, color.g, color.b)
            Health.Background:SetVertexColor(color.r*0.25, color.g*0.25, color.b*0.25)
        end
    end
end

local function UpdateRessurectStatus(self)
	if (UnitHasIncomingResurrection(self.unit)) then
		self.RessurectText:Show()
	else
		self.RessurectText:Hide()
	end
end

local function UpdateTargetBorder(self)
	if (UnitIsUnit('target', self.unit)) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

local function UpdateHealPredictionSize(self)
    if (self.HealPrediction) then
        self.HealPrediction.myBar:SetWidth(self.Health:GetWidth())
        self.HealPrediction.myBar:SetHeight(self.Health:GetHeight())
        
        self.HealPrediction.otherBar:SetWidth(self.Health:GetWidth())
        self.HealPrediction.otherBar:SetHeight(self.Health:GetHeight())
    end
end

local function UpdatePower(self, _, unit)
	if (self.unit ~= unit) then
        return 
    end
    
    local powerType, powerToken = UnitPowerType(unit)
    local unitPower = PowerBarColor[powerToken]
    
    self.Health:ClearAllPoints()
    
	if (powerToken == 'MANA') then
        if (unitPower) then
            self.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
            self.Power.Background:SetVertexColor(unitPower.r*0.3, unitPower.g*0.3, unitPower.b*0.3)
        end
        
        if (oUF_Neav.units.raid.manabar.horizontalOrientation) then
            self.Health:SetPoint('BOTTOMLEFT', self, 0, 3)
            self.Health:SetPoint('TOPRIGHT', self)
        else
            self.Health:SetPoint('BOTTOMLEFT', self)
            self.Health:SetPoint('TOPRIGHT', self, -3.5, 0)
        end
        
        self.Power:Show()
	else
        self.Health:SetAllPoints(self)
		self.Power:Hide()
	end
    
    UpdateHealPredictionSize(self)
end

local function CreateRaidLayout(self, unit)
    self:SetScript('OnEnter', function(self)
		UnitFrame_OnEnter(self)
    	self.Health.Mouseover:SetAlpha(0.175)
	end)
    
    self:SetScript('OnLeave', function(self)
		UnitFrame_OnLeave(self)
    	self.Health.Mouseover:SetAlpha(0)
	end)

        -- health bar

    self.Health = CreateFrame('StatusBar', nil, self)
    self.Health:SetStatusBarTexture(oUF_Neav.media.statusbar, 'ARTWORK')
    self.Health:SetFrameStrata('LOW')
    self.Health:SetAllPoints(self)
    self.Health:SetFrameLevel(1)
    self.Health:SetOrientation(oUF_Neav.units.raid.horizontalHealthBars and 'HORIZONTAL' or 'VERTICAL')

    self.Health.PostUpdate = UpdateHealth
	self.Health.frequentUpdates = true
    self.Health.colorClass = true

	if (not isHealer or oUF_Neav.units.raid.smoothUpdatesForAllClasses) then
		self.Health.Smooth = true
	end

        -- health background

    self.Health.Background = self.Health:CreateTexture(nil, 'BORDER')
    self.Health.Background:SetAllPoints(self.Health)
    self.Health.Background:SetTexture(oUF_Neav.media.statusbar)
    
        -- mouseover darklight
        
    self.Health.Mouseover = self.Health:CreateTexture(nil, 'OVERLAY')
    self.Health.Mouseover:SetAllPoints(self.Health)
    self.Health.Mouseover:SetTexture(oUF_Neav.media.statusbar)
    self.Health.Mouseover:SetVertexColor(0, 0, 0)
    self.Health.Mouseover:SetAlpha(0)

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Health.Value:SetPoint('TOP', self.Health, 'CENTER', 0, 2)
    self.Health.Value:SetFont(oUF_Neav.media.font, 11)
    self.Health.Value:SetShadowOffset(1, -1)
    self:Tag(self.Health.Value, '[health:Raid]')

        -- name text

    self.Name = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Name:SetPoint('BOTTOM', self.Health, 'CENTER', 0, 3)
    self.Name:SetFont(oUF_Neav.media.fontThick, 12)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetTextColor(1, 1, 1)
    self:Tag(self.Name, '[name:Raid]')

        -- power bar
                
	if (oUF_Neav.units.raid.manabar.show) then
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetStatusBarTexture(oUF_Neav.media.statusbar, 'OVERLAY')
		self.Power:SetFrameStrata('MEDIUM')
		self.Power:SetFrameLevel(1)
        
        if (oUF_Neav.units.raid.manabar.horizontalOrientation) then
            self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
            self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
            self.Power:SetOrientation('HORIZONTAL')
            self.Power:SetHeight(2.5)
        else
            self.Power:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 1, 0)
            self.Power:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMRIGHT', 1, 0)
            self.Power:SetOrientation('VERTICAL')
            self.Power:SetWidth(2.5)
        end
        
		self.Power.colorPower = true
		self.Power.Smooth = true
    
		self.Power.Background = self.Power:CreateTexture(nil, 'ARTWORK')
		self.Power.Background:SetAllPoints(self.Power)
		self.Power.Background:SetTexture(1, 1, 1)
        
		UpdatePower(self, _, unit) -- Force an update on init
		
		table.insert(self.__elements, UpdatePower)
		self:RegisterEvent('UNIT_DISPLAYPOWER', UpdatePower)
	end

        -- heal prediction, new healcomm
	
	local myBar = CreateFrame('StatusBar', nil, self.Health)
	myBar:SetStatusBarTexture(oUF_Neav.media.statusbar)
	myBar:SetStatusBarColor(0, 1, 0.5, 0.25)
	if (oUF_Neav.units.raid.horizontalHealthBars) then
		myBar:SetOrientation('HORIZONTAL')
		myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT', 0, 0)
	else
		myBar:SetOrientation('VERTICAL')
		myBar:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
	end
    
	local otherBar = CreateFrame('StatusBar', nil, self.Health)
	otherBar:SetStatusBarTexture(oUF_Neav.media.statusbar)
	otherBar:SetStatusBarColor(0, 1, 0, 0.25)
	if (oUF_Neav.units.raid.horizontalHealthBars) then
		otherBar:SetOrientation('HORIZONTAL')
		otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	else
		otherBar:SetOrientation('VERTICAL')
		otherBar:SetPoint('BOTTOM', myBar:GetStatusBarTexture(), 'TOP', 0, 0)
	end
    
	self.HealPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		maxOverflow = 1,
	}
    
    UpdateHealPredictionSize(self)
    
        -- threat text
    
    if (oUF_Neav.units.raid.showThreatText) then
        self.ThreatText = self.Health:CreateFontString(nil, 'OVERLAY')
        self.ThreatText:SetPoint('CENTER', self, 'TOP')
        self.ThreatText:SetFont(oUF_Neav.media.font, 10, 'THINOUTLINE')
        self.ThreatText:SetShadowColor(0, 0, 0, 0)
        self.ThreatText:SetTextColor(1, 1, 1)
    end
    
    table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
    
        -- background texture
        
    self.Background = self.Health:CreateTexture(nil, 'BACKGROUND')
    self.Background:SetPoint('TOPRIGHT', self, 1.5, 1.5)
    self.Background:SetPoint('BOTTOMLEFT', self, -1.5, -1.5)
    self.Background:SetTexture('Interface\\Buttons\\WHITE8x8', 'LOW')
    self.Background:SetVertexColor(0, 0, 0)

        -- masterlooter icons

    self.MasterLooter = self.Health:CreateTexture('$parentMasterLooterIcon', 'OVERLAY', self)
    self.MasterLooter:SetSize(11, 11)
    self.MasterLooter:SetPoint('RIGHT', self.Health, 'TOPRIGHT', -1, 1)

        -- leader icons

    self.Leader = self.Health:CreateTexture('$parentLeaderIcon', 'OVERLAY', self)
    self.Leader:SetSize(12, 12)
    self.Leader:SetPoint('LEFT', self.Health, 'TOPLEFT', 1, 0)

        -- raid icons

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetSize(18, 18)
    self.RaidIcon:SetPoint('CENTER', self, 'TOP')

        -- readycheck icons

    self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
    self.ReadyCheck:SetPoint('CENTER', self.Health)
    self.ReadyCheck:SetSize(20, 20)
    self.ReadyCheck.delayTime = 4
	self.ReadyCheck.fadeTime = 1

        -- debuff icons

    self.Icon = CreateFrame('Frame')
    self.Icon:SetParent(self)
    self.Icon:SetFrameStrata('MEDIUM')
    
	self.Icon.Icon = self.Icon:CreateTexture(nil, 'ARTWORK', self.Icon)
	self.Icon.Icon:SetPoint('CENTER', self.Health)
	self.Icon.Icon:SetHeight(oUF_Neav.units.raid.iconSize)
	self.Icon.Icon:SetWidth(oUF_Neav.units.raid.iconSize)
	self.Icon.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    self.Icon.Count = self.Icon:CreateFontString(nil, 'OVERLAY', self.Icon)
    self.Icon.Count:SetPoint('BOTTOMRIGHT', self.Icon.Icon, 1, 0)
    self.Icon.Count:SetFont(oUF_Neav.media.font, 14, 'OUTLINE')
    self.Icon.Count:SetShadowColor(0, 0, 0, 0)
    self.Icon.Count:SetTextColor(1, 1, 1)

	self.Icon.Border = self.Icon:CreateTexture(nil, 'BORDER', self.Icon)
	self.Icon.Border:SetPoint('CENTER', self.Health)
	self.Icon.Border:SetHeight(oUF_Neav.units.raid.iconSize + 7)
	self.Icon.Border:SetWidth(oUF_Neav.units.raid.iconSize + 7)
	self.Icon.Border:SetTexture('Interface\\Addons\\oUF_Neav\\media\\borderIcon')
	self.Icon.Border:SetVertexColor(1, 1, 1)
            
    table.insert(self.__elements, UpdateAura)
    self:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateAura)
    self:RegisterEvent('UNIT_AURA', UpdateAura)
    self:RegisterEvent('UNIT_DEAD', UpdateAura)

        -- create indicators
        
	CreateIndicators(self, unit)
    
        -- role indicator

    -- self.LFDRole = self.Health:CreateTexture('$parentRoleIcon', 'OVERLAY')
    -- self.LFDRole:SetSize(12, 12)
    -- self.LFDRole:SetPoint('TOPLEFT', self.Health, -5, -5)
   
    if (oUF_Neav.units.raid.showRolePrefix) then
        self.LFDRoleText = self.Health:CreateFontString(nil, 'ARTWORK')
        self.LFDRoleText:SetPoint('TOPLEFT', self.Health, 0, 4)
        self.LFDRoleText:SetFont(oUF_Neav.media.font, 15)
        self.LFDRoleText:SetShadowOffset(0.5, -0.5)
        self.LFDRoleText:SetTextColor(1, 0, 1)
        self:Tag(self.LFDRoleText, '[role:Raid]')
    end
    
        -- ressurection text
    --[[
    if (oUF_Neav.units.raid.showRessurectText) then
        self.RessurectText = self.Health:CreateFontString(nil, 'OVERLAY')
        self.RessurectText:SetPoint('CENTER', self, 'TOP')
        self.RessurectText:SetFont(oUF_Neav.media.font, 10, 'THINOUTLINE')
        self.RessurectText:SetShadowColor(0, 0, 0, 0)
        self.RessurectText:SetTextColor(0.1, 1, 0.1)
        
        self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateRessurectStatus)
    end
    --]]
    
        -- playertarget border

    if (oUF_Neav.units.raid.showTargetBorder) then
        self.TargetBorder = self.Health:CreateTexture(nil, 'BACKGROUND', self)
        self.TargetBorder:SetPoint('TOPRIGHT', self, 3, 3)
        self.TargetBorder:SetPoint('BOTTOMLEFT', self, -3, -3)
        self.TargetBorder:SetTexture('Interface\\Addons\\oUF_Neav\\media\\borderTarget')
        self.TargetBorder:SetVertexColor(unpack(oUF_Neav.units.raid.targetBorderColor))
        self.TargetBorder:Hide()

        self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateTargetBorder)
    end

        -- range check

	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.3,
	}

    self.SpellRange = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }

    return self
end

oUF:RegisterStyle('oUF_Neav_Raid', CreateRaidLayout)
oUF:Factory(function(self)
	self:SetActiveStyle('oUF_Neav_Raid')

    local raid = {}
    for i = 1, oUF_Neav.units.raid.numGroups do
        table.insert(raid, self:SpawnHeader('oUF_Neav_Raid'..i, nil, 'solo,party,raid',
			'oUF-initialConfigFunction', ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(oUF_Neav.units.raid.width, oUF_Neav.units.raid.height),
            'showRaid', true,
            'showParty', true,
            'showPlayer', true,
            'showSolo', (oUF_Neav.units.raid.showSolo and true) or false,
            'columnSpacing', oUF_Neav.units.raid.frameSpacing,
            'unitsPerColumn', 1,
            'maxColumns', 5,
            'columnAnchorPoint', 'TOP',
            'groupFilter', i
            )
        )

        if (i == 1) then
            raid[i]:SetPoint(unpack(oUF_Neav.units.raid.layout.position))
        else
            if (oUF_Neav.units.raid.layout.orientationHorizontal == 'RIGHT') then
                raid[i]:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', oUF_Neav.units.raid.frameSpacing, 0)
            elseif (oUF_Neav.units.raid.layout.orientationHorizontal == 'LEFT') then
                raid[i]:SetPoint('TOPRIGHT', raid[i-1], 'TOPLEFT', -oUF_Neav.units.raid.frameSpacing, 0)
            end
        end

		raid[i]:SetScale(oUF_Neav.units.raid.scale)
    end
end)
