local _, nMainbar = ...
local cfg = nMainbar.Config

if not cfg.MainMenuBar.moveableExtraBars then
    return
end

 -- Moveable Bars

for _, frame in pairs({
    _G["PetActionBarFrame"],
    _G["StanceBarFrame"],
    _G["PossessBarFrame"],
}) do
    frame:EnableMouse(false)
end

    -- Shift + alt-key and left mouse to move.

for _, button in pairs({
    _G["PossessButton1"],
    _G["PetActionButton1"],
    _G["StanceButton1"],
}) do
    button:ClearAllPoints()
    button:SetPoint("CENTER", UIParent, -100)

    button:SetMovable(true)
    button:SetUserPlaced(true)

    button:RegisterForDrag("LeftButton")
    button:HookScript("OnDragStart", function(self)
        if IsShiftKeyDown() and IsAltKeyDown() then
            self:StartMoving()
        end
    end)

    button:HookScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
end
