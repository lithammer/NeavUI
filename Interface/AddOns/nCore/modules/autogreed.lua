
-- A skip list for green stuff you might not wanna auto-greed on
local skipList = {
    --['Stone Scarab'] = true,
    --['Silver Scarab'] = true,
}

local f = CreateFrame('Frame')
f:RegisterEvent('START_LOOT_ROLL')
f:SetScript('OnEvent', function(_, _, rollID)
    local _, name, _, quality, BoP, _, _, canDisenchant = GetLootRollItemInfo(rollID)
    if (quality == 2 and not BoP and not skipList[name]) then
        RollOnLoot(rollID, canDisenchant and 3 or 2)
    end
end)
