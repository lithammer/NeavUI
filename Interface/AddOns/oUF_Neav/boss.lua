
local _, ns = ...
local config = ns.Config

if not config.units.boss.show then
    return
end

local function EnableMouseOver(self)
    self.Health.Value:Hide()

    if self.Power and self.Power.Value then
        self.Power.Value:Hide()
    end

    self:HookScript("OnEnter", function(self)
        self.Health.Value:Show()

        if self.Power and self.Power.Value then
            self.Power.Value:Show()
        end
    end)

    self:HookScript("OnLeave", function(self)
        self.Health.Value:Hide()

        if self.Power and self.Power.Value then
            self.Power.Value:Hide()
        end
    end)
end

local function UpdateHealth(Health, unit, cur, max)
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end

    Health.Value:SetText(ns.GetHealthText(unit, cur, max))

    local self = Health:GetParent()
    if self.Name.Bg then
        self.Name.Bg:SetVertexColor(GameTooltip_UnitColor(unit))
    end
end

local function UpdatePower(Power, unit, cur, min, max)
    if UnitIsDead(unit) then
        Power:SetValue(0)
    end

    Power.Value:SetText(ns.GetPowerText(unit, cur, max))
end

local function CreateBossLayout(self, unit)
    self:RegisterForClicks("AnyUp")
    self:EnableMouse(true)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:SetSize(132, 46)
    self:SetScale(config.units.boss.scale)
    self:SetFrameStrata("LOW")

        -- Healthbar

    self.Health = CreateFrame("StatusBar", "$parentHealthBar", self)

        -- Texture

    self.Texture = self.Health:CreateTexture("$parentTexture", "ARTWORK")
    self.Texture:SetSize(250, 129)
    self.Texture:SetPoint("CENTER", self, 31, -24)
    self.Texture:SetTexture("Interface\\TargetingFrame\\UI-UnitFrame-Boss")

    self.Health:SetStatusBarTexture(config.media.statusbar, "BORDER")
    self.Health:SetSize(115, 8)
    self.Health:SetPoint("TOPRIGHT", self.Texture, -105, -43)

    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- Health Text

    self.Health.Value = self.Health:CreateFontString("$parentTexture", "ARTWORK")
    self.Health.Value:SetFont(config.font.normal, config.font.normalSize)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint("CENTER", self.Health)

        -- Powerbar

    self.Power = CreateFrame("StatusBar", "$parentPowerBar", self)
    self.Power:SetStatusBarTexture(config.media.statusbar, "BORDER")
    self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -4)
    self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -4)
    self.Power:SetHeight(self.Health:GetHeight())

    self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Power:SetBackdropColor(0, 0, 0, 0.55)

    self.Power.PostUpdate = UpdatePower
    self.Power.frequentUpdates = true
    self.Power.Smooth = true

    self.Power.colorPower = true

        -- Power Text

    self.Power.Value = self.Health:CreateFontString("$parentPowerText", "ARTWORK")
    self.Power.Value:SetFont(config.font.normal, config.font.normalSize)
    self.Power.Value:SetShadowOffset(1, -1)
    self.Power.Value:SetPoint("CENTER", self.Power)

        -- Name

    self.Name = self.Health:CreateFontString("$parentNameText", "ARTWORK")
    self.Name:SetFontObject("Neav_FontName")
    self.Name:SetJustifyH("CENTER")
    self.Name:SetSize(110, 10)
    self.Name:SetPoint("BOTTOM", self.Health, "TOP", 0, 6)

    self:Tag(self.Name, "[neav:name]")

        -- Name Background

    self.Name.Bg = self.Health:CreateTexture("$parentBackground", "BACKGROUND")
    self.Name.Bg:SetHeight(18)
    self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
    self.Name.Bg:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT")
    self.Name.Bg:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT")
    self.Name.Bg:SetTexture("Interface\\AddOns\\oUF_Neav\\media\\nameBackground")

        -- Level

    self.Level = self.Health:CreateFontString("$parentLevelText", "ARTWORK")
    self.Level:SetFont(config.font.numberFont, 16, "OUTLINE")
    self.Level:SetShadowOffset(0, 0)
    self.Level:SetPoint("CENTER", self.Texture, 23, -2)

    self:Tag(self.Level, "[neav:level]")

        -- Raid Target Indicator

    self.RaidTargetIndicator = self.Health:CreateTexture("$parentRaidTargetIndicator", "OVERLAY", self)
    self.RaidTargetIndicator:SetPoint("CENTER", self, "TOPRIGHT", -9, -5)
    self.RaidTargetIndicator:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    self.RaidTargetIndicator:SetSize(26, 26)

        -- Threat Glow Texture

    self.ThreatGlow = self:CreateTexture("$parentThreatGlow", "OVERLAY")
    self.ThreatGlow:SetAlpha(0)
    self.ThreatGlow:SetSize(241, 100)
    self.ThreatGlow:SetPoint("TOPRIGHT", self.Texture, -11, 4)
    self.ThreatGlow:SetTexture("Interface\\TargetingFrame\\UI-UnitFrame-Boss-Flash")
    self.ThreatGlow:SetTexCoord(0.0, 0.945, 0.0, 0.73125)
    self.feedbackUnit = "player"

        -- Buffs

    self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
    self.Buffs.size = 25
    self.Buffs:SetHeight(self.Buffs.size * 1.1)
    self.Buffs:SetWidth(self.Buffs.size * 5)
    self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    self.Buffs.initialAnchor = "TOPLEFT"
    self.Buffs["growth-x"] = "RIGHT"
    self.Buffs["growth-y"] = "DOWN"
    self.Buffs.num = 4
    self.Buffs.spacing = 4.5

    self.Buffs.PostCreateIcon = ns.UpdateAuraIcons
    self.Buffs.PostUpdateIcon = ns.PostUpdateIcon

        -- Castbar

    if config.units.boss.castbar.show then
        self.Castbar = CreateFrame("StatusBar", self:GetName().."Castbar", self)
        self.Castbar:SetStatusBarTexture(config.media.statusbar)
        self.Castbar:SetSize(150, 18)
        self.Castbar:SetStatusBarColor(unpack(config.units.boss.castbar.color))
        self.Castbar:SetPoint("BOTTOM", self, "TOP", 10, 13)

        self.Castbar.Bg = self.Castbar:CreateTexture("$parentBackground", "BACKGROUND")
        self.Castbar.Bg:SetTexture("Interface\\Buttons\\WHITE8x8")
        self.Castbar.Bg:SetAllPoints(self.Castbar)
        self.Castbar.Bg:SetVertexColor(config.units.boss.castbar.color[1]*0.3, config.units.boss.castbar.color[2]*0.3, config.units.boss.castbar.color[3]*0.3, 0.8)

        self.Castbar:CreateBeautyBorder(11)
        self.Castbar:SetBeautyBorderPadding(3)

        ns.CreateCastbarStrings(self, false)

        self.Castbar.CustomDelayText = ns.CustomDelayText
        self.Castbar.CustomTimeText = ns.CustomTimeText

        self.Castbar.PostCastStart = function(self, unit)
            if self.notInterruptible then
                ns.ColorBorder(self, "white", config.units.boss.castbar.interruptColor[1], config.units.boss.castbar.interruptColor[2], config.units.boss.castbar.interruptColor[3], 0)
            else
                ns.ColorBorder(self, "default", 1, 1, 1, 0)
            end
        end
    end

        -- Mouseover Text

    if config.units.boss.mouseoverText then
        EnableMouseOver(self)
    end

    return self
end

oUF:RegisterStyle("oUF_Neav_Boss", CreateBossLayout)
oUF:Factory(function(self)
    oUF:SetActiveStyle("oUF_Neav_Boss")

    local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
        boss[i] = self:Spawn("boss"..i, "oUF_Neav_BossFrame"..i)
        boss[i]:SetFrameStrata("LOW")

        if i == 1 then
            boss[i]:SetPoint(unpack(config.units.boss.position))
        else
            boss[i]:SetPoint("TOPLEFT", boss[i-1], "BOTTOMLEFT", 0, (config.units.boss.castbar.show and -80) or -50)
        end
    end
end)
