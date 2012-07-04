
local _, ns = ...
local config = ns.Config

local playerClass = select(2, UnitClass('player'))

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
		MONK = {
			{119611, 'BOTTOMRIGHT', {0, 1, 0}}, -- Renewing Mist
			{124682, 'BOTTOMLEFT', {0.15, 0.98, 0.64}}, -- Enveloping Mist
			{115175, 'TOPRIGHT', {0.15, 0.98, 0.64}}, -- Soothing Mist
			{116849, 'TOPRIGHT', {1, 1, 0}}, -- Life Cocoon
			{124081, 'BOTTOMLEFT', {0.7, 0.8, 1}}, -- Zen Sphere
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
            {23333, 'TOPLEFT', {1, 0, 0}}, -- Warsong flag, Horde
            {23335, 'TOPLEFT', {0, 0, 1}}, -- Warsong flag, Alliance 
        },
    }
end

--[[

    -- W    I   P
    
local inlist
do
    inlist = {
        DRUID = {
            [1] = {
                spellid = 774,  -- Rejuvenation
                pos = 'BOTTOMRIGHT', 
                color = {1, 0.2, 1}, -- custom color, set to nil if the spellicon should be shown
                anyCaster = false,
                hideCD = false,
                hideCount = false,
                priority = 'HIGH', -- to overlap other icons on this position
            }, 
            
            [2] = {
                spellid = 33763,  -- Lifebloom
                pos = 'BOTTOM', 
                color = {0.5, 1, 0.5},
                anyCaster = false,
                hideCD = false,
                hideCount = true,
            }, 
            
            [3] = {
                spellid = 48438,  -- Wild Growth
                pos = 'BOTTOMLEFT', 
                color = {0.7, 1, 0},
                anyCaster = false,
                hideCD = false,
                hideCount = true,
            },
        }
    }

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
            {23333, 'TOPLEFT', {1, 0, 0}}, -- Warsong flag, Horde
            {23335, 'TOPLEFT', {0, 0, 1}}, -- Warsong flag, Alliance 
        },
end
]]

local function AuraIcon(self, icon)
    if (icon.cd) then
        icon.cd:SetReverse()
        icon.cd:SetAllPoints(icon.icon)
    end
end

local offsets
do
    local space = 2

    offsets = {
        TOPLEFT = {
            icon = {space, -space},
            count = {'TOP', icon, 'BOTTOM', 0, 0},
        },

        TOPRIGHT = {
            icon = {-space, -space},
            count = {'TOP', icon, 'BOTTOM', 0, 0},
        },

        BOTTOMLEFT = {
            icon = {space, space},
            count = {'LEFT', icon, 'RIGHT', 1, 0},
        },

        BOTTOMRIGHT = {
            icon = {-space, space},
            count = {'RIGHT', icon, 'LEFT', -1, 0},
        },

        LEFT = {
            icon = {space, 0},
            count = {'LEFT', icon, 'RIGHT', 1, 0},
        },

        RIGHT = {
            icon = {-space, 0},
            count = {'RIGHT', icon, 'LEFT', -1, 0},
        },

        TOP = {
            icon = {0, -space},
            count = {'CENTER', icon, 0, 0},
        },

        BOTTOM = {
            icon = {0, space},
            count = {'CENTER', icon, 0, 0},
        },
    }
end

