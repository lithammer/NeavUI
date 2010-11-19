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

local function GetSpellName(spellID)
    local name = GetSpellInfo(spellID)
    return name
end

local playerClass = select(2, UnitClass('player'))
local isHealer = (playerClass == 'DRUID' or playerClass == 'PALADIN' or playerClass == 'PRIEST' or playerClass == 'SHAMAN')

local indicatorList = {}
if playerClass == 'DRUID' then
	indicatorList = {
		774, -- rejuvenation #1
		33763, -- lifebloom #2
		48438, -- wild growth #3
	}
elseif playerClass == 'MAGE' then
	indicatorList = {
		54648, -- focus magic #1
	}
elseif playerClass == 'PALADIN' then
	indicatorList = {
		53563, -- beacon of light #1
	}
elseif playerClass == 'PRIEST' then
	indicatorList = {
		6788, -- weakened soul #1
		17, -- power word: shield #2
		139, -- renew #3
		33076, -- prayer of mending #4
	}
elseif playerClass == 'SHAMAN' then
	indicatorList = {
		974, -- earth shield #1
		61295, -- riptide #1
	}
elseif playerClass == 'WARLOCK' then
	indicatorList = {
		20707, -- soulstone #1
		85767, -- dark intent #2
	}
end

function auraIcon(self, icon)
	icon.icon:SetPoint("TOPLEFT", -1, 1)
	icon.icon:SetPoint("BOTTOMRIGHT", 1, -1)
	icon.icon:SetTexCoord(.08, .92, .08, .92)
	icon.icon:SetDrawLayer("ARTWORK")
	
	if (icon.cd) then
		icon.cd:SetReverse()
	end
	
	--icon.overlay:SetTexture()
end

local function CreateIndicators(self, unit)
    self.AuraWatch = CreateFrame('Frame', nil, self)
    self.AuraWatch.presentAlpha = 1
    self.AuraWatch.missingAlpha = 0
    self.AuraWatch.hideCooldown = false
    self.AuraWatch.noCooldownCount = true
    self.AuraWatch.icons = {}
	self.AuraWatch.PostCreateIcon = auraIcon

    for i, id in pairs(indicatorList) do
        icon = CreateFrame('Frame', nil, self.AuraWatch)
        icon.spellID = id
		icon.anyUnit = false

        icon:SetWidth(oUF_Neav.units.raid.indicatorSize)
        icon:SetHeight(oUF_Neav.units.raid.indicatorSize)

        icon.icon = icon:CreateTexture(nil, 'OVERLAY')
        icon.icon:SetAllPoints(icon)
        icon.icon:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderIndicator')
		
		if playerClass == 'DRUID' then
			if i == 1 then -- rejuvenation
				icon:SetPoint('BOTTOMRIGHT', self)
				icon.icon:SetVertexColor(1, 0.2, 1)
			elseif i == 2 then -- lifebloom
				icon:SetPoint('TOP', self)
				icon.icon:SetVertexColor(0.5, 1, 0.5)

				local count = icon:CreateFontString(nil, 'OVERLAY')
				count:SetFont(NumberFontNormal:GetFont(), 10)
				count:SetShadowColor(0, 0, 0)
				count:SetShadowOffset(1, -1)
            	count:SetPoint('RIGHT', icon, 'LEFT', -1, 0)
				icon.count = count
			elseif i == 3 then -- wild growth
				icon:SetPoint('TOPRIGHT', self)
				icon.icon:SetVertexColor(0.7, 1, 0)
				icon:SetFrameLevel(icon:GetFrameLevel() + 1)
			end
		elseif playerClass == 'MAGE' then
			if i == 1 then -- focus magic
				icon:SetPoint('TOPRIGHT', self)
				icon.icon:SetVertexColor(180/255, 0, 1)
				icon.anyUnit = true
				icon.hideCooldown = true
			end
		elseif playerClass == 'PALADIN' then
			if i == 1 then -- beacon of light
				icon:SetPoint('TOPRIGHT', self)
				icon.icon:SetVertexColor(0, 1, 0)
			end
		elseif playerClass == 'PRIEST' then
			if i == 1 then -- weakened soul
				icon:SetPoint('TOP', self)
				icon.icon:SetVertexColor(0.6, 0, 0)
				icon.anyUnit = true
			elseif i == 2 then -- power word: shield
				icon:SetFrameLevel(icon:GetFrameLevel() + 5)
				icon:SetPoint('TOP', self)
				icon.icon:SetVertexColor(1, 1, 0)
				icon.anyUnit = true
			elseif i == 3 then -- renew
				icon:SetPoint('BOTTOMRIGHT', self)
				icon.icon:SetVertexColor(0, 1, 0)
			elseif i == 4 then -- prayer of mending
				icon:SetPoint('TOPRIGHT', self)
				icon.icon:SetVertexColor(1, 0.6, 0.6)
				icon.anyUnit = true
				icon.hideCooldown = true
				
				local count = icon:CreateFontString(nil, 'OVERLAY')
				count:SetFont(NumberFontNormal:GetFont(), 10)
				count:SetShadowColor(0, 0, 0)
				count:SetShadowOffset(1, -1)
            	count:SetPoint('RIGHT', icon, 'LEFT', -1, 0)
				icon.count = count
			end
		elseif playerClass == 'SHAMAN' then
			if i == 1 then -- earth shield
				icon:SetPoint('TOPRIGHT', self)
				icon.icon:SetVertexColor(0.4, 1, 0.4)
				icon.anyUnit = true
				icon.hideCooldown = true
			elseif i == 2 then -- riptide
				icon:SetPoint('BOTTOMRIGHT', self)
				icon.icon:SetVertexColor(0.2, 0.2, 1)
			end
		elseif playerClass == 'WARLOCK' then
			if i == 1 then -- soulstone
				icon:SetPoint('TOP', self)
				icon.icon:SetVertexColor(180/255, 0, 1)
				icon.anyUnit = true
				icon.hideCooldown = true
			elseif i == 2 then -- dark intent
				icon:SetPoint('TOPRIGHT', self)
				icon.icon:SetVertexColor(180/255, 0.5, 1)
				icon.anyUnit = true
				icon.hideCooldown = true
			end
		end
        self.AuraWatch.icons[id] = icon
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
            self.Aggro:SetText('|cFFFF0000AGGRO')
            self.Health:SetBackdropColor(0.9, 0, 0) 
        else
            self.Aggro:SetText('')
            self.Health:SetBackdropColor(0, 0, 0) 
        end
    end
