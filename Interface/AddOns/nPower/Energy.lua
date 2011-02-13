local _, addon = ...

local playerClass = select(2, UnitClass('player'))
if (playerClass ~= 'ROGUE' and playerClass ~= 'DRUID' or not addon.show.energy) then
    return
end

local ComboColor = addon.comboColor

local Energy = CreateFrame('Frame', nil, UIParent)
Energy:SetScale(1.4)
Energy:SetWidth(18)
Energy:SetHeight(18)
Energy:SetPoint(unpack(addon.position))
Energy:EnableMouse(false)

Energy.Color = PowerBarColor['ENERGY']

Energy:RegisterEvent('PLAYER_REGEN_ENABLED')
Energy:RegisterEvent('PLAYER_REGEN_DISABLED')
Energy:RegisterEvent('PLAYER_LOGIN')
Energy:RegisterEvent('UNIT_COMBO_POINTS')
Energy:RegisterEvent('PLAYER_TARGET_CHANGED')

Energy.Combo = {}

for i = 1, 5 do
    Energy.Combo[i] = Energy:CreateFontString(nil, 'ARTWORK')
    Energy.Combo[i]:SetFont('Fonts\\ARIALN.ttf', 16, 'OUTLINE')
    Energy.Combo[i]:SetShadowOffset(0, 0)
    Energy.Combo[i]:SetParent(Energy)
    Energy.Combo[i]:SetText(i)
	Energy.Combo[i]:SetAlpha(0)
end

Energy.Combo[1]:SetPoint('CENTER', -52, 0)
Energy.Combo[2]:SetPoint('CENTER', -26, 0)
Energy.Combo[3]:SetPoint('CENTER', 0, 0)
Energy.Combo[4]:SetPoint('CENTER', 26, 0)
Energy.Combo[5]:SetPoint('CENTER', 52, 0)

Energy.Power = CreateFrame('StatusBar', nil, UIParent)
Energy.Power:SetHeight(3)
Energy.Power:SetWidth(198)
Energy.Power:SetPoint('TOP', Energy, 'BOTTOM', 0, -7)
Energy.Power:SetStatusBarTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
Energy.Power:SetStatusBarColor(Energy.Color.r, Energy.Color.g, Energy.Color.b, 1)
Energy.Power:SetAlpha(0)

Energy.Power.Value = Energy.Power:CreateFontString(nil, 'ARTWORK')
Energy.Power.Value:SetFont('Fonts\\ARIALN.ttf', 20, 'OUTLINE')
Energy.Power.Value:SetPoint('CENTER', Energy.Power, 0, 1.5)
Energy.Power.Value:SetVertexColor(Energy.Color.r, Energy.Color.g, Energy.Color.b)

Energy.Power.Background = Energy.Power:CreateTexture(nil, 'BACKGROUND')
Energy.Power.Background:SetAllPoints(Energy.Power)
Energy.Power.Background:SetTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
Energy.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

Energy.Power.Background.Shadow = CreateFrame('Frame', nil, Energy.Power)
Energy.Power.Background.Shadow:SetFrameStrata('BACKGROUND')
Energy.Power.Background.Shadow:SetPoint('TOPLEFT', -4, 4)
Energy.Power.Background.Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
Energy.Power.Background.Shadow:SetBackdrop({
	BgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
	edgeFile = 'Interface\\Addons\\nPower\\media\\textureGlow', edgeSize = 4,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
Energy.Power.Background.Shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
Energy.Power.Background.Shadow:SetBackdropBorderColor(0, 0, 0)

Energy.Power.Below = Energy.Power:CreateTexture(nil, 'BACKGROUND')
Energy.Power.Below:SetHeight(14)
Energy.Power.Below:SetWidth(14)
Energy.Power.Below:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowBelow')

Energy.Power.Above = Energy.Power:CreateTexture(nil, 'BACKGROUND')
Energy.Power.Above:SetHeight(14)
Energy.Power.Above:SetWidth(14)
Energy.Power.Above:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowAbove')


local SetComboColor = function(i)
	local comboPoints = GetComboPoints('player', 'target') or 0
	
	if (i > comboPoints or UnitIsDeadOrGhost('target')) then
		return 1, 1, 1
	else
		return ComboColor[i].r, ComboColor[i].g, ComboColor[i].b
	end
end

local SetComboAlpha = function(i)
	local comboPoints = GetComboPoints('player', 'target') or 0
	
	if (UnitIsDeadOrGhost('target') or comboPoints == 0) then
		return 0
	elseif (i > comboPoints) then
		return 0.2
	else
		return 1
	end
end

Energy:SetScript('OnEvent', function(self, event, arg1)
	if (event == 'UNIT_COMBO_POINTS' or event == 'PLAYER_TARGET_CHANGED') then
		for i = 1, 5 do
			Energy.Combo[i]:SetTextColor(SetComboColor(i))
			Energy.Combo[i]:SetAlpha(SetComboAlpha(i))
		end
	end

    if (event == 'PLAYER_LOGIN') then
        Energy:SetAlpha(0.35)
    elseif (event == 'PLAYER_REGEN_ENABLED') then
        UIFrameFadeOut(Energy, 0.35, Energy:GetAlpha(), 0)
    elseif (event == 'PLAYER_REGEN_DISABLED') then
        UIFrameFadeIn(Energy, 0.35, Energy:GetAlpha(), 1)
    end
end)

local updateTimer = 0
local ENERGY = SPELL_POWER_ENERGY
Energy:SetScript('OnUpdate', function(self, elapsed)
	updateTimer = updateTimer + elapsed
	
	if (updateTimer > 0.25) then
        Energy.Power:SetMinMaxValues(0, UnitPowerMax('player', ENERGY))
        Energy.Power:SetValue(UnitPower('player', ENERGY))
        
        Energy.Power.Value:SetText(UnitPower('player', ENERGY) > 0 and UnitPower('player', ENERGY) or '')

        local newPosition = UnitPower('player', ENERGY) / UnitPowerMax('player', ENERGY) * Energy.Power:GetWidth() - 7
        Energy.Power.Below:SetPoint('LEFT', Energy.Power, 'LEFT', newPosition, -8)
        Energy.Power.Above:SetPoint('LEFT', Energy.Power, 'LEFT', newPosition, 8)
		
        if (playerClass == 'ROGUE' or playerClass == 'DRUID' and GetShapeshiftFormID() == CAT_FORM) then
			if (UnitPower('player', ENERGY) < UnitPowerMax('player', ENERGY) and not InCombatLockdown()) then
				UIFrameFadeIn(Energy.Power, 0.35, Energy.Power:GetAlpha(), 0.35)
			elseif (InCombatLockdown()) then
				UIFrameFadeIn(Energy.Power, 0.35, Energy.Power:GetAlpha(), 0.8)
			else
				UIFrameFadeOut(Energy.Power, 0.35, Energy.Power:GetAlpha(), 0)
			end
		else
			UIFrameFadeOut(Energy.Power, 0.35, Energy.Power:GetAlpha(), 0)
		end
        
		updateTimer   = 0
	end
end)