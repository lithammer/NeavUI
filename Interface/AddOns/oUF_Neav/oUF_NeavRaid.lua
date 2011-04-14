--[[

	Supported Units:
        Party
        Raid

	Supported Plugins:
		oUF_AuraWatch
		oUF_Smooth

	Features:
		Aggro highlighting
        DebuffIcons
        Leader-, MasterLooter- and Raidicons
        
--]]

if IsAddOnLoaded('Aptechka') or IsAddOnLoaded('Grid') then
	return
end

    -- Kill the Blizzard party/raid frames
    
for _, frame in pairs({
	CompactPartyFrame,
	-- CompactRaidFrameManager, -- Actually usefull for world markers
	CompactRaidFrameContainer,
}) do
	frame:UnregisterAllEvents()
	frame.Show = function() end
	frame:Hide()
end

for _, button in pairs({
	'OptionsButton',

    'FilterRoleTank',
    'FilterRoleHealer',
    'FilterRoleDamager',
	
	'FilterGroup1',
	'FilterGroup2',
	'FilterGroup3',
	'FilterGroup4',
	'FilterGroup5',
	'FilterGroup6',
	'FilterGroup7',
	'FilterGroup8',
	
	'LockedModeToggle',
	'HiddenModeToggle',
}) do
    --_G['CompactRaidFrameManagerDisplayFrame'..button]:SetAlpha(0.35)
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

local function GetSpellName(spellID)
    local name = GetSpellInfo(spellID)
    return name
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
			{23333, 'LEFT', {1, 0, 0}}, -- Warsong flag
		},
	}
end

function auraIcon(self, icon)
	if (icon.cd) then
		icon.cd:SetReverse()
		icon.cd:SetAllPoints(icon.icon)
		icon.cd:SetPoint('TOPLEFT', 2, -2)
		icon.cd:SetPoint('BOTTOMRIGHT', -2, 2)
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
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon.hideCooldown = spell[5]
			icon.hideCount = spell[6]
			icon:SetWidth(oUF_Neav.units.raid.indicatorSize)
			icon:SetHeight(oUF_Neav.units.raid.indicatorSize)
			icon:SetPoint(spell[2], self)

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

            local col = DebuffTypeColor[dis]
            self.Icon.Border:SetVertexColor(col.r, col.g, col.b)

            self.Icon.Count:SetText(co > 0 and co or '')

            self.Health.Value:Hide()
            self.Name:Hide()

            self.Dispell = true
		elseif (self.Dispell) then
            self.Icon:Hide()

            self.Health.Value:Show()
            self.Name:Show()

            self.Dispell = false
		end
	else
        self.Icon:Hide()

        self.Health.Value:Show()
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

    if (self.Aggro) then
        local threat = UnitThreatSituation(self.unit)
        if (threat == 3) then
            -- self.Aggro:SetText('|cFFFF0000AGGRO')
            self.Health:SetBackdropColor(0.9, 0, 0)
			if oUF_Neav.units.raid.manabar then
				self.Power:SetBackdropColor(0.9, 0, 0)
			end
        else
            -- self.Aggro:SetText('')
            self.Health:SetBackdropColor(0, 0, 0)
			if oUF_Neav.units.raid.manabar then
				self.Power:SetBackdropColor(0, 0, 0)
			end
        end
    end
end

local function UpdateHealth(Health, unit, min, max)
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

local function UpdateTargetBorder(self)
	if (UnitIsUnit('target', self.unit)) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

