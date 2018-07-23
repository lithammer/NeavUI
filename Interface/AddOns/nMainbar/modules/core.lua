
local _, nMainbar = ...
local cfg = nMainbar.Config

if (cfg.MainMenuBar.hideGryphons) then
    MainMenuBarArtFrame.LeftEndCap:SetTexCoord(0, 0, 0, 0)
    MainMenuBarArtFrame.RightEndCap:SetTexCoord(0, 0, 0, 0)
end

MainMenuBar:SetScale(cfg.MainMenuBar.scale)
OverrideActionBar:SetScale(cfg.vehicleBar.scale)
