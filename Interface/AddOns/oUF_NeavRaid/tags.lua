
local _, ns = ...
local config = ns.config

oUF.TagEvents['name:Raid'] = 'UNIT_NAME_UPDATE'
oUF.Tags['name:Raid'] = function(unit)
    local name = UnitName(unit)
    return ns.utf8sub(name, config.units.raid.nameLength)
    -- return ns.utf8sub(name, config.units.raid.nameLength - 2  )..[[|TInterface\GroupFrame\UI-Group-MaintankIcon:0|t]]
end

local timer = {}

oUF.TagEvents['notHere'] = 'PLAYER_FLAGS_CHANGED UNIT_CONNECTION'
oUF.Tags['notHere'] = function(unit)
    local name = UnitName(unit)

    if (UnitIsAFK(unit) or not UnitIsConnected(unit)) then
        if (not timer[name]) then
            timer[name] = GetTime()
        end

        local time = (GetTime() - timer[name])
        return ns.FormatTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end

oUF.TagEvents['role:Raid'] = 'PARTY_MEMBERS_CHANGED PLAYER_ROLES_ASSIGNED'
if (not oUF.Tags['role:Raid']) then
	oUF.Tags['role:Raid'] = function(unit)
		local role = UnitGroupRolesAssigned(unit)
        
		if (role) then
			if (role == 'TANK') then
				role = '>'
			elseif (role == 'HEALER') then
				role = '+'
			elseif (role == 'DAMAGER') then
				role = '-'
			elseif (role == 'NONE') then
				role = ''
			end

			return role
        else
            return ''
		end
	end
end