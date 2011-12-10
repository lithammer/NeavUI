
local parent, ns = ...
local oUF = ns.oUF or _G.oUF

local function FormatValue(self)
    if (self >= 1000000) then
        return ('%.2fm'):format(self / 1e6)
        -- return ('%.3fK'):format(self / 1e6):gsub('%.', 'M ')
    elseif (self >= 100000) then
        return ('%.1fk'):format(self / 1e3)
        -- return ('%.3f'):format(self / 1e3):gsub('%.', 'K ')
    else
        return self
    end
end

local Update = function(self, event, unit)
    if (unit ~= self.unit) then 
        return 
    end

    local unit = unit or self.unit
    local druid = self.DruidMana

        -- Show druid mana only as bear or cat

    if (GetShapeshiftForm() == 1 or GetShapeshiftForm() == 3) then
        if (druid.PreUpdate) then 
            druid:PreUpdate(unit)
        end

        druid:Show()

        local min, max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
        druid:SetMinMaxValues(0, max)
        druid:SetValue(min)

        local r, g, b
        if (druid.colorClass and UnitIsPlayer(unit)) then
            local t = RAID_CLASS_COLORS['DRUID']
            r, g, b = t['r'], t['g'], t['b']
        elseif(druid.colorSmooth) then
            r, g, b = self.ColorGradient(min/max, unpack(oUF.smoothGradient or oUF.colors.smooth))
        else
            local t = PowerBarColor['MANA']
            r, g, b = t['r'], t['g'], t['b']
        end

        if (b) then
            self.DruidMana:SetStatusBarColor(r, g, b)

            local bg = druid.bg
            if (bg) then
                local mu = bg.multiplier or 1
                bg:SetVertexColor(r * mu, g * mu, b * mu)
            end
        end

        local value = druid.Value
        if (value) then
            if (min == max) then
                value:SetText(FormatValue(min))
            else
                value:SetText(FormatValue(min)..'/'..FormatValue(max))
            end
        end

        if (druid.PostUpdate) then
            return druid:PostUpdate(unit, min, max)
        end
    else
        self.DruidMana:Hide()
    end
end

local Path = function(self, ...)
    return (self.DruidMana.Override or Update)(self, ...)
end

local ForceUpdate = function(element)
    return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self)
    local druid = self.DruidMana

    if (druid) then
        druid.__owner = self
        druid.ForceUpdate = ForceUpdate

        self:RegisterEvent('UNIT_POWER', Path)
        self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
        self:RegisterEvent('UNIT_MAXPOWER', Path)
        
        if (not druid:GetStatusBarTexture()) then
            druid:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
        end
        
        return true
    end
end

local Disable = function(self)
    local druid = self.DruidMana

    if (druid) then
        self:UnregisterEvent('UNIT_POWER', Path)
        self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
        self:UnregisterEvent('UNIT_MAXPOWER', Path)
    end
end

oUF:AddElement('DruidMana', Path, Enable, Disable)