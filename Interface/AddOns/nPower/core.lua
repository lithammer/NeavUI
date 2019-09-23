
local _, nPower = ...
local config = nPower.Config

local function GetRealMpFive()
    local _, activeRegen = GetPowerRegen()
    local realRegen = activeRegen * 5
    local _, powerType = UnitPowerType("player")

    if (powerType == "MANA") then
        return math.floor(realRegen)
    else
        return ""
    end
end

local function SetPowerColor(self)
    local powerType
    if (self.class == "ROGUE" or self.class == "DRUID") then
        powerType = Enum.PowerType.ComboPoints
    elseif (self.class == "MAGE") then
        powerType = Enum.PowerType.ArcaneCharges
    elseif (self.class == "PALADIN") then
        powerType = Enum.PowerType.HolyPower
    elseif (self.class == "WARLOCK") then
        powerType = Enum.PowerType.SoulShards
    end

    local currentPower = UnitPower("player", powerType)
    local maxPower = UnitPowerMax("player", powerType)

    if (UnitIsDeadOrGhost("target")) then
        return 1, 1, 1
    elseif (currentPower == maxPower-1) then
        return 0.9, 0.7, 0.0
    elseif (currentPower == maxPower) then
        return 1, 0, 0
    else
        return 1, 1, 1
    end
end

local function UpdateArrow(self)
    if (UnitPower("player") == 0) then
        self.Power.Below:SetAlpha(0.3)
        self.Power.Above:SetAlpha(0.3)
    else
        self.Power.Below:SetAlpha(1)
        self.Power.Above:SetAlpha(1)
    end

    local newPosition = UnitPower("player") / UnitPowerMax("player") * self.Power:GetWidth()
    self.Power.Below:SetPoint("TOP", self.Power, "BOTTOMLEFT", newPosition, 0)
end

local function UpdateBarValue(self)
    local min = UnitPower("player")
    self.Power:SetMinMaxValues(0, UnitPowerMax("player"))
    self.Power:SetValue(min)

    if (config.valueAbbrev) then
        self.Power.Value:SetText(min > 0 and nPower:FormatValue(min) or "")
    else
        self.Power.Value:SetText(min > 0 and min or "")
    end
end

local function UpdateBarColor(self)
    local _, powerToken, altR, altG, altB = UnitPowerType("player")
    local unitPower = PowerBarColor[powerToken]

    if (unitPower) then
        if (powerToken == "MANA") then
            self.Power:SetStatusBarColor(0.0, 0.55, 1.0)
        else
            self.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
        end
    else
        self.Power:SetStatusBarColor(altR, altG, altB)
    end
end

local function UpdateBarVisibility(self)
    local _, powerToken = UnitPowerType("player")
    local newAlpha = nil

    if (not config.showPowerType[powerToken] or UnitIsDeadOrGhost("player")) then
        self.Power:SetAlpha(0)
    elseif (InCombatLockdown()) then
        newAlpha = config.activeAlpha
    elseif (not InCombatLockdown() and UnitPower("player") > 0) then
        newAlpha = config.inactiveAlpha
    else
        newAlpha = config.emptyAlpha
    end

    if (newAlpha) then
        nPower:Fade(self.Power, 0.3, self.Power:GetAlpha(), newAlpha)
    end
end

function nPower_OnLoad(self)
    self.updateTimer = 0
    self.class = select(2, UnitClass("player"))

    self:SetScale(config.scale)
    self:SetSize(18, 18)
    self:SetPoint(unpack(config.position))
    self:EnableMouse(false)

    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
    self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
    self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")

    if (config.showCombatRegen) then
        self:RegisterUnitEvent("UNIT_AURA", "player")
    end

    nPower:SetupPower(self)

    if nPower:HasExtraPoints(self.class) then
        nPower:SetupExtraPoints(self)
    end
end

