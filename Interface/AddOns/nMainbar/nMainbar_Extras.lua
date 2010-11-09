--[[

    nMainbar
    Copyright (c) 2008-2010, Anton "Neav" I. (Neav @ Alleria-EU)
    All rights reserved.

--]]

SlashCmdList['GM'] = function()
    ToggleHelpFrame() 
end

SLASH_GM1 = '/gm'
SLASH_GM2 = '/ticket'
    
if (nMainbar.MainMenuBar.hideGryphons) then
    MainMenuBarLeftEndCap:SetAlpha(0)
    MainMenuBarRightEndCap:SetAlpha(0)
end

MultiBarLeft:SetAlpha(nMainbar.multiBarLeft.alpha)
MultiBarRight:SetAlpha(nMainbar.multiBarRight.alpha)

MultiBarBottomLeft:SetAlpha(nMainbar.multiBarBottomLeft.alpha)
MultiBarBottomRight:SetAlpha(nMainbar.multiBarBottomRight.alpha)
    
for _, bar in pairs({
    'MainMenuBar',
                
    'MultiBarLeft',
    'MultiBarRight',
                
    'MultiBarBottomLeft',
    'MultiBarBottomRight',
}) do
    _G[bar]:SetScale(nMainbar.MainMenuBar.scale)
end

-- scaling of the vehicle frame
VehicleMenuBar:SetScale(nMainbar.vehicle.scale)
-- scaling of the shapeshiftbar
ShapeshiftBarFrame:SetScale(nMainbar.stanceBar.scale)
-- scaling of the possessbar
PossessBarFrame:SetScale(nMainbar.possessbar.scale)
-- scaling of the petbar
PetActionBarFrame:SetScale(nMainbar.petbar.scale)
