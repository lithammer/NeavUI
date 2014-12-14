
local _, ns = ...

local function FormatValue(value)
    if (value >= 1e6) then
        return tonumber(format('%.1f', value/1e6))..'m'
    elseif (value >= 1e3) then
        return tonumber(format('%.1f', value/1e3))..'k'
    else
        return value
    end
end

oUF.Tags.Events['druidmana'] = 'UNIT_POWER UNIT_DISPLAYPOWER UNIT_MAXPOWER'
oUF.Tags.Methods['druidmana'] = function(unit)
    local min, max = UnitPower(unit, SPELL_POWER_MANA), UnitPowerMax(unit, SPELL_POWER_MANA)
    if (min == max) then
        return FormatValue(min)
    else
        return FormatValue(min)..'/'..FormatValue(max)
    end
end

oUF.Tags.Methods['pvptimer'] = function(unit)
    if (not IsPVPTimerRunning() and GetPVPTimer() >= 0) then
        return ''
    end

    return ns.FormatTime(math.floor(GetPVPTimer()/1000))
end

oUF.Tags.Methods['level'] = function(unit)
    local r, g, b
    local level = UnitLevel(unit)
    local colorL = GetQuestDifficultyColor(level)

    if (level < 0) then
        r, g, b = 1, 0, 0
        level = '??'
    elseif (level == 0) then
        r, g, b = colorL.r, colorL.g, colorL.b
        level = '?'
    else
        r, g, b = colorL.r, colorL.g, colorL.b
        level = level
    end

    return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, level)
end

oUF.Tags.Events['name'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['name'] = function(unit)
    local r, g, b = 1, 1, 1
    local colorA, colorB
    local unitName, unitRealm = UnitName(unit)
    local _, class = UnitClass(unit)

    if (unitRealm) and (unitRealm ~= '') then
        unitName = unitName..' (*)'
    end

    for i = 1, 4 do
        if (unit == 'party'..i) then
            colorA = oUF.colors.class[class]
        end
    end

    if (unit == 'player' or not UnitIsFriend('player', unit) and UnitIsPlayer(unit) and UnitClass(unit) and not unit:match('arena(%d)')) then
        colorA = oUF.colors.class[class]
    elseif (unit == 'targettarget' or unit == 'focustarget' or unit:match('arena(%d)target')) then
        r, g, b = UnitSelectionColor(unit)
    else
        colorB = {1, 1, 1}
    end

    if (colorA) then
        r, g, b = colorA[1], colorA[2], colorA[3]
    elseif (colorB) then
        r, g, b = colorB[1], colorB[2], colorB[3]
    end

    -- if (unitRealm) and (unitRealm ~= '') then
    return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, unitName)     -- no abbrev
    -- else
        -- return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, string.gsub(unitName, '%s(.[\128-\191]*)%S+%S', ' %1.'))     -- abbrev all words except the first
    -- end
    -- return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, string.gsub(unitName, '%s?(.[\128-\191]*)%S+%s', '%1. '))   -- abbrev all words except the last
end

oUF.Tags.Events['combopoints'] = 'UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED'
oUF.Tags.Methods['combopoints'] = function(unit)
    local cp
    if (UnitHasVehicleUI('player')) then
        cp = GetComboPoints('vehicle', 'target')
    else
        cp = GetComboPoints('player', 'target')
    end

    return cp == 0 and '' or cp
end
