
local _, ns = ...
local config = ns.Config

if not config.units.arena.show then
    return
end

SetCVar("showArenaEnemyFrames", 0)

local function UpdateHealth(Health, unit, cur, max)
    if Health.Value then
        Health.Value:SetText(ns.GetHealthText(unit, cur, max))
    end
end

local function UpdatePower(Power, unit, cur, min, max)
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
        Power:SetValue(0)
    end

    Power.Value:SetText(ns.GetPowerText(unit, cur, max))
end

local function FilterArenaBuffs(...)

    local icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster = ...
    local buffList = config.units.arena.buffList

    if buffList[name] then
        return true
    end
    return false
end

local function CreateArenaLayout(self, unit)
    self:RegisterForClicks("AnyUp")
    self:EnableMouse(true)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:SetFrameStrata("LOW")

    if unit:match("arena%dtarget") then
        self.targetUnit = true
    else
        self.arenaUnit = true
    end

        -- Health Bar

    self.Health = CreateFrame("StatusBar", "$parentHealthBar", self)

        -- Frame Texture

    self.Texture = self.Health:CreateTexture("$parentTexture", "ARTWORK", nil, 7)
    self.Texture:SetSize(256, 128)
    self.Texture:SetPoint("TOPLEFT", self, 0, 0)
    self.Texture:SetAtlas("UnitFrame")

    self.Health:SetStatusBarTexture(config.media.statusbar, "BORDER")
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 71, -58)
    self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 22)
    self.Health:SetSize(138,34.9999)

    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health.frequentUpdates = true
    self.Health.colorClass = true
    self.Health.colorDisconnected = true
    self.Health.colorReaction = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- Power Bar

    if self.arenaUnit then
        self.Power = CreateFrame("StatusBar", "$parentPowerBar", self)
        self.Power:SetStatusBarTexture(config.media.statusbar, "BORDER")
        self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 71, -95)
        self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 4)

        self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
        self.Power:SetBackdropColor(0, 0, 0, 0.55)

        self.Power.PostUpdate = UpdatePower
        self.Power.frequentUpdates = true
        self.Power.Smooth = true

        self.Power.colorPower = true
    end

        -- Name

    self.Name = self.Health:CreateFontString("$parentNameText", "ARTWORK")
    self.Name:SetFontObject("Neav_FontName")
    self.Name:SetJustifyH("LEFT")
    self.Name:SetPoint("TOPLEFT", self, 76, -26)
    self.Name:SetPoint("BOTTOMRIGHT", self, -6, 60)

    self:Tag(self.Name, "[neav:name]")
    self.UNIT_NAME_UPDATE = UpdateFrame

        -- Spec Icon

    self.PVPSpecIcon = CreateFrame("Frame", "$parentSpecIcon", self)
    self.PVPSpecIcon:SetFrameStrata("BACKGROUND")
    self.PVPSpecIcon.UseCircle = true

    if self.arenaUnit then

            -- Health Text

        self.Health.Value = self.Health:CreateFontString("$parentHealthText", "ARTWORK")
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize+2, nil)
        self.Health.Value:SetShadowOffset(1, -1)
        self.Health.Value:SetPoint("CENTER", self.Health)

            -- Health Prediction

        local myBar = CreateFrame("StatusBar", "$parentMyHealthPredictionBar", self)
        myBar:SetStatusBarTexture(config.media.statusbar, "ARTWORK", nil, 6)
        myBar:SetStatusBarColor(0, 0.827, 0.765, 1)
        myBar:SetOrientation("HORIZONTAL")
        myBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
        myBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
        myBar:SetWidth(self.Health:GetWidth())
        myBar.Smooth = true

        local otherBar = CreateFrame("StatusBar", "$parentOtherHealthPredictionBar", self)
        otherBar:SetStatusBarTexture(config.media.statusbar, "ARTWORK", nil, 6)
        otherBar:SetStatusBarColor(0.0, 0.631, 0.557, 1)
        otherBar:SetOrientation("HORIZONTAL")
        otherBar:SetPoint("TOPLEFT", myBar:GetStatusBarTexture(), "TOPRIGHT")
        otherBar:SetPoint("BOTTOMLEFT", myBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        otherBar:SetWidth(self.Health:GetWidth())
        otherBar.Smooth = true

        local absorbBar = CreateFrame("StatusBar", "$parentTotalAbsorbBar", self)
        absorbBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
        absorbBar:SetStatusBarColor(0.85, 0.85, 0.9, 1)
        absorbBar:SetOrientation("HORIZONTAL")
        absorbBar:SetPoint("TOPLEFT", otherBar:GetStatusBarTexture(), "TOPRIGHT")
        absorbBar:SetPoint("BOTTOMLEFT", otherBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        absorbBar:SetWidth(self.Health:GetWidth())
        absorbBar.Smooth = true

        absorbBar.Overlay = absorbBar:CreateTexture("$parentOverlay", "ARTWORK", "TotalAbsorbBarOverlayTemplate", 1)
        absorbBar.Overlay:SetAllPoints(absorbBar:GetStatusBarTexture())

        local healAbsorbBar = CreateFrame("StatusBar", "$parentHealAbsorbBar", self)
        healAbsorbBar:SetReverseFill(true)
        healAbsorbBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
        healAbsorbBar:SetStatusBarColor(0.9, 0.1, 0.3, 1)
        healAbsorbBar:SetOrientation("HORIZONTAL")
        healAbsorbBar:SetPoint("TOP", self.Health:GetStatusBarTexture())
        healAbsorbBar:SetPoint("BOTTOM", self.Health:GetStatusBarTexture())
        healAbsorbBar:SetPoint("RIGHT", self.Health:GetStatusBarTexture())
        healAbsorbBar:SetWidth(self.Health:GetWidth())
        healAbsorbBar:SetHeight(self.Health:GetHeight())
        healAbsorbBar.Smooth = true

        local overAbsorb = self.Health:CreateTexture("$parentOverAbsorb", "OVERLAY")
        overAbsorb:SetPoint("TOP")
        overAbsorb:SetPoint("BOTTOM")
        overAbsorb:SetPoint("RIGHT", self.Health, "RIGHT")
        overAbsorb:SetWidth(10)
        overAbsorb:SetHeight(self.Health:GetHeight())

        local overHealAbsorb = self.Health:CreateTexture("$parentOverHealAbsorb", "OVERLAY")
        overHealAbsorb:SetPoint("TOP")
        overHealAbsorb:SetPoint("BOTTOM")
        overHealAbsorb:SetPoint("RIGHT", self.Health, "LEFT")
        overHealAbsorb:SetWidth(10)
        overHealAbsorb:SetHeight(self.Health:GetHeight())

        self.HealthPrediction = {
            myBar = myBar,
            otherBar = otherBar,
            healAbsorbBar = healAbsorbBar,
            absorbBar = absorbBar,
            overAbsorb = overAbsorb,
            overHealAbsorb = overHealAbsorb,
            maxOverflow = 1.00,
            frequentUpdates = true
        }

            -- Power Text

        self.Power.Value = self.Health:CreateFontString("$parentPowerText", "ARTWORK")
        self.Power.Value:SetFont(config.font.normal, config.font.normalSize, nil)
        self.Power.Value:SetShadowOffset(1, -1)
        self.Power.Value:SetPoint("CENTER", self.Power)

            -- Trinket Icon

        self.Trinket = CreateFrame("Frame", "$parentTrinketIcon", self)
        self.Trinket:SetSize(38, 38)
        self.Trinket:SetFrameStrata("MEDIUM")
        self.Trinket:SetPoint("CENTER", self, "BOTTOMLEFT", 46, 26)
        self.Trinket:CreateBeautyBorder(11)
        self.Trinket:SetBeautyBorderPadding(3)

            -- Crowd Control Icon

        self.CCIcon = CreateFrame("Frame", "$parentCCIcon", self)
        self.CCIcon:SetFrameStrata("BACKGROUND")
        self.CCIcon:SetSize(38, 38)
        self.CCIcon:SetPoint("RIGHT", self.Trinket, "LEFT", -15, 0)
        self.CCIcon:CreateBeautyBorder(11)
        self.CCIcon:SetBeautyBorderPadding(3)

            -- Spec Icon

        self.PVPSpecIcon:SetSize(52, 52)
        self.PVPSpecIcon:SetPoint("CENTER", self, "TOPLEFT", 42, -41)

            -- Raid Target Indicator

        self.RaidTargetIndicator = self.Health:CreateTexture("$parentRaidTargetIndicator", "OVERLAY", self)
        self.RaidTargetIndicator:SetPoint("CENTER", self.PVPSpecIcon, "TOP", 0, 0)
        self.RaidTargetIndicator:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
        self.RaidTargetIndicator:SetSize(26, 26)

            -- Buffs/Debuffs

        self.Auras = CreateFrame("Frame", "$parentAuras", self)
        self.Auras.gap = true
        self.Auras.size = config.units.arena.auraSize
        self.Auras:SetHeight(self.Auras.size * 5)
        self.Auras:SetWidth(self.Auras.size * 9)
        self.Auras:SetPoint("TOPLEFT", self.Name, "TOPRIGHT", 13, 0)
        self.Auras.initialAnchor = "TOPLEFT"
        self.Auras["growth-x"] = "RIGHT"
        self.Auras["growth-y"] = "DOWN"
        self.Auras.numBuffs = (config.units.arena.debuffsOnly and 0 ) or config.units.arena.numBuffs
        self.Auras.numDebuffs = 8
        self.Auras.numTotal = 16
        self.Auras.onlyShowPlayer = config.units.arena.onlyShowPlayer
        self.Auras.spacing = 4.5
        self.Auras.showStealableBuffs = true
        self.Auras.showDebuffType = true

        if config.units.arena.filterBuffs then
            self.Auras.CustomFilter = FilterArenaBuffs
        else
            self.Auras.buffFilter = "HELPFUL|CANCELABLE"
        end

        self.Auras.PostUpdateGapIcon = function(self, unit, icon, visibleBuffs)
            icon:Hide()
        end
        self.Auras.PostCreateIcon = ns.UpdateAuraIcons
        self.Auras.PostUpdateIcon = ns.PostUpdateIcon

            -- Castbar

        if config.units.arena.castbar.show then
            self.Castbar = CreateFrame("StatusBar", self:GetName().."Castbar", self)
            self.Castbar:SetPoint("TOPLEFT", self.Trinket, "BOTTOMLEFT", 22, -10)
            self.Castbar:SetStatusBarTexture(config.media.statusbar)
            self.Castbar:SetParent(self)
            self.Castbar:SetHeight(config.units.arena.castbar.height)
            self.Castbar:SetWidth(config.units.arena.castbar.width)
            self.Castbar.castColor = config.units.arena.castbar.castColor
            self.Castbar.channeledColor = config.units.arena.castbar.channeledColor
            self.Castbar.nonInterruptibleColor = config.units.arena.castbar.nonInterruptibleColor
            self.Castbar.failedCastColor = config.units.arena.castbar.failedCastColor
            self.Castbar.timeToHold = 1

            self.Castbar.IconSize = self.Castbar:GetHeight()

            self.Castbar.Background = self.Castbar:CreateTexture(nil, "BACKGROUND")
            self.Castbar.Background:SetTexture("Interface\\Buttons\\WHITE8x8")
            self.Castbar.Background:SetAllPoints(self.Castbar)

            self.Castbar:CreateBeautyBorder(11)
            self.Castbar:SetBeautyBorderPadding(4+self.Castbar.IconSize, 3, 3, 3, 4+self.Castbar.IconSize, 3, 3, 3, 3)

            self.Castbar.Icon = self.Castbar:CreateTexture("$parentIcon", "BACKGROUND")
            self.Castbar.Icon:SetSize(self.Castbar.IconSize, self.Castbar.IconSize)
            self.Castbar.Icon:SetPoint("TOPRIGHT", self.Castbar, "TOPLEFT", 0, 0)
            self.Castbar.Icon:SetColorTexture(1, 1, 1)
            self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            ns.CreateCastbarStrings(self, false)

            self.Castbar.CustomDelayText = ns.CustomDelayText
            self.Castbar.CustomTimeText = ns.CustomTimeText

            self.Castbar.PostCastStart = ns.UpdateCastbarColor
            self.Castbar.PostChannelStart = ns.UpdateCastbarColor
            self.Castbar.PostCastInterruptible = ns.UpdateCastbarColor
            self.Castbar.PostCastNotInterruptible = ns.UpdateCastbarColor

            self.Castbar.PostCastInterrupted = function(self, unit)
                self:SetStatusBarColor(unpack(self.failedCastColor))
                self.Background:SetVertexColor(self.failedCastColor[1]*0.3, self.failedCastColor[2]*0.3, self.failedCastColor[3]*0.3)
            end
        end

        self:SetSize(210, 115)
    end

        -- Target of Target Frame

    if self.targetUnit then
        self:SetSize(110, 20)

        self.Texture:SetTexture("Interface\\AddOns\\oUF_Neav\\media\\customTargetTargetTexture")
        self.Texture:SetPoint("CENTER", self, 0, -2)
        self.Texture:SetSize(128, 64)
        self.Texture:SetDrawLayer("ARTWORK", 2)

        self.PVPSpecIcon:SetSize(37, 37)
        self.PVPSpecIcon:SetPoint("TOPLEFT", self.Texture, 7, -6)

        self.Name:SetJustifyH("LEFT")
        self.Name:SetJustifyV("BOTTOM")
        self.Name:SetSize(250, 10)
        self.Name:ClearAllPoints()
        self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 2)

        self.Health:SetSize(50, 6)
        self.Health:ClearAllPoints()
        self.Health:SetPoint("CENTER", self.Texture, 5, 8)
    end

    self:SetScale(config.units.arena.scale)

    return self
end

oUF:RegisterStyle("oUF_Neav_Arena", CreateArenaLayout)
oUF:Factory(function(self)
    oUF:SetActiveStyle("oUF_Neav_Arena")

    local arena = {}
    local arenaTarget = {}
    for i = 1, 5 do
        arena[i] = self:Spawn("arena"..i, "oUF_Neav_ArenaFrame"..i)
        arena[i]:SetFrameStrata("LOW")

        if i == 1 then
            arena[i]:SetPoint(unpack(config.units.arena.position))
        else
            arena[i]:SetPoint("TOPLEFT", arena[i-1], "BOTTOMLEFT", 0, -45)
        end

        arenaTarget[i] = self:Spawn("arena"..i.."target", "oUF_Neav_ArenaFrame"..i.."Target")
        arenaTarget[i]:SetPoint("CENTER", arena[i], "TOPLEFT", 110, 0)
    end
end)
