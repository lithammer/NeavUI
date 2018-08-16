
local _, ns = ...
local config = ns.Config
local raidFrames, tankFrames

local oUF = ns.oUF or oUF
local unpack = unpack
local tostring = tostring
local pairs = pairs
local format = format
local tinsert = table.insert
local statusbar, font, fontSize

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("statusbar", "Neav "..DEFAULT, "Interface\\AddOns\\oUF_NeavRaid\\media\\statusbarTexture")
LSM:Register("font", "Neav "..DEFAULT, "Interface\\AddOns\\oUF_NeavRaid\\media\\fontSmall.ttf")

oUF.colors.power["MANA"] = {0, 0.55, 1}

local _, playerClass = UnitClass("player")

function NeavRaid_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
end

function NeavRaid_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == "oUF_NeavRaid" then
            ns.RegisterDefaultSetting("showSolo", false)
            ns.RegisterDefaultSetting("showParty", true)
            ns.RegisterDefaultSetting("assistFrame", false)
            ns.RegisterDefaultSetting("sortByRole", true)
            ns.RegisterDefaultSetting("showRoleIcons", true)
            ns.RegisterDefaultSetting("anchorToControls", false)
            ns.RegisterDefaultSetting("horizontalHealthBars", false)
            ns.RegisterDefaultSetting("powerBars", true)
            ns.RegisterDefaultSetting("manaOnlyPowerBars", true)
            ns.RegisterDefaultSetting("horizontalPowerBars", false)
            ns.RegisterDefaultSetting("indicatorSize", 7)
            ns.RegisterDefaultSetting("debuffSize", 22)
            ns.RegisterDefaultSetting("orientation", "VERTICAL")
            ns.RegisterDefaultSetting("initialAnchor", "TOPLEFT")
            ns.RegisterDefaultSetting("texture", "Interface\\AddOns\\oUF_NeavRaid\\media\\statusbarTexture")
            ns.RegisterDefaultSetting("font", "Interface\\AddOns\\oUF_NeavRaid\\media\\fontSmall.ttf")
            ns.RegisterDefaultSetting("fontSize", 12)
            ns.RegisterDefaultSetting("nameLength", 4)
            ns.RegisterDefaultSetting("frameWidth", 48)
            ns.RegisterDefaultSetting("frameHeight", 46)
            ns.RegisterDefaultSetting("frameOffset", 7)
            ns.RegisterDefaultSetting("frameScale", 1.2)

            statusbar = nRaidDB.texture
            font = nRaidDB.font
            fontSize = nRaidDB.fontSize

            raidFrames = ns.CreateAnchor("Raid")
            tankFrames = ns.CreateAnchor("Assist")
        end
    end
end

    -- oUF_AuraWatch
    -- Class buffs { spell ID, position [, {r, g, b, a}][, anyUnit][, hideCount] }