local function CreateIndicators(self, unit)
    self.AuraWatch = CreateFrame('Frame', nil, self)
    self.AuraWatch.presentAlpha = 1
    self.AuraWatch.missingAlpha = 0
    self.AuraWatch.hideCooldown = false
    self.AuraWatch.noCooldownCount = true
    self.AuraWatch.icons = {}
    self.AuraWatch.PostCreateIcon = AuraIcon

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
            icon:SetWidth(config.units.raid.indicatorSize)
            icon:SetHeight(config.units.raid.indicatorSize)
            icon:SetPoint(spell[2], self.Health, unpack(offsets[spell[2]].icon))

            icon.spellID = spell[1]
            icon.anyUnit = spell[4]
            icon.hideCooldown = spell[5]
            icon.hideCount = spell[6]

                -- exception to place PW:S above Weakened Soul

            if (spell[1] == 17) then
                icon:SetFrameLevel(icon:GetFrameLevel() + 5)
            end

                -- indicator icon

            icon.icon = icon:CreateTexture(nil, 'OVERLAY')
            icon.icon:SetAllPoints(icon)
            icon.icon:SetTexture('Interface\\AddOns\\oUF_NeavRaid\\media\\borderIndicator')

            if (spell[3]) then
                icon.icon:SetVertexColor(unpack(spell[3]))
            else
                icon.icon:SetVertexColor(0.8, 0.8, 0.8)
            end

            if (not icon.hideCount) then
                icon.count = icon:CreateFontString(nil, 'OVERLAY')
                icon.count:SetShadowColor(0, 0, 0)
                icon.count:SetShadowOffset(1, -1)
                icon.count:SetPoint(unpack(offsets[spell[2]].count))
                icon.count:SetFont('Interface\\AddOns\\oUF_NeavRaid\\media\\fontVisitor.ttf', 13)
            end

            self.AuraWatch.icons[spell[1]] = icon
        end
    end
end

local function UpdateThreat(self, _, unit)
    if (self.unit ~= unit) then
        return
    end

    local threatStatus = UnitThreatSituation(self.unit)
    if (threatStatus == 3) then  
        if (self.ThreatText) then
            self.ThreatText:Show()
        end
    end

    if (threatStatus and threatStatus >= 2) then
        -- self.Bg:SetVertexColor(0.75, 0, 0)
        local r, g, b = GetThreatStatusColor(threatStatus)
        self.ThreatGlow:SetBackdropBorderColor(r, g, b, 1)
    else
        -- self.Bg:SetVertexColor(0, 0, 0)
        self.ThreatGlow:SetBackdropBorderColor(0, 0, 0, 0)

        if (self.ThreatText) then
            self.ThreatText:Hide()
        end
    end
end

local function UpdatePower(self, _, unit)
    if (self.unit ~= unit) then
        return 
    end

    local _, powerToken = UnitPowerType(unit)

    if (powerToken == 'MANA' and UnitHasMana(unit)) then
        if (not self.Power:IsVisible()) then
            self.Health:ClearAllPoints()
            if (config.units.raid.manabar.horizontalOrientation) then
                self.Health:SetPoint('BOTTOMLEFT', self, 0, 3)
                self.Health:SetPoint('TOPRIGHT', self)
            else
                self.Health:SetPoint('BOTTOMLEFT', self)
                self.Health:SetPoint('TOPRIGHT', self, -3.5, 0)
            end

            self.Power:Show()
        end
    else
        if (self.Power:IsVisible()) then
            self.Health:ClearAllPoints()
            self.Health:SetAllPoints(self)
            self.Power:Hide()
        end
    end
end

local function DeficitValue(self)
    if (self >= 1000) then
        return format('-%.1f', self/1000)
    else
        return self
    end
end

local function GetUnitStatus(unit)
    if (UnitIsDead(unit)) then 
        return DEAD
    elseif (UnitIsGhost(unit)) then
        return 'Ghost' 
    elseif (not UnitIsConnected(unit)) then
        return PLAYER_OFFLINE
    else
        return ''
    end
end

local function GetHealthText(unit, cur, max)
    local healthString
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        healthString = GetUnitStatus(unit)
    else
        if ((cur/max) < config.units.raid.deficitThreshold) then
            healthString = format('|cff%02x%02x%02x%s|r', 0.9*255, 0*255, 0*255, DeficitValue(max-cur))
        else
            healthString = ''
        end
    end

    return healthString
end

local function UpdateHealth(Health, unit, cur, max)
    if (not UnitIsPlayer(unit)) then
        local r, g, b = 0, 0.82, 1
        Health:SetStatusBarColor(r, g, b)
        Health.bg:SetVertexColor(r * 0.25, g * 0.25, b * 0.25)
    end

    Health.Value:SetText(GetHealthText(unit, cur, max))
end

