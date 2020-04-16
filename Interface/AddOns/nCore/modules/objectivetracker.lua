local _, nCore = ...
local L = nCore.L

function nCore:ObjectiveTracker()
    -- Classic: 'ObjectiveTrackerFrame' isn't available? Have commented out the config option for now
    if ( not ObjectiveTrackerFrame ) then return end

    if ( not nCoreDB.ObjectiveTracker ) then return end

    local objectiveTrackerFrame = _G["ObjectiveTrackerFrame"]
    objectiveTrackerFrame:SetHeight(600)
    objectiveTrackerFrame:SetClampedToScreen(true)
    objectiveTrackerFrame:SetMovable(true)
    objectiveTrackerFrame:SetUserPlaced(true)

    local minimizeButton = objectiveTrackerFrame.HeaderMenu.MinimizeButton
    minimizeButton:EnableMouse(true)
    minimizeButton:RegisterForDrag("LeftButton")
    minimizeButton:SetHitRectInsets(-15, 0, -5, -5)
    minimizeButton:SetScript("OnDragStart", function(self)
        if ( IsShiftKeyDown() ) then
            objectiveTrackerFrame:StartMoving()
        end
    end)

    minimizeButton:SetScript("OnDragStop", function(self)
        objectiveTrackerFrame:StopMovingOrSizing()
    end)

    minimizeButton:SetScript("OnEnter", function()
        if ( not InCombatLockdown() ) then
            GameTooltip:SetOwner(minimizeButton, "ANCHOR_TOPLEFT", 0, 10)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L.ObjectiveTrackerButtonTooltip)
            GameTooltip:Show()
        end
    end)

    minimizeButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end
