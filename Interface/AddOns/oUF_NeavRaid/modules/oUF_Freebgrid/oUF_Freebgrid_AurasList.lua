
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
    -- find out the instance ID by typing this in the chat "/run print(GetCurrentMapAreaID())"
    -- Note: Just must be in this instance, when you run the script above

local L = {
    ['Terrace of Endless Spring'] = 886,
    ['Heart of Fear'] = 897,
    ['Mogu\'shan Vaults'] = 896,

    ['Baradin Hold'] = 752,
    ['Blackwing Descent'] = 754,
    ['The Bastion of Twilight'] = 758,
    ['Throne of the Four Winds'] = 773,
    ['Firelands'] = 800,
    ['Dragon Soul'] = 824,

    -- ['Ulduar'] = 529,
    ['ToC'] = 543,
    ['Naxxramas'] = 535,
    ['Ruby Sanctum'] = 531,
    ['Icecrown'] = 604,

    -- ['Tol Barad'] = 708,
    -- ['Lost City Tol'vir'] = 747,
    -- ['Deadmines'] = 756,
    -- ['Grim Batol'] = 757,
    -- ['Shadowfang'] = 764,
    -- ['Throne of Tides'] = 767,

    -- ['Zul'Gurub'] = 697 or 793,
    -- ['Zul'Aman'] = 781,
}

ns.auras = {

        -- Ascending aura timer
        -- Add spells to this list to have the aura time count up from 0
        -- NOTE: This does not show the aura, it needs to be in one of the other list too.

    ascending = {
        [GetSpellInfo(89421)] = true, -- Wrack
    },

        -- General debuffs

    debuffs = {
        [GetSpellInfo(115804)] = 9, -- Mortal Wounds
        [GetSpellInfo(113746)] = 9, -- Weakened Armor
        [GetSpellInfo(51372)] = 1, -- Daze
        [GetSpellInfo(5246)] = 5, -- Intimidating Shout
        -- [GetSpellInfo(6788)] = 16, -- Weakened Soul
    },

        -- Buffs

    buffs = {
        [GetSpellInfo(871)] = 15, -- Shield Wall
        [GetSpellInfo(61336)] = 15, -- Survival Instincts
        [GetSpellInfo(31850)] = 15, -- Ardent Defender
        [GetSpellInfo(498)] = 15, -- Divine Protection
        [GetSpellInfo(33206)] = 15, -- Pain Suppression
    },

        -- Raid Debuffs

    instances = {
        [L['Terrace of Endless Spring']] = {
        },

        [L['Heart of Fear']] = {
        },

        [L['Mogu\'shan Vaults']] = {
            [GetSpellInfo(130395)] = 6, -- Jasper Chains: Stacks, Stone Guard
            [GetSpellInfo(130404)] = 3, -- Jasper Chains: Stacks, Stone Guard
            [GetSpellInfo(130774)] = 6, -- Amethyst Pool, Stone Guard
        },

        [L['Dragon Soul']] = {
            [GetSpellInfo(109075)] = 7, -- Fading Light, Ultraxion
        },

        [L['Firelands']] = {
            [GetSpellInfo(99256)] = 11, -- Baloroc shard debuff
            [GetSpellInfo(99252)] = 11, -- Baloroc shard debuff
        },

        [L['Baradin Hold']] = {
            [GetSpellInfo(88954)] = 6, -- Consuming Darkness
        },

        [L['Blackwing Descent']] = {

                -- Magmaw

            [GetSpellInfo(78941)] = 6, -- Parasitic Infection
            [GetSpellInfo(89773)] = 7, -- Mangle

                -- Omnitron Defense System

            [GetSpellInfo(79888)] = 6, -- Lightning Conductor
            [GetSpellInfo(79505)] = 8, -- Flamethrower
            [GetSpellInfo(80161)] = 7, -- Chemical Cloud
            [GetSpellInfo(79501)] = 8, -- Acquiring Target
            [GetSpellInfo(80011)] = 7, -- Soaked in Poison
            [GetSpellInfo(80094)] = 7, -- Fixate
            [GetSpellInfo(92048)] = 9, -- Shadow Infusion
            [GetSpellInfo(92053)] = 9, -- Shadow Conductor

                -- Maloriak

            [GetSpellInfo(77786)] = 8, -- Consuming Flames
            [GetSpellInfo(77699)] = 8, -- Flash Freeze
            [GetSpellInfo(77760)] = 7, -- Biting Chill
            --[GetSpellInfo(91829)] = 7, -- Fixate XXX: Gone?
            [GetSpellInfo(92787)] = 9, -- Engulfing Darkness

                -- Atramedes

            [GetSpellInfo(78092)] = 7, -- Tracking
            [GetSpellInfo(78897)] = 8, -- Noisy
            [GetSpellInfo(78023)] = 7, -- Roaring Flame

                -- Chimaeron

            [GetSpellInfo(89084)] = 8, -- Low Health
            [GetSpellInfo(82881)] = 7, -- Break
            [GetSpellInfo(82890)] = 9, -- Mortality

                -- Nefarian

            [GetSpellInfo(77827)] = 7, -- Tail Lash
            -- [GetSpellInfo(94075)] = 8, -- Magma
            [GetSpellInfo(79339)] = 9, -- Explosive Cinders
            [GetSpellInfo(79318)] = 9, -- Dominion
        },

        [L['The Bastion of Twilight']] = {

                -- Halfus

            [GetSpellInfo(39171)] = 7, -- Malevolent Strikes
            [GetSpellInfo(83710)] = 8, -- Furious Roar

                -- Valiona & Theralion

            [GetSpellInfo(86788)] = 6, -- Blackout
            [GetSpellInfo(86622)] = 7, -- Engulfing Magic
            [GetSpellInfo(86202)] = 7, -- Twilight Shift

                -- Council

            [GetSpellInfo(82665)] = 7, -- Heart of Ice
            [GetSpellInfo(82660)] = 7, -- Burning Blood
            [GetSpellInfo(82762)] = 7, -- Waterlogged
            [GetSpellInfo(83099)] = 7, -- Lightning Rod
            [GetSpellInfo(82285)] = 7, -- Elemental Stasis
            [GetSpellInfo(84948)] = 8, -- Gravity Crush

                -- Cho'gall

            [GetSpellInfo(86028)] = 6, -- Cho's Blast
            [GetSpellInfo(86029)] = 6, -- Gall's Blast
            [GetSpellInfo(81701)] = 7, -- Corrupted Blood
            [GetSpellInfo(82411)] = 7, -- Debilitating Beam
            [GetSpellInfo(81836)] = 8, -- Corruption: Accelerated
            [GetSpellInfo(81831)] = 8, -- Corruption: Sickness
            [GetSpellInfo(82125)] = 8, -- Corruption: Malformation
            [GetSpellInfo(82170)] = 8, -- Corruption: Absolute

                -- Sinestra

            [GetSpellInfo(89421)] = 9, -- Wrack
        },

        [L['Throne of the Four Winds']] = {

                -- Conclave

            [GetSpellInfo(85576)] = 9, -- Withering Winds
            [GetSpellInfo(85573)] = 9, -- Deafening Winds
            [GetSpellInfo(86182)] = 7, -- Slicing Gale
            [GetSpellInfo(86481)] = 8, -- Hurricane
            [GetSpellInfo(84645)] = 7, -- Wind Chill
            [GetSpellInfo(86282)] = 8, -- Toxic Spores

                -- Al'Akir

            -- [GetSpellInfo(93281)] = 7, -- Acid Rain
            [GetSpellInfo(87873)] = 7, -- Static Shock
            [GetSpellInfo(88427)] = 7, -- Electrocute
            [GetSpellInfo(89667)] = 8, -- Lightning Rod
            [GetSpellInfo(87856)] = 9, -- Squall Line
        },

            -- Naxxramas

        [L['Naxxramas']] = {
            [GetSpellInfo(27808)] = 9, -- Frost Blast, Kel'Thuzad
        },

            -- Trial of Crusader

        [L['ToC']] = {
            [GetSpellInfo(66869)] = 8, -- Burning Bile
            [GetSpellInfo(66823)] = 10, -- Paralizing Toxin
            [GetSpellInfo(66237)] = 9, -- Incinerate Flesh
        },

            -- Ruby Sanctum

        [L['Ruby Sanctum']] = {
            [GetSpellInfo(74562)] = 8, -- Fiery Combustion, Halion
            [GetSpellInfo(74792)] = 8, -- Soul Consumption, Halion
        },

            -- Icecrown

        [L['Icecrown']] = {
            [GetSpellInfo(69057)] = 9, -- Bone Spike Graveyard
            [GetSpellInfo(72410)] = 9, -- Rune of Blood
            [GetSpellInfo(72293)] = 10, -- Mark of the Fallen Champion, Deathbringer Saurfang

            [GetSpellInfo(69674)] = 9, -- Mutated Infection, Rotface
            [GetSpellInfo(72272)] = 9, -- Vile Gas, Festergut
            [GetSpellInfo(69279)] = 8, -- Gas Spore, Festergut

            [GetSpellInfo(70126)] = 9, -- Frost Beacon, Sindragosa

            [GetSpellInfo(70337)] = 9, -- Necrotic Plague, Lich King
            [GetSpellInfo(70541)] = 6, -- Infest, Lich King
            [GetSpellInfo(72754)] = 8, -- Defile, Lich King
            [GetSpellInfo(68980)] = 10, -- Harvest Soul, Lich King
        },
    },
}
