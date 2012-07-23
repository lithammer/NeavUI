
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
