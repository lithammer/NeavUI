
    -- THANKS & CREDITS GOES TO Freebaser (oUF_Freebgrid)
    -- http://www.wowinterface.com/downloads/info12264-oUF_Freebgrid.html

local _, ns = ...
local oUF = ns.oUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v)
    local a = {GetSpellInfo(v)}
    if (GetSpellInfo(v)) then
        t[v] = a
    end

    return a
end})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

    -- instance name and the instance ID,
    -- find out the instance ID by typing this in the chat "/run print(select(8, GetInstanceInfo()))"
    -- or find them on https://wow.gamepedia.com/InstanceMapID
    -- Note: Just must be in this instance, when you run the script above

local L = {
}

ns.auras = {

        -- Ascending aura timer
        -- Add spells to this list to have the aura time count up from 0
        -- NOTE: This does not show the aura, it needs to be in one of the other list too.

    ascending = {
    },

        -- General debuffs

    debuffs = {
        [GetSpellInfo(1604)] = 1,      -- Daze
        [GetSpellInfo(5246)] = 5,       -- Intimidating Shout
    },

        -- Buffs

    buffs = {
        -- Druid
        [GetSpellInfo(22812)] = 15,         -- Barkskin
        -- Mage
        [GetSpellInfo(11958)] = 15,         -- Ice Block
        -- Paladin
        [GetSpellInfo(498)] = 15,           -- Divine Protection
        [GetSpellInfo(1022)] = 15,          -- Blessing of Protection
        [GetSpellInfo(6940)] = 15,          -- Blessing of Sacrifice
        -- Priest
        [GetSpellInfo(27827)] = 15,         -- Spirit of Redemption
        -- Rogue
        -- Shaman
        -- Warlock
        -- Warrior
        [GetSpellInfo(871)] = 15,           -- Shield Wall
    },

        -- Debuffs

    instances = {
    },
}
