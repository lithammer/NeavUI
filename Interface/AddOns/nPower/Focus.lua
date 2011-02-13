local _, addon = ...

local playerClass = select(2, UnitClass('player'))
if (playerClass ~= 'HUNTER' or not addon.show.focus) then
    return
end

local Focus = CreateFrame('Frame', nil, UIParent)
Focus:SetScale(1.4)
Focus:SetWidth(18)
Focus:SetHeight(18)
Focus:SetPoint(unpack(addon.position))
Focus:EnableMouse(false)

Focus.Color = PowerBarColor['FOCUS']

Focus:RegisterEvent('PLAYER_REGEN_ENABLED')
Focus:RegisterEvent('PLAYER_REGEN_DISABLED')
Focus:RegisterEvent('PLAYER_LOGIN')

Focus.Power = CreateFrame('StatusBar', nil, UIParent)
Focus.Power:SetHeight(3)
Focus.Power:SetWidth(198)
Focus.Power:SetPoint('TOP', Focus, 'BOTTOM', 0, -7)
Focus.Power:SetStatusBarTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
Focus.Power:SetStatusBarColor(Focus.Color.r, Focus.Color.g, Focus.Color.b, 1)
Focus.Power:SetAlpha(0)

Focus.Power.Value = Focus.Power:CreateFontString(nil, 'ARTWORK')
Focus.Power.Value:SetFont('Fonts\\ARIALN.ttf', 20, 'OUTLINE')
Focus.Power.Value:SetPoint('CENTER', Focus.Power, 0, 1.5)
Focus.Power.Value:SetVertexColor(Focus.Color.r, Focus.Color.g, Focus.Color.b)

Focus.Power.Background = Focus.Power:CreateTexture(nil, 'BACKGROUND')
Focus.Power.Background:SetAllPoints(Focus.Power)
Focus.Power.Background:SetTexture('Interface\\AddOns\\nPower\\media\\statusbarTexture')
Focus.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

Focus.Power.Background.Shadow = CreateFrame('Frame', nil, Focus.Power)
Focus.Power.Background.Shadow:SetFrameStrata('BACKGROUND')
Focus.Power.Background.Shadow:SetPoint('TOPLEFT', -4, 4)
Focus.Power.Background.Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
Focus.Power.Background.Shadow:SetBackdrop({
	BgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
	edgeFile = 'Interface\\Addons\\nPower\\media\\textureGlow', edgeSize = 4,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
Focus.Power.Background.Shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
Focus.Power.Background.Shadow:SetBackdropBorderColor(0, 0, 0)

Focus.Power.Below = Focus.Power:CreateTexture(nil, 'BACKGROUND')
Focus.Power.Below:SetHeight(14)
Focus.Power.Below:SetWidth(14)
Focus.Power.Below:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowBelow')

Focus.Power.Above = Focus.Power:CreateTexture(nil, 'BACKGROUND')
Focus.Power.Above:SetHeight(14)
Focus.Power.Above:SetWidth(14)
Focus.Power.Above:SetTexture('Interface\\AddOns\\nPower\\media\\textureArrowAbove')

Focus:SetScript('OnEvent', function(self, event, arg1)
    if (event == 'PLAYER_LOGIN') then
        Focus:SetAlpha(0.35)
    elseif (event == 'PLAYER_REGEN_ENABLED') then
        UIFrameFadeOut(Focus, 0.35, Focus:GetAlpha(), 0.35)
    elseif (event == 'PLAYER_REGEN_DISABLED') then
        UIFrameFadeIn(Focus, 0.35, Focus:GetAlpha(), 1)
    end
end)

local updateTimer = 0
local FOCUS = SPELL_POWER_FOCUS
Focus:SetScript('OnUpdate', function(self, elapsed)
	updateTimer = updateTimer + elapsed
	
	if (updateTimer > 0.25) then
        Focus.Power:SetMinMaxValues(0, UnitPowerMax('player', FOCUS))
        Focus.Power:SetValue(UnitPower('player', FOCUS))
        
        Focus.Power.Value:SetText(UnitPower('player', FOCUS) > 0 and UnitPower('player', FOCUS) or '')

        local newPosition = UnitPower('player', FOCUS) / UnitPowerMax('player', FOCUS) * Focus.Power:GetWidth() - 7
        Focus.Power.Below:SetPoint('LEFT', Focus.Power, 'LEFT', newPosition, -8)
        Focus.Power.Above:SetPoint('LEFT', Focus.Power, 'LEFT', newPosition, 8)
        
        if (UnitPower('player', FOCUS) < UnitPowerMax('player', FOCUS) and not InCombatLockdown()) then
			UIFrameFadeIn(Focus.Power, 0.35, Focus.Power:GetAlpha(), 0.35)
		elseif (InCombatLockdown()) then
			UIFrameFadeIn(Focus.Power, 0.35, Focus.Power:GetAlpha(), 0.8)
        else
			UIFrameFadeOut(Focus.Power, 0.35, Focus.Power:GetAlpha(), 0)
        end
        
		updateTimer   = 0
	end
end)