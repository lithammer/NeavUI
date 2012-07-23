
local parent, ns = ...
local oUF = ns.oUF or _G.oUF

local Update = function(self, event, unit)
    if (unit ~= self.unit) then 
        return 
    end

    local threat = self.ThreatGlow
    local unit = unit or self.unit

    local status
    -- if (UnitCanAttack(unit, 'player')) then
    if (UnitCanAttack('player', 'target')) then
        status = UnitThreatSituation('player', 'target')
    else
        status = UnitThreatSituation(unit)
    end

    if (status and status > 0) then
        local r, g, b = GetThreatStatusColor(status)

        if (threat:IsObjectType('Texture')) then
            threat:SetVertexColor(r, g, b, 1)
        elseif (threat:IsObjectType('FontString')) then
            threat:SetTextColor(r, g, b, 1)
        elseif (threat:IsObjectType('Frame') and threat:GetBackdropBorderColor()) then
            threat:SetBackdropBorderColor(r, g, b, 1)
        else
            return
        end
    else
        if (threat:IsObjectType('Frame') and threat:GetBackdropBorderColor()) then
            threat:SetBackdropBorderColor(0, 0, 0, 0)
        else
            threat:SetAlpha(0)
        end
    end
end

local Path = function(self, ...)
    return (self.ThreatGlow.Override or Update)(self, ...)
end

local ForceUpdate = function(element)
    return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
    local threat = self.ThreatGlow

    if (threat and not self.ThreatGlow.ignore) then
        threat.__owner = self
        threat.ForceUpdate = ForceUpdate

        self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', Path)
        self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', Path)
        self:RegisterEvent('UNIT_TARGET', Path)

        return true
    end
end

local Disable = function(self)
    local threat = self.ThreatGlow

    if (threat and not self.ThreatGlow.ignore) then
        self:UnregisterEvent('UNIT_THREAT_SITUATION_UPDATE', Path)
        self:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', Path)
        self:UnregisterEvent('UNIT_TARGET', Path)
    end
end

oUF:AddElement('SmartThreatGlow', Path, Enable, Disable)