function nPower_OnEvent(self, event, ...)
    if (self.extraPoints) then
        local nump
        if (self.class == "ROGUE" or self.class == "DRUID") then
            nump = UnitPower("player", Enum.PowerType.ComboPoints)
        end

        self.extraPoints:SetTextColor(SetPowerColor(self))
        self.extraPoints:SetText(nump == 0 and "" or nump)

        if (not self.extraPoints:IsShown()) then
            self.extraPoints:Show()
        end
    end

    if (self.mpreg and (event == "UNIT_AURA" or event == "PLAYER_ENTERING_WORLD")) then
        self.mpreg:SetText(GetRealMpFive())
    end

    UpdateArrow(self)
    UpdateBarValue(self)
    UpdateBarColor(self)
    UpdateBarVisibility(self)

    if (event == "PLAYER_ENTERING_WORLD") then
        if (InCombatLockdown()) then
            securecall("UIFrameFadeIn", self, 0.35, self:GetAlpha(), 1)
        else
            securecall("UIFrameFadeOut", self, 0.35, self:GetAlpha(), config.inactiveAlpha)
        end
    elseif (event == "PLAYER_REGEN_DISABLED") then
        securecall("UIFrameFadeIn", self, 0.35, self:GetAlpha(), 1)
    elseif (event == "PLAYER_REGEN_ENABLED") then
        securecall("UIFrameFadeOut", self, 0.35, self:GetAlpha(), config.inactiveAlpha)
    end
end

function nPower:SetupPower(self)
    self.Power = CreateFrame("StatusBar", nil, UIParent)
    self.Power:SetScale(self:GetScale())
    self.Power:SetSize(config.sizeWidth, 3)
    self.Power:SetPoint("CENTER", self, 0, -23)
    self.Power:SetStatusBarTexture([[Interface\AddOns\nPower\media\statusbarTexture]])
    self.Power:SetAlpha(0)

    self.Power.Value = self.Power:CreateFontString(nil, "ARTWORK")

    if (config.valueFontOutline) then
        self.Power.Value:SetFont(config.valueFont, config.valueFontSize, "THINOUTLINE")
        self.Power.Value:SetShadowOffset(0, 0)
    else
        self.Power.Value:SetFont(config.valueFont, config.valueFontSize)
        self.Power.Value:SetShadowOffset(1, -1)
    end

    self.Power.Value:SetPoint("CENTER", self.Power, 0, config.valueFontAdjustmentX)
    self.Power.Value:SetVertexColor(1, 1, 1)

    self.Power.Background = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.Background:SetAllPoints(self.Power)
    self.Power.Background:SetTexture([[Interface\AddOns\nPower\media\statusbarTexture]])
    self.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

    self.Power.BackgroundShadow = CreateFrame("Frame", nil, self.Power)
    self.Power.BackgroundShadow:SetFrameStrata("BACKGROUND")
    self.Power.BackgroundShadow:SetPoint("TOPLEFT", -4, 4)
    self.Power.BackgroundShadow:SetPoint("BOTTOMRIGHT", 4, -4)
    self.Power.BackgroundShadow:SetBackdrop({
        BgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        edgeFile = [[Interface\Addons\nPower\\media\textureGlow]], edgeSize = 4,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    self.Power.BackgroundShadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
    self.Power.BackgroundShadow:SetBackdropBorderColor(0, 0, 0)

    self.Power.Below = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.Below:SetHeight(14)
    self.Power.Below:SetWidth(14)
    self.Power.Below:SetTexture([[Interface\AddOns\nPower\media\textureArrowBelow]])

    self.Power.Above = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.Above:SetHeight(14)
    self.Power.Above:SetWidth(14)
    self.Power.Above:SetTexture([[Interface\AddOns\nPower\media\textureArrowAbove]])
    self.Power.Above:SetPoint("BOTTOM", self.Power.Below, "TOP", 0, self.Power:GetHeight())

    if (config.showCombatRegen) then
        self.mpreg = self.Power:CreateFontString(nil, "ARTWORK")
        self.mpreg:SetFont(config.valueFont, 12, "THINOUTLINE")
        self.mpreg:SetShadowOffset(0, 0)
        self.mpreg:SetPoint("TOP", self.Power.Below, "BOTTOM", 0, 4)
        self.mpreg:SetParent(self.Power)
        self.mpreg:Show()
    end
end

function nPower:SetupExtraPoints(self)
    self.extraPoints = self:CreateFontString(nil, "ARTWORK")

    if (config.extraFontOutline) then
        self.extraPoints:SetFont(config.extraFont, config.extraFontSize, "THINOUTLINE")
        self.extraPoints:SetShadowOffset(0, 0)
    else
        self.extraPoints:SetFont(config.extraFont, config.extraFontSize)
        self.extraPoints:SetShadowOffset(1, -1)
    end

    self.extraPoints:SetParent(self)
    self.extraPoints:SetPoint("CENTER", 0, 0)
end
