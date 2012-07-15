
local _, nMainbar = ...
local cfg = nMainbar.Config

StanceBarFrame:SetFrameStrata('HIGH')

StanceBarFrame:SetScale(cfg.stanceBar.scale)
StanceBarFrame:SetAlpha(cfg.stanceBar.alpha)

if (cfg.stanceBar.hide) then
    for i = 1, NUM_STANCE_SLOTS do
        local button = _G['StanceButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

StanceBarLeft:SetTexture('')
StanceBarMiddle:SetTexture('')
StanceBarRight:SetTexture('')

hooksecurefunc('UIParent_ManageFramePositions', function()
    if (StanceBarFrame) then
        for i = 1, NUM_STANCE_SLOTS do
            _G['StanceButton'..i]:GetNormalTexture():SetSize(52, 52)
        end
    end
end)

-- HACK: This will prevent Blizzard's StanceBar_Update() function from
-- re-positioning StanceBarFrame when GetNumShapeshiftForms() == 1.
StanceBarFrame.numForms = GetNumShapeshiftForms()