local function CreateRaidLayout(self, unit)
    self:RegisterForClicks('AnyUp')

    self:SetScript('OnEnter', function(self)
        UnitFrame_OnEnter(self)
        
        if (self.Mouseover) then
            self.Mouseover:SetAlpha(0.175)
        end
    end)

    self:SetScript('OnLeave', function(self)
        UnitFrame_OnLeave(self)
        
        if (self.Mouseover) then
            self.Mouseover:SetAlpha(0)
        end
    end)

    self:SetBackdrop({
          bgFile = 'Interface\\Buttons\\WHITE8x8',
          insets = {
            left = -1.5,
            right = -1.5,
            top = -1.5,
            bottom = -1.5
        }
    })

    self:SetBackdropColor(0, 0, 0, 1)

        -- Health bar

    self.Health = CreateFrame('StatusBar', nil, self)
    self.Health:SetStatusBarTexture(config.media.statusbar, 'ARTWORK')
    self.Health:SetAllPoints(self)
    self.Health:SetOrientation(config.units.raid.horizontalHealthBars and 'HORIZONTAL' or 'VERTICAL')

    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true

    self.Health.colorClass = true
    self.Health.colorDisconnected = true   

    if (config.units.raid.smoothUpdates) then
        self.Health.Smooth = true
    end

        -- Health background

    self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.bg:SetTexture(config.media.statusbar)

    self.Health.bg.multiplier = 0.3

        -- Health text

    self.Health.Value = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Health.Value:SetPoint('TOP', self.Health, 'CENTER', 0, 2)
    self.Health.Value:SetFont(config.font.fontSmall, config.font.fontSmallSize)
    self.Health.Value:SetShadowOffset(1, -1)

        -- Name text

    self.Name = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Name:SetPoint('BOTTOM', self.Health, 'CENTER', 0, 3)
    self.Name:SetFont(config.font.fontBig,config.font.fontBigSize)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetTextColor(1, 1, 1)
    self:Tag(self.Name, '[name:raid]')

        -- Power bar

    if (config.units.raid.manabar.show) then
        self.Power = CreateFrame('StatusBar', nil, self)
        self.Power:SetStatusBarTexture(config.media.statusbar, 'ARTWORK')

        if (config.units.raid.manabar.horizontalOrientation) then
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

        self.Power.bg = self.Power:CreateTexture(nil, 'BORDER')
        self.Power.bg:SetAllPoints(self.Power)
        self.Power.bg:SetTexture(1, 1, 1)

        self.Power.bg.multiplier = 0.3

        table.insert(self.__elements, UpdatePower)
        self:RegisterEvent('UNIT_DISPLAYPOWER', UpdatePower)
        UpdatePower(self, _, unit)
    end

        -- Heal prediction, new healcomm

    local myBar = CreateFrame('StatusBar', nil, self)
    myBar:SetStatusBarTexture(config.media.statusbar, 'OVERLAY')
    myBar:SetStatusBarColor(0, 1, 0.3, 0.5)

    if (config.units.raid.smoothUpdates) then
        myBar.Smooth = true
    end

    if (config.units.raid.horizontalHealthBars) then
        myBar:SetOrientation('HORIZONTAL')
        myBar:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT')
        myBar:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
        myBar:SetWidth(self:GetWidth())
    else
        myBar:SetOrientation('VERTICAL')
        myBar:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'TOPLEFT')
        myBar:SetPoint('BOTTOMRIGHT', self.Health:GetStatusBarTexture(), 'TOPRIGHT')
        myBar:SetHeight(self:GetHeight())
    end

    local otherBar = CreateFrame('StatusBar', nil, self)
    otherBar:SetStatusBarTexture(config.media.statusbar, 'OVERLAY')
    otherBar:SetStatusBarColor(0, 1, 0, 0.35)

    if (config.units.raid.smoothUpdates) then
        otherBar.Smooth = true
    end

    if (config.units.raid.horizontalHealthBars) then
        otherBar:SetOrientation('HORIZONTAL')
        otherBar:SetPoint('TOPLEFT', myBar:GetStatusBarTexture(), 'TOPRIGHT')
        otherBar:SetPoint('BOTTOMLEFT', myBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
        otherBar:SetWidth(self:GetWidth())
    else
        otherBar:SetOrientation('VERTICAL')
        otherBar:SetPoint('BOTTOMLEFT', myBar:GetStatusBarTexture(), 'TOPLEFT')
        otherBar:SetPoint('BOTTOMRIGHT', myBar:GetStatusBarTexture(), 'TOPRIGHT')
        otherBar:SetHeight(self:GetHeight())
    end

    self.HealPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        maxOverflow = 1.2,
    }

        -- Afk /offline timer, using frequentUpdates function from oUF tags

    if (config.units.raid.showNotHereTimer) then
        self.NotHere = self.Health:CreateFontString(nil, 'OVERLAY')
        self.NotHere:SetPoint('CENTER', self, 'BOTTOM')
        -- self.NotHere:SetFont(config.font.fontSmall, 11)
        self.NotHere:SetFont(config.font.fontSmall, 11, 'THINOUTLINE')
        self.NotHere:SetShadowOffset(0, 0)
        self.NotHere:SetTextColor(0, 1, 0)
        self.NotHere.frequentUpdates = 1
        self:Tag(self.NotHere, '[status:raid]')
    end

        -- Mouseover darklight

    if (config.units.raid.showMouseoverHighlight) then    
        self.Mouseover = self.Health:CreateTexture(nil, 'OVERLAY')
        self.Mouseover:SetAllPoints(self.Health)
        self.Mouseover:SetTexture(config.media.statusbar)
        self.Mouseover:SetVertexColor(0, 0, 0)
        self.Mouseover:SetAlpha(0)
    end

        -- Threat glow

    self.ThreatGlow = CreateFrame('Frame', nil, self)
    self.ThreatGlow:SetPoint('TOPLEFT', self, 'TOPLEFT', -4, 4)
    self.ThreatGlow:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 4, -4)
    self.ThreatGlow:SetBackdrop({edgeFile = 'Interface\\AddOns\\oUF_NeavRaid\\media\\textureGlow', edgeSize = 3})
    self.ThreatGlow:SetBackdropBorderColor(0, 0, 0, 0)
    self.ThreatGlow:SetFrameLevel(self:GetFrameLevel() - 1)
    self.ThreatGlow.ignore = true

        -- Threat text

    if (config.units.raid.showThreatText) then
        self.ThreatText = self.Health:CreateFontString(nil, 'OVERLAY')
        self.ThreatText:SetPoint('CENTER', self, 'BOTTOM')
        self.ThreatText:SetFont(config.font.fontSmall, 11, 'THINOUTLINE')
        self.ThreatText:SetShadowOffset(0, 0)
        self.ThreatText:SetTextColor(1, 0, 0)
        self.ThreatText:SetText('AGGRO')
    end

    table.insert(self.__elements, UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)

        -- Masterlooter icons

    self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY', self)
    self.MasterLooter:SetSize(11, 11)
    self.MasterLooter:SetPoint('RIGHT', self, 'TOPRIGHT', -1, 1)

        -- Main tank icon

    if (config.units.raid.showMainTankIcon) then
        self.MainTank = self.Health:CreateTexture(nil, 'OVERLAY')
        self.MainTank:SetSize(12, 11)
        self.MainTank:SetPoint('CENTER', self, 'TOP', 0, 1)
        self.MainTank:Hide()
    end

        -- Leader icons

    self.Leader = self.Health:CreateTexture(nil, 'OVERLAY', self)
    self.Leader:SetSize(12, 12)
    self.Leader:SetPoint('LEFT', self.Health, 'TOPLEFT', 1, 0)

        -- Raid icons

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetSize(16, 16)
    self.RaidIcon:SetPoint('CENTER', self, 'TOP')

        -- Readycheck icons

    self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
    self.ReadyCheck:SetPoint('CENTER')
    self.ReadyCheck:SetSize(20, 20)
    self.ReadyCheck.delayTime = 2
    self.ReadyCheck.fadeTime = 1

        -- Debuff icons, using freebAuras from oUF_Freebgrid

    self.FreebAuras = CreateFrame('Frame', nil, self)
    self.FreebAuras:SetSize(config.units.raid.iconSize, config.units.raid.iconSize)
    self.FreebAuras:SetPoint('CENTER', self.Health)

        -- Create indicators

    CreateIndicators(self, unit)

        -- Role indicator

    --[[
    self.LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
    self.LFDRole:SetSize(12, 12)
    self.LFDRole:SetPoint('TOPLEFT', self.Health, -5, -5)
    --]]

    if (config.units.raid.showRolePrefix) then
        self.LFDRoleText = self.Health:CreateFontString(nil, 'ARTWORK')
        self.LFDRoleText:SetPoint('TOPLEFT', self.Health, 0, 4)
        self.LFDRoleText:SetFont(config.font.fontSmall, 15)
        self.LFDRoleText:SetShadowOffset(0.5, -0.5)
        self.LFDRoleText:SetTextColor(1, 0, 1)
        self:Tag(self.LFDRoleText, '[role:raid]')
    end

        -- Ressurection icon....ehm text!

    if (config.units.raid.showResurrectText) then
        self.ResurrectIcon = self.Health:CreateFontString(nil, 'OVERLAY')
        self.ResurrectIcon:SetPoint('CENTER', self, 'BOTTOM', 0, 1)
        self.ResurrectIcon:SetFont(config.font.fontSmall, 11, 'THINOUTLINE')
        self.ResurrectIcon:SetShadowOffset(0, 0)
        self.ResurrectIcon:SetTextColor(0.1, 1, 0.1)
        self.ResurrectIcon:SetText('RES') -- RESURRECT

        self.ResurrectIcon.Override = function()
            local incomingResurrect = UnitHasIncomingResurrection(self.unit)

            if (incomingResurrect) then
                self.ResurrectIcon:Show()
                
                if (self.NotHere) then
                    self.NotHere:Hide()
                end
            else
                self.ResurrectIcon:Hide()
                
                if (self.NotHere) then
                    self.NotHere:Show()
                end
            end
        end
    end

        -- Playertarget border

    if (config.units.raid.showTargetBorder) then
        self.TargetBorder = self.Health:CreateTexture(nil, 'OVERLAY', self)
        -- self.TargetBorder:SetPoint('TOPRIGHT', self, 5, 5)
        -- self.TargetBorder:SetPoint('BOTTOMLEFT', self, -5, -5)
        self.TargetBorder:SetAllPoints(self.Health)
        self.TargetBorder:SetTexture('Interface\\Addons\\oUF_NeavRaid\\media\\borderTarget')
        self.TargetBorder:SetVertexColor(unpack(config.units.raid.targetBorderColor))
        self.TargetBorder:Hide()
 
        self:RegisterEvent('PLAYER_TARGET_CHANGED', function()
            if (UnitIsUnit('target', self.unit)) then
                self.TargetBorder:Show()
            else
                self.TargetBorder:Hide()
            end
        end)
    end

        -- Range check

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

