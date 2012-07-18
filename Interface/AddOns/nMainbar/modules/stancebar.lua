
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
-- re-positioning StanceButton1 when GetNumShapeshiftForms() == 1. Ugly as
-- hell, but StanceButton1 is extremely taint prone if manipulated at the wrong
-- time. All these methods caused taint:
--
-- 1. Forcing a call to StanceBar_Update() have fire before Blizzard applies user positions.
-- 2. Fetching StanceButton1:GetPoint() values early, and re-apply them by hooksecurefunc() on StanceBar_Update().
-- 3. Setting StanceBarFrame.numForms to GetNumShapeshiftForms() so that StanceBarFrame.numForms ~= numForms is always false.
local point, relativeTo, relativePoint, xOffset, yOffset

local f = CreateFrame('Frame')
f:RegisterEvent('VARIABLES_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function(self, event, ...)
    if (event == 'VARIABLES_LOADED') then
        point, relativeTo, relativePoint, xOffset, yOffset = StanceButton1:GetPoint()
        self:UnregisterEvent('VARIABLES_LOADED')
    end

    if (event == 'PLAYER_ENTERING_WORLD') then
        StanceButton1:ClearAllPoints()
        StanceButton1:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
        self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    end
end)
