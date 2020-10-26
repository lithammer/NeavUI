-- Kill Unused Options

for _, button in pairs({
    "CombatPanelTargetOfTarget", -- Target of Target
    "DisplayPanelDisplayDropDown", -- Unit Frame Status Text
}) do
    _G["InterfaceOptions"..button]:SetAlpha(0)
    _G["InterfaceOptions"..button]:SetScale(0.00001)
    _G["InterfaceOptions"..button]:EnableMouse(false)
end

function PetFrame_Update() end -- luacheck: ignore

function PlayerFrame_AnimateOut() end -- luacheck: ignore
function PlayerFrame_AnimFinished() end -- luacheck: ignore
function PlayerFrame_ToPlayerArt() end -- luacheck: ignore
function PlayerFrame_ToVehicleArt() end -- luacheck: ignore