local f = CreateFrame('Frame', 'oUF_Neav_Raid_Anchor', UIParent)
f:SetSize(80, 80)
f:SetPoint('CENTER')
f:SetFrameStrata('HIGH')
f:SetMovable(true)
f:SetClampedToScreen(true)
f:SetUserPlaced(true)
f:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
f:SetBackdropColor(0, 1, 0, 0.55)
f:EnableMouse(true)
f:RegisterForDrag('LeftButton')
f:Hide()

f.t = f:CreateFontString(nil, 'OVERLAY')
f.t:SetAllPoints(f)
f.t:SetFont('Fonts\\ARIALN.ttf', 13)
f.t:SetText('oUF_Neav Raid_Anchor "'..config.units.raid.layout.initialAnchor..'"')

f:SetScript('OnDragStart', function(self) 
    self:StartMoving()
end)

f:SetScript('OnDragStop', function(self) 
    self:StopMovingOrSizing()
end)

SlashCmdList['oUF_Neav_Raid_AnchorToggle'] = function()
    if (InCombatLockdown()) then
        f:Hide()
        print('oUF_NeavRaid: You cant do this in combat!')
        return
    end

    if (not f:IsShown()) then
        f:Show()
    else
        f:Hide()
    end
end
SLASH_oUF_Neav_Raid_AnchorToggle1 = '/neavrt'

