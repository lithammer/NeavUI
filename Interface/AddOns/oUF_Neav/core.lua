
local _, ns = ...
local config = ns.Config

local oUF = ns.oUF or oUF
oUF.colors.power["MANA"] = {0, 0.55, 1}

local _, playerClass = UnitClass("player")
local charTexPath = "Interface\\CharacterFrame\\"
local tarTexPath = "Interface\\TargetingFrame\\"
local texPath = tarTexPath.."UI-TargetingFrame"
local texTable = {
    ["elite"] = texPath.."-Elite",
    ["rareelite"] = texPath.."-Rare-Elite",
    ["rare"] = texPath.."-Rare",
    ["worldboss"] = texPath.."-Elite",
    ["normal"] = texPath,
}

local function CreateTab(self, text)
    self.T = {}
    local tabCoordTable = {
        [1] = {0.1875, 0.53125, 0, 1},
        [2] = {0.53125, 0.71875, 0, 1},
        [3] = {0, 0.1875, 0, 1},
    }

    for i = 1, 3 do
        self.T[i] = self:CreateTexture("$parentTabPart"..i, "BACKGROUND")
        self.T[i]:SetTexture(charTexPath.."UI-CharacterFrame-GroupIndicator")
        self.T[i]:SetTexCoord(unpack(tabCoordTable[i]))
        self.T[i]:SetSize(24, 18)
        self.T[i]:SetAlpha(0.5)
    end

    self.T[1]:SetPoint("BOTTOM", self.Name.Bg, "TOP", -1, 0) --0, 1
    self.T[2]:SetPoint("LEFT", self.T[1], "RIGHT")
    self.T[3]:SetPoint("RIGHT", self.T[1], "LEFT")

    self.T[4] = self:CreateFontString("$parentTabText", "OVERLAY")
    self.T[4]:SetFont(config.font.normal, config.font.normalSize - 1)
    self.T[4]:SetShadowOffset(1, -1)
    self.T[4]:SetPoint("BOTTOM", self.T[1], 0, 2)
    self.T[4]:SetAlpha(0.5)

    self.T[4]:SetText(text)
    local width = self.T[4]:GetStringWidth()
    self.T[1]:SetWidth((width < 5 and 50) or width + 4)

    self.T.FadeIn = function(_, alpha, alpha2)
        for i = 1, 4 do
            securecall("UIFrameFadeIn", self.T[i], 0.15, self.T[i]:GetAlpha(), alpha)
            securecall("UIFrameFadeIn", self.T[4], 0.15, self.T[4]:GetAlpha(), alpha2 or alpha)
        end
    end

    self.T.FadeOut = function(_, alpha, alpha2)
        for i = 1, 4 do
            securecall("UIFrameFadeOut", self.T[i], 0.15, self.T[i]:GetAlpha(), alpha)
            securecall("UIFrameFadeOut", self.T[4], 0.15, self.T[4]:GetAlpha(), alpha2 or alpha)
        end
    end
end

local function CreateFocusButton(self)
    self.FTarget = CreateFrame("BUTTON", "$parentFocusTarget", self, "SecureActionButtonTemplate")
    self.FTarget:EnableMouse(true)
    self.FTarget:RegisterForClicks("AnyUp")
    self.FTarget:SetAttribute("type", "macro")
    self.FTarget:SetAttribute("macrotext", "/focus [button:1]\n/clearfocus [button:2]")
    self.FTarget:SetSize(self.T[1]:GetWidth() + 30, self.T[1]:GetHeight() + 2)
    self.FTarget:SetPoint("TOPLEFT", self, (self.T[1]:GetWidth()/5), 17)

    self.FTarget:SetScript("OnMouseDown", function()
        self.T[4]:SetPoint("BOTTOM", self.T[1], -1, 1)
    end)

    self.FTarget:SetScript("OnMouseUp", function()
        self.T[4]:SetPoint("BOTTOM", self.T[1], 0, 2)
    end)

    self.FTarget:SetScript("OnLeave", function()
        self.T:FadeOut(0)
    end)

    self.FTarget:SetScript("OnEnter", function()
        self.T:FadeIn(0.5, 1)
    end)

    self:HookScript("OnLeave", function()
        self.T:FadeOut(0)
    end)

    self:HookScript("OnEnter", function()
        self.T:FadeIn(0.5, 0.65)
    end)
end

local function UpdatePartyTab(self)
    if not IsInRaid() then
        self.T:FadeOut(0)
        return
    end

    local numGroupMembers = GetNumGroupMembers()
    for i = 1, MAX_RAID_MEMBERS do
        if i <= numGroupMembers then
            local unitName, _, groupNumber = GetRaidRosterInfo(i)
            if unitName == UnitName("player") then
                self.T:FadeIn(0.5, 0.65)
                self.T[4]:SetText(GROUP.." "..groupNumber)
                self.T[1]:SetWidth(self.T[4]:GetStringWidth()+4)
            end
        end
    end
end

    -- Update Threat

local function UpdateThreat(self)
    if not self.NumericalThreat then
        return
    end

    local isTanking, status, scaledPercent, rawPercentage = UnitDetailedThreatSituation("player", "target")
    local display = scaledPercent

    if isTanking then
        display = UnitThreatPercentageOfLead("player", "target")
    end

    if not (UnitClassification(self.unit) == "minus") then
        if display and display ~= 0 then
            self.NumericalThreat.value:SetText(format("%1.0f", display).."%")
            self.NumericalThreat.bg:SetVertexColor(GetThreatStatusColor(status))
            self.NumericalThreat:Show()
        else
            self.NumericalThreat:Hide()
        end
    else
        self.NumericalThreat:Hide()
    end
end

    -- Update Alt Resource Display

local function Toggle(frame, shouldShow)
    if frame then
        if not shouldShow then
            HideUIPanel(frame)
        else
            ShowUIPanel(frame)
        end
    end
end

local function ToggleAltResources(shouldShow)
    local playerSpec = GetSpecialization()

    if playerClass == "SHAMAN" then
        Toggle(TotemFrame)
    elseif playerClass == "DEATHKNIGHT" then
        Toggle(RuneFrame)
    elseif playerClass == "MAGE" then
        Toggle(MageArcaneChargesFrame, shouldShow and playerSpec == SPEC_MAGE_ARCANE)
    elseif playerClass == "MONK" then
        if playerSpec == SPEC_MONK_BREWMASTER then
            Toggle(MonkStaggerBar, shouldShow)
        elseif playerSpec == SPEC_MONK_WINDWALKER then
            Toggle(MonkHarmonyBarFrame, shouldShow)
        end
    elseif playerClass == "PALADIN" then
        Toggle(PaladinPowerBarFrame, shouldShow and playerSpec == SPEC_PALADIN_RETRIBUTION)
    elseif playerClass == "ROGUE" then
        Toggle(ComboPointPlayerFrame, shouldShow)
    elseif playerClass == "WARLOCK" then
        Toggle(WarlockPowerFrame, shouldShow)
    end
end

    -- Update TotemFrame Location

