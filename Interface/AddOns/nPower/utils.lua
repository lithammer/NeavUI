
local _, nPower = ...
local config = nPower.Config

local floor = math.floor

function nPower:FormatValue(v)
    if (v >= 10000) then
        return ("%.1fk"):format(v / 1e3)
    else
        return v
    end
end

function nPower:Round(num, idp)
    local mult = 10^(idp or 0)
    return floor(num * mult + 0.5) / mult
end

function nPower:Fade(frame, timeToFade, startAlpha, endAlpha)
    if (self:Round(frame:GetAlpha(), 1) ~= endAlpha) then
        local mode = startAlpha > endAlpha and "In" or "Out"
        securecall("UIFrameFade"..mode, frame, timeToFade, startAlpha, endAlpha)
    end
end

function nPower:HasExtraPoints(class)
    if (
       class == "WARLOCK"   and config.showSoulshards
    or class == "PALADIN"   and config.showHolypower and not config.holyPower.showRunes
    or class == "ROGUE"     and config.showComboPoints
    or class == "DRUID"     and config.showComboPoints
    or class == "MONK"      and config.showChi
    or class == "MAGE"      and config.showArcaneCharges
    ) then
        return true
    else
        return false
    end
end

function nPower.UpdateHealthTextLocation(self, nump)
    if not self.HPText then
        return
    end

    if (self.extraPoints) then
        self.HPText:ClearAllPoints()
        if (nump == 0) then
            self.HPText:SetPoint("CENTER", 0, 0)
        else
            self.HPText:SetPoint("CENTER", 0, config.extraFontSize + config.hp.hpFontHeightAdjustment)
        end
    elseif (self.Rune) then
        local offset
        if (self.class == "PALADIN" and self.spec ~= SPEC_PALADIN_RETRIBUTION) then
            offset = config.hp.hpFontHeightAdjustment
        else
            offset = self.Rune[1]:GetWidth() + config.hp.hpFontHeightAdjustment
        end
        self.HPText:ClearAllPoints()
        self.HPText:SetPoint("CENTER", 0, offset)
    else
        self.HPText:ClearAllPoints()
        self.HPText:SetPoint("CENTER", 0, 0)
    end
end
