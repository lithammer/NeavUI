local _, nCore = ...

function nCore:AutoGreed()
    if not nCoreDB.AutoGreed then return end

    -- Option to only auto-greed at max level.
    local maxLevelOnly = true

    -- Disenchant items when able.
    local disenchantItems = false

    -- A skip list for green stuff you might not wanna auto-greed on
    local skipList = {
        --["Stone Scarab"] = true,
        --["Silver Scarab"] = true,
    }

    local f = CreateFrame("Frame")
    f:RegisterEvent("START_LOOT_ROLL")

    f:SetScript("OnEvent", function(_, _, rollID)
        if maxLevelOnly and UnitLevel("player") == MAX_PLAYER_LEVEL then
            local _, name, _, quality, BoP, _, _, canDisenchant = GetLootRollItemInfo(rollID)
            if quality == 2 and not BoP and not skipList[name] then
                RollOnLoot(rollID, (disenchantItems and canDisenchant and 3) or 2)
            end
        end
    end)
end