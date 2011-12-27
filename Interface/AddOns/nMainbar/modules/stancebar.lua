
local _, nMainbar = ...
local cfg = nMainbar.Config

ShapeshiftBarFrame:SetFrameStrata('HIGH')

ShapeshiftBarFrame:SetScale(cfg.stanceBar.scale)
ShapeshiftBarFrame:SetAlpha(cfg.stanceBar.alpha)

if (cfg.stanceBar.hide) then
    for i = 1, NUM_SHAPESHIFT_SLOTS do
        local button = _G['ShapeshiftButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

