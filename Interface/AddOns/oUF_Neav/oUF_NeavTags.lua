
local function DeficitValue(self)
    if (self >= 1000) then
		return format('-%.1f', self/1000)
	else
		return self
	end
end

oUF.Tags['level'] = function(unit)
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

oUF.TagEvents['name'] = 'UNIT_NAME_UPDATE'
oUF.Tags['name'] = function(unit)
    local r, g, b
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

    if (unit == 'player' or not UnitIsFriend('player', unit) and UnitIsPlayer(unit) and UnitClass(unit)) then
		colorA = oUF.colors.class[class]
	elseif (unit == 'targettarget' and UnitIsPlayer(unit) and UnitClass(unit)) then
		colorA = oUF.colors.class[class]
	else
		colorB = {1, 1, 1}
	end

	if (colorA) then
		r, g, b = colorA[1], colorA[2], colorA[3]
	elseif (colorB) then
		r, g, b = colorB[1], colorB[2], colorB[3]
	end

    return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, unitName)
end

-- oUF.TagEvents['phase'] = 'UNIT_PHASE'
oUF.Tags['phase'] = function(unit)
    --[[
	if (not UnitInPhase(unit)) then
        return 'OTHER PHASE'
    else
        return ''
	end
    --]]
end

oUF.TagEvents['name:Raid'] = 'UNIT_NAME_UPDATE'
oUF.Tags['name:Raid'] = function(unit)
    return UnitName(unit):sub(1, 4)
end

oUF.TagEvents['health:Raid'] = 'UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT'
oUF.Tags['health:Raid'] = function(unit)
    local max = UnitHealthMax(unit)
    local min = UnitHealth(unit)

    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        return format('|cff%02x%02x%02x%s|r', 0.5*255, 0.5*255, 0.5*255, (UnitIsDead(unit) and 'Dead') or (UnitIsGhost(unit) and 'Ghost') or (not UnitIsConnected(unit) and 'Offline'))
    else
        if ((min/max * 100) < 90) then
            return format('|cff%02x%02x%02x%s|r', 1*255, 0*255, 0*255, DeficitValue(max-min))
        else
            return ''
        end
    end
end
