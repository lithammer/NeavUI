local parent, ns = ...
local oUF = ns.oUF

local Update = function(self, event, unit)
	if(unit ~= self.unit) then return end

	if(self.PvPIndicator) then
		local factionGroup = UnitFactionGroup(unit)
		if(UnitIsPVPFreeForAll(unit)) then
			self.PvPIndicator:SetTexture[[Interface\TargetingFrame\UI-PVP-FFA]]
			self.PvPIndicator:Show()
		elseif(factionGroup and UnitIsPVP(unit)) then
			self.PvPIndicator:SetTexture([[Interface\TargetingFrame\UI-PVP-]]..factionGroup)
			self.PvPIndicator:Show()
		else
			self.PvPIndicator:Hide()
		end
	end
end

local Path = function(self, ...)
	return (self.PvPIndicator.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local pvp = self.PvPIndicator
	if(pvp) then
		pvp.__owner = self
		pvp.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_FACTION", Path)

		return true
	end
end

local Disable = function(self)
	local pvp = self.PvPIndicator
	if(pvp) then
		self:UnregisterEvent("UNIT_FACTION", Path)
	end
end

oUF:AddElement('PvPIndicator', Path, Enable, Disable)