
ShapeshiftBarFrame:SetFrameStrata('HIGH')

ShapeshiftBarFrame:SetScale(nMainbar.stanceBar.scale)
ShapeshiftBarFrame:SetAlpha(nMainbar.stanceBar.alpha)

    -- hide the stancebar

if (nMainbar.stanceBar.hide) then
    for i = 1, NUM_SHAPESHIFT_SLOTS do
        local button = _G['ShapeshiftButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end

        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

