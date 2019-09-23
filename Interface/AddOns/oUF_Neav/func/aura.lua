
local _, ns = ...
local config = ns.Config

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local function ExactTime(time)
    return format("%.1f", time), (time * 100 - floor(time * 100))/100
end

local function IsMine(unit)
    if unit == "player" or unit == "pet" then
        return true
    else
        return false
    end
end

ns.UpdateAuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < 0.1 then
        return
    end

    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        if timeLeft <= 5 and IsMine(self.caster) then
            self.remaining:SetText("|cffff0000"..ExactTime(timeLeft).."|r")
            if not self.ignoreSize then
                self.remaining:SetFont(config.font.normal, 12, "OUTLINE")
            end
        else
            self.remaining:SetText(ns.FormatTime(timeLeft))
            if not self.ignoreSize then
                self.remaining:SetFont(config.font.normal, 8, "OUTLINE")
            end
        end
    end
end

ns.PostUpdateIcon = function(self, unit, button, index, position)
    button:SetAlpha(1)

    if button.isStealable then
        if button.Shadow then
            button.Shadow:SetVertexColor(1, 1, 0, 1)
        end
    else
        if button.Shadow then
            button.Shadow:SetVertexColor(0, 0, 0, 1)
        end
    end

    if config.units.target.colorPlayerDebuffsOnly then
        if unit == "target" then
            if button.isDebuff then
                if not IsMine(button.caster) then
                    button.overlay:SetVertexColor(0.45, 0.45, 0.45)
                    button.icon:SetDesaturated(true)
                else
                    button.icon:SetDesaturated(false)
                end
            end
        end
    end

    if button.remaining then
        if  unit == "target"
            and button.isDebuff
            and not IsMine(button.caster)
            and (not UnitIsFriend("player", unit) and UnitCanAttack(unit, "player") and not UnitPlayerControlled(unit))
            and not config.units.target.showAllTimers
        then

            if button.remaining:IsShown() then
                button.remaining:Hide()
            end

            button:SetScript("OnUpdate", nil)
        else
            local _, _, _, _, duration, expirationTime = UnitAura(unit, index, button.filter)
            if duration and duration > 0 then
                if not button.remaining:IsShown() then
                    button.remaining:Show()
                end
            else
                if button.remaining:IsShown() then
                    button.remaining:Hide()
                end
            end

            button.duration = duration
            button.expires = expirationTime
            button:SetScript("OnUpdate", ns.UpdateAuraTimer)
        end
    end
end

ns.UpdateAuraIcons = function(auras, button)
    if not button.Shadow then
        button:SetFrameLevel(1)

        button.overlay:SetTexture(config.media.border)
        button.overlay:SetTexCoord(0, 1, 0, 1)
        button.overlay:ClearAllPoints()
        button.overlay:SetPoint("TOPRIGHT", button.icon, 1.35, 1.35)
        button.overlay:SetPoint("BOTTOMLEFT", button.icon, -1.35, -1.35)

        button.count:SetFont(config.font.normal, 11, "OUTLINE")
        button.count:SetDrawLayer("OVERLAY",7)
        button.count:SetShadowOffset(0, 0)
        button.count:ClearAllPoints()
        button.count:SetPoint("BOTTOMRIGHT", button.icon, 2, 0)

        if config.show.disableCooldown then
            button.cd:SetReverse(false)
            button.cd:SetDrawEdge(true)
            button.cd:ClearAllPoints()
            button.cd:SetHideCountdownNumbers(true)
            button.cd:SetPoint("TOPRIGHT", button.icon, "TOPRIGHT", -1, -1)
            button.cd:SetPoint("BOTTOMLEFT", button.icon, "BOTTOMLEFT", 1, 1)
        else
            auras.disableCooldown = true

            button.remaining = button:CreateFontString(nil, "OVERLAY")
            button.remaining:SetFont(config.font.normal, 8, "OUTLINE")
            button.remaining:SetShadowOffset(0, 0)
            button.remaining:SetPoint("TOP", button.icon, 0, 2)
        end

        button.Shadow = button:CreateTexture(nil, "BACKGROUND")
        button.Shadow:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -4, 4)
        button.Shadow:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 4, -4)
        button.Shadow:SetTexture("Interface\\AddOns\\oUF_Neav\\media\\borderBackground")
        button.Shadow:SetVertexColor(0, 0, 0, 1)

        if button.stealable then
            local stealable = button:CreateTexture(nil, "OVERLAY")
            stealable:SetPoint("TOPLEFT", -4, 4)
            stealable:SetPoint("BOTTOMRIGHT", 4, -4)
        end

        button.overlay.Hide = function(self)
            self:SetVertexColor(0.5, 0.5, 0.5, 1)
        end
    end
end