local function UpdateTotemFrameAnchor(self)
    local hasPet = UnitExists("pet")
    if playerClass == "WARLOCK" then
        if hasPet then
            TotemFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -75) -- oUF_Neav_Player
        else
            TotemFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 25, -25)
        end
    end
    if playerClass == "SHAMAN" then
        if hasPet then
            TotemFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -75)
        else
            TotemFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 25, -25)
        end
    end
    if playerClass == "PALADIN" or playerClass == "DEATHKNIGHT" or playerClass == "DRUID" or playerClass == "MAGE" or playerClass == "MONK" then
        TotemFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 25, 0)
    end
end

    -- Update rest/combat flash.

local function UpdateFlashStatus(self)
    if UnitIsDeadOrGhost("player") then
        self.StatusFlash:Hide()
        return
    end

    local inCombat = UnitAffectingCombat("player")

    if IsResting() then
        if inCombat then
            self.StatusFlash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
            self.StatusFlash:Show()
        else
            self.StatusFlash:SetVertexColor(1.0, 0.88, 0.25, 1.0)
            self.StatusFlash:Show()
        end
    elseif inCombat then
        self.StatusFlash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        self.StatusFlash:Show()
    else
        self.StatusFlash:Hide()
    end
end

    -- Player Frame StatusFlash OnUpdate

local function StatusFlash_OnUpdate(self, elapsed)
    if self.StatusFlash:IsShown() then
        local alpha = 255
        local counter = self.statusCounter + elapsed
        local sign    = self.statusSign

        if counter > 0.5 then
            sign = -sign
            self.statusSign = sign
        end
        counter = mod(counter, 0.5)
        self.statusCounter = counter

        if sign == 1 then
            alpha = (55  + (counter * 400)) / 255
        else
            alpha = (255 - (counter * 400)) / 255
        end
        self.StatusFlash:SetAlpha(alpha)

        if self.RestingIndicator.Glow:IsShown() then
            self.RestingIndicator.Glow:SetAlpha(alpha)
        elseif self.CombatIndicator.Glow:IsShown() then
            self.CombatIndicator.Glow:SetAlpha(alpha)
        end
    end

    if self.RestingIndicator:IsShown() then
        self.RestingIndicator.Glow:Show()
        self.CombatIndicator:Hide()
        self.CombatIndicator.Glow:Hide()
    elseif self.CombatIndicator:IsShown() then
        self.CombatIndicator.Glow:Show()
        self.Level:SetAlpha(.01)
    else
        self.RestingIndicator.Glow:Hide()
        self.CombatIndicator.Glow:Hide()
        self.Level:SetAlpha(1)
    end
end

    -- Check Vehicle Status

local function CheckVehicleStatus(self)
    if UnitHasVehiclePlayerFrameUI("player") then
        ToggleAltResources(false)
        if self.AdditionalPower then
            self.AdditionalPower:SetAlpha(0)
        end
    else
        ToggleAltResources(true)
        if self.AdditionalPower then
            self.AdditionalPower:SetAlpha(1)
        end
    end
end

    -- Mouseover Text

local function EnableMouseOver(self)
    self.Health.Value:Hide()

    if self.Power and self.Power.Value then
        self.Power.Value:Hide()
    end

    if self.AdditionalPower and self.AdditionalPower.Value then
        self.AdditionalPower.Value:Hide()
    end

    self:HookScript("OnEnter", function(self)
        self.Health.Value:Show()

        if self.Power and self.Power.Value then
            self.Power.Value:Show()
        end

        if self.AdditionalPower and self.AdditionalPower.Value then
            self.AdditionalPower.Value:Show()
        end
    end)

    self:HookScript("OnLeave", function(self)
        self.Health.Value:Hide()

        if self.Power and self.Power.Value then
            self.Power.Value:Hide()
        end

        if self.AdditionalPower and self.AdditionalPower.Value then
            self.AdditionalPower.Value:Hide()
        end
    end)
end

    -- Class Icon Portraits

local function UpdateClassPortraits(self, unit)
    local _, unitClass = UnitClass(unit)
    if unitClass and UnitIsPlayer(unit) then
        self:SetTexture(tarTexPath.."UI-Classes-Circles")
        self:SetTexCoord(unpack(CLASS_ICON_TCOORDS[unitClass]))
    else
        self:SetTexCoord(0, 1, 0, 1)
    end
end

    -- Update Portrait Color

local function UpdatePortraitColor(self, unit, min, max)
    if not UnitIsConnected(unit) then
        self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
    elseif UnitIsDead(unit) then
        self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
    elseif UnitIsGhost(unit) then
        self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
    elseif max == 0 or min/max * 100 < 25 then
        if UnitIsPlayer(unit) then
            if unit ~= "player" then
                self.Portrait:SetVertexColor(1, 0, 0, 0.7)
            end
        end
    else
        self.Portrait:SetVertexColor(1, 1, 1, 1)
    end
end

    -- Update Health

local function UpdateHealth(Health, unit, cur, max)
    local self = Health:GetParent()
    UpdatePortraitColor(self, unit, cur, max)

    if unit == "target" or unit == "focus" then
        if self.Name.Bg then
            self.Name.Bg:SetVertexColor(GameTooltip_UnitColor(unit))
        end
    end

    if not UnitIsConnected(unit) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        if config.show.classHealth then
            if UnitIsPlayer(unit) then
                local _, unitClass = UnitClass(unit)
                local classColor = RAID_CLASS_COLORS[unitClass]
                Health:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
            else
                Health:SetStatusBarColor(0, 1, 0)
            end
        else
            Health:SetStatusBarColor(0, 1, 0)
        end
    end

    Health.Value:SetText(ns.GetHealthText(unit, cur, max))
end

    -- Update Power

local function UpdatePower(Power, unit, cur, min, max)
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
        Power:SetValue(0)
    end

    Power.Value:SetText(ns.GetPowerText(unit, cur, max))
end

    -- Update Level Anchor

local function UpdateLevelTextAnchor(self, event, ...)
    local x
    local targetEffectiveLevel = UnitEffectiveLevel(self.unit)

    if UnitIsWildBattlePet(self.unit) or UnitIsBattlePetCompanion(self.unit) then
        targetEffectiveLevel = UnitBattlePetLevel(self.unit)
    end

    if targetEffectiveLevel >= 100 then
        if self.unit == "player" or self.unit == "vehicle" then
            x = -62
        else
            x = 61
        end
    else
        if self.unit == "player" or self.unit == "vehicle" then
            x = -61
        else
            x = 62
        end
    end

    self.Level:SetPoint("CENTER", self.Texture, x, -16)
end

    -- Player Frame Update