local function OnPowerTypeChange(self, _, unit)
	if (self.unit ~= unit) then
        return 
    end

	local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
	local unitPower = PowerBarColor[powerToken]
	
	if (unitPower) then
		self.Power.Background:SetVertexColor(unitPower.r * 0.25, unitPower.g * 0.25, unitPower.b * 0.25)
	end

	-- TODO: Really need to improve how this ugly solution
	self.Health:ClearAllPoints()
	if (powerToken == 'MANA') then
		if (oUF_Neav.units.raid.horizontalHealthBars) then
			self.Health:SetPoint('TOPLEFT', self)
			self.Health:SetPoint('BOTTOMRIGHT', self.Power, 'TOPRIGHT', 0, 0)
			self.HealPrediction.myBar:SetHeight(oUF_Neav.units.raid.height - 3.5)
			self.HealPrediction.otherBar:SetHeight(oUF_Neav.units.raid.height - 3.5)
		else
			self.Health:SetPoint('TOPLEFT', self)
			self.Health:SetPoint('BOTTOMRIGHT', self.Power, 'BOTTOMLEFT', 0, 0)
			self.HealPrediction.myBar:SetWidth(oUF_Neav.units.raid.width - 3.5)
			self.HealPrediction.otherBar:SetWidth(oUF_Neav.units.raid.width - 3.5)
		end
		self.Power:Show()
	else
		self.Health:SetAllPoints(self)
		if (oUF_Neav.units.raid.horizontalHealthBars) then
			self.HealPrediction.myBar:SetHeight(oUF_Neav.units.raid.height)
			self.HealPrediction.otherBar:SetHeight(oUF_Neav.units.raid.height)
		else
			self.HealPrediction.myBar:SetWidth(oUF_Neav.units.raid.width)
			self.HealPrediction.otherBar:SetWidth(oUF_Neav.units.raid.width)
		end
		self.Power:Hide()
	end
	
end

