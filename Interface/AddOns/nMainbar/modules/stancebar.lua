
local _, nMainbar = ...
local cfg = nMainbar.Config

StanceBarFrame:SetFrameStrata('HIGH')

StanceBarFrame:SetScale(cfg.stanceBar.scale)
StanceBarFrame:SetAlpha(cfg.stanceBar.alpha)

hooksecurefunc('UIParent_ManageFramePositions', function()
	if (not MultiBarBottomLeft:IsShown()) then
		SlidingActionBarTexture0:Hide()
		SlidingActionBarTexture1:Hide()
		if ( StanceBarFrame ) then
			StanceBarLeft:Hide()
			StanceBarRight:Hide()
			StanceBarMiddle:Hide()
			for i = 1, NUM_STANCE_SLOTS do
				_G['StanceButton'..i]:GetNormalTexture():SetWidth(52)
				_G['StanceButton'..i]:GetNormalTexture():SetHeight(52)
			end
		end
	end
end)

if (cfg.stanceBar.hide) then
    for i = 1, NUM_STANCE_SLOTS do
        local button = _G['StanceButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end
