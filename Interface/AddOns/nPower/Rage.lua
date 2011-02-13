local _, addon = ...

local playerClass = select(2, UnitClass('player'))
if (playerClass ~= 'WARRIOR' and playerClass ~= 'DRUID' and addon.show.rage) then
    return
end

local Rage = CreateFrame('Frame', nil, UIParent)
Rage:SetScale(1.4)
Rage:SetWidth(18)
Rage:SetHeight(18)
Rage:SetPoint('CENTER', UIParent, 0, -223)
Rage:EnableMouse(false)

Rage.Color = PowerBarColor['RAGE']

Rage:RegisterEvent('PLAYER_REGEN_ENABLED')
Rage:RegisterEvent('PLAYER_REGEN_DISABLED')
Rage:RegisterEvent('PLAYER_LOGIN')

Rage.Power = CreateFrame('StatusBar', nil, UIParent)
Rage.Power:SetHeight(3)
Rage.Power:SetWidth(198)
Rage.Power:SetPoint('TOP', Rage, 'BOTTOM', 0, -7)
Rage.Power:SetStatusBarTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
Rage.Power:SetStatusBarColor(Rage.Color.r, Rage.Color.g, Rage.Color.b, 1)
Rage.Power:SetAlpha(0)

Rage.Power.Value = Rage.Power:CreateFontString(nil, 'ARTWORK')
Rage.Power.Value:SetFont('Fonts\\ARIALN.ttf', 20, 'OUTLINE')
Rage.Power.Value:SetPoint('CENTER', Rage.Power, 0, 1.5)
Rage.Power.Value:SetVertexColor(Rage.Color.r, Rage.Color.g, Rage.Color.b)

Rage.Power.Background = Rage.Power:CreateTexture(nil, 'BACKGROUND')
Rage.Power.Background:SetAllPoints(Rage.Power)
Rage.Power.Background:SetTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
Rage.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

Rage.Power.Background.Shadow = CreateFrame('Frame', nil, Rage.Power)
Rage.Power.Background.Shadow:SetFrameStrata('BACKGROUND')
Rage.Power.Background.Shadow:SetPoint('TOPLEFT', -4, 4)
Rage.Power.Background.Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
Rage.Power.Background.Shadow:SetBackdrop({
	BgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
	edgeFile = 'Interface\\Addons\\nPower\\media\\textureGlow', edgeSize = 4,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
Rage.Power.Background.Shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
Rage.Power.Background.Shadow:SetBackdropBorderColor(0, 0, 0)

Rage.Power.Below = Rage.Power:CreateTexture(nil, 'BACKGROUND')
Rage.Power.Below:SetHeight(14)
Rage.Power.Below:SetWidth(14)
Rage.Power.Below:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowBelow')

Rage.Power.Above = Rage.Power:CreateTexture(nil, 'BACKGROUND')
Rage.Power.Above:SetHeight(14)
Rage.Power.Above:SetWidth(14)
Rage.Power.Above:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowAbove')

Rage:SetScript('OnEvent', function(self, event, arg1)
    if (event == 'PLAYER_LOGIN') then
        Rage:SetAlpha(0.35)
    elseif (event == 'PLAYER_REGEN_ENABLED') then
        UIFrameFadeOut(Rage, 0.35, Rage:GetAlpha(), 0.35)
    elseif (event == 'PLAYER_REGEN_DISABLED') then
        UIFrameFadeIn(Rage, 0.35, Rage:GetAlpha(), 1)
    end
end)

local updateTimer = 0
local RAGE = SPELL_POWER_RAGE
Rage:SetScript('OnUpdate', function(self, elapsed)
	updateTimer = updateTimer + elapsed
	
	if (updateTimer > 0.25) then
        Rage.Power:SetMinMaxValues(0, UnitPowerMax('player', RAGE))
        Rage.Power:SetValue(UnitPower('player', RAGE))
        
        Rage.Power.Value:SetText(UnitPower('player', RAGE) > 0 and UnitPower('player', RAGE) or '')

        local newPosition = UnitPower('player', RAGE) / UnitPowerMax('player', RAGE) * Rage.Power:GetWidth() - 7
        Rage.Power.Below:SetPoint('LEFT', Rage.Power, 'LEFT', newPosition, -8)
        Rage.Power.Above:SetPoint('LEFT', Rage.Power, 'LEFT', newPosition, 8)
        
        if (playerClass == 'WARRIOR' and UnitPower('player', RAGE) >= 1) then
			UIFrameFadeIn(Rage.Power, 0.35, Rage.Power:GetAlpha(), 0.8)
		elseif (playerClass == 'DRUID' and GetShapeshiftFormID() == BEAR_FORM and UnitPower('player', RAGE) >= 1) then
			UIFrameFadeIn(Rage.Power, 0.35, Rage.Power:GetAlpha(), 0.8)
        else
			UIFrameFadeOut(Rage.Power, 0.35, Rage.Power:GetAlpha(), 0)
        end
        
		updateTimer   = 0
	end
end)