local function UpdatePlayerFrame(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        CheckVehicleStatus(self)
        UpdateTotemFrameAnchor(self)
        UpdateFlashStatus(self)
        UpdateLevelTextAnchor(self)
    elseif event == "UNIT_LEVEL" then
        UpdateLevelTextAnchor(self)
    elseif event == "PLAYER_REGEN_ENABLED" then
        UpdateFlashStatus(self)
    elseif event == "PLAYER_REGEN_DISABLED" then
        UpdateFlashStatus(self)
    elseif event == "PLAYER_UPDATE_RESTING" then
        UpdateFlashStatus(self)
    elseif event == "PLAYER_TALENT_UPDATE" then
        UpdateTotemFrameAnchor(self)
    elseif event == "PLAYER_TOTEM_UPDATE" then
        UpdateTotemFrameAnchor(self)
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        CheckVehicleStatus(self)
    elseif event == "CINEMATIC_STOP" then
        UpdateFlashStatus(self)
    elseif event == "GROUP_ROSTER_UPDATE" then
        UpdatePartyTab(self)
    elseif event == "UNIT_ENTERED_VEHICLE" then
        CheckVehicleStatus(self)
    elseif event == "UNIT_ENTERING_VEHICLE" then
        CheckVehicleStatus(self)
    elseif event == "UNIT_EXITING_VEHICLE" then
        CheckVehicleStatus(self)
    elseif event == "UNIT_EXITED_VEHICLE" then
        CheckVehicleStatus(self)
    elseif event == "UPDATE_SHAPESHIFT_FORM" then
        UpdateTotemFrameAnchor(self)
    end
end

    -- Target Frame Update

local function UpdateTargetFrame(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        UpdateLevelTextAnchor(self)
    elseif event == "UNIT_LEVEL" then
        UpdateLevelTextAnchor(self)
    elseif event == "PLAYER_REGEN_ENABLED" then
        UpdateThreat(self)
    elseif event == "PLAYER_REGEN_DISABLED" then
        UpdateThreat(self)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdateThreat(self)
        UpdateLevelTextAnchor(self)
        if UnitExists(self.unit) and not IsReplacingUnit() then
            if UnitIsEnemy(self.unit, "player") then
                PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
            elseif UnitIsFriend("player", self.unit) then
                PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
            end
        end
        CloseDropDownMenus()
    elseif event == "UNIT_TARGETABLE_CHANGED" then
        UpdateLevelTextAnchor(self)
        CloseDropDownMenus()
    elseif event == "UNIT_THREAT_LIST_UPDATE" then
        UpdateThreat(self)
    elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
        UpdateThreat(self)
    end
end

    -- Focus Frame Update

local function UpdateFocusFrame(self, event, ...)
    if event == "UNIT_LEVEL" then
        UpdateLevelTextAnchor(self)
    elseif event == "PLAYER_FOCUS_CHANGED" then
        UpdateLevelTextAnchor(self)
        CloseDropDownMenus()
    elseif event == "UNIT_CLASSIFICATION_CHANGED" then
        UpdateLevelTextAnchor(self)
    end
end

local function CreateUnitLayout(self, unit)
    self.IsMainFrame = ns.MultiCheck(unit, "player", "target", "focus")
    self.IsTargetFrame = ns.MultiCheck(unit, "targettarget", "focustarget")
    self.IsPartyFrame = unit:match("party")

    if self.IsTargetFrame then
        self:SetFrameLevel(30)
    end

    self:RegisterForClicks("AnyUp")

    if unit:match("^raid") then
        self:SetAttribute("type2", "menu")
    else
        self:SetAttribute("type2", "togglemenu")
    end

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    if config.units.focus.enableFocusToggleKeybind then
        if unit == "focus" then
            self:SetAttribute(config.units.focus.focusToggleKey, "macro")
            self:SetAttribute("macrotext", "/clearfocus")
        else
            self:SetAttribute(config.units.focus.focusToggleKey, "focus")
        end
    end

        -- Create the castbars.

    if config.show.castbars then
        ns.CreateCastbars(self, unit)
    end

        -- Texture

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    if unit == "player" then
        if config.units.player.style == "NORMAL" then
            self.Texture:SetTexture(tarTexPath.."UI-TargetingFrame")
        elseif config.units.player.style == "RARE" then
            self.Texture:SetTexture(tarTexPath.."UI-TargetingFrame-Rare")
        elseif config.units.player.style == "ELITE" then
            self.Texture:SetTexture(tarTexPath.."UI-TargetingFrame-Elite")
        elseif config.units.player.style == "CUSTOM" then
            self.Texture:SetTexture(config.units.player.customTexture)
        end
        self.Texture:SetSize(232, 100)
        self.Texture:SetPoint("CENTER", self, -20, -7)
        self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
    elseif unit == "pet" then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint("TOPLEFT", self, 0, -2)
        self.Texture:SetTexture(tarTexPath.."UI-SmallTargetingFrame")
        self.Texture.SetTexture = function() end
    elseif unit == "target" or unit == "focus" then
        self.Texture:SetSize(230, 100)
        self.Texture:SetPoint("CENTER", self, 20, -7)
        self.Texture:SetTexture(tarTexPath.."UI-TargetingFrame")
        self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    elseif self.IsTargetFrame then
        self.Texture:SetTexture("Interface\\TargetingFrame\\UI-TargetofTargetFrame")
        self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
        self.Texture:SetSize(93, 45)
        self.Texture:SetAllPoints(self)
    elseif self.IsPartyFrame then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint("TOPLEFT", self, 0, -2)
        self.Texture:SetTexture(tarTexPath.."UI-PartyFrame")
    end

        -- Healthbar

    self.Health = CreateFrame("StatusBar", "$parentHealth", self)
    self.Health:SetStatusBarTexture(config.media.statusbar)
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.70)

    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

    if unit == "player" then
        self.Health:SetSize(119, 12)
        self.Health:SetPoint("TOPLEFT", self.Texture, 106, -41)
    elseif unit == "pet" then
        self.Health:SetSize(70, 9)
        self.Health:SetPoint("TOPLEFT", self.Texture, 45, -20)
    elseif unit == "target" or unit == "focus" then
        self.Health:SetSize(119, 12)
        self.Health:SetPoint("TOPRIGHT", self.Texture, -105, -41) -- -105
    elseif self.IsTargetFrame then
        self.Health:SetSize(46, 7)
        self.Health:SetPoint("TOPRIGHT", self.Texture, -2, -15)
    elseif self.IsPartyFrame then
        self.Health:SetPoint("TOPLEFT", self.Texture, 47, -12)
        self.Health:SetSize(70, 7)
    end

        -- Health Prediction

    local myBar = CreateFrame("StatusBar", "$parentMyHealthPredictionBar", self)
    myBar:SetFrameLevel(self:GetFrameLevel() - 1)
    myBar:SetStatusBarTexture(config.media.statusbar, "OVERLAY")
    myBar:SetStatusBarColor(0, 0.827, 0.765, 1)
    myBar:SetOrientation("HORIZONTAL")
    myBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
    myBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
    myBar:SetWidth(self.Health:GetWidth())
    myBar.Smooth = true

    local otherBar = CreateFrame("StatusBar", "$parentOtherHealthPredictionBar", self)
    otherBar:SetFrameLevel(self:GetFrameLevel() - 1)
    otherBar:SetStatusBarTexture(config.media.statusbar, "OVERLAY")
    otherBar:SetStatusBarColor(0.0, 0.631, 0.557, 1)
    otherBar:SetOrientation("HORIZONTAL")
    otherBar:SetPoint("TOPLEFT", myBar:GetStatusBarTexture(), "TOPRIGHT")
    otherBar:SetPoint("BOTTOMLEFT", myBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    otherBar:SetWidth(self.Health:GetWidth())
    otherBar.Smooth = true

    local absorbBar = CreateFrame("StatusBar", "$parentTotalAbsorbBar", self)
    absorbBar:SetFrameLevel(self:GetFrameLevel() - 1)
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
    healAbsorbBar:SetFrameLevel(self:GetFrameLevel() - 1)
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
    overAbsorb:SetWidth(16)
    overAbsorb:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -10, 0)
    overAbsorb:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -10, 0)

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

        -- Health Text

    self.Health.Value = self:CreateFontString("$parentHealthText", "OVERLAY")
    self.Health.Value:SetShadowOffset(1, -1)

    if self.IsTargetFrame then
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize - 2)
        self.Health.Value:SetPoint("CENTER", self.Health, "BOTTOM", -4, 1)
    else
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize)
        self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)
    end

        -- Powerbar

    self.Power = CreateFrame("StatusBar", "$parentPower", self)
    self.Power:SetStatusBarTexture(config.media.statusbar)
    self.Power:SetFrameLevel(self:GetFrameLevel() - 2)
    self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Power:SetBackdropColor(0, 0, 0, 0.70)

    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.colorPower = true

    if self.IsTargetFrame then
        self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
        self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
        self.Power:SetHeight(self.Health:GetHeight())
    else
        self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
        self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
        self.Power:SetHeight(self.Health:GetHeight()-1)

        self.Power.Value = self:CreateFontString("$parentPowerText", "OVERLAY")
        self.Power.Value:SetFont(config.font.normal, config.font.normalSize)
        self.Power.Value:SetShadowOffset(1, -1)
        self.Power.Value:SetPoint("CENTER", self.Power, 0, 0)

        self.Power.PostUpdate = UpdatePower
    end

        -- Power Prediction Bar

    if unit == "player" then
        self.MainPowerPrediction = CreateFrame("StatusBar", "$parentPowerPrediction", self.Power)
        self.MainPowerPrediction:SetStatusBarTexture(config.media.statusbar)
        self.MainPowerPrediction:SetStatusBarColor(0.8,0.8,0.8,.50)
        self.MainPowerPrediction:SetReverseFill(true)
        self.MainPowerPrediction:SetPoint("TOP")
        self.MainPowerPrediction:SetPoint("BOTTOM")
        self.MainPowerPrediction:SetPoint("RIGHT", self.Power:GetStatusBarTexture())
        self.MainPowerPrediction:SetWidth(119)

        self.PowerPrediction = { mainBar = self.MainPowerPrediction }
    end

        -- Name

    self.Name = self:CreateFontString("$parentName", "OVERLAY")
    self.Name:SetFontObject("Neav_FontName")
    self.Name:SetJustifyH("CENTER")
    self.Name:SetHeight(10)

    self:Tag(self.Name, "[neav:name]")

    if unit == "player" then
        self.Name:SetWidth(110)
        self.Name:SetPoint("CENTER", self.Texture, 50, 19)
    elseif unit == "pet" then
        self.Name:SetWidth(90)
        self.Name:SetJustifyH("LEFT")
        self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 1, 4)
    elseif unit == "target" or unit == "focus" then
        self.Name:SetWidth(110)
        self.Name:SetPoint("CENTER", self.Texture, -50, 19)
    elseif self.IsTargetFrame then
        self.Name:SetWidth(60)
        self.Name:SetJustifyH("LEFT")
        self.Name:SetPoint("BOTTOMLEFT", self.Texture, 42, -1)
    elseif self.IsPartyFrame then
        self.Name:SetJustifyH("CENTER")
        self.Name:SetHeight(10)
        self.Name:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -3)
    end

        -- Level

    if self.IsMainFrame then
        self.Level = self:CreateFontString("$parentLevel", "ARTWORK")
        self.Level:SetFont(config.font.numberFont, 17, "OUTLINE")
        self.Level:SetShadowOffset(0, 0)
        self.Level:SetPoint("CENTER", self.Texture, "CENTER", (unit == "player" and -62) or 61, -16)
        self:Tag(self.Level, "[neav:level]")
    end

        -- Portrait

    self.Portrait = self.Health:CreateTexture("$parentPortrait", "BACKGROUND")

    if unit == "player" then
        self.Portrait:SetSize(64, 64)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 42, -12)
    elseif unit == "pet" then
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
    elseif unit == "target" or unit == "focus" then
        self.Portrait:SetSize(64, 64)
        self.Portrait:SetPoint("TOPRIGHT", self.Texture, -42, -12)
    elseif self.IsTargetFrame then
        self.Portrait:SetSize(35, 35)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 5, -5)
    elseif self.IsPartyFrame then
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
    end

    if config.show.classPortraits then
        self.Portrait.PostUpdate = UpdateClassPortraits
    end

        -- Portrait Timer

    if config.show.portraitTimer then
        self.PortraitTimer = CreateFrame("Frame", "$parentPortraitTimer", self.Health)
        self.PortraitTimer:SetAllPoints(self.Portrait)
    end

        -- PvP Icon

    self.PvPIndicator = self:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)

    if unit == "player" then
        self.PvPIndicator:SetSize(40, 42)
        self.PvPIndicator:SetPoint("TOPLEFT", self.Texture, 18, -20)
    elseif unit == "pet" then
        self.PvPIndicator:SetSize(35, 35)
        self.PvPIndicator:SetPoint("CENTER", self.Portrait, "LEFT", -7, -7)
    elseif unit == "target" or unit == "focus" then
        self.PvPIndicator:SetSize(40, 42)
        self.PvPIndicator:SetPoint("TOPRIGHT", self.Texture, -16, -23)
    elseif self.IsPartyFrame then
        self.PvPIndicator:SetSize(40, 40)
        self.PvPIndicator:SetPoint("TOPLEFT", self.Texture, -9, -10)
    end

        -- Group Leader Icon

    self.LeaderIndicator = self:CreateTexture("$parentLeaderIcon", "ARTWORK")
    self.LeaderIndicator:SetSize(16, 16)

    if unit == "player" then
        self.LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)
    elseif unit == "target" or unit == "focus" then
        self.LeaderIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)
    elseif self.IsTargetFrame then
        self.LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, -3, 4)
    elseif self.IsPartyFrame then
        self.LeaderIndicator:SetSize(14, 14)
        self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOPLEFT", 1, -1)
    end

        -- Assist Icon

    self.AssistantIndicator = self:CreateTexture("$parentAssistIcon", "ARTWORK")
    self.AssistantIndicator:SetSize(16, 16)

    if unit == "player" then
        self.AssistantIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 3)
    elseif unit == "target" or unit == "focus" then
        self.AssistantIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)
    elseif self.IsTargetFrame then
        self.AssistantIndicator:SetPoint("TOPLEFT", self.Portrait, -3, 4)
    elseif self.IsPartyFrame then
        self.AssistantIndicator:SetSize(14, 14)
        self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOPLEFT", 1, -1)
    end

        -- Raid target indicator

    self.RaidTargetIndicator = self:CreateTexture("$parentRaidTargetIcon", "ARTWORK")
    self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, -1)
    local s1 = self.Portrait:GetSize() / 3
    self.RaidTargetIndicator:SetSize(s1, s1)

        -- Phase Icon

    if not self.IsTargetFrame then
        self.PhaseIndicator = self:CreateTexture("$parentPhaseIcon", "OVERLAY")
        self.PhaseIndicator:SetPoint("CENTER", self.Portrait, "BOTTOM")

        if self.IsMainFrame then
            self.PhaseIndicator:SetSize(26, 26)
        else
            self.PhaseIndicator:SetSize(18, 18)
        end
    end

        -- Offline Icons

    self.OfflineIcon = self:CreateTexture("$parentOfflineIcon", "OVERLAY")
    self.OfflineIcon:SetPoint("TOPRIGHT", self.Portrait, 7, 7)
    self.OfflineIcon:SetPoint("BOTTOMLEFT", self.Portrait, -7, -7)

        -- Ready Check Icons

    if unit == "player" or self.IsPartyFrame then
        self.ReadyCheckIndicator = self:CreateTexture("$parentReadyCheckIcon", "OVERLAY", nil, 7)
        self.ReadyCheckIndicator:SetPoint("TOPRIGHT", self.Portrait, -7, -7)
        self.ReadyCheckIndicator:SetPoint("BOTTOMLEFT", self.Portrait, 7, 7)
        self.ReadyCheckIndicator.delayTime = 2
        self.ReadyCheckIndicator.fadeTime = 0.5
    end

        -- Threat Textures

    self.ThreatGlow = self:CreateTexture("$parentThreatGlow", "BACKGROUND")

    if unit == "player" then
        self.ThreatGlow:SetSize(242, 93)
        self.ThreatGlow:SetPoint("TOPLEFT", self.Texture, 13, 0)
        self.ThreatGlow:SetTexture(tarTexPath.."UI-TargetingFrame-Flash")
        self.ThreatGlow:SetTexCoord(0.9453125, 0, 0, 0.181640625)
    elseif unit == "pet" then
        self.ThreatGlow:SetSize(129, 64)
        self.ThreatGlow:SetPoint("TOPLEFT", self.Texture, -5, 13)
        self.ThreatGlow:SetTexture(tarTexPath.."UI-PartyFrame-Flash")
        self.ThreatGlow:SetTexCoord(0, 1, 1, 0)
    elseif unit == "target" or unit == "focus" then
        self.ThreatGlow:SetSize(239, 92)
        self.ThreatGlow:SetPoint("TOPLEFT", self.Texture, -23, 0)
        self.ThreatGlow:SetTexture(tarTexPath.."UI-TargetingFrame-Flash")
        self.ThreatGlow:SetTexCoord(0, 0.9453125, 0, 0.182)
        self.feedbackUnit = "player"
    elseif self.IsPartyFrame then
        self.ThreatGlow:SetSize(128, 63)
        self.ThreatGlow:SetPoint("TOPLEFT", self.Texture, -3, 4)
        self.ThreatGlow:SetTexture(tarTexPath.."UI-PartyFrame-Flash")
    end

        -- LFD Role Icon

    if self.IsPartyFrame or unit == "player" or unit == "target" then
        self.GroupRoleIndicator = self:CreateTexture("$parentGroupRoleIcon", "ARTWORK")
        self.GroupRoleIndicator:SetSize(20, 20)

        if unit == "player" then
            self.GroupRoleIndicator:SetPoint("BOTTOMRIGHT", self.Portrait, -2, -3)
        elseif unit == "target" then
            self.GroupRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
        else
            self.GroupRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)
        end
    end

        -- Player Frame

    if unit == "player" then
        self:SetSize(175, 42)

        self.Name.Bg = self:CreateTexture("$parentNameBG", "BACKGROUND")
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT")
        self.Name.Bg:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT")
        self.Name.Bg:SetTexture("Interface\\Buttons\\WHITE8x8")
        self.Name.Bg:SetVertexColor(0, 0, 0, 0.70)

            -- Afk timer, using frequentUpdates function from oUF tags

        if config.units.player.showAFKTimer then
            self.NotHere = self:CreateFontString("$parentNotHere", "OVERLAY")
            self.NotHere:SetPoint("CENTER", self.Portrait, "BOTTOM")
            self.NotHere:SetFont(config.font.normal, 11, "OUTLINE")
            self.NotHere:SetShadowOffset(0, 0)
            self.NotHere:SetTextColor(0, 1, 0)
            self.NotHere.frequentUpdates = 1
            self:Tag(self.NotHere, "[neav:afk]")
        end

            -- Warlock Soul Shards

        if playerClass == "WARLOCK" then
            WarlockPowerFrame:ClearAllPoints()
            WarlockPowerFrame:SetParent(oUF_Neav_Player)
            WarlockPowerFrame:SetScale(config.units.player.scale * 0.8)
            WarlockPowerFrame:SetPoint("TOP", oUF_Neav_Player, "BOTTOM", 30, -2)
        end

            -- Holy Power Bar (Retribution Only)

        if playerClass == "PALADIN" then
            PaladinPowerBarFrame:ClearAllPoints()
            PaladinPowerBarFrame:SetParent(oUF_Neav_Player)
            PaladinPowerBarFrame:SetScale(config.units.player.scale * 0.81)
            PaladinPowerBarFrame:SetPoint("TOP", oUF_Neav_Player, "BOTTOM", 25, 2)
        end

            -- Monk Chi / Stagger Bar

        if playerClass == "MONK" then
            -- Windwalker Chi
            MonkHarmonyBarFrame:ClearAllPoints()
            MonkHarmonyBarFrame:SetParent(oUF_Neav_Player)
            MonkHarmonyBarFrame:SetScale(config.units.player.scale * 0.81)
            MonkHarmonyBarFrame:SetPoint("TOP", oUF_Neav_Player, "BOTTOM", 31, 18)

            -- Brewmaster Stagger
            MonkStaggerBar:ClearAllPoints()
            MonkStaggerBar:SetParent(oUF_Neav_Player)
            MonkStaggerBar:SetScale(config.units.player.scale * 0.81)
            MonkStaggerBar:SetPoint("TOP", oUF_Neav_Player, "BOTTOM", 30, -2)
        end

            -- Deathknight Runebar

        if playerClass == "DEATHKNIGHT" then
            RuneFrame:ClearAllPoints()
            RuneFrame:SetParent(oUF_Neav_Player)
            RuneFrame:SetPoint("TOP", self.Power, "BOTTOM", 2, -2)
        end

            -- Arcane Mage

        if playerClass == "MAGE" then
            MageArcaneChargesFrame:ClearAllPoints()
            MageArcaneChargesFrame:SetParent(oUF_Neav_Player)
            MageArcaneChargesFrame:SetScale(config.units.player.scale * 0.81)
            MageArcaneChargesFrame:SetPoint("TOP", oUF_Neav_Player, "BOTTOM", 30, -2)
        end

            -- Combo Point Frame

        if playerClass == "DRUID" or playerClass == "ROGUE" then
            ComboPointPlayerFrame:ClearAllPoints()
            ComboPointPlayerFrame:SetParent(oUF_Neav_Player)
            ComboPointPlayerFrame:SetScale(config.units.player.scale * 0.81)
            ComboPointPlayerFrame:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", -3, 2)
        end

            -- Totem Frame

        if  playerClass == "DEATHKNIGHT"
            or playerClass == "DRUID"
            or playerClass == "MAGE"
            or playerClass == "MONK"
            or playerClass == "PALADIN"
            or playerClass == "SHAMAN"
            or playerClass == "WARLOCK"
        then
            TotemFrame:SetScale(config.units.player.scale * 0.65)
            TotemFrame:SetFrameStrata("LOW")
            TotemFrame:SetParent(self)
            UpdateTotemFrameAnchor(self)
        end

            -- Alt Mana Frame for Druids, Shaman, and Shadow Priest

        if  playerClass == "DRUID"
            or playerClass == "PRIEST"
            or playerClass == "SHAMAN"
        then
            self.AdditionalPower = CreateFrame("StatusBar", "$parentAdditionalPower", self)
            self.AdditionalPower:SetPoint("TOP", self.Power, "BOTTOM", 0, -1)
            self.AdditionalPower:SetStatusBarTexture(config.media.statusbar, "BORDER")
            self.AdditionalPower:SetSize(99, 9)
            self.AdditionalPower:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
            self.AdditionalPower:SetBackdropColor(0, 0, 0, 0.70)
            self.AdditionalPower.colorPower = true

            self.AdditionalPower.Value = self.AdditionalPower:CreateFontString("$parentAdditionalPowerText", "OVERLAY")
            self.AdditionalPower.Value:SetFont(config.font.normal, config.font.normalSize)
            self.AdditionalPower.Value:SetShadowOffset(1, -1)
            self.AdditionalPower.Value:SetPoint("CENTER", self.AdditionalPower, 0, 0.5)

            self:Tag(self.AdditionalPower.Value, "[neav:AdditionalPower]")

            self.AdditionalPower.Texture = self.AdditionalPower:CreateTexture("$parentAdditionalPowerTexture", "ARTWORK")
            self.AdditionalPower.Texture:SetTexture("Interface\\AddOns\\oUF_Neav\\media\\AdditionalPowerTexture")
            self.AdditionalPower.Texture:SetSize(104, 28)
            self.AdditionalPower.Texture:SetPoint("TOP", self.Power, "BOTTOM", 0, 6)

            self.PowerPredictionAlt = CreateFrame("StatusBar", "$parentAltPowerPrediction", self.AdditionalPower)
            self.PowerPredictionAlt:SetStatusBarTexture(config.media.statusbar)
            self.PowerPredictionAlt:SetStatusBarColor(0.8,0.8,0.8,.50)
            self.PowerPredictionAlt:SetReverseFill(true)
            self.PowerPredictionAlt:SetPoint("TOP")
            self.PowerPredictionAlt:SetPoint("BOTTOM")
            self.PowerPredictionAlt:SetPoint("RIGHT", self.AdditionalPower:GetStatusBarTexture(),"RIGHT")
            self.PowerPredictionAlt:SetWidth(99)

            self.PowerPrediction = { mainBar = self.MainPowerPrediction, altBar = self.PowerPredictionAlt }
        end

            -- Raid Group Indicator

        CreateTab(self, GROUP)
        UpdatePartyTab(self)

            -- Pvptimer

        if self.PvPIndicator then
            self.PvPTimer = self:CreateFontString("$parentPvPTimer", "OVERLAY")
            self.PvPTimer:SetFont(config.font.normal, config.font.normalSize)
            self.PvPTimer:SetShadowOffset(1, -1)
            self.PvPTimer:SetPoint("BOTTOM", self.PvPIndicator, "TOP", 0, -3   )
            self.PvPTimer.frequentUpdates = 0.5
            self:Tag(self.PvPTimer, "[neav:pvptimer]")
        end

            -- Loot Spec Icon

        local LootSpecIndicator = self:CreateTexture("$parentSpecIcon")
        LootSpecIndicator:SetDrawLayer("OVERLAY", 2)
        LootSpecIndicator:SetSize(16, 16)
        LootSpecIndicator:SetPoint("TOPRIGHT", self.Portrait, 5, 0)
        LootSpecIndicator.alwaysShow = true

        LootSpecIndicator.Border = self:CreateTexture("$parentSpecIconRing")
        LootSpecIndicator.Border:SetDrawLayer("OVERLAY", 3)
        LootSpecIndicator.Border:SetSize(42,42)
        LootSpecIndicator.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
        LootSpecIndicator.Border:SetPoint("TOPLEFT", LootSpecIndicator, -5, 5)

        self.LootSpecIndicator = LootSpecIndicator

            -- Resting Icon

        self.RestingIndicator = self:CreateTexture("$parentRestingIcon", "OVERLAY")
        self.RestingIndicator:SetPoint("TOPLEFT", self.Texture, 39, -50)
        self.RestingIndicator:SetSize(31, 31) --31,34

        self.RestingIndicator.Glow = self:CreateTexture("$parentRestingIconGlow", "OVERLAY")
        self.RestingIndicator.Glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
        self.RestingIndicator.Glow:SetTexCoord(0.0, 0.5, 0.5, 1.0)
        self.RestingIndicator.Glow:SetBlendMode("ADD")
        self.RestingIndicator.Glow:SetSize(32,32)
        self.RestingIndicator.Glow:SetPoint("TOPLEFT", self.RestingIndicator)
        self.RestingIndicator.Glow:SetAlpha(0)
        self.RestingIndicator.Glow:Hide()

            -- Combat Icon

        self.CombatIndicator = self:CreateTexture("$parentCombatIcon", "OVERLAY")
        self.CombatIndicator:SetDrawLayer("OVERLAY", 7)
        self.CombatIndicator:SetPoint("TOPLEFT", self.RestingIndicator, 1, 1)
        self.CombatIndicator:SetSize(32, 31)

        self.CombatIndicator.Glow = self:CreateTexture("$parentCombatIconGlow", "OVERLAY")
        self.CombatIndicator.Glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
        self.CombatIndicator.Glow:SetTexCoord(0.5, 1.0, 0.5, 1.0)
        self.CombatIndicator.Glow:SetVertexColor(1.0, 0.0, 0.0)
        self.CombatIndicator.Glow:SetBlendMode("ADD")
        self.CombatIndicator.Glow:SetSize(32,32)
        self.CombatIndicator.Glow:SetPoint("TOPLEFT", self.RestingIndicator, 1, 1)
        self.CombatIndicator.Glow:SetAlpha(0)
        self.CombatIndicator.Glow:Hide()

            -- Resting/combat status flashing

        self.StatusFlash = self:CreateTexture("$parentStatusFlash", "ARTWORK")
        self.StatusFlash:SetTexture(charTexPath.."UI-Player-Status")
        self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
        self.StatusFlash:SetBlendMode("ADD")
        self.StatusFlash:SetSize(192, 66)
        self.StatusFlash:SetPoint("TOPLEFT", self.Texture, 35, -9)
        self.StatusFlash:SetAlpha(0)

        UpdateFlashStatus(self)

        self.statusCounter = 0
        self.statusSign = -1

        self:SetScript("OnUpdate", StatusFlash_OnUpdate)

            -- Player Events

        self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdatePlayerFrame)
        self:RegisterEvent("PLAYER_REGEN_ENABLED", UpdatePlayerFrame)
        self:RegisterEvent("PLAYER_REGEN_DISABLED", UpdatePlayerFrame)
        self:RegisterEvent("PLAYER_UPDATE_RESTING", UpdatePlayerFrame)
        self:RegisterEvent("PLAYER_TALENT_UPDATE", UpdatePlayerFrame)
        self:RegisterEvent("PLAYER_TOTEM_UPDATE", UpdatePlayerFrame)
        self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", UpdatePlayerFrame)
        self:RegisterEvent("CINEMATIC_STOP", UpdatePlayerFrame)
        self:RegisterEvent("GROUP_ROSTER_UPDATE", UpdatePlayerFrame)
        self:RegisterEvent("UNIT_ENTERED_VEHICLE", UpdatePlayerFrame)
        self:RegisterEvent("UNIT_ENTERING_VEHICLE", UpdatePlayerFrame)
        self:RegisterEvent("UNIT_EXITING_VEHICLE", UpdatePlayerFrame)
        self:RegisterEvent("UNIT_EXITED_VEHICLE", UpdatePlayerFrame)
        self:RegisterEvent("UNIT_LEVEL", UpdatePlayerFrame)
        self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", UpdatePlayerFrame)
    end

        -- Petframe

    if unit == "pet" then
        self:SetSize(175, 42)

        if not config.units[ns.cUnit(unit)].disableAura then
            self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
            self.Debuffs.size = 20
            self.Debuffs:SetWidth(self.Debuffs.size * 4)
            self.Debuffs:SetHeight(self.Debuffs.size)
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 1, -3)
            self.Debuffs.initialAnchor = "TOPLEFT"
            self.Debuffs["growth-x"] = "RIGHT"
            self.Debuffs["growth-y"] = "DOWN"
            self.Debuffs.num = 9
        end
    end

        -- Target + Focus Frame

    if unit == "target" or unit == "focus" then
        self:SetSize(175, 42)

            -- Class Colored Name Background

        self.Name.Bg = self:CreateTexture("$parentNameBG", "BACKGROUND")
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.Name.Bg:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT")
        self.Name.Bg:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT")
        self.Name.Bg:SetTexture("Interface\\AddOns\\oUF_Neav\\media\\nameBackground")

            -- Questmob Icon

        self.QuestIndicator = self:CreateTexture("$parentQuestIcon", "OVERLAY")
        self.QuestIndicator:SetSize(32, 32)
        self.QuestIndicator:SetPoint("CENTER", self.Health, "TOPRIGHT", 1, 10)

        table.insert(self.__elements, function(self, _, unit)
            self.Texture:SetTexture(texTable[UnitClassification(unit)] or texTable["normal"])
        end)
    end

    if unit == "target" then
        if not config.units[ns.cUnit(unit)].disableAura then
            if config.units.target.showDebuffsOnTop then
                -- Debuffs
                self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
                self.Debuffs.gap = true
                self.Debuffs.size = 20
                self.Debuffs:SetHeight(self.Debuffs.size * 3)
                self.Debuffs:SetWidth(self.Debuffs.size * 5)
                self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)
                self.Debuffs.initialAnchor = "BOTTOMLEFT"
                self.Debuffs["growth-x"] = "RIGHT"
                self.Debuffs["growth-y"] = "UP"
                self.Debuffs.num = config.units.target.numDebuffs
                self.Debuffs.onlyShowPlayer = config.units.target.onlyShowPlayerDebuffs
                self.Debuffs.spacing = 4.5

                -- Buffs
                self.Buffs = CreateFrame("Frame", "$parentBuffs", self)
                self.Buffs.gap = true
                self.Buffs.size = 20
                self.Buffs:SetHeight(self.Buffs.size * 3)
                self.Buffs:SetWidth(self.Buffs.size * 5)
                self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
                self.Buffs.initialAnchor = "TOPLEFT"
                self.Buffs["growth-x"] = "RIGHT"
                self.Buffs["growth-y"] = "DOWN"
                self.Buffs.num = config.units.target.numBuffs
                self.Buffs.onlyShowPlayer = config.units.target.onlyShowPlayerBuffs
                self.Buffs.spacing = 4.5
                self.Buffs.showStealableBuffs = true
            else
                self.Auras = CreateFrame("Frame", "$parentAuras", self)
                self.Auras.gap = true
                self.Auras.size = 20
                self.Auras:SetHeight(self.Auras.size * 3)
                self.Auras:SetWidth(self.Auras.size * 5)
                self.Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
                self.Auras.initialAnchor = "TOPLEFT"
                self.Auras["growth-x"] = "RIGHT"
                self.Auras["growth-y"] = "DOWN"
                self.Auras.numBuffs = config.units.target.numBuffs
                self.Auras.numDebuffs = config.units.target.numDebuffs
                self.Auras.onlyShowPlayer = config.units.target.onlyShowPlayer
                self.Auras.spacing = 4.5
                self.Auras.showStealableBuffs = true
                self.Auras.debuffFilter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"

                self.Auras.PostUpdateGapIcon = function(self, unit, icon, visibleBuffs)
                    icon:Hide()
                end
            end
        end

        if not config.units.target.showDebuffsOnTop and config.units.target.showThreatValue then
            self.NumericalThreat = CreateFrame("Frame", "$parentNumericalThreat", self)
            self.NumericalThreat:SetSize(49, 18)
            self.NumericalThreat:SetPoint("BOTTOM", self, "TOP", 0, 0)
            self.NumericalThreat:Hide()

            self.NumericalThreat.bg = self.NumericalThreat:CreateTexture("$parentNumericalThreatBG", "ARTWORK")
            self.NumericalThreat.bg:SetDrawLayer("ARTWORK", 6)
            self.NumericalThreat.bg:SetPoint("TOP", 0, -3)
            self.NumericalThreat.bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
            self.NumericalThreat.bg:SetSize(37, 14)

            self.NumericalThreat.value = self.NumericalThreat:CreateFontString("$parentNumericalThreatText", "OVERLAY", "GameFontHighlight")
            self.NumericalThreat.value:SetPoint("TOP", 1, -3)

            self.NumericalThreat.texture = self.NumericalThreat:CreateTexture("$parentNumericalThreatTexture", "ARTWORK")
            self.NumericalThreat.texture:SetPoint("TOP", 0, 0)
            self.NumericalThreat.texture:SetDrawLayer("ARTWORK", 7)
            self.NumericalThreat.texture:SetTexture("Interface\\TargetingFrame\\NumericThreatBorder")
            self.NumericalThreat.texture:SetTexCoord(0, 0.765625, 0, 0.5625)
            self.NumericalThreat.texture:SetSize(49, 18)
        end

            -- Battle Pet Icon

        self.petBattleIcon = self:CreateTexture("$parentPetBattleIcon", "ARTWORK")
        self.petBattleIcon:SetSize(32, 32)
        self.petBattleIcon:SetPoint("CENTER", self.Portrait, "RIGHT")

            -- Target Events

        self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateTargetFrame)
        self:RegisterEvent("PLAYER_REGEN_DISABLED", UpdateTargetFrame)
        self:RegisterEvent("PLAYER_REGEN_ENABLED", UpdateTargetFrame)
        self:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateTargetFrame)
        self:RegisterEvent("UNIT_TARGETABLE_CHANGED", UpdateTargetFrame)
        self:RegisterEvent("UNIT_FACTION", UpdateTargetFrame)
        self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateTargetFrame)
        self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateTargetFrame)
        self:RegisterEvent("UNIT_LEVEL", UpdateTargetFrame)
    end

    if unit == "focus" then
        CreateTab(self, FOCUS)

        self.T[4]:SetPoint("BOTTOM", self.T[1], -4, 2)

        self.FClose = CreateFrame("Button", "$parentFClose", self, "SecureActionButtonTemplate")
        self.FClose:EnableMouse(true)
        self.FClose:RegisterForClicks("AnyUp")
        self.FClose:SetAttribute("type", "macro")
        self.FClose:SetAttribute("macrotext", "/clearfocus")
        self.FClose:SetSize(20, 20)
        self.FClose:SetAlpha(0.65)
        self.FClose:SetPoint("TOPLEFT", self, (56 + (self.T[1]:GetWidth()/2)), 17)
        self.FClose:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
        self.FClose:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
        self.FClose:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
        self.FClose:GetHighlightTexture():SetBlendMode("ADD")

        self.FClose:SetScript("OnLeave", function()
            securecall("UIFrameFadeOut", self.T[4], 0.15, self.T[4]:GetAlpha(), 0.5)
        end)

        self.FClose:SetScript("OnEnter", function()
            securecall("UIFrameFadeIn", self.T[4], 0.15, self.T[4]:GetAlpha(), 1)
        end)

        if not config.units[ns.cUnit(unit)].disableAura then
            self.Auras = CreateFrame("Frame", "$parentAuras", self)
            self.Auras.gap = true
            self.Auras.size = 20
            self.Auras:SetHeight(self.Auras.size * 3)
            self.Auras:SetWidth(self.Auras.size * 5)
            self.Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -5)
            self.Auras.initialAnchor = "TOPLEFT"
            self.Auras["growth-x"] = "RIGHT"
            self.Auras["growth-y"] = "DOWN"
            self.Auras.numBuffs = (config.units[ns.cUnit(unit)].debuffsOnly and 0 ) or config.units.target.numBuffs
            self.Auras.numDebuffs = config.units.target.numDebuffs
            self.Auras.spacing = 4.5
            self.Auras.showStealableBuffs = true
            self.Auras.onlyShowPlayer = config.units.focus.onlyShowPlayer

            self.Auras.PostUpdateGapIcon = function(self, unit, icon, visibleBuffs)
                icon:Hide()
            end
        end

            -- Focus Events

        self:RegisterEvent("PLAYER_FOCUS_CHANGED", UpdateFocusFrame)
        self:RegisterEvent("UNIT_LEVEL", UpdateFocusFrame)
        self:RegisterEvent("UNIT_CLASSIFICATION_CHANGED", UpdateFocusFrame)

        self:SetScript("OnHide", function(self)
            CloseDropDownMenus()
        end)
    end

    if self.IsTargetFrame then
        self:SetSize(93, 45)

        if not config.units[ns.cUnit(unit)].disableAura then
            self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
            self.Debuffs:SetHeight(20)
            self.Debuffs:SetWidth(20 * 3)
            self.Debuffs.size = 20
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 7, 0)
            self.Debuffs.initialAnchor = "LEFT"
            self.Debuffs["growth-y"] = "DOWN"
            self.Debuffs["growth-x"] = "RIGHT"
            self.Debuffs.num = 4
        end
    end

    if self.IsPartyFrame then
        self:SetSize(105, 30)

        if not config.units[ns.cUnit(unit)].disableAura then
            self.Debuffs = CreateFrame("Frame", "$parentDebuffs", self)
            self.Debuffs:SetFrameStrata("BACKGROUND")
            self.Debuffs:SetHeight(20)
            self.Debuffs:SetWidth(20 * 3)
            self.Debuffs.size = 20
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 5, 1)
            self.Debuffs.initialAnchor = "LEFT"
            self.Debuffs["growth-y"] = "DOWN"
            self.Debuffs["growth-x"] = "RIGHT"
            self.Debuffs.num = 3
        end
    end

        -- Mouseover Text

    if config.units[ns.cUnit(unit)] and config.units[ns.cUnit(unit)].mouseoverText then
        EnableMouseOver(self)
    end

    if self.Auras then
        self.Auras.PostCreateIcon = ns.UpdateAuraIcons
        self.Auras.PostUpdateIcon = ns.PostUpdateIcon
        self.Auras.showDebuffType = true
    end
    if self.Buffs then
        self.Buffs.PostCreateIcon = ns.UpdateAuraIcons
        self.Buffs.PostUpdateIcon = ns.PostUpdateIcon
    end
    if self.Debuffs then
        self.Debuffs.PostCreateIcon = ns.UpdateAuraIcons
        self.Debuffs.PostUpdateIcon = ns.PostUpdateIcon
        self.Debuffs.showDebuffType = true
    end

    self:SetScale(config.units[ns.cUnit(unit)] and config.units[ns.cUnit(unit)].scale or 1)

        -- Range Check

    if unit == "pet" or self.IsPartyFrame then
        self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }
    end

    return self
end

oUF:RegisterStyle("oUF_Neav", CreateUnitLayout)
oUF:Factory(function(self)

        -- Player frame spawn

    local player = self:Spawn("player", "oUF_Neav_Player")
    player:SetPoint(unpack(config.units.player.position))
    player:RegisterForDrag("LeftButton")
    player:SetFrameStrata("LOW")

    player:SetScript("OnReceiveDrag", function()
        if CursorHasItem() and not InCombatLockdown() then
            AutoEquipCursorItem()
        end
    end)

        -- Pet frame spawn

    local pet = self:Spawn("pet", "oUF_Neav_Pet")
    pet:SetPoint("TOPLEFT", player, "BOTTOMLEFT", unpack(config.units.pet.position))
    pet:SetFrameStrata("LOW")

        -- Target frame spawn

    local target = self:Spawn("target", "oUF_Neav_Target")
    target:SetPoint(unpack(config.units.target.position))
    target:RegisterForDrag("LeftButton")
    target:SetFrameStrata("LOW")

    target:SetScript("OnReceiveDrag", function()
        if CursorHasItem() and not InCombatLockdown() then
            AutoEquipCursorItem()
        end
    end)

        -- Targettarget frame spawn

    local targettarget = self:Spawn("targettarget", "oUF_Neav_TargetTarget")
    targettarget:SetPoint("TOPRIGHT", target, "BOTTOMRIGHT", 15, 0)
    targettarget:SetFrameStrata("LOW")

        -- Focus frame spawn

    local focus = self:Spawn("focus", "oUF_Neav_Focus")
    focus:SetPoint(unpack(config.units.focus.position))
    focus:SetFrameStrata("LOW")

        -- Focustarget frame spawn

    local focustarget = self:Spawn("focustarget", "oUF_Neav_FocusTarget")
    focustarget:SetPoint("TOPRIGHT", focus, "BOTTOMRIGHT", 15, 0)
    focustarget:SetFrameStrata("LOW")

        -- Party frame spawn

    if config.units.party.show then
        local party = oUF:SpawnHeader("oUF_Neav_Party", nil, (config.units.party.hideInRaid and "party") or "party,raid",
            "oUF-initialConfigFunction", [[
                self:SetWidth(105)
                self:SetHeight(30)
            ]],
            "showParty", true,
            "yOffset", -30
        )
        party:SetPoint(unpack(config.units.party.position))
        party:SetFrameStrata("LOW")
    end
end)