end

local function UpdateHealth(Health, unit, min, max)
	if (Health:GetParent().unit ~= unit) then 
        return 
    end

    if (UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit)) then
     -- Health.Value:SetText((UnitIsDead(unit) and 'Dead') or (UnitIsGhost(unit) and 'Ghost') or (not UnitIsConnected(unit) and 'Offline'))
        Health.Value:SetTextColor(0.5, 0.5, 0.5)
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        if ((min/max * 100) < 90) then
         -- Health.Value:SetText(DeficitValue(max-min))
            Health.Value:SetTextColor(1, 0, 0)
        else
         -- Health.Value:SetText('')
            Health.Value:SetTextColor(1, 1, 1)
        end

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

-- Number formatting for healcomm4
local shortVal = function(val)
	if (val >= 1e6) then
		return ("+%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("+%.1f"):format(val / 1e3)
	else
		return ("+%d"):format(val)
	end
end

local function CreateRaidLayout(self, unit)
    self:SetScript('OnEnter', function(self)
    	self.Health.Mouseover:SetAlpha(0.15)
    	UnitFrame_OnEnter(self)
    end)
    self:SetScript('OnLeave', function(self)
    	self.Health.Mouseover:SetAlpha(0)
    	UnitFrame_OnLeave(self)
    end)

	self:SetSize(oUF_Neav.units.raid.width, oUF_Neav.units.raid.height)

        -- health bar

    self.Health = CreateFrame('StatusBar', nil, self)
    self.Health:SetStatusBarTexture(oUF_Neav.media.statusbar, 'ARTWORK')
    self.Health:SetFrameStrata('LOW')
    self.Health:SetAllPoints(self)
    self.Health:SetFrameLevel(1)
    self.Health:SetOrientation('VERTICAL') 
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

    self.Health.PostUpdate = UpdateHealth

    self.Health.colorClass = true
    self.Health.Smooth = true

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

        -- name text

    self.Name = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Name:SetPoint('TOP', 0, -6)
    self.Name:SetFont(oUF_Neav.media.fontThick, 13)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetTextColor(1, 1, 1)
    self:Tag(self.Name, '[name:Raid]')

        -- heal prediction (new healcomm)
	
	if isHealer then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetOrientation('VERTICAL')
		mhpb:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
		mhpb:SetWidth(oUF_Neav.units.raid.width)
		mhpb:SetHeight(oUF_Neav.units.raid.height)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetOrientation('VERTICAL')
		ohpb:SetPoint('BOTTOM', mhpb:GetStatusBarTexture(), 'TOP', 0, 0)
		ohpb:SetWidth(oUF_Neav.units.raid.width)
		ohpb:SetHeight(oUF_Neav.units.raid.height)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	
        -- aggro text

    self.Aggro = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Aggro:SetPoint('CENTER', self, 'TOP')
    self.Aggro:SetFont(oUF_Neav.media.font, 11, 'OUTLINE')
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
        self.TargetBorder:SetPoint('TOPRIGHT', self.Health, 7, 7)
        self.TargetBorder:SetPoint('BOTTOMLEFT', self.Health, -7, -7)
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

    raid = {}
    for i = 1, oUF_Neav.units.raid.numGroups do
        table.insert(raid, self:SpawnHeader('oUF_Neav_Raid'..i, nil, visible,
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
        raid[i]:Show()
    end
end)

-- Moves the raid frames a bit
--SlashCmdList["HEAL"] = function()
--	local pos = {'LEFT', UIParent, 'CENTER', 200, 0}
--    for i = 1, oUF_Neav.units.raid.numGroups do
--		if (i == 1) then
--			raid[i]:ClearAllPoints()
--			raid[i]:SetPoint(unpack(pos))
--		else
--			raid[i]:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', 7, 0)
--		end
--	end
--end
--SLASH_HEAL1 = "/heal"
--
---- Moves the raid frames a bit
--SlashCmdList["DPS"] = function()
--    for i = 1, oUF_Neav.units.raid.numGroups do
--		if (i == 1) then
--			raid[i]:ClearAllPoints()
--			raid[i]:SetPoint(unpack(oUF_Neav.units.raid.position))
--		else
--			raid[i]:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', 7, 0)
--		end
--	end
--end
--SLASH_DPS1 = "/dps"