local function CreateRaidLayout(self, unit)
    self:SetScript('OnEnter', function(self)
		UnitFrame_OnEnter(self)
    	self.Health.Mouseover:SetAlpha(0.15)
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
	if oUF_Neav.units.raid.horizontalHealthBars then
		self.Health:SetOrientation('HORIZONTAL')
	else
		self.Health:SetOrientation('VERTICAL')
	end
    self.Health:SetBackdrop{
        bgFile = 'Interface\\Buttons\\WHITE8x8', 
        insets = {
            left = -1.5, 
            right = -1.5, 
            top = -1.5, 
            bottom = -1.5
        },
    }
    self.Health:SetBackdropColor(0, 0, 0)
	self.Health.colorClass = true
	
	self.Health.frequentUpdates = true

	if (not isHealer) then
		self.Health.Smooth = true
	end
	
	self.Health.PostUpdate = UpdateHealth

        -- health background

    self.Health.Background = self.Health:CreateTexture(nil, 'BORDER')
    self.Health.Background:SetAllPoints(self.Health)
    self.Health.Background:SetTexture(oUF_Neav.media.statusbar)

    self.Health.Mouseover = self.Health:CreateTexture(nil, 'OVERLAY')
    self.Health.Mouseover:SetAllPoints(self.Health)
    self.Health.Mouseover:SetTexture(oUF_Neav.media.statusbar)
    self.Health.Mouseover:SetVertexColor(0, 0, 0)
    self.Health.Mouseover:SetAlpha(0)

        -- health text

    self.Health.Value = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Health.Value:SetPoint('BOTTOM', 0, 5)
    self.Health.Value:SetFont(oUF_Neav.media.font, 13)
    self.Health.Value:SetShadowOffset(1, -1)
    self:Tag(self.Health.Value, '[health:Raid]')
	
		-- power bar

	if oUF_Neav.units.raid.manabar then
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetStatusBarTexture(oUF_Neav.media.statusbar, 'ARTWORK')
		self.Power:SetFrameStrata('LOW')
		
		if (oUF_Neav.units.raid.horizontalHealthBars) then
			self.Power:SetPoint('BOTTOM', self, 0, 0)
			self.Power:SetWidth(self:GetWidth())
			self.Power:SetHeight(3.5)
			self.Power:SetOrientation('HORIZONTAL')
		else
			self.Power:SetPoint('RIGHT', self, 0, 0)
			self.Power:SetWidth(3.5)
			self.Power:SetHeight(self:GetHeight())
			self.Power:SetOrientation('VERTICAL')
		end
		
		self.Power:SetFrameLevel(1)
		self.Power:SetBackdrop{
			bgFile = 'Interface\\Buttons\\WHITE8x8',
			insets = {
				left = -1.5,
				right = -1.5,
				top = -1.5,
				bottom = -1.5
			},
		}
		self.Power:SetBackdropColor(0, 0, 0)
		self.Power.colorPower = true
		self.Power.Smooth = true

		self.Power.Background = self.Power:CreateTexture(nil, 'BORDER')
		self.Power.Background:SetAllPoints(self.Power)
		self.Power.Background:SetTexture(oUF_Neav.media.statusbar)
		OnPowerTypeChange(self, _, unit) -- Force an update on init
		
		table.insert(self.__elements, OnPowerTypeChange)
		self:RegisterEvent('UNIT_DISPLAYPOWER', OnPowerTypeChange)
	end

        -- name text

    self.Name = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Name:SetPoint('TOP', 0, -6)
    self.Name:SetFont(oUF_Neav.media.fontThick, 13)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetTextColor(1, 1, 1)
    self:Tag(self.Name, '[name:Raid]')

        -- heal prediction, new healcomm
	
	local mhpb = CreateFrame('StatusBar', nil, self.Health)
	if (oUF_Neav.units.raid.horizontalHealthBars) then
		mhpb:SetOrientation('HORIZONTAL')
		mhpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT', 0, 0)
	else
		mhpb:SetOrientation('VERTICAL')
		mhpb:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
	end
	mhpb:SetStatusBarTexture(oUF_Neav.media.statusbar)
	mhpb:SetWidth(oUF_Neav.units.raid.width)
	mhpb:SetHeight(oUF_Neav.units.raid.height)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.15)

	local ohpb = CreateFrame('StatusBar', nil, self.Health)
	if (oUF_Neav.units.raid.horizontalHealthBars) then
		ohpb:SetOrientation('HORIZONTAL')
		ohpb:SetPoint('LEFT', mhpb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	else
		ohpb:SetOrientation('VERTICAL')
		ohpb:SetPoint('BOTTOM', mhpb:GetStatusBarTexture(), 'TOP', 0, 0)
	end
	ohpb:SetStatusBarTexture(oUF_Neav.media.statusbar)
	ohpb:SetWidth(oUF_Neav.units.raid.width)
	ohpb:SetHeight(oUF_Neav.units.raid.height)
	ohpb:SetStatusBarColor(0, 1, 0, 0.15)

	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
	}
	
        -- aggro text

    self.Aggro = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Aggro:SetPoint('CENTER', self, 'TOP')
    self.Aggro:SetFont(oUF_Neav.media.font, 9, 'THINOUTLINE')
    self.Aggro:SetShadowColor(0, 0, 0, 0)
    self.Aggro:SetTextColor(1, 1, 1)

    table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)

        -- masterlooter icons

    self.MasterLooter = self.Health:CreateTexture('$parentMasterLooterIcon', 'OVERLAY', self)
    self.MasterLooter:SetHeight(11)
    self.MasterLooter:SetWidth(11)
    self.MasterLooter:SetPoint('RIGHT', self.Health, 'TOPRIGHT', -1, 1)

        -- leader icons

    self.Leader = self.Health:CreateTexture('$parentLeaderIcon', 'OVERLAY', self)
    self.Leader:SetHeight(12)
    self.Leader:SetWidth(12)
    self.Leader:SetPoint('LEFT', self.Health, 'TOPLEFT', 1, 0)

        -- raid icons

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetHeight(18)
    self.RaidIcon:SetWidth(18)
    self.RaidIcon:SetPoint('CENTER', self, 'TOP')
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')

        -- readycheck icons

    self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
    self.ReadyCheck:SetPoint('TOPRIGHT', self.Health, -7, -7)
    self.ReadyCheck:SetPoint('BOTTOMLEFT', self.Health, 7, 7)
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
    self:RegisterEvent('UNIT_AURA', UpdateAura)
    self:RegisterEvent('UNIT_DEAD', UpdateAura)

        -- create indicators
	CreateIndicators(self, unit)

        -- playertarget border

    if (oUF_Neav.units.raid.showTargetBorder) then
        self.TargetBorder = self.Health:CreateTexture(nil, 'BORDER', self)
        self.TargetBorder:SetPoint('TOPRIGHT', self, 7, 7)
        self.TargetBorder:SetPoint('BOTTOMLEFT', self, -7, -7)
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
            'showParty', true,
            'showPlayer', true,
            'showSolo', (oUF_Neav.units.raid.showSolo and true) or false,
            'showRaid', true,
            'columnSpacing', 7,
            'unitsPerColumn', 1,
            'maxColumns', 5,
            'columnAnchorPoint', 'TOP',
            'groupFilter', i
            )
        )

        if (i == 1) then
            raid[i]:SetPoint(unpack(oUF_Neav.units.raid.position))
        else
            raid[i]:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', 7, 0)
        end

		raid[i]:SetScale(oUF_Neav.units.raid.scale)
    end
end)