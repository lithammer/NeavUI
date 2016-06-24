
UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
UIErrorsFrame:SetTimeVisible(1)
UIErrorsFrame:SetFadeDuration(0.75)

local ignoreList = {
    [LE_GAME_ERR_SPELL_COOLDOWN] = true,
    [LE_GAME_ERR_ABILITY_COOLDOWN] = true,

    [LE_GAME_ERR_OUT_OF_ENERGY] = true,
    [LE_GAME_ERR_OUT_OF_CHI] = true,
    [LE_GAME_ERR_OUT_OF_ARCANE_CHARGES] = true,
    [LE_GAME_ERR_OUT_OF_FOCUS] = true,
    [LE_GAME_ERR_OUT_OF_FURY] = true,
    [LE_GAME_ERR_OUT_OF_HOLY_POWER] = true,    
    [LE_GAME_ERR_OUT_OF_INSANITY] = true,
    [LE_GAME_ERR_OUT_OF_LUNAR_POWER] = true,
    [LE_GAME_ERR_OUT_OF_MAELSTROM] = true,
    [LE_GAME_ERR_OUT_OF_MANA] = true,
    [LE_GAME_ERR_OUT_OF_RAGE] = true,
    [LE_GAME_ERR_OUT_OF_RUNES] = true,
    [LE_GAME_ERR_OUT_OF_RUNIC_POWER] = true,
    [LE_GAME_ERR_OUT_OF_SOUL_SHARDS] = true,   
    [LE_GAME_ERR_OUT_OF_COMBO_POINTS] = true,
    
    [LE_GAME_ERR_SPELL_FAILED_S] = true,
    [LE_GAME_ERR_NO_ATTACK_TARGET] = true,
    [LE_GAME_ERR_SPELL_FAILED_ANOTHER_IN_PROGRESS] = true,

    [LE_GAME_ERR_NO_ATTACK_TARGET] = true,
    [LE_GAME_ERR_INVALID_ATTACK_TARGET] = true,
    [LE_GAME_ERR_NO_ATTACK_TARGET] = true,
}

local event = CreateFrame('Frame')
event:SetScript('OnEvent', function(self, event, error)
    if (not ignoreList[error]) then
        UIErrorsFrame:AddMessage(error, 1, .1, .1)
    end
end)

event:RegisterEvent('UI_ERROR_MESSAGE')
