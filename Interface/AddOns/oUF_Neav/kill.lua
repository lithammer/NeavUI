
    -- kill the config entry with stuff like 'show arena background' or 'bigger focustarget'

InterfaceOptionsFrameCategoriesButton10:SetScale(0.00001)
InterfaceOptionsFrameCategoriesButton10:SetAlpha(0)

    -- kill the unitframestuff and 'remove' the playerframe animation functions

for _, button in pairs({
    'CombatPanelTargetOfTarget',
    'CombatPanelTOTDropDown',
    'CombatPanelTOTDropDownButton',
    'CombatPanelEnemyCastBarsOnPortrait',

    'DisplayPanelShowAggroPercentage',
    'DisplayPanelemphasizeMySpellEffects'
}) do
    _G['InterfaceOptions'..button]:SetAlpha(0.35)
    _G['InterfaceOptions'..button]:Disable()
    _G['InterfaceOptions'..button]:EnableMouse(false)
end

function PetFrame_Update() end

function PlayerFrame_AnimateOut() end
function PlayerFrame_AnimFinished() end
function PlayerFrame_ToPlayerArt() end
function PlayerFrame_ToVehicleArt() end

-- InterfaceOptionsFrameCategoriesButton9:SetScale(0.00001)
-- InterfaceOptionsFrameCategoriesButton9:SetAlpha(0)