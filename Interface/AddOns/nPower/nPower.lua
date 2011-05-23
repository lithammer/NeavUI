
local ComboColor = nPower.energy.comboColor
local playerClass = select(2, UnitClass('player'))

local RuneColor = {}
RuneColor[1] = {r = 0.7, g = 0.1, b = 0.1}
RuneColor[2] = {r = 0.7, g = 0.1, b = 0.1}
RuneColor[3] = {r = 0.4, g = 0.8, b = 0.2}
RuneColor[4] = {r = 0.4, g = 0.8, b = 0.2}
RuneColor[5] = {r = 0.0, g = 0.6, b = 0.8}
RuneColor[6] = {r = 0.0, g = 0.6, b = 0.8}

local f = CreateFrame('Frame', nil, UIParent)
f:SetScale(1.4)
f:SetSize(18, 18)
f:SetPoint(unpack(nPower.position))
f:EnableMouse(false)

f:RegisterEvent('PLAYER_REGEN_ENABLED')
f:RegisterEvent('PLAYER_REGEN_DISABLED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')

f:RegisterEvent('UNIT_COMBO_POINTS')
f:RegisterEvent('PLAYER_TARGET_CHANGED')

f:RegisterEvent('RUNE_TYPE_UPDATE')

-- f:RegisterEvent('UNIT_DISPLAYPOWER')
-- f:RegisterEvent('UNIT_POWER')
-- f:RegisterEvent('UPDATE_SHAPESHIFT_FORM')

if (nPower.energy.showComboPoints) then
    f.ComboPoints = {}

    for i = 1, 5 do
        f.ComboPoints[i] = f:CreateFontString(nil, 'ARTWORK')
        
        if (nPower.energy.comboFontOutline) then
            f.ComboPoints[i]:SetFont(nPower.energy.comboFont, nPower.energy.comboFontSize, 'THINOUTLINE')
            f.ComboPoints[i]:SetShadowOffset(0, 0)
        else
            f.ComboPoints[i]:SetFont(nPower.energy.comboFont, nPower.energy.comboFontSize)
            f.ComboPoints[i]:SetShadowOffset(1, -1)
        end
        
        f.ComboPoints[i]:SetParent(f)
        f.ComboPoints[i]:SetText(i)
        f.ComboPoints[i]:SetAlpha(0)
    end

    f.ComboPoints[1]:SetPoint('CENTER', -52, 0)
    f.ComboPoints[2]:SetPoint('CENTER', -26, 0)
    f.ComboPoints[3]:SetPoint('CENTER', 0, 0)
    f.ComboPoints[4]:SetPoint('CENTER', 26, 0)
    f.ComboPoints[5]:SetPoint('CENTER', 52, 0)
end

if (playerClass == 'DEATHKNIGHT' and nRune.rune.showRuneCooldown) then
    for i = 1, 6 do 
        RuneFrame:UnregisterAllEvents()
        _G['RuneButtonIndividual'..i]:Hide()
    end

    f.Rune = {}

    for i = 1, 6 do
        f.Rune[i] = f:CreateFontString(nil, 'ARTWORK')
        
        if (nPower.rune.runeFontOutline) then
            f.Rune[i]:SetFont(nPower.rune.runeFont, nPower.rune.runeFontSize, 'THINOUTLINE')
            f.Rune[i]:SetShadowOffset(0, 0)
        else
            f.Rune[i]:SetFont(nPower.rune.runeFont, nPower.rune.runeFontSize)
            f.Rune[i]:SetShadowOffset(1, -1)
        end

        f.Rune[i]:SetShadowOffset(0, 0)
        f.Rune[i]:SetParent(f)
    end

    f.Rune[1]:SetPoint('CENTER', -65, 0)
    f.Rune[2]:SetPoint('CENTER', -39, 0)
    f.Rune[3]:SetPoint('CENTER', 39, 0)
    f.Rune[4]:SetPoint('CENTER', 65, 0)
    f.Rune[5]:SetPoint('CENTER', -13, 0)
    f.Rune[6]:SetPoint('CENTER', 13, 0)
