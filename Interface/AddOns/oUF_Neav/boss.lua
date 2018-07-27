
local _, ns = ...
local config = ns.Config

local bossAnchor = CreateFrame("Frame", "oUF_Neav_Boss_Anchor", UIParent)
bossAnchor:SetSize(250, 129)
bossAnchor:SetPoint(unpack(config.units.boss.position))
bossAnchor:SetMovable(true)
bossAnchor:SetUserPlaced(true)
bossAnchor:SetClampedToScreen(true)
bossAnchor:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
bossAnchor:SetBackdropColor(0, 1, 0, 0.55)
bossAnchor:EnableMouse(true)
bossAnchor:RegisterForDrag("LeftButton")
bossAnchor:Hide()
bossAnchor.text = bossAnchor:CreateFontString("$parentText", "OVERLAY")
bossAnchor.text:SetAllPoints(bossAnchor)
bossAnchor.text:SetFont("Fonts\\ARIALN.ttf", 13)
bossAnchor.text:SetText("oUF_Neav\nBoss")

bossAnchor:SetScript("OnDragStart", function()
    if (IsShiftKeyDown() and IsAltKeyDown()) then
        bossAnchor:StartMoving()
    end
end)

bossAnchor:SetScript("OnDragStop", function()
    bossAnchor:StopMovingOrSizing()
end)

local function UpdateHealth(Health, unit, cur, max)
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end

    Health.Value:SetText(ns.GetHealthText(unit, cur, max))

    local self = Health:GetParent()
    if (self.Name.Bg) then
        self.Name.Bg:SetVertexColor(GameTooltip_UnitColor(unit))
    end
end

local function UpdatePower(Power, unit, cur, min, max)
    if (UnitIsDead(unit)) then
        Power:SetValue(0)
    end

    Power.Value:SetText(ns.GetPowerText(unit, cur, max))
end

local function CreateBossLayout(self, unit)
    self:RegisterForClicks("AnyUp")
    self:EnableMouse(true)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:SetFrameStrata("LOW")

        -- Health bar

    self.Health = CreateFrame("StatusBar", "$parentHealthBar", self)
    self.Health:SetStatusBarTexture(config.media.statusbar, "BORDER")
    self.Health:SetSize(115, 8)
    self.Health:SetPoint("TOPRIGHT", self.Texture, -105, -43)

    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    self.Health.PostUpdate = UpdateHealth

        -- Texture

    self.Texture = self.Health:CreateTexture("$parentTexture", "ARTWORK")
    self.Texture:SetSize(250, 129)
    self.Texture:SetPoint("CENTER", self, 31, -24)
    self.Texture:SetTexture("Interface\\TargetingFrame\\UI-UnitFrame-Boss")

        -- Health text

    self.Health.Value = self.Health:CreateFontString("$parentHealthText", "ARTWORK")
    self.Health.Value:SetFont("Fonts\\ARIALN.ttf", config.font.normalSize)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint("CENTER", self.Health)

        -- Power bar

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

        -- Power text

    self.Power.Value = self.Health:CreateFontString("$parentPowerText", "ARTWORK")
    self.Power.Value:SetFont("Fonts\\ARIALN.ttf", config.font.normalSize)
    self.Power.Value:SetShadowOffset(1, -1)
    self.Power.Value:SetPoint("CENTER", self.Power)

        -- Name text

    self.Name = self.Health:CreateFontString("$parentNameText", "ARTWORK")
    self.Name:SetFont(config.font.normalBig, config.font.normalBigSize)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH("CENTER")
    self.Name:SetSize(110, 10)
    self.Name:SetPoint("BOTTOM", self.Health, "TOP", 0, 6)

    self:Tag(self.Name, "[name]")

        -- Colored name background

    self.Name.Bg = self.Health:CreateTexture("$parentBackground", "BACKGROUND")
    self.Name.Bg:SetHeight(18)
    self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
    self.Name.Bg:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT")
    self.Name.Bg:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT")
    self.Name.Bg:SetTexture("Interface\\AddOns\\oUF_Neav\\media\\nameBackground")

        -- Level text

    self.Level = self.Health:CreateFontString("$parentLevelText", "ARTWORK")
    self.Level:SetFont("Interface\\AddOns\\oUF_Neav\\media\\fontNumber.ttf", 16, "OUTLINE")
    self.Level:SetShadowOffset(0, 0)
    self.Level:SetPoint("CENTER", self.Texture, 24, -2)

    self:Tag(self.Level, "[level]")

        -- Raid target indicator

    self.RaidTargetIndicator = self.Health:CreateTexture("$parentRaidTargetIndicator", "OVERLAY", self)
    self.RaidTargetIndicator:SetPoint("CENTER", self, "TOPRIGHT", -9, -5)
    self.RaidTargetIndicator:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    self.RaidTargetIndicator:SetSize(26, 26)

        -- Threat glow textures

    self.ThreatGlow = self:CreateTexture("$parentThreatGlow", "OVERLAY")
    self.ThreatGlow:SetAlpha(0)
    self.ThreatGlow:SetSize(241, 100)
    self.ThreatGlow:SetPoint("TOPRIGHT", self.Texture, -11, 3)
    self.ThreatGlow:SetTexture("Interface\\TargetingFrame\\UI-UnitFrame-Boss-Flash")
    self.ThreatGlow:SetTexCoord(0.0, 0.945, 0.0, 0.73125)

    self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
    self.Buffs.size = 30
    self.Buffs:SetHeight(self.Buffs.size * 3)
    self.Buffs:SetWidth(self.Buffs.size * 5)
    self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 3, -6)
    self.Buffs.initialAnchor = "TOPLEFT"
    self.Buffs["growth-x"] = "RIGHT"
    self.Buffs["growth-y"] = "DOWN"
    self.Buffs.numBuffs = 8
    self.Buffs.spacing = 4.5

    self.Buffs.customColor = {1, 0, 0}

    self.Buffs.PostCreateIcon = ns.UpdateAuraIcons
    self.Buffs.PostUpdateIcon = ns.PostUpdateIcon

    self:SetSize(132, 46)
    self:SetScale(config.units.boss.scale)

    if (config.units.boss.castbar.show) then
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

        ns.CreateCastbarStrings(self, true)

        self.Castbar.CustomDelayText = ns.CustomDelayText
        self.Castbar.CustomTimeText = ns.CustomTimeText
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

        if (i == 1) then
            boss[i]:SetPoint("TOPRIGHT", bossAnchor, "TOPRIGHT",0,0)
        else
            boss[i]:SetPoint("TOPLEFT", boss[i-1], "BOTTOMLEFT", 0, (config.units.boss.castbar.show and -80) or -50)
        end
    end
end)
