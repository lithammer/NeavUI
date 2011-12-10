
local _, ns = ...
local config = ns.Config

local floor = floor
local select = select
local tonumber = tonumber

local modf = math.modf
local fmod = math.fmod
local floot = math.floor
local gsub = string.gsub
local format = string.format

local GetTime = GetTime
local day, hour, minute = 86400, 3600, 60

ns.CreateFocusButton = function(self)
    local FTarget = CreateFrame('BUTTON', nil, self, 'SecureActionButtonTemplate')
    FTarget:EnableMouse(true)
    FTarget:RegisterForClicks('AnyUp')
    FTarget:SetAttribute('type', 'macro')
    FTarget:SetAttribute('macrotext', '/focus')
    FTarget:SetSize(64, 48)
    FTarget:SetPoint('CENTER', self, 70, -1)

    FTarget.Text = FTarget:CreateFontString(nil, 'OVERLAY')
    FTarget.Text:SetTextColor(0, 0.65, 1)
    FTarget.Text:SetFont(config.font.normal, 15, 'OUTLINE')
    FTarget.Text:SetShadowOffset(0, 0)
    FTarget.Text:SetPoint('LEFT')
    FTarget.Text:SetJustifyH('LEFT')

    do
        local text = FTarget.Text
        local stage_table = {
            '',
            'F  ',
            'FO ',
            'FOC',
            'FOCU',
            'FOCUS',
        }

        local curent_stage = 1

        local printer = CreateFrame('Frame', nil, FTarget)
        printer:Hide()
        printer:SetScript('OnUpdate',function(self, et)
            curent_stage = curent_stage + self.dir

            if (curent_stage == 7) then
                curent_stage = 6
                self:Hide() return
            elseif (curent_stage == 0) then
                curent_stage = 1
                self:Hide() return
            end

            text:SetText(stage_table[curent_stage])
        end)

        FTarget.printer = printer
    end

    FTarget:SetScript('OnLeave', function(self) 
        self.printer:Hide()
        self.printer.dir = -1
        self.printer:Show()
    end)

    FTarget:SetScript('OnEnter', function(self) 
        self.printer:Hide()
        self.printer.dir = 1
        self.printer:Show()
    end)

    self.FTarget = FTarget
end

local function FormatValue(value)
    if (value >= 1e6) then
        return tonumber(format('%.1f', value/1e6))..'m'
    elseif (value >= 1e3) then
        return tonumber(format('%.1f', value/1e3))..'k'
    else
        return value
    end
end

local function DeficitValue(value)
    if (value == 0) then
        return ''
    else
        return '-'..FormatValue(value)
    end
end

ns.cUnit = function(unit)
    if (unit:match('party%d')) then
        return 'party'
    elseif (unit:match('arena%d')) then
        return 'arena'
    elseif (unit:match('boss%d')) then
        return 'boss'
    else
        return unit
    end
end

ns.FormatTime = function(time)
    if (time >= day) then
        return format('%dd', floor(time/day + 0.5))
    elseif (time>= hour) then
        return format('%dh', floor(time/hour + 0.5))
    elseif (time >= minute) then
        return format('%dm', floor(time/minute + 0.5))
    end

    return format('%d', fmod(time, minute))
end

local function GetUnitStatus(unit)
    if (UnitIsDead(unit)) then 
        return DEAD
    elseif (UnitIsGhost(unit)) then
        return 'Ghost' 
    elseif (not UnitIsConnected(unit)) then
        return PLAYER_OFFLINE
    else
        return ''
    end
end

local function GetFormattedText(text, cur, max, alt)
    local perc = (cur/max)*100

    if (alt) then
        text = gsub(text, '$alt', ((alt > 0) and format('%s', FormatValue(alt)) or ''))
    end

    local r, g, b = oUF.ColorGradient(cur/max, unpack(oUF.smoothGradient or oUF.colors.smooth))
    text = gsub(text, '$cur', format('%s', (cur > 0 and FormatValue(cur)) or ''))
    text = gsub(text, '$max', format('%s', FormatValue(max)))
    text = gsub(text, '$deficit', format('%s', DeficitValue(max-cur)))
    text = gsub(text, '$perc', format('%d', perc)..'%%')
    text = gsub(text, '$smartperc', format('%d', perc))
    text = gsub(text, '$smartcolorperc', format('|cff%02x%02x%02x%d|r', r*255, g*255, b*255, perc))
    text = gsub(text, '$colorperc', format('|cff%02x%02x%02x%d', r*255, g*255, b*255, perc)..'%%|r')

    return text
end

ns.GetHealthText = function(unit, cur, max)
    local uconf = config.units[ns.cUnit(unit)]

    if (not cur) then
        cur = UnitHealth(unit)
        max = UnitHealthMax(unit)
    end

    local healthString
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        healthString = GetUnitStatus(unit)
    elseif ((cur == max) and uconf and uconf.healthTagFull)then
        healthString = GetFormattedText(uconf.healthTagFull, cur, max)
    elseif (uconf and uconf.healthTag) then
        healthString = GetFormattedText(uconf.healthTag, cur, max)
    else
        if (cur == max) then
            healthString = FormatValue(cur)
        else
            healthString = FormatValue(cur)..'/'..FormatValue(max)
        end
    end

    return healthString
end

ns.GetPowerText = function(unit, cur, max)
    local uconf = config.units[ns.cUnit(unit)]

    if (not cur) then
        max = UnitPower(unit)
        cur = UnitPowerMax(unit)
    end

    local alt = UnitPower(unit, ALTERNATE_POWER_INDEX)
    local powerType = UnitPowerType(unit)

    local powerString
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        powerString = ''
    elseif (max == 0) then
        powerString = ''
    elseif (not UnitHasMana(unit) or powerType ~= 0 or UnitHasVehicleUI(unit) and uconf and uconf.powerTagNoMana) then
        powerString = GetFormattedText(uconf.powerTagNoMana, cur, max, alt)
    elseif ((cur == max) and uconf and uconf.powerTagFull)then
        powerString = GetFormattedText(uconf.powerTagFull, cur, max, alt)
    elseif (uconf and uconf.powerTag) then
        powerString = GetFormattedText(uconf.powerTag, cur, max, alt)
        
    else
        if (cur == max) then
            powerString = FormatValue(cur)
        else
            powerString = FormatValue(cur)..'/'..FormatValue(max)
        end
    end

    return powerString
end

ns.MultiCheck = function(what, ...)
    for i = 1, select('#', ...) do
        if (what == select(i, ...)) then 
            return true 
        end
    end

    return false
end

ns.utf8sub = function(string, index)
    local bytes = string:len()
    if (bytes <= index) then
        return string
    else
        local length, currentIndex = 0, 1

        while currentIndex <= bytes do
            length = length + 1
            local char = string:byte(currentIndex)

            if (char > 240) then
                currentIndex = currentIndex + 4
            elseif (char > 225) then
                currentIndex = currentIndex + 3
            elseif (char > 192) then
                currentIndex = currentIndex + 2
            else
                currentIndex = currentIndex + 1
            end

            if (length == index) then
                break
            end
        end

        if (length == index and currentIndex <= bytes) then
            return string:sub(1, currentIndex - 1)
        else
            return string
        end
    end
end