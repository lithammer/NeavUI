
local _, nMainbar = ...
local cfg = nMainbar.Config

StanceBarFrame:SetFrameStrata('MEDIUM')

StanceBarFrame:SetScale(cfg.stanceBar.scale)
StanceBarFrame:SetAlpha(cfg.stanceBar.alpha)

if (cfg.stanceBar.hide) then
    hooksecurefunc("StanceBar_Update", function()
        if StanceBarFrame:IsShown() then
            RegisterStateDriver(StanceBarFrame, "visibility", "hide")
            function StanceBar_Update() end
        end
    end)
end
