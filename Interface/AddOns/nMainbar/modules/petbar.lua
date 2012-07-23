
local _, nMainbar = ...
local cfg = nMainbar.Config

PetActionBarFrame:SetFrameStrata('HIGH')

PetActionBarFrame:SetScale(cfg.petBar.scale)
PetActionBarFrame:SetAlpha(cfg.petBar.alpha)

   -- horizontal/vertical bars

if (cfg.petBar.vertical) then
    for i = 2, 10 do
        button = _G['PetActionButton'..i]
        button:ClearAllPoints()
        button:SetPoint('TOP', _G['PetActionButton'..(i - 1)], 'BOTTOM', 0, -8)
    end
end