local indicatorList
do
    indicatorList = {
        DRUID = {
            {774, "BOTTOMRIGHT", {1, 0.2, 1}},          -- Rejuvenation
            {155777, "RIGHT", {0.4, 0.9, 0.4}},         -- Rejuvenation (Germination)
            {33763, "BOTTOM", {0.5, 1, 0.5}},           -- Lifebloom
            {48438, "BOTTOMLEFT", {0.7, 1, 0}},         -- Wild Growth
            {8936, "TOPRIGHT", {0, 1, 0}},              -- Regrowth
            {102351, "TOPLEFT", {0, 1, 0}},             -- Cenarion Ward
        },
        MONK = {
            {119611, "BOTTOMRIGHT", {0, 1, 0}},         -- Renewing Mist
            {124682, "TOPRIGHT", {0.15, 0.98, 0.64}},   -- Enveloping Mist
            {116849, "TOPLEFT", {1, 1, 0}},             -- Life Cocoon
            {115175, "BOTTOMLEFT", {0.7, 0.8, 1}},      -- Soothing Mist
            {191840, "RIGHT", {0, 1, 0}},               -- Essence Font
        },
        PALADIN = {
            {53563, "TOPLEFT", {0, 1, 0}},              -- Beacon of Light
            {156910, "TOPLEFT", {0.5, 0.5, 1}},         -- Beacon of Faith
            {200025, "TOPLEFT", {0, 1, 0}},             -- Beacon of Virtue
            {223306, "BOTTOMRIGHT", {1, 1, 0}},         -- Bestow Faith
            {6940, "TOPRIGHT", {1, 0, 0}},              -- Blessing of Sacrifice
        },
        PRIEST = {
            {17, "BOTTOMRIGHT", {1, 1, 0}},             -- Power Word: Shield
            {194384, "TOPRIGHT", {1, 0, 0}},            -- Atonement
            {271466, "RIGHT", {1, 1, 0}},               -- Luminous Barrier
            {41635, "TOPRIGHT", {1, 0, 0}},             -- Prayer of Mending
            {139, "RIGHT", {0, 1, 0}},                  -- Renew
        },
        SHAMAN = {
            {61295, "TOPLEFT", {0.7, 0.3, 0.7}},        -- Riptide
            {974, "BOTTOMRIGHT", {0.7, 0.4, 0}},        -- Earth Shield (Talent)
        },
        WARLOCK = {
            {20707, "BOTTOMRIGHT", {0.7, 0, 1}, true},  -- Soulstone
        },
        ALL = {
            {23333, "TOPLEFT", {1, 0, 0}, true},        -- Warsong flag, Horde
            {23335, "TOPLEFT", {0, 0, 1}, true},        -- Warsong flag, Alliance
            {34976, "TOPLEFT", {1, 0, 1}, true},        -- Netherstorm Flag
        },
    }
end

local function AuraIcon(self, icon)
    if icon.cd then
        icon.cd:SetReverse(true)
        icon.cd:SetDrawEdge(true)
        icon.cd:SetAllPoints(icon.icon)
        icon.cd:SetHideCountdownNumbers(true)
    end
end

local offsets
do
    local space = 2

    offsets = {
        TOPLEFT = {
            icon = {space, -space},
            count = {"TOP", icon, "BOTTOM", 0, 0},
        },

        TOPRIGHT = {
            icon = {-space, -space},
            count = {"TOP", icon, "BOTTOM", 0, 0},
        },

        BOTTOMLEFT = {
            icon = {space, space},
            count = {"LEFT", icon, "RIGHT", 1, 0},
        },

        BOTTOMRIGHT = {
            icon = {-space, space},
            count = {"RIGHT", icon, "LEFT", -1, 0},
        },

        LEFT = {
            icon = {space, 0},
            count = {"LEFT", icon, "RIGHT", 1, 0},
        },

        RIGHT = {
            icon = {-space, 0},
            count = {"RIGHT", icon, "LEFT", -1, 0},
        },

        TOP = {
            icon = {0, -space},
            count = {"CENTER", icon, 0, 0},
        },

        BOTTOM = {
            icon = {0, space},
            count = {"CENTER", icon, 0, 0},
        },
    }
end

local function CreateIndicators(self, unit)

    self.AuraWatch = CreateFrame("Frame", "$parentAuraWatch", self)

    local Auras = {}
    Auras.icons = {}
    Auras.customIcons = true
    Auras.presentAlpha = 1
    Auras.missingAlpha = 0
    Auras.PostCreateIcon = AuraIcon

    local buffs = {}

    if indicatorList["ALL"] then
        for key, value in pairs(indicatorList["ALL"]) do
            tinsert(buffs, value)
        end
    end

    if indicatorList[playerClass] then
        for key, value in pairs(indicatorList[playerClass]) do
            tinsert(buffs, value)
        end
    end

    if buffs then
        for key, spell in pairs(buffs) do

            local icon = CreateFrame("Frame", "$parentSpell"..spell[1], self.AuraWatch)
            icon:SetWidth(nRaidDB.indicatorSize)
            icon:SetHeight(nRaidDB.indicatorSize)
            icon:SetPoint(spell[2], self.Health, unpack(offsets[spell[2]].icon))

            icon.spellID = spell[1]
            icon.anyUnit = spell[4]
            icon.hideCount = spell[5]

            local cd = CreateFrame("Cooldown", "$parentCD", icon, "CooldownFrameTemplate")
            cd:SetAllPoints(icon)
            icon.cd = cd

                -- Indicator

            local tex = icon:CreateTexture("$parentTexture", "OVERLAY")
            tex:SetAllPoints(icon)
            tex:SetTexture("Interface\\AddOns\\oUF_NeavRaid\\media\\borderIndicator")
            icon.icon = tex

                -- Color Overlay

            if spell[3] then
                icon.icon:SetVertexColor(unpack(spell[3]))
            else
                icon.icon:SetVertexColor(0.8, 0.8, 0.8)
            end

            if not icon.hideCount then
                local count = icon:CreateFontString("$parentCount", "OVERLAY")
                count:SetShadowColor(0, 0, 0)
                count:SetShadowOffset(1, -1)
                count:SetPoint(unpack(offsets[spell[2]].count))
                count:SetFont("Interface\\AddOns\\oUF_NeavRaid\\media\\fontVisitor.ttf", 13)
                icon.count = count
            end

             Auras.icons[spell[1]] = icon
        end
    end
    self.AuraWatch = Auras
