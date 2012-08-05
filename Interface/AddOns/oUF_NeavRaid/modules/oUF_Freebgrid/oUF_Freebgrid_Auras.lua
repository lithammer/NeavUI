
    -- THANKS & CREDITS GOES TO Freebaser (oUF Freebgrid)
    -- http://www.wowinterface.com/downloads/info12264-oUF_Freebgrid.html

local _, ns = ...
local oUF = ns.oUF or oUF

local _, class = UnitClass('player')
local buffcolor = { r = 0.0, g = 1.0, b = 1.0 }

local backdrop = {
    bgFile = 'Interface\\Buttons\\WHITE8x8',
    tile = true,
    tileSize = 16,
    edgeFile = 'Interface\\Buttons\\WHITE8x8',
    edgeSize = 2,
    insets = {
        top = 2,
        left = 2,
        bottom = 2,
        right = 2
    },
}

local BBackdrop = {
    bgFile = 'Interface\\Buttons\\WHITE8x8',
    tile = true,
    tileSize = 16,
    insets = {
        top = -1,
        left = -1,
        bottom = -1,
        right = -1
    },
}

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if (s >= day) then
        return format('%dd', floor(s/day + 0.5))
    elseif (s >= hour) then
        return format('%dh', floor(s/hour + 0.5))
    elseif (s >= minute) then
        return format('%dm', floor(s/minute + 0.5))
    end

    return format('%d', fmod(s, minute))
end

local CreateAuraIcon = function(auras)
    if (not auras.button) then
        local button = CreateFrame('Frame', nil, auras)
        button:EnableMouse(false)
        button:SetBackdrop(BBackdrop)
        button:SetBackdropColor(0, 0, 0, 1)
        button:SetBackdropBorderColor(0, 0, 0, 0)
        button:SetAllPoints(auras)

        local icon = button:CreateTexture(nil, 'OVERLAY')
        icon:SetAllPoints(button)
        icon:SetTexCoord(.1, .9, .1, .9)

        local overlay = CreateFrame('Frame', nil, button)
        overlay:SetAllPoints(button)
        overlay:SetBackdrop(backdrop)
        overlay:SetBackdropColor(0, 0, 0, 0)
        overlay:SetBackdropBorderColor(1, 1, 1, 1)
        overlay:SetFrameLevel(6)

        local font, fontsize = GameFontNormalSmall:GetFont()
        local count = overlay:CreateFontString(nil, 'OVERLAY')
        count:SetFont(font, 10, 'THINOUTLINE')
        count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 1, 1)

        local remaining = button:CreateFontString(nil, 'OVERLAY')
        remaining:SetPoint('CENTER', icon, 0.5, 0)
        remaining:SetFont(font, 11, 'THINOUTLINE')
        remaining:SetTextColor(1, 0.82, 0)

        button.overlay = overlay
        button.remaining = remaining
        button.parent = auras
        button.icon = icon
        button.count = count
        button.cd = cd
        button:Hide()

        return button
    end
end

    -- Want to see all magic/disease/curse or poison debuffs, even when you can't dispell it?
    -- I've prepared something below..

local dispelClass = {
    PRIEST = {
        -- Disease = true,
        Magic = true,
        -- Poison = true,
        -- Curse = true,
    },
    SHAMAN = {
        Curse = true,
        -- Magic = true,
        -- Disease = true,
        -- Poison = true,
    },
    PALADIN = {
        Poison = true,
        Disease = true,
        -- Magic = true,
        -- Disease = true,
    },
    MAGE = {
        Curse = true,
        -- Poison = true,
        -- Disease = true,
        -- Magic = true,
    },
    MONK = {
        -- Curse = true,
        Poison = true,
        Disease = true,
        -- Magic = true,
    },
    DRUID = {
        Curse = true,
        Poison = true,
        -- Magic = true,
        -- Disease = true,
    },
    --[[
    WARRIOR = {
        Curse = true,
        Poison = true,
        Magic = true,
        Disease = true,
    },
    DEATHKNIGHT = {
        Curse = true,
        Poison = true,
        Magic = true,
        Disease = true,
    },
    HUNTER = {
        Curse = true,
        Poison = true,
        Magic = true,
        Disease = true,
    },
    WARLOCK = {
        Curse = true,
        Poison = true,
        Magic = true,
        Disease = true,
    },
    ROGUE = {
        Curse = true,
        Poison = true,
        Magic = true,
        Disease = true,
    },
    --]]
}

