local _, nCore = ...

function nCore:ErrorFilter()
    UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
    UIErrorsFrame:SetTimeVisible(1)
    UIErrorsFrame:SetFadeDuration(0.75)

    local ignoreList = {
        [LE_GAME_ERR_ABILITY_COOLDOWN] = true,
        [LE_GAME_ERR_SPELL_COOLDOWN] = true,
        [LE_GAME_ERR_SPELL_FAILED_ANOTHER_IN_PROGRESS] = true,

        [LE_GAME_ERR_OUT_OF_HOLY_POWER] = true,
        [LE_GAME_ERR_OUT_OF_POWER_DISPLAY] = true,
        [LE_GAME_ERR_OUT_OF_SOUL_SHARDS] = true,
        [LE_GAME_ERR_OUT_OF_FOCUS] = true,
        [LE_GAME_ERR_OUT_OF_COMBO_POINTS] = true,
        [LE_GAME_ERR_OUT_OF_CHI] = true,
        [LE_GAME_ERR_OUT_OF_PAIN] = true,
        [LE_GAME_ERR_OUT_OF_HEALTH] = true,
        [LE_GAME_ERR_OUT_OF_RAGE] = true,
        [LE_GAME_ERR_OUT_OF_ARCANE_CHARGES] = true,
        [LE_GAME_ERR_OUT_OF_RANGE] = true,
        [LE_GAME_ERR_OUT_OF_ENERGY] = true,
        [LE_GAME_ERR_OUT_OF_LUNAR_POWER] = true,
        [LE_GAME_ERR_OUT_OF_RUNIC_POWER] = true,
        [LE_GAME_ERR_OUT_OF_INSANITY] = true,
        [LE_GAME_ERR_OUT_OF_RUNES] = true,
        [LE_GAME_ERR_OUT_OF_FURY] = true,
        [LE_GAME_ERR_OUT_OF_MAELSTROM] = true,

        [LE_GAME_ERR_SPELL_FAILED_TOTEMS] = true,
        [LE_GAME_ERR_SPELL_FAILED_EQUIPPED_ITEM] = true,
        [LE_GAME_ERR_SPELL_ALREADY_KNOWN_S] = true,
        [LE_GAME_ERR_SPELL_FAILED_SHAPESHIFT_FORM_S] = true,
        [LE_GAME_ERR_SPELL_FAILED_ALREADY_AT_FULL_MANA] = true,
        [LE_GAME_ERR_OUT_OF_MANA] = true,
        [LE_GAME_ERR_SPELL_OUT_OF_RANGE] = true,
        [LE_GAME_ERR_SPELL_FAILED_S] = true,
        [LE_GAME_ERR_SPELL_FAILED_REAGENTS] = true,
        [LE_GAME_ERR_SPELL_FAILED_REAGENTS_GENERIC] = true,
        [LE_GAME_ERR_SPELL_FAILED_NOTUNSHEATHED] = true,
        [LE_GAME_ERR_SPELL_UNLEARNED_S] = true,
        [LE_GAME_ERR_SPELL_FAILED_EQUIPPED_SPECIFIC_ITEM] = true,
        [LE_GAME_ERR_SPELL_FAILED_ALREADY_AT_FULL_POWER_S] = true,
        [LE_GAME_ERR_SPELL_FAILED_EQUIPPED_ITEM_CLASS_S] = true,
        [LE_GAME_ERR_SPELL_FAILED_ALREADY_AT_FULL_HEALTH] = true,
        [LE_GAME_ERR_GENERIC_NO_VALID_TARGETS] = true,
        [LE_GAME_ERR_BADATTACKFACING] = true,
        [LE_GAME_ERR_BADATTACKPOS] = true,

        [LE_GAME_ERR_ITEM_COOLDOWN] = true,
        [LE_GAME_ERR_CANT_USE_ITEM] = true,
        [LE_GAME_ERR_SPELL_FAILED_ANOTHER_IN_PROGRESS] = true,

        [193] = true, -- aka LE_GAME_ERR_NO_ATTACK_TARGET, variable version doesn"t work.
    }

    local f = CreateFrame("Frame")
    f:RegisterEvent("UI_ERROR_MESSAGE")

    f:SetScript("OnEvent", function(self, event, messageType, message)
        if nCoreDB.ErrorFilter and not ignoreList[messageType] then
            UIErrorsFrame:AddMessage(message, 1, .1, .1)
        elseif not nCoreDB.ErrorFilter then
            UIErrorsFrame:AddMessage(message, 1, .1, .1)
        end
    end)
end