oUF:RegisterStyle('oUF_Neav_Raid', CreateRaidLayout)
oUF:Factory(function(self)
    self:SetActiveStyle('oUF_Neav_Raid')

    local rlayout = config.units.raid.layout
    local relpoint, anchpoint, offset

    if (rlayout.orientation == 'HORIZONTAL') then
        if (rlayout.initialAnchor == 'TOPRIGHT' or rlayout.initialAnchor == 'TOPLEFT') then
            relpoint = 'TOP'
            anchpoint = 'TOP'
            offset = -rlayout.frameSpacing
        elseif (rlayout.initialAnchor == 'BOTTOMLEFT' or rlayout.initialAnchor == 'BOTTOMRIGHT') then
            relpoint = 'BOTTOM'
            anchpoint = 'BOTTOM'
            offset = rlayout.frameSpacing
        end
    elseif (rlayout.orientation == 'VERTICAL') then
        if (rlayout.initialAnchor == 'TOPRIGHT') then
            relpoint = 'TOP'
            anchpoint = 'RIGHT'
            offset = -rlayout.frameSpacing
        elseif (rlayout.initialAnchor == 'TOPLEFT') then
            relpoint = 'TOP'
            anchpoint = 'LEFT'
            offset = rlayout.frameSpacing
        elseif (rlayout.initialAnchor == 'BOTTOMLEFT') then
            relpoint = 'BOTTOM'
            anchpoint = 'LEFT'
            offset = rlayout.frameSpacing
        elseif (rlayout.initialAnchor == 'BOTTOMRIGHT') then
            relpoint = 'BOTTOM'
            anchpoint = 'RIGHT'
            offset = -rlayout.frameSpacing
        end
    end

    local raid = {}
    for i = 1, rlayout.numGroups do
        table.insert(raid, self:SpawnHeader('oUF_Neav_Raid'..i, nil, 'solo,party,raid',
            'oUF-initialConfigFunction', ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            ]]):format(config.units.raid.width, config.units.raid.height),

            'showRaid', true,
            'showParty', config.units.raid.showParty,
            'showPlayer', true,
            'showSolo', config.units.raid.showSolo,

            'xOffset', offset,
            'yOffset', offset,
            'columnSpacing', offset,

            'point', anchpoint,
            'columnAnchorPoint', relpoint,

            'sortMethod', 'INDEX',
            'groupFilter', i
            )
        )

        if (i == 1) then
            raid[i]:SetPoint(rlayout.initialAnchor, f)
        else
            if (rlayout.initialAnchor == 'TOPLEFT') then
                if (rlayout.orientation == 'HORIZONTAL') then
                    raid[i]:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', rlayout.frameSpacing, 0)
                elseif (rlayout.orientation == 'VERTICAL') then
                    raid[i]:SetPoint('TOPLEFT', raid[i-1], 'BOTTOMLEFT', 0, -rlayout.frameSpacing)
                end
            elseif (rlayout.initialAnchor == 'TOPRIGHT') then
                if (rlayout.orientation == 'HORIZONTAL') then
                    raid[i]:SetPoint('TOPRIGHT', raid[i-1], 'TOPLEFT', -rlayout.frameSpacing, 0)
                else
                    raid[i]:SetPoint('TOPRIGHT', raid[i-1], 'BOTTOMRIGHT', 0, -rlayout.frameSpacing)
                end   
            elseif (rlayout.initialAnchor == 'BOTTOMLEFT') then
                if (rlayout.orientation == 'HORIZONTAL') then
                    raid[i]:SetPoint('BOTTOMLEFT', raid[i-1], 'BOTTOMRIGHT', rlayout.frameSpacing, 0)
                else
                    raid[i]:SetPoint('BOTTOMLEFT', raid[i-1], 'TOPLEFT', 0, rlayout.frameSpacing)
                end
            elseif (rlayout.initialAnchor == 'BOTTOMRIGHT') then
                    if (rlayout.orientation == 'HORIZONTAL') then
                    raid[i]:SetPoint('BOTTOMRIGHT', raid[i-1], 'BOTTOMLEFT', -rlayout.frameSpacing, 0)
                else
                    raid[i]:SetPoint('BOTTOMRIGHT', raid[i-1], 'TOPRIGHT', 0, rlayout.frameSpacing)
                end
            end
        end

        raid[i]:SetScale(config.units.raid.scale) 
    end
end)