local checkTalents = CreateFrame('Frame')
checkTalents:RegisterEvent('PLAYER_ENTERING_WORLD')
checkTalents:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
checkTalents:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
checkTalents:RegisterEvent('CHARACTER_POINTS_CHANGED')
checkTalents:SetScript('OnEvent', function()
    if (ns.MultiCheck(class, 'SHAMAN', 'PALADIN', 'DRUID', 'PRIEST', 'MONK')) then
        local spec = GetSpecialization()
        if (class == 'SHAMAN') then
            dispelClass[class].Magic = spec == 3 and true
        elseif (class == 'PALADIN') then
            dispelClass[class].Magic = spec == 1 and true
        elseif (class == 'DRUID') then
            dispelClass[class].Magic = spec == 4 and true
        elseif (class == 'PRIEST') then
            dispelClass[class].Disease = (spec == 1 or spec == 2) and true
        elseif (class == 'MONK') then
            dispelClass[class].Magic = spec == 2 and true
        end
    end

    if (event == 'PLAYER_ENTERING_WORLD') then
        self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    end
end)

local dispellist = dispelClass[class] or {}
local instDebuffs = {}

local delaytimer = 0
local zoneDelay = function(self, elapsed)
    delaytimer = delaytimer + elapsed

    if (delaytimer < 5) then
        return
    end

    if (IsInInstance()) then
        SetMapToCurrentZone()
        local zone = GetCurrentMapAreaID()

        if (ns.auras.instances[zone]) then
            instDebuffs = ns.auras.instances[zone]
        end
    else
        instDebuffs = {}
    end

    self:SetScript('OnUpdate', nil)
    delaytimer = 0
end

local getZone = CreateFrame('Frame')
getZone:RegisterEvent('PLAYER_ENTERING_WORLD')
getZone:RegisterEvent('ZONE_CHANGED_NEW_AREA')
getZone:SetScript('OnEvent', function(self, event)

        -- Delay just in case zone data hasn't loaded

    self:SetScript('OnUpdate', zoneDelay)

    if (event == 'PLAYER_ENTERING_WORLD') then
        self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    end
end)

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype = ...

    icon.asc = false
    icon.buff = false
    icon.priority = 0

    if (ns.auras.ascending[name]) then
        icon.asc = true
    end

    if (instDebuffs[name]) then
        icon.priority = instDebuffs[name]
        return true
    elseif (ns.auras.debuffs[name]) then
        icon.priority = ns.auras.debuffs[name]
        return true
    elseif (ns.auras.buffs[name]) then
        icon.priority = ns.auras.buffs[name]
        icon.buff = true
        return true
    elseif (dispellist[dtype]) then
        icon.priority = ns.dispelPriority[dtype]
        return true
    end
end

local AuraTimerAsc = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if (self.elapsed < .2) then
        return
    end

    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.remaining:SetText(nil)
    else
        local duration = self.duration - timeLeft
        self.remaining:SetText(FormatTime(duration))
    end
end

local AuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if (self.elapsed) < .2 then
        return
    end

    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.remaining:SetText(nil)
    else
        self.remaining:SetText(FormatTime(timeLeft))
    end
end

local updateDebuff = function(icon, texture, count, dtype, duration, expires, buff)
    local color = buff and buffcolor or DebuffTypeColor[dtype] or DebuffTypeColor.none

    icon.overlay:SetBackdropBorderColor(color.r, color.g, color.b)

    icon.icon:SetTexture(texture)
    icon.count:SetText((count > 1 and count))

    icon.expires = expires
    icon.duration = duration

    if (icon.asc) then
        icon:SetScript('OnUpdate', AuraTimerAsc)
    else
        icon:SetScript('OnUpdate', AuraTimer)
    end
end

local Update = function(self, event, unit)
    if (self.unit ~= unit) then
        return
    end

    local cur
    local hide = true
    local auras = self.FreebAuras
    local icon = auras.button

    local index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster = UnitDebuff(unit, index)
        if (not name) then
            break
        end

        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster)

        if (show) then
            if (not cur) then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires)
            else
                if (icon.priority > cur) then
                    updateDebuff(icon, texture, count, dtype, duration, expires)
                end
            end

            icon:Show()

            if (self.Name) then
                self.Name:Hide()
            end

            if (self.Health.Value) then
                self.Health.Value:Hide()
            end

            hide = false
        end

        index = index + 1
    end

    index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster = UnitBuff(unit, index)
        if (not name) then
            break
        end

        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster)

        if (show and icon.buff) then
            if (not cur) then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires, true)
            else
                if (icon.priority > cur) then
                    updateDebuff(icon, texture, count, dtype, duration, expires, true)
                end
            end

            icon:Show()

            if (self.Name) then
                self.Name:Hide()
            end

            if (self.Health.Value) then
                self.Health.Value:Hide()
            end

            hide = false
        end

        index = index + 1
    end

    if (hide) then
        icon:Hide()

        if (self.Name) then
            self.Name:Show()
        end

        if (self.Health.Value) then
            self.Health.Value:Show()
        end
    end
end

local Enable = function(self)
    local auras = self.FreebAuras

    if (auras) then
        auras.button = CreateAuraIcon(auras)

        self:RegisterEvent('UNIT_AURA', Update)
        return true
    end
end

local Disable = function(self)
    local auras = self.FreebAuras

    if (auras) then
        self:UnregisterEvent('UNIT_AURA', Update)
    end
end

oUF:AddElement('FreebAuras', Update, Enable, Disable)