end

local function UpdateThreat(self, _, unit)
    if self.unit ~= unit then
        return
    end

    local threatStatus = UnitThreatSituation(unit) or 0

    if threatStatus and threatStatus >= 2 then
        local r, g, b = GetThreatStatusColor(threatStatus)
        self.ThreatIndicator:SetBackdropBorderColor(r, g, b, 1)
    else
        self.ThreatIndicator:SetBackdropBorderColor(0, 0, 0, 0)
    end
end

local function UpdatePower(self, _, unit)
    if self.unit ~= unit then
        return
    end

    local _, powerToken = UnitPowerType(unit)

    if powerToken == "MANA" and nRaidDB.manaOnlyPowerBars then
        if not self.Power:IsVisible() then
            self.Health:ClearAllPoints()
            if nRaidDB.horizontalPowerBars then
                self.Health:SetPoint("BOTTOMLEFT", self, 0, 3)
                self.Health:SetPoint("TOPRIGHT", self)
            else
                self.Health:SetPoint("BOTTOMLEFT", self)
                self.Health:SetPoint("TOPRIGHT", self, -3.5, 0)
            end

            self.Power:Show()
        end
    elseif not nRaidDB.manaOnlyPowerBars then
        if not self.Power:IsVisible() then
            self.Health:ClearAllPoints()
            if nRaidDB.horizontalPowerBars then
                self.Health:SetPoint("BOTTOMLEFT", self, 0, 3)
                self.Health:SetPoint("TOPRIGHT", self)
            else
                self.Health:SetPoint("BOTTOMLEFT", self)
                self.Health:SetPoint("TOPRIGHT", self, -3.5, 0)
            end

            self.Power:Show()
        end
    else
        if self.Power:IsVisible() then
            self.Health:ClearAllPoints()
            self.Health:SetAllPoints(self)
            self.Power:Hide()
        end
    end
end

local function DeficitValue(self)
    if self >= 1000 then
        return format("-%.1f", self/1000)
    else
        return self
    end
end

local function GetUnitStatus(unit)
    if UnitIsDead(unit) then
        return DEAD
    elseif UnitIsGhost(unit) then
        return "Ghost"
    elseif not UnitIsConnected(unit) then
        return PLAYER_OFFLINE
    else
        return ""
    end
end

local function GetHealthText(unit, cur, max)
    local healthString
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
        healthString = GetUnitStatus(unit)
    else
        if (cur/max) < 0.95 then
            healthString = format("|cff%02x%02x%02x%s|r", 0.9*255, 0*255, 0*255, DeficitValue(max-cur))
        else
            healthString = ""
        end
    end

    return healthString
end

local function UpdateHealth(Health, unit, cur, max)
    if not UnitIsPlayer(unit) and not UnitIsFriend("player",unit) then
        local r, g, b = 0, 0.82, 1
        Health:SetStatusBarColor(r, g, b)
        Health.bg:SetVertexColor(r * 0.25, g * 0.25, b * 0.25)
    end

    Health.Value:SetText(GetHealthText(unit, cur, max))
end