end

f.Power = CreateFrame('StatusBar', nil, UIParent)
f.Power:SetSize(nPower.sizeWidth, 3)
f.Power:SetPoint('CENTER', f, 0, -10)
f.Power:SetStatusBarTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')

f.Power:SetAlpha(0)

f.Power.Value = f.Power:CreateFontString(nil, 'ARTWORK')

if (nPower.valueFontOutline) then
    f.Power.Value:SetFont(nPower.valueFont, nPower.valueFontSize, 'THINOUTLINE')
    f.Power.Value:SetShadowOffset(0, 0)
else
    f.Power.Value:SetFont(nPower.valueFont, nPower.valueFontSize)
    f.Power.Value:SetShadowOffset(1, -1)
end

f.Power.Value:SetPoint('CENTER', f.Power, 0, nPower.valueFontAdjustmentX)
f.Power.Value:SetVertexColor(1, 1, 1)

f.Power.Background = f.Power:CreateTexture(nil, 'BACKGROUND')
f.Power.Background:SetAllPoints(f.Power)
f.Power.Background:SetTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
f.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

f.Power.BackgroundShadow = CreateFrame('Frame', nil, f.Power)
f.Power.BackgroundShadow:SetFrameStrata('BACKGROUND')
f.Power.BackgroundShadow:SetPoint('TOPLEFT', -4, 4)
f.Power.BackgroundShadow:SetPoint('BOTTOMRIGHT', 4, -4)
f.Power.BackgroundShadow:SetBackdrop({
    BgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
    edgeFile = 'Interface\\Addons\\nPower\\media\\textureGlow', edgeSize = 4,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
f.Power.BackgroundShadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
f.Power.BackgroundShadow:SetBackdropBorderColor(0, 0, 0)

f.Power.Below = f.Power:CreateTexture(nil, 'BACKGROUND')
f.Power.Below:SetHeight(14)
f.Power.Below:SetWidth(14)
f.Power.Below:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowBelow')

f.Power.Above = f.Power:CreateTexture(nil, 'BACKGROUND')
f.Power.Above:SetHeight(14)
f.Power.Above:SetWidth(14)
f.Power.Above:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowAbove')

local function SetComboColor(i)
    local comboPoints = GetComboPoints('player', 'target') or 0

    if (i > comboPoints or UnitIsDeadOrGhost('target')) then
        return 1, 1, 1
    else
        return ComboColor[i].r, ComboColor[i].g, ComboColor[i].b
    end
end

local function SetComboAlpha(i)
    local comboPoints = GetComboPoints('player', 'target') or 0

    if (UnitIsDeadOrGhost('target') or comboPoints == 0) then
        return 0
    elseif (i > comboPoints) then
        return 0.1
    elseif (InCombatLockdown()) then
        return 1
    else
        return 0.5
    end
end

local function GetRuneCooldown(self)
    local start, duration, runeReady = GetRuneCooldown(self)
    local time = floor(GetTime() - start)
    local cooldown = ceil(duration - time)
    
    if (runeReady or UnitIsDeadOrGhost('player')) then
        return '#'
    elseif (not UnitIsDeadOrGhost('player') and cooldown) then
        return cooldown
    end
end

local function SetRuneColor(i)
    if (f.Rune[i].type == 4) then
        return 1, 0, 1
    else
        return RuneColor[i].r, RuneColor[i].g, RuneColor[i].b
    end
end

local function UpdateBarVisibility()
    local _, powerType = UnitPowerType('player')
    
    if ((not nPower.energy.show and powerType == 'ENERGY') or (not nPower.focus.show and powerType == 'FOCUS') or (not nPower.rage.show and powerType == 'RAGE') or (not nPower.mana.show and powerType == 'MANA') or (not nPower.rune.show and powerType == 'RUNEPOWER')) then
        f.Power:SetAlpha(0)
    elseif (InCombatLockdown()) then
        securecall('UIFrameFadeIn', f.Power, 0.3, f.Power:GetAlpha(), nPower.activeAlpha)
    elseif (not InCombatLockdown() and UnitPower('player') > 0) then
        securecall('UIFrameFadeOut', f.Power, 0.3, f.Power:GetAlpha(), nPower.inactiveAlpha)
    elseif (UnitIsDeadOrGhost('player')) then
        securecall('UIFrameFadeOut', f.Power, 0.3, f.Power:GetAlpha(), nPower.emptyAlpha)
    else
        securecall('UIFrameFadeOut', f.Power, 0.3, f.Power:GetAlpha(), nPower.emptyAlpha)
    end
end

local function UpdateArrow()
    if (UnitPower('player') == 0) then
        f.Power.Below:SetAlpha(0.3)
        f.Power.Above:SetAlpha(0.3)
    else
        f.Power.Below:SetAlpha(1)
        f.Power.Above:SetAlpha(1)
    end
    
    local newPosition = UnitPower('player') / UnitPowerMax('player') * f.Power:GetWidth() - 7
    f.Power.Below:SetPoint('LEFT', f.Power, 'LEFT', newPosition, -8)
    f.Power.Above:SetPoint('LEFT', f.Power, 'LEFT', newPosition, 8)
end

local function UpdateBarValue()
    f.Power:SetMinMaxValues(0, UnitPowerMax('player', f))
    f.Power:SetValue(UnitPower('player'))
    f.Power.Value:SetText(UnitPower('player') > 0 and UnitPower('player') or '')
end

local function UpdateBarColor()
    local _, powerType, altR, altG, altB = UnitPowerType('player')
    local unitPower = PowerBarColor[powerType]
    
    if (unitPower) then
        f.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
    else
        f.Power:SetStatusBarColor(altR, altG, altB)
    end
end

local function UpdateBar()
    UpdateBarColor()
    UpdateBarValue()
    UpdateArrow()
end

f:SetScript('OnEvent', function(self, event, arg1)
    if (f.ComboPoints) then
        if (event == 'UNIT_COMBO_POINTS' or event == 'PLAYER_TARGET_CHANGED') then
            for i = 1, 5 do
                f.ComboPoints[i]:SetTextColor(SetComboColor(i))
                f.ComboPoints[i]:SetAlpha(SetComboAlpha(i))
            end
        end
    end
    
    if (event == 'RUNE_TYPE_UPDATE') then
        if (playerClass == 'DEATHKNIGHT') then
            Rune.Rune[arg1].type = GetRuneType(arg1)
        end
    end
    
    -- UpdateBar()
    -- UpdateBarVisibility()
    
    -- if (event == 'PLAYER_ENTERING_WORLD') then
    --     UpdateBar()
    -- end
    
    if (event == 'PLAYER_REGEN_DISABLED') then
        securecall('UIFrameFadeIn', f, 0.35, f:GetAlpha(), 1)
    end
    
    if (event == 'PLAYER_REGEN_ENABLED') then
        securecall('UIFrameFadeOut', f, 0.35, f:GetAlpha(), nPower.inactiveAlpha)
    end
end)

local updateTimer = 0
f:SetScript('OnUpdate', function(self, elapsed)
    updateTimer = updateTimer + elapsed
        
    if (updateTimer > 0.1) then
        if (playerClass == 'DEATHKNIGHT' and nRune.rune.showRuneCooldown) then
            if (f.Rune) then
                for i = 1, 6 do
                    f.Rune[i]:SetText(GetRuneCooldown(i))
                    f.Rune[i]:SetTextColor(SetRuneColor(i))
                end
            end
        end
        
        UpdateBar()
        UpdateBarVisibility()
        
        updateTimer   = 0
    end
end)