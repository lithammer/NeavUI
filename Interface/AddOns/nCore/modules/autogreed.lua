local AddOn = CreateFrame('Frame')

AddOn:RegisterEvent('START_LOOT_ROLL')
AddOn:SetScript('OnEvent', function(_, _, RollID)
    local _, Name, _, Quality, BoP, _, _, CanDisenchant = GetLootRollItemInfo(RollID)
    if (Quality == 2 and not BoP) then
        RollOnLoot(RollID, CanDisenchant and 3 or 2)
    end
end)