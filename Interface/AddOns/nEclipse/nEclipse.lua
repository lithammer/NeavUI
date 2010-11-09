
if select(2, UnitClass('player')) ~= 'DRUID' then
    return
end

local eclipseBar = CreateFrame('Frame', nil, UIParent)
eclipseBar:SetScale(1)
eclipseBar:SetWidth(198)
eclipseBar:SetHeight(3)
eclipseBar:SetPoint('CENTER', UIParent, 0, -223)
eclipseBar:EnableMouse(false)

eclipseBar:RegisterEvent('PLAYER_REGEN_ENABLED')
eclipseBar:RegisterEvent('PLAYER_REGEN_DISABLED')
eclipseBar:RegisterEvent('PLAYER_LOGIN')

local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
lunarBar:SetHeight(eclipseBar:GetHeight())
lunarBar:SetWidth(eclipseBar:GetWidth())
lunarBar:SetPoint('TOP', eclipseBar, 'BOTTOM', 0, 0)
lunarBar:SetStatusBarTexture('Interface\\AddOns\\nEclipse\\media\\statusbarTexture')
lunarBar:SetStatusBarColor(0.30, 0.52, 0.90, 1)
--lunarBar:SetAlpha(0)
eclipseBar.lunarBar = lunarBar

local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
solarBar:SetHeight(eclipseBar:GetHeight())
solarBar:SetWidth(eclipseBar:GetWidth())
solarBar:SetPoint('TOP', eclipseBar, 'BOTTOM', 0, 0)
solarBar:SetStatusBarTexture('Interface\\AddOns\\nEclipse\\media\\statusbarTexture')
solarBar:SetStatusBarColor(0.80, 0.82, 0.60, 1)
--solarBar:SetAlpha(0)
eclipseBar.solarBar = solarBar

local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
eclipseBarText:SetPoint('BOTTOM', eclipseBar, 'TOP')
eclipseBarText:SetFont('Fonts\\ARIALN.ttf', 14)
eclipseBar.Text = eclipseBarText
self.EclipseBar = eclipseBar

eclipseBar.Shadow = CreateFrame('Frame', nil, eclipseBar)
eclipseBar.Shadow:SetFrameStrata('BACKGROUND')
eclipseBar.Shadow:SetPoint('TOPLEFT', -4, 4)
eclipseBar.Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
eclipseBar.Shadow:SetBackdrop({
	BgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
	edgeFile = 'Interface\\Addons\\nEclipse\\media\\textureGlow', edgeSize = 4,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
eclipseBar.Shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
eclipseBar.Shadow:SetBackdropBorderColor(0, 0, 0)

eclipseBar.Below = eclipseBar.Power:CreateTexture(nil, 'BACKGROUND')
eclipseBar.Below:SetHeight(14)
eclipseBar.Below:SetWidth(14)
eclipseBar.Below:SetTexture('Interface\\AddOns\\nEclipse\\media\\textureArrowBelow')

eclipseBar.Above = eclipseBar.Power:CreateTexture(nil, 'BACKGROUND')
eclipseBar.Above:SetHeight(14)
eclipseBar.Above:SetWidth(14)
eclipseBar.Above:SetTexture('Interface\\AddOns\\nEclipse\\media\\textureArrowAbove')

eclipseBar:SetScript('OnEvent', function(self, event, arg1)
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

        eclipseBar.Power:SetMinMaxValues(0, UnitPowerMax('player', 8))
        eclipseBar.Power:SetValue(UnitPower('player', 8))

        local newPosition = UnitPower('player', 8) / UnitPowerMax('player', 8) * eclipseBar.solarBar:GetWidth() - 7
        eclipseBar.Power.Below:SetPoint('LEFT', eclipseBar.solarBar, 'LEFT', newPosition, -8)
        eclipseBar.Power.Above:SetPoint('LEFT', eclipseBar.solarBar, 'LEFT', newPosition, 8)

		updateTimer = 0
	end
end)