local function CreateRaidLayout(self, unit)

    -- Block oUF_MovableFrames
    self.disableMovement = true

    self:RegisterForClicks("AnyUp")

    self:SetScript("OnEnter", function(self)
        UnitFrame_OnEnter(self)

        if self.Mouseover then
            self.Mouseover:SetAlpha(0.175)
        end
    end)

    self:SetScript("OnLeave", function(self)
        UnitFrame_OnLeave(self)

        if self.Mouseover then
            self.Mouseover:SetAlpha(0)
        end
    end)

    self:SetBackdrop({
          bgFile = "Interface\\Buttons\\WHITE8x8",
          insets = {
            left = -1.5,
            right = -1.5,
            top = -1.5,
            bottom = -1.5
        }
    })

    self:SetBackdropColor(0, 0, 0, 1)

        -- Health Bar

    self.Health = CreateFrame("StatusBar", "$parentHealthBar", self)
    self.Health:SetStatusBarTexture(statusbar)
    self.Health:SetAllPoints(self)
    self.Health:SetOrientation(nRaidDB.horizontalHealthBars and "HORIZONTAL" or "VERTICAL")

    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true

    self.Health.colorClass = true
    self.Health.colorClassNPC = true
    self.Health.colorDisconnected = true
    self.Health.Smooth = true

        -- Health Background

    self.Health.bg = self.Health:CreateTexture("$parentBackground", "BACKGROUND")
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.bg:SetTexture(statusbar)

    self.Health.bg.multiplier = 0.3

        -- Health Text

    self.Health.Value = self.Health:CreateFontString("$parentHealth")
    self.Health.Value:SetDrawLayer("OVERLAY", 6)
    self.Health.Value:SetPoint("TOP", self.Health, "CENTER", 0, 2)
    self.Health.Value:SetFont(font, fontSize)
    self.Health.Value:SetShadowOffset(1, -1)

        -- Name

    self.Name = self.Health:CreateFontString("$parentName")
    self.Name:SetDrawLayer("OVERLAY", 6)
    self.Name:SetPoint("BOTTOM", self.Health, "CENTER", 0, 3)
    self.Name:SetFont(font, fontSize)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetTextColor(1, 1, 1)
    self:Tag(self.Name, "[name:raid]")

        -- Power Bar

    if nRaidDB.powerBars then
        self.Power = CreateFrame("StatusBar", "$parentPower", self)
        self.Power:SetStatusBarTexture(statusbar)

        if nRaidDB.horizontalPowerBars then
            self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
            self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
            self.Power:SetOrientation("HORIZONTAL")
            self.Power:SetHeight(2.5)
        else
            self.Power:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 1, 0)
            self.Power:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", 1, 0)
            self.Power:SetOrientation("VERTICAL")
            self.Power:SetWidth(2.5)
        end

        self.Power.colorPower = true
        self.Power.Smooth = true

        self.Power.bg = self.Power:CreateTexture("$parentPowerBG", "BACKGROUND")
        self.Power.bg:SetAllPoints(self.Power)
        self.Power.bg:SetColorTexture(1, 1, 1)

        self.Power.bg.multiplier = 0.3

        tinsert(self.__elements, UpdatePower)
        self:RegisterEvent("UNIT_DISPLAYPOWER", UpdatePower)
        UpdatePower(self, _, unit)
    end

        -- Health Prediction

    local myBar = CreateFrame("StatusBar", "$parentMyHealthPredictionBar", self)
    myBar:SetStatusBarTexture(statusbar, "OVERLAY")
    myBar:SetStatusBarColor(0, 0.827, 0.765, 1)
    myBar.Smooth = true

    if nRaidDB.horizontalHealthBars then
        myBar:SetOrientation("HORIZONTAL")
        myBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
        myBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
        myBar:SetWidth(self:GetWidth())
    else
        myBar:SetOrientation("VERTICAL")
        myBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT")
        myBar:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
        myBar:SetHeight(self:GetHeight())
    end

    local otherBar = CreateFrame("StatusBar", "$parentOtherHealthPredictionBar", self)
    otherBar:SetStatusBarTexture(statusbar, "OVERLAY")
    otherBar:SetStatusBarColor(0.0, 0.631, 0.557, 1)
    otherBar.Smooth = true

    if nRaidDB.horizontalHealthBars then
        otherBar:SetOrientation("HORIZONTAL")
        otherBar:SetPoint("TOPLEFT", myBar:GetStatusBarTexture(), "TOPRIGHT")
        otherBar:SetPoint("BOTTOMLEFT", myBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        otherBar:SetWidth(self:GetWidth())
    else
        otherBar:SetOrientation("VERTICAL")
        otherBar:SetPoint("BOTTOMLEFT", myBar:GetStatusBarTexture(), "TOPLEFT")
        otherBar:SetPoint("BOTTOMRIGHT", myBar:GetStatusBarTexture(), "TOPRIGHT")
        otherBar:SetHeight(self:GetHeight())
    end

    local absorbBar = CreateFrame("StatusBar", "$parentTotalAbsorbBar", self)
    absorbBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    absorbBar:SetStatusBarColor(0.85, 0.85, 0.9, 1)
    absorbBar.Smooth = true

    if nRaidDB.horizontalHealthBars then
        absorbBar:SetOrientation("HORIZONTAL")
        absorbBar:SetPoint("TOPLEFT", otherBar:GetStatusBarTexture(), "TOPRIGHT")
        absorbBar:SetPoint("BOTTOMLEFT", otherBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        absorbBar:SetWidth(self:GetWidth())
    else
        absorbBar:SetOrientation("VERTICAL")
        absorbBar:SetPoint("BOTTOMLEFT", otherBar:GetStatusBarTexture(), "TOPLEFT")
        absorbBar:SetPoint("BOTTOMRIGHT", otherBar:GetStatusBarTexture(), "TOPRIGHT")
        absorbBar:SetHeight(self:GetHeight())
    end

    absorbBar.Overlay = absorbBar:CreateTexture("$parentOverlay", "OVERLAY", "TotalAbsorbBarOverlayTemplate", -1)
    absorbBar.Overlay:SetAllPoints(absorbBar:GetStatusBarTexture())

    local healAbsorbBar = CreateFrame("StatusBar", "$parentHealAbsorbBar", self)
    healAbsorbBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    healAbsorbBar:SetStatusBarColor(0.9, 0.1, 0.3, 1)
    healAbsorbBar:SetReverseFill(true)
    healAbsorbBar.Smooth = true

    if nRaidDB.horizontalHealthBars then
        healAbsorbBar:SetOrientation("HORIZONTAL")
        healAbsorbBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
        healAbsorbBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
        healAbsorbBar:SetWidth(self.Health:GetWidth())
    else
        healAbsorbBar:SetOrientation("VERTICAL")
        healAbsorbBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT")
        healAbsorbBar:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
        healAbsorbBar:SetHeight(self.Health:GetHeight())
    end

    local overAbsorb = self.Health:CreateTexture("$parentOverAbsorb", "OVERLAY")

    if nRaidDB.horizontalHealthBars then
        overAbsorb:SetPoint("TOPLEFT", self.Health, "TOPRIGHT")
        overAbsorb:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT")
        overAbsorb:SetWidth(3)
    else
        overAbsorb:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT")
        overAbsorb:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT")
        overAbsorb:SetHeight(3)
    end

    local overHealAbsorb = self.Health:CreateTexture("$parentOverHealAbsorb", "OVERLAY")

    if nRaidDB.horizontalHealthBars then
        overHealAbsorb:SetPoint("TOPLEFT", self.Health, "TOPRIGHT")
        overHealAbsorb:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT")
        overHealAbsorb:SetWidth(3)
    else
        overHealAbsorb:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT")
        overHealAbsorb:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT")
        overHealAbsorb:SetHeight(3)
    end

    self.HealthPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        healAbsorbBar = healAbsorbBar,
        absorbBar = absorbBar,
        overAbsorb = overAbsorb,
        overHealAbsorb = overHealAbsorb,
        maxOverflow = 1.05,
        frequentUpdates = true
    }

        -- Afk /offline timer, using frequentUpdates function from oUF tags

    self.NotHere = self.Health:CreateFontString("$parentStatusText", "OVERLAY")
    self.NotHere:SetPoint("CENTER", self, "BOTTOM")
    self.NotHere:SetFont(font, 11, "OUTLINE")
    self.NotHere:SetShadowOffset(0, 0)
    self.NotHere:SetTextColor(0, 1, 0)
    self.NotHere.frequentUpdates = 1
    self:Tag(self.NotHere, "[status:raid]")

        -- Mouseover Darklight

    self.Mouseover = self.Health:CreateTexture("$parentDarklight", "OVERLAY")
    self.Mouseover:SetAllPoints(self.Health)
    self.Mouseover:SetTexture(statusbar)
    self.Mouseover:SetVertexColor(0, 0, 0)
    self.Mouseover:SetAlpha(0)

        -- Threat Glow

    self.ThreatIndicator = CreateFrame("Frame", "$parentThreatGlow", self)
    self.ThreatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
    self.ThreatIndicator:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
    self.ThreatIndicator:SetBackdrop({edgeFile = "Interface\\AddOns\\oUF_NeavRaid\\media\\textureGlow", edgeSize = 3})
    self.ThreatIndicator:SetBackdropBorderColor(0, 0, 0, 0)
    self.ThreatIndicator:SetFrameLevel(self:GetFrameLevel() - 1)

    tinsert(self.__elements, UpdateThreat)
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)

        -- Leader Icon

    self.LeaderIndicator = self.Health:CreateTexture("$parentLeaderIcon", "OVERLAY", nil, 7)
    self.LeaderIndicator:SetSize(12, 12)
    self.LeaderIndicator:SetPoint("LEFT", self.Health, "TOPLEFT", 1, 2)

        -- Assist Icon

    self.AssistantIndicator = self.Health:CreateTexture("$parentAssistIcon", "OVERLAY", nil, 7)
    self.AssistantIndicator:SetSize(12, 12)
    self.AssistantIndicator:SetPoint("LEFT", self.Health, "TOPLEFT", 1, 2)

        -- Raid Target Indicator

    self.RaidTargetIndicator = self.Health:CreateTexture("$parentRaidTargetIcon", "OVERLAY", nil, 7)
    self.RaidTargetIndicator:SetSize(16, 16)
    self.RaidTargetIndicator:SetPoint("CENTER", self, "TOP")

        -- Phase Icon

    self.PhaseIndicator = self.Health:CreateTexture("$parentPhaseIcon", "OVERLAY", nil, 7)
    self.PhaseIndicator:SetSize(20, 20)
    self.PhaseIndicator:SetPoint("CENTER")

        -- Readycheck icons

    self.ReadyCheckIndicator = self.Health:CreateTexture("$parentReadyCheckIcon", "OVERLAY", nil, 7)
    self.ReadyCheckIndicator:SetPoint("CENTER")
    self.ReadyCheckIndicator:SetSize(20, 20)
    self.ReadyCheckIndicator.finishedTime = DEFAULT_READY_CHECK_STAY_TIME
    self.ReadyCheckIndicator.fadeTime = 1

        -- Debuff icons, using freebAuras from oUF_Freebgrid

    self.FreebAuras = CreateFrame("Frame", "$parentFreebAuras", self)
    self.FreebAuras:SetSize(nRaidDB.debuffSize, nRaidDB.debuffSize)
    self.FreebAuras:SetPoint("CENTER", self.Health, 0, 3)

        -- Create Indicators

    CreateIndicators(self, unit)

        -- Group Role Indicator

    if nRaidDB.showRoleIcons then
        self.GroupRoleIndicator = self.Health:CreateTexture("$parentRoleIcon", "OVERLAY", nil, 6)
        self.GroupRoleIndicator:SetSize(12, 12)
        self.GroupRoleIndicator:SetPoint("BOTTOM", self.Health, 0, -6)
    end

        -- Resurrect Indicator

    self.ResurrectIndicator = self.Health:CreateTexture("$parentResIcon", "OVERLAY", nil, 7)
    self.ResurrectIndicator:SetSize(24, 24)
    self.ResurrectIndicator:SetPoint("CENTER", self.Health)
    self.ResurrectIndicator.Override = function(self, event, ...)
        local incomingResurrect = UnitHasIncomingResurrection(self.unit)

        if incomingResurrect then
            self.ResurrectIndicator:Show()
            self.Name:SetTextColor(1, 1, 1, 0)
            self.Health.Value:SetTextColor(0.9, 0, 0, 0)
        else
            self.ResurrectIndicator:Hide()
            self.Name:SetTextColor(1, 1, 1, 1)
            self.Health.Value:SetTextColor(0.9, 0, 0, 1)
        end
    end

        -- Player Target Border

    self.TargetBorder = self.Health:CreateTexture("$parentTargetBorder", "OVERLAY")
    self.TargetBorder:SetAllPoints(self.Health)
    self.TargetBorder:SetTexture("Interface\\Addons\\oUF_NeavRaid\\media\\borderTarget")
    self.TargetBorder:SetVertexColor(1, 1, 1)
    self.TargetBorder:Hide()

    self:RegisterEvent("PLAYER_TARGET_CHANGED", function()
        if UnitIsUnit("target", self.unit) then
            self.TargetBorder:Show()
        else
            self.TargetBorder:Hide()
        end
    end)

        -- Range Check

    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }

    return self
end

SlashCmdList["oUF_Neav_Raid_AnchorToggle"] = function(msg)
    if InCombatLockdown() then
        print("|oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid: You cant do this in combat!")
    else
        if not raidFrames:IsShown() then
            raidFrames:Show()
            tankFrames:Show()
        else
            raidFrames:Hide()
            tankFrames:Hide()
        end
    end
end
SLASH_oUF_Neav_Raid_AnchorToggle1 = "/neavrt"

oUF:RegisterStyle("oUF_Neav_Raid", CreateRaidLayout)
oUF:RegisterStyle("oUF_Neav_Raid_MT", CreateRaidLayout)
oUF:Factory(function(self)
    self:SetActiveStyle("oUF_Neav_Raid")

    local relpoint, anchpoint, xOffset, yOffset, columnRelPoint
    local spacing = nRaidDB.frameOffset
    local orientation = nRaidDB.orientation
    local initialAnchor = nRaidDB.initialAnchor

    if orientation == "HORIZONTAL" then
        if initialAnchor == "TOPLEFT" then
            relpoint = "LEFT"
            anchpoint = "TOP"
            xOffset = spacing
            yOffset = spacing
            columnRelPoint = "BOTTOMLEFT"
        elseif initialAnchor == "TOPRIGHT" then
            relpoint = "LEFT"
            anchpoint = "TOP"
            xOffset = spacing
            yOffset = spacing
            columnRelPoint = "BOTTOMRIGHT"
        elseif initialAnchor == "BOTTOMLEFT" then
            relpoint = "RIGHT"
            anchpoint = "BOTTOM"
            xOffset = -spacing
            yOffset = spacing
            columnRelPoint = "TOPLEFT"
        elseif initialAnchor == "BOTTOMRIGHT" then
            relpoint = "RIGHT"
            anchpoint = "BOTTOM"
            xOffset = -spacing
            yOffset = spacing
            columnRelPoint = "TOPRIGHT"
        end
    elseif orientation == "VERTICAL" then
        if initialAnchor == "TOPRIGHT" then
            relpoint = "TOP"
            anchpoint = "RIGHT"
            xOffset = -spacing
            yOffset = -spacing
            columnRelPoint = "TOPLEFT"
        elseif initialAnchor == "TOPLEFT" then
            relpoint = "TOP"
            anchpoint = "LEFT"
            xOffset = spacing
            yOffset = -spacing
            columnRelPoint = "TOPRIGHT"
        elseif initialAnchor == "BOTTOMLEFT" then
            relpoint = "BOTTOM"
            anchpoint = "LEFT"
            xOffset = spacing
            yOffset = spacing
            columnRelPoint = "BOTTOMRIGHT"
        elseif initialAnchor == "BOTTOMRIGHT" then
            relpoint = "BOTTOM"
            anchpoint = "RIGHT"
            xOffset = -spacing
            yOffset = spacing
            columnRelPoint = "BOTTOMLEFT"
        end
    end

    local sortByRole = nRaidDB.sortByRole

    if not sortByRole then
        local raid = {}
        for i = 1, 8 do
            raid[i] = self:SpawnHeader("oUF_Raid"..i, nil, "party,raid,solo",
            "showSolo", nRaidDB.showSolo,
            "showParty", nRaidDB.showParty,
            "showRaid", true,
            "showPlayer", true,
            "point", relpoint,
            "groupFilter", tostring(i),
            "groupingOrder", tostring(i),
            "groupBy", "GROUP",
            "maxColumns", 8,
            "unitsPerColumn", 5,
            "columnAnchorPoint", anchpoint,
            "columnSpacing", spacing,
            "yOffset", yOffset,
            "xOffset", xOffset,
            "templateType", "Button",
            "oUF-initialConfigFunction", ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
            ]]):format(nRaidDB.frameWidth, nRaidDB.frameHeight))

            if i == 1 then
                if not nRaidDB.anchorToControls then
                    local toggleButton = _G["oUF_NeavRaidControlsFrame"]
                    raid[i]:SetPoint("TOPLEFT", toggleButton, "TOPRIGHT", 5, 0)
                else
                    raid[i]:SetPoint(initialAnchor, raidFrames)
                end
            else
                if orientation == "VERTICAL" then
                    raid[i]:SetPoint(initialAnchor, raid[i-1], columnRelPoint, xOffset, 0)
                else
                    if initialAnchor == "TOPRIGHT" or initialAnchor == "TOPLEFT" then
                        raid[i]:SetPoint(initialAnchor, raid[i-1], columnRelPoint, 0, -yOffset)
                    else
                        raid[i]:SetPoint(initialAnchor, raid[i-1], columnRelPoint, 0, yOffset)
                    end
                end
            end

            raid[i]:SetScale(nRaidDB.frameScale)
            raid[i]:SetFrameStrata("LOW")
        end
    else
        local raid = self:SpawnHeader("oUF_Raid", nil, "party,raid,solo",
        "showSolo", nRaidDB.showSolo,
        "showParty", nRaidDB.showParty,
        "showRaid", true,
        "showPlayer", true,
        "point", relpoint,
        "groupFilter", "TANK,DAMAGER,HEALER,NONE",
        "groupingOrder", "TANK,DAMAGER,HEALER,NONE",
        "roleFilter", "TANK,DAMAGER,HEALER,NONE",
        "groupBy", "ASSIGNEDROLE",
        "maxColumns", 8,
        "unitsPerColumn", 5,
        "columnAnchorPoint", anchpoint,
        "columnSpacing", spacing,
        "yOffset", yOffset,
        "xOffset", xOffset,
        "templateType", "Button",
        "oUF-initialConfigFunction", ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
        ]]):format(nRaidDB.frameWidth, nRaidDB.frameHeight))

        if not nRaidDB.anchorToControls  then
            local toggleButton = _G["oUF_NeavRaidControlsFrame"]
            raid:SetPoint("TOPLEFT", toggleButton, "TOPRIGHT", 5, 0)
        else
            raid:SetPoint(initialAnchor, raidFrames)
        end

        raid:SetScale(nRaidDB.frameScale)
        raid:SetFrameStrata("LOW")
    end

        -- Main Tank/Assist Frames

    if nRaidDB.assistFrame then
        self:SetActiveStyle("oUF_Neav_Raid_MT")

        local tanks = self:SpawnHeader("oUF_Neav_Raid_MT", nil, "solo,party,raid",
            "showRaid", true,
            "showParty", false,
            "yOffset", -spacing,
            "template", "oUF_NeavRaid_MT_Target_Template",     -- Target
            "sortMethod", "INDEX",
            "groupFilter", "MAINTANK,MAINASSIST",
            "oUF-initialConfigFunction", ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
            ]]):format(nRaidDB.frameWidth, nRaidDB.frameHeight))

        tanks:SetPoint("TOPLEFT", tankFrames, "TOPLEFT")
        tanks:SetScale(nRaidDB.frameScale)
        tanks:SetFrameStrata("LOW")
    end
end)
