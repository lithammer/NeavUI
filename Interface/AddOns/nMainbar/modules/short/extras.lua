
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.shortBar and not cfg.MainMenuBar.moveableExtraBars) then
    return
end

    -- moveable bars

for _, frame in pairs({
    _G['PetActionBarFrame'],
    _G['StanceBarFrame'],
    _G['PossessBarFrame'],
    _G['MultiCastActionBarFrame'],
}) do
    frame:EnableMouse(false)
end

    -- key + alt-key and left mouse to move

for _, button in pairs({
    _G['PossessButton1'],
    _G['PetActionButton1'],
    _G['StanceButton1'],
    _G['StanceBarFrame'],
}) do
    button:ClearAllPoints()
    button:SetPoint('CENTER', UIParent, -100)

    button:SetMovable(true)
    button:SetUserPlaced(true)

    button:RegisterForDrag('LeftButton')
    button:HookScript('OnDragStart', function(self)
        if (IsShiftKeyDown() and IsAltKeyDown()) then
            self:StartMoving()
        end
    end)

    button:HookScript('OnDragStop', function(self) 
        self:StopMovingOrSizing()
    end)
end

-- HACK: This will prevent Blizzard's StanceBar_Update() function from
-- re-positioning StanceButton1 when GetNumShapeshiftForms() == 1.
if (GetNumShapeshiftForms() == 1) then
    StanceButton1:HookScript('OnDragStop', function(self)
        local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint()
        StanceBarFrame:ClearAllPoints()
        -- 12 and 3 is to offset for StanceButton1's relative position towards StanceBarFrame set by StanceBar_Update()
        StanceBarFrame:SetPoint(point, relativeTo, relativePoint, xOffset - 12, yOffset - 3)
    end)
end
