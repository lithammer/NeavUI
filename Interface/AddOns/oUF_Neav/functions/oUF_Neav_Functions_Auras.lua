
local _, ns = ...

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local function AuraMouseover(button, ...)
    local size = ...
    
    button:HookScript('OnEnter', function(self)
        button.icon:SetSize(size + 12, size + 12)
        button:SetFrameLevel(2)
        button.remaining:SetFont(ns.config.media.font, 13, 'THINOUTLINE')
        button.count:SetFont(ns.config.media.font, 15, 'THINOUTLINE')
    end)
    
    button:HookScript('OnLeave', function(self)
        button.icon:SetSize(size, size)
        button:SetFrameLevel(1)
        button.remaining:SetFont(ns.config.media.font, 8, 'THINOUTLINE')
        button.count:SetFont(ns.config.media.font, 11, 'THINOUTLINE')
    end)
end

local function CreateAuraTimer(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if (self.elapsed < 0.2) then 
        return 
    end
    
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.remaining:SetText(nil)
    else
        if (timeLeft < 5) then
            self.remaining:SetText('|cffff0000'..ns.FormatTime(timeLeft))
        else
            self.remaining:SetText(ns.FormatTime(timeLeft))
        end
    end
end

function ns.PostUpdateIcon(icons, unit, icon, index, offset)
    if (not icon.remaining) then
        return
    end
            
    if (ns.config.units.target.colorPlayerDebuffsOnly) then
        if (unit == 'target') then 
            if (icon.debuff) then
                if (not UnitIsFriend('player', unit) and icon.owner ~= 'player' and icon.owner ~= 'vehicle') then
                    icon.overlay:SetVertexColor(0.45, 0.45, 0.45)
                    icon.icon:SetDesaturated(true)
                else
                    icon.icon:SetDesaturated(false)
                end
            end
        end
    end
    
    local _, _, _, _, _, duration, expirationTime = UnitAura(unit, index, icon.filter)

    if (duration and duration > 0) then
        icon.remaining:Show()
    else
        icon.remaining:Hide()
    end

    icon.duration = duration
    icon.expires = expirationTime
    
    icon:SetScript('OnUpdate', CreateAuraTimer)
end

function ns.UpdateAuraIcons(auras, button)
    local size = button:GetSize()

    button:SetFrameLevel(1)
    
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.icon:ClearAllPoints()
    button.icon:SetPoint('CENTER', button)
    button.icon:SetSize(size, size)
    
	button.overlay:SetTexture(ns.config.media.border)
	button.overlay:SetTexCoord(0, 1, 0, 1)
    button.overlay:ClearAllPoints()
    button.overlay:SetPoint('TOPRIGHT', button.icon, 1.35, 1.35)
    button.overlay:SetPoint('BOTTOMLEFT', button.icon, -1.35, -1.35)
    
    auras.disableCooldown = true

    button.remaining = button:CreateFontString(nil, 'OVERLAY')
	button.remaining:SetFont(ns.config.media.font, 8, 'THINOUTLINE')
    button.remaining:SetShadowOffset(0, 0)
    button.remaining:SetPoint('TOP', button.icon, 0, 2)
        
    button.count:SetFont(ns.config.media.font, 11, 'THINOUTLINE')
    button.count:SetShadowOffset(0, 0)
    button.count:ClearAllPoints()
    button.count:SetPoint('BOTTOMRIGHT', button.icon, 1, 1)
    
    if (not auras.disableCooldown) then
        button.cd:SetReverse()
        button.cd:ClearAllPoints()
        button.cd:SetPoint('TOPRIGHT', button.icon, 'TOPRIGHT', -1, -1)
        button.cd:SetPoint('BOTTOMLEFT', button.icon, 'BOTTOMLEFT', 1, 1)
    end

    if (not button.Shadow) then
        button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
        button.Shadow:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
        button.Shadow:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
        button.Shadow:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderBackground')
        button.Shadow:SetVertexColor(0, 0, 0, 1)
    end

	button.overlay.Hide = function(self)
        if (auras.customColor) then
            self:SetVertexColor(unpack(auras.customColor))
        else
            self:SetVertexColor(0.45, 0.45, 0.45, 1)
        end
    end
    
    if (not button.disableMouseover) then
        AuraMouseover(button, size)
    end
end