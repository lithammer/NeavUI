local parent, ns = ...
local oUF = ns.oUF
local Private = oUF.Private

local enableTargetUpdate = Private.enableTargetUpdate

-- Handles unit specific actions.
function oUF:HandleUnit(object, unit)
	local unit = object.unit or unit
	if(unit == 'target') then
		object:RegisterEvent('PLAYER_TARGET_CHANGED', object.UpdateAllElements, true)
	elseif(unit == 'mouseover') then
		object:RegisterEvent('UPDATE_MOUSEOVER_UNIT', object.UpdateAllElements, true)
	elseif(unit:match('%w+target')) then
		enableTargetUpdate(object)
	end
end
