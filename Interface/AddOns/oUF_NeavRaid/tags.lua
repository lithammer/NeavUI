local _, ns = ...

local tags = oUF.Tags.Methods
local events = oUF.Tags.Events
local timer = {}

tags["status:raid"] = function(unit)
    local name = UnitName(unit) or UNKNOWN

    if UnitIsAFK(unit) or not UnitIsConnected(unit) then
        if not timer[name] then
            timer[name] = GetTime()
        end

        local time = GetTime() - timer[name]

        return ns.FormatTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end
events["status:raid"] = "PLAYER_FLAGS_CHANGED UNIT_CONNECTION"


tags["name:raid"] = function(unit)
    local name = UnitName(unit) or UNKNOWN

    return ns.utf8sub(name)
end
events["name:raid"] = "UNIT_NAME_UPDATE"
