
local _, ns = ...

local len = string.len
local gsub = string.gsub
local format = string.format
local match = string.match
local floor = math.floor

local tags = oUF.Tags.Methods
local events = oUF.Tags.Events

local function FormatValue(value)
    if value >= 1e6 then
        return tonumber(format("%.1f", value/1e6)).."m"
    elseif value >= 1e3 then
        return tonumber(format("%.1f", value/1e3)).."k"
    else
        return value
    end
end

tags["neav:AdditionalPower"] = function(unit)
    local min, max = UnitPower(unit, Enum.PowerType.Mana), UnitPowerMax(unit, Enum.PowerType.Mana)
    if min == max then
        return FormatValue(min)
    else
        return FormatValue(min).."/"..FormatValue(max)
    end
end
events["neav:AdditionalPower"] = "UNIT_POWER_UPDATE UNIT_DISPLAYPOWER UNIT_MAXPOWER"

tags["neav:pvptimer"] = function(unit)
    if not IsPVPTimerRunning() or GetPVPTimer() == 301000 or GetPVPTimer() == 999 then
        return ""
    end

    return ns.FormatTime(floor(GetPVPTimer()/1000))
end
events["neav:pvptimer"] = "PLAYER_ENTERING_WORLD PLAYER_FLAGS_CHANGED"

tags["neav:level"] = function(unit)
    local r, g, b
    local targetEffectiveLevel = UnitLevel(unit)

    if targetEffectiveLevel > 0 then
        if UnitCanAttack("player", unit) then
            local color = GetCreatureDifficultyColor(targetEffectiveLevel)
            r, g, b = color.r, color.g, color.b
        else
            r, g, b = 1.0, 0.82, 0.0
        end
    else
        r, g, b = 1, 0, 0
        targetEffectiveLevel = "??"
    end

    return format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, targetEffectiveLevel)
end
events["neav:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

tags["neav:name"] = function(unit)
    local r, g, b
    local name, _ = UnitName(unit) or UNKNOWN
    local _, class = UnitClass(unit)

    if unit == "player" or unit:match("party") then
        if class then
            local color = oUF.colors.class[class]
            r, g, b = color[1], color[2], color[3]
        else
            r, g, b = 0, 1, 0
        end
    elseif unit == "targettarget" then
        r, g, b = GameTooltip_UnitColor(unit)
    else
        r, g, b = 1, 1, 1
    end

    name = (len(name) > 15) and gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name

    return format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, name)
end
events["neav:name"] = "UNIT_NAME_UPDATE"

local timer = {}


tags["neav:afk"] = function(unit)
    local name, _ = UnitName(unit) or UNKNOWN

    if UnitIsAFK(unit) then
        if not timer[name] then
            timer[name] = GetTime()
        end

        local time = (GetTime() - timer[name])

        return ns.FormatTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end
events["neav:afk"] = "PLAYER_FLAGS_CHANGED"
