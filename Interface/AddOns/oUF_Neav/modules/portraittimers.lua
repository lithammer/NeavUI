
local _, ns = ...
local oUF = ns.oUF or oUF

ns.PortraitTimerDB = {

        -- Immunitys

    '45438',    -- Ice Block
    '33786',    -- Cyclone
    '642',      -- Divine Shield
    '1022',     -- Hand of Protection
    '19263',    -- Deterrence
    '46924',    -- Bladestorm

        -- Stuns

    '408',      -- Kidney Shot
    '1833',     -- Cheap Shot
    '12809',    -- Concussion Blow
    '46968',    -- Shockwave
    '853',      -- Hammer of Justice
    '49203',    -- Hungering Cold
    '85388',    -- Throwdown
    '44572',    -- Deep Freeze
    '5211',     -- Bash
    '19503',    -- Scatter Shot
    '30283',    -- Shadowfury
    '89605',    -- Aura of Foreboding
    '89766',    -- Axe Toss
    '22570',    -- Maim
    '9005',     -- Pounce
    '47481',    -- Gnaw
    '1776',     -- Gouge
    '6770',     -- Sap
    '87195',    -- Paralysis
    '88625',    -- Holy Word: Chastise   
    '90337',     -- Bad Manner (monkey stun)   
    '12489',    -- Improved Cone of Cold
    '65929',    -- Charge Stun
    '20253',    -- Intercept 
    '91797',    -- Monstrous Blow (Gnaw with DT)

        -- CC

    '91807',    -- Shambling Rush (Leap with DT)
    '87100',    -- Sin and Punishment
    '1513',     -- Scare Beast
    '2637',     -- Hibernate
    '605',      -- Mind Control
    '64044',    -- Psychic Horror
    '2094',     -- Blind
    '118',      -- Polymorph
    '51514',    -- Hex
    '6789',     -- Death Coil
    '5246',     -- Intimidating Shout 
    '8122',     -- Psychic Scream
    '5484',     -- Howl of Terror
    '5782',     -- Fear
    '6358',     -- Seduction
    '1499',     -- Freezing Trap
    '20066',    -- Repentance
    '339',      -- Entangling Roots
    '8377',     -- Earthgrab
    '31661',    -- Dragon's Breath
    '16689',    -- Nature's Grasp
    '82691',    -- Ring of Frost
    '23694',    -- Improved Hamstring
    '76780',    -- Bind Elemental
    '19387',    -- Entrapment

        -- CCc immune

    '53271',    -- Master's Call
    '1044',     -- Hand of Freedom
    '31224',    -- Cloak of Shadows
    '51271',    -- Pillar of Frost
    '31821',    -- Aura Mastery

        -- Smg reductions

    '48707',    -- Anti-Magic Shell
    '30823',    -- Shamanistic Rage 
    '33206',    -- Pain Suppression
    '47585',    -- Dispersion
    '871',      -- Shield Wall
    '48792',    -- Icebound Fortitude
    '498',      -- Divine Protection
    '22812',    -- Barkskin
    '61336',    -- Survival Instincts	
    '5277',     -- Evasion
    '74001',    -- Combat Readiness
    '47788',     -- Guardian Spirit

        -- Silences

    '47476',    -- Strangulate
    '1330',     -- Garrote - Silence
    '55021',    -- Silenced - Improved Counterspell
    '15487',    -- Silence (priest)
    '19647',    -- Spell Lock
    '34490',    -- Silencing Shot
    '28730',    -- Arcane Torrent

        -- Disarms

    '676',      -- Disarm
    '51722',    -- Dismantle

        -- Dmg buffs  

    '34692',    -- The Beast Within
    '31884',    -- Avenging Wrath
    '51713',    -- Shadow Dance 

        -- Helpful buffs

    '6940',     -- Hand of Sacrifice
    '89488',    -- Strength of Soul
    '23920',    -- Spell Reflection (warrior)
    '68992',    -- Darkflight (Worgen racial)
    '31642',    -- Blazing Speed
    '54428',    -- Divine Plea
    '2983',     -- Sprint
    '1850',     -- Dash
    '29166',    -- Innervate
}

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local function ExactTime(time)
    return format("%.1f", time), (time * 100 - floor(time * 100))/100
end

local function FormatTime(s)
    if (s >= day) then
        return format('%dd', floor(s/day + 0.5))
    elseif (s >= hour) then
        return format('%dh', floor(s/hour + 0.5))
    elseif (s >= minute) then
        return format('%dm', floor(s/minute + 0.5))
    end

    return format('%d', fmod(s, minute))
end

local function AuraTimer(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if (self.elapsed < 0.1) then 
        return 
    end

    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.Remaining:SetText(nil)
    else
        if (timeLeft <= 5) then
            self.Remaining:SetText('|cffff0000'..ExactTime(timeLeft)..'|r')
        else
            self.Remaining:SetText(FormatTime(timeLeft))
        end
    end
end

local function UpdateIcon(self, texture, duration, expires)
    SetPortraitToTexture(self.Icon, texture)

    self.expires = expires
    self.duration = duration
    self:SetScript('OnUpdate', AuraTimer)
end

local Update = function(self, event, unit)
    if (self.unit ~= unit) then 
        return 
    end

    local pt = self.PortraitTimer
    for _, spellID in ipairs(ns.PortraitTimerDB) do
        local spell = GetSpellInfo(spellID)
        if (UnitBuff(unit, spell)) then
            local name, _, texture, _, _, duration, expires = UnitBuff(unit, spell)
            UpdateIcon(pt, texture, duration, expires)

            pt:Show()

            return
        elseif (UnitDebuff(unit, spell)) then
            local name, _, texture, _, _, duration, expires = UnitDebuff(unit, spell)
            UpdateIcon(pt, texture, duration, expires)

            pt:Show()

            return
        else
            if (pt:IsShown()) then
                pt:Hide()
            end
        end
    end
end

local Enable = function(self)
    local pt = self.PortraitTimer
    if (pt) then
        self:RegisterEvent('UNIT_AURA', Update)
        return true
    end
end

local Disable = function(self)
    local pt = self.PortraitTimer
    if (pt) then
        self:UnregisterEvent('UNIT_AURA', Update)
    end
end

oUF:AddElement('PortraitTimer', Update, Enable, Disable)