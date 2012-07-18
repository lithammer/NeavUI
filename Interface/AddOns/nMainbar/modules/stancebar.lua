
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

-- HACK: This will prevent Blizzard's StanceBar_Update() function from
-- re-positioning StanceButton1 when GetNumShapeshiftForms() == 1. Ugly as
-- hell, but StanceButton1 is extremely taint prone if manipulated at the wrong
-- time. All these methods caused taint:
--
-- 1. Forcing a call to StanceBar_Update() to have it fire before Blizzard
--    applies user positions from layout-local.txt.
--
-- 2. Fetching StanceButton1:GetPoint() as early as possible after they've been
--    loaded from layout-local.txt, and re-apply them by
--    hooksecurefunc('StanceBar_Update', ...).
--
-- 3. Setting StanceBarFrame.numForms = GetNumShapeshiftForms() so that
--    StanceBarFrame.numForms ~= numForms always evaluates to false.
local point, relativeTo, relativePoint, xOffset, yOffset

local f = CreateFrame('Frame')
f:RegisterEvent('VARIABLES_LOADED')
f:RegisterEvent('PLAYER_ALIVE')
f:SetScript('OnEvent', function(self, event, ...)
    if (event == 'VARIABLES_LOADED') then
        point, relativeTo, relativePoint, xOffset, yOffset = StanceButton1:GetPoint()
        self:UnregisterEvent('VARIABLES_LOADED')
    end

    if (event == 'PLAYER_ALIVE') then
        StanceButton1:ClearAllPoints()
        if (point) then
            StanceButton1:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
        end
        self:UnregisterEvent('PLAYER_ALIVE')
    end
end)
