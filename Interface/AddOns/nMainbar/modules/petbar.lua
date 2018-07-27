
local _, nMainbar = ...
local cfg = nMainbar.Config

PetActionBarFrame:SetFrameStrata("MEDIUM")

PetActionBarFrame:SetScale(cfg.petBar.scale)
PetActionBarFrame:SetAlpha(cfg.petBar.alpha)

   -- horizontal/vertical bars

if (cfg.petBar.vertical) then
    for i = 2, 10 do
        local button = _G["PetActionButton"..i]
        button:ClearAllPoints()
        button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -8)
    end
end

hooksecurefunc("PetActionButton_SetHotkeys", function(self)
    local hotkey = _G[self:GetName().."HotKey"]
    if (not cfg.button.showKeybinds) then
        hotkey:Hide()
    end
end)

if (not cfg.button.showKeybinds) then
    for i = 1, NUM_PET_ACTION_SLOTS, 1 do
        local buttonName = _G["PetActionButton"..i]
        PetActionButton_SetHotkeys(buttonName)
    end
end
