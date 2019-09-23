
local _, nPower = ...
local config = nPower.Config

local format = string.format
local floor = math.floor

function nPower:FormatValue(self)
    if (self >= 10000) then
        return ("%.1fk"):format(self / 1e3)
    else
        return self
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
    if (class == "ROGUE" and config.showComboPoints or class == "DRUID" and config.showComboPoints) then
        return true
    else
        return false
    end
end
