
UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
UIErrorsFrame:SetTimeVisible(1)
UIErrorsFrame:SetFadeDuration(0.75)

local ignoreList = {
    [ERR_SPELL_COOLDOWN] = true,
    [ERR_ABILITY_COOLDOWN] = true,

    [OUT_OF_ENERGY] = true,

    [SPELL_FAILED_NO_COMBO_POINTS] = true,

    [SPELL_FAILED_MOVING] = true,
    [ERR_NO_ATTACK_TARGET] = true,
    [SPELL_FAILED_SPELL_IN_PROGRESS] = true,

    [ERR_NO_ATTACK_TARGET] = true,
    [ERR_INVALID_ATTACK_TARGET] = true,
    [SPELL_FAILED_BAD_TARGETS] = true,
}

local event = CreateFrame('Frame')
event:SetScript('OnEvent', function(self, event, error)
    if (not ignoreList[error]) then
        UIErrorsFrame:AddMessage(error, 1, .1, .1)
    end
end)

event:RegisterEvent('UI_ERROR_MESSAGE')