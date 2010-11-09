
if select(2, UnitClass('player')) ~= 'DRUID' then
    return
end

local eclipseBar = CreateFrame('Frame', nil, UIParent)
eclipseBar:SetScale(1)
eclipseBar:SetWidth(100)
eclipseBar:SetHeight(3)
eclipseBar:SetPoint('CENTER', UIParent, eclipseBar:GetWidth() / 2 * -1, -223)
eclipseBar:EnableMouse(false)

eclipseBar:RegisterEvent('PLAYER_REGEN_ENABLED')
eclipseBar:RegisterEvent('PLAYER_REGEN_DISABLED')
eclipseBar:RegisterEvent('PLAYER_LOGIN')

local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
lunarBar:SetStatusBarTexture('Interface\\AddOns\\nEclipse\\media\\statusbarTexture')
lunarBar:SetStatusBarColor(0.30, 0.52, 0.90, 1)
eclipseBar.lunarBar = lunarBar

local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
solarBar:SetStatusBarTexture('Interface\\AddOns\\nEclipse\\media\\statusbarTexture')
solarBar:SetStatusBarColor(1, 0.8, 0, 1)
eclipseBar.solarBar = solarBar

local eclipseBarText = eclipseBar:CreateFontString(nil, 'OVERLAY')
eclipseBarText:SetPoint('BOTTOM', eclipseBar, 'TOP', 0, 0)
eclipseBarText:SetFont('Fonts\\ARIALN.ttf', 14)
eclipseBar.Text = eclipseBarText

EclipseBar = eclipseBar

eclipseBar.Shadow = CreateFrame('Frame', nil, eclipseBar)
eclipseBar.Shadow:SetFrameStrata('BACKGROUND')
eclipseBar.Shadow:SetPoint('TOPLEFT', -4, 4)
eclipseBar.Shadow:SetPoint('BOTTOMRIGHT', 4 + eclipseBar:GetWidth(), -4)
eclipseBar.Shadow:SetBackdrop({
	BgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
	edgeFile = 'Interface\\Addons\\nEclipse\\media\\textureGlow', edgeSize = 4,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
eclipseBar.Shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
eclipseBar.Shadow:SetBackdropBorderColor(0, 0, 0)

eclipseBar.Below = eclipseBar:CreateTexture(nil, 'BACKGROUND')
eclipseBar.Below:SetHeight(14)
eclipseBar.Below:SetWidth(14)
eclipseBar.Below:SetTexture('Interface\\AddOns\\nEclipse\\media\\textureArrowBelow')

eclipseBar.Above = eclipseBar:CreateTexture(nil, 'BACKGROUND')
eclipseBar.Above:SetHeight(14)
eclipseBar.Above:SetWidth(14)
eclipseBar.Above:SetTexture('Interface\\AddOns\\nEclipse\\media\\textureArrowAbove')

eclipseBar:SetScript('OnEvent', function(self, event, arg1)
	if GetPrimaryTalentTree() ~= 1 then
		eclipseBar:Hide()
		return
	else
		eclipseBar:Show()
	end
	
    if (event == 'PLAYER_LOGIN') then
        eclipseBar:SetAlpha(0.35)
    elseif (event == 'PLAYER_REGEN_ENABLED') then
        UIFrameFadeOut(eclipseBar, 0.35, eclipseBar:GetAlpha(), 0.35)
    elseif (event == 'PLAYER_REGEN_DISABLED') then
        UIFrameFadeIn(eclipseBar, 0.35, eclipseBar:GetAlpha(), 1)
    end
end)

local updateTimer = 0
eclipseBar:SetScript('OnUpdate', function(self, elapsed)
	updateTimer = updateTimer + elapsed
	if (updateTimer > 0.25) then
        local newPosition = UnitPower('player', 8) / UnitPowerMax('player', 8) * eclipseBar.solarBar:GetWidth() - 7
        eclipseBar.Below:SetPoint('LEFT', eclipseBar, 'RIGHT', newPosition, -8)
        eclipseBar.Above:SetPoint('LEFT', eclipseBar, 'RIGHT', newPosition, 8)

		updateTimer = 0
	end
end)