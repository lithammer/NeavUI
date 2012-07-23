
local _, nMainbar = ...
local cfg = nMainbar.Config

if (cfg.MainMenuBar.hideGryphons) then
    MainMenuBarLeftEndCap:SetTexCoord(0, 0, 0, 0)
    MainMenuBarRightEndCap:SetTexCoord(0, 0, 0, 0)
end

MainMenuBar:SetScale(cfg.MainMenuBar.scale)
OverrideActionBar:SetScale(cfg.vehicleBar.scale)
