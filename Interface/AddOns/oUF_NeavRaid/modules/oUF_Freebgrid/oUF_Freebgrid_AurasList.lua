
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
    ['Throne of Thunder'] = 930,
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
        [L['Throne of Thunder']] = {

                -- Jin'rokh the Breaker

            [GetSpellInfo(138006)] = 4, -- Electrified Waters
            [GetSpellInfo(137399)] = 6, -- Focused Lightning fixate
            [GetSpellInfo(138732)] = 5, -- Ionization
            [GetSpellInfo(138349)] = 2, -- Static Wound (tank only)
            [GetSpellInfo(137371)] = 2, -- Thundering Throw (tank only)

                -- Horridon

            [GetSpellInfo(136769)] = 6, -- Charge
            [GetSpellInfo(136767)] = 6, -- Triple Puncture (tanks only)
            [GetSpellInfo(136708)] = 3, -- Stone Gaze
            [GetSpellInfo(136723)] = 5, -- Sand Trap
            [GetSpellInfo(136587)] = 5, -- Venom Bolt Volley (dispellable)
            [GetSpellInfo(136710)] = 5, -- Deadly Plague (disease)
            [GetSpellInfo(136670)] = 4, -- Mortal Strike
            [GetSpellInfo(136573)] = 6, -- Frozen Bolt (Debuff used by frozen orb)
            [GetSpellInfo(136512)] = 5, -- Hex of Confusion
            [GetSpellInfo(136719)] = 6, -- Blazing Sunlight
            [GetSpellInfo(136654)] = 4, -- Rending Charge
            [GetSpellInfo(140946)] = 7, -- Dire Fixation (Heroic Only)

                -- Council of Elders

            [GetSpellInfo(136922)] = 6, -- Frostbite
            [GetSpellInfo(137084)] = 3, -- Body Heat
            [GetSpellInfo(137641)] = 6, -- Soul Fragment (Heroic only)
            [GetSpellInfo(136878)] = 5, -- Ensnared
            [GetSpellInfo(136857)] = 6, -- Entrapped (Dispell)
            [GetSpellInfo(137650)] = 5, -- Shadowed Soul
            [GetSpellInfo(137359)] = 6, -- Shadowed Loa Spirit fixate target
            [GetSpellInfo(137972)] = 6, -- Twisted Fate (Heroic only)
            [GetSpellInfo(136860)] = 5, -- Quicksand

                -- Tortos

            [GetSpellInfo(134030)] = 6, -- Kick Shell
            [GetSpellInfo(134920)] = 6, -- Quake Stomp
            [GetSpellInfo(136751)] = 6, -- Sonic Screech
            [GetSpellInfo(136753)] = 2, -- Slashing Talons (tank only)
            [GetSpellInfo(137633)] = 5, -- Crystal Shell (heroic only)

                -- Megaera

            [GetSpellInfo(139822)] = 6, -- Cinder (Dispell)
            [GetSpellInfo(134396)] = 6, -- Consuming Flames (Dispell)
            [GetSpellInfo(137731)] = 5, -- Ignite Flesh
            [GetSpellInfo(136892)] = 6, -- Frozen Solid
            [GetSpellInfo(139909)] = 5, -- Icy Ground
            [GetSpellInfo(137746)] = 6, -- Consuming Magic
            [GetSpellInfo(139843)] = 4, -- Artic Freeze
            [GetSpellInfo(139840)] = 4, -- Rot Armor
            [GetSpellInfo(140179)] = 6, -- Suppression (stun)

                -- Ji-Kun

            [GetSpellInfo(138309)] = 4, -- Slimed
            [GetSpellInfo(138319)] = 5, -- Feed Pool
            [GetSpellInfo(140571)] = 3, -- Feed Pool
            [GetSpellInfo(134372)] = 3, -- Screech

                -- Durumu the Forgotten

            [GetSpellInfo(133768)] = 2, -- Arterial Cut (tank only)
            [GetSpellInfo(133767)] = 2, -- Serious Wound (Tank only)
            [GetSpellInfo(136932)] = 7, -- Force of Will
            [GetSpellInfo(134122)] = 6, -- Blue Beam
            [GetSpellInfo(134123)] = 6, -- Red Beam
            [GetSpellInfo(134124)] = 6, -- Yellow Beam
            [GetSpellInfo(133795)] = 4, -- Life Drain
            [GetSpellInfo(133597)] = 6, -- Dark Parasite
            [GetSpellInfo(133732)] = 5, -- Infrared Light (the stacking red debuff)
            [GetSpellInfo(133677)] = 5, -- Blue Rays (the stacking blue debuff)
            [GetSpellInfo(133738)] = 5, -- Bright Light (the stacking yellow debuff)
            [GetSpellInfo(133737)] = 6, -- Bright Light (The one that says you are actually in a beam)
            [GetSpellInfo(133675)] = 6, -- Blue Rays (The one that says you are actually in a beam)
            [GetSpellInfo(134626)] = 6, -- Lingering Gaze

                -- Primordius

            [GetSpellInfo(140546)] = 6, -- Fully Mutated
            [GetSpellInfo(136180)] = 3, -- Keen Eyesight (Helpful)
            [GetSpellInfo(136181)] = 4, -- Impared Eyesight (Harmful)
            [GetSpellInfo(136182)] = 3, -- Improved Synapses (Helpful)
            [GetSpellInfo(136183)] = 4, -- Dulled Synapses (Harmful)
            [GetSpellInfo(136184)] = 3, -- Thick Bones (Helpful)
            [GetSpellInfo(136185)] = 4, -- Fragile Bones (Harmful)
            [GetSpellInfo(136186)] = 3, -- Clear Mind (Helpful)
            [GetSpellInfo(136187)] = 4, -- Clouded Mind (Harmful)
            [GetSpellInfo(136050)] = 2, -- Malformed Blood(Tank Only)

                -- Dark Animus

            [GetSpellInfo(138569)] = 2, -- Explosive Slam (tank only)
            [GetSpellInfo(138659)] = 6, -- Touch of the Animus
            [GetSpellInfo(138609)] = 6, -- Matter Swap
            [GetSpellInfo(138691)] = 4, -- Anima Font
            [GetSpellInfo(136962)] = 5, -- Anima Ring
            [GetSpellInfo(138480)] = 6, -- Crimson Wake Fixate

                -- Iron Qon

            [GetSpellInfo(134647)] = 5, -- Scorched
            [GetSpellInfo(136193)] = 6, -- Arcing Lightning
            [GetSpellInfo(135147)] = 2, -- Dead Zone
            [GetSpellInfo(134691)] = 2, -- Impale (tank only)
            [GetSpellInfo(135145)] = 6, -- Freeze
            [GetSpellInfo(136520)] = 5, -- Frozen Blood
            [GetSpellInfo(137669)] = 3, -- Storm Cloud
            [GetSpellInfo(137668)] = 5, -- Burning Cinders
            [GetSpellInfo(137654)] = 5, -- Rushing Winds
            [GetSpellInfo(136577)] = 4, -- Wind Storm
            [GetSpellInfo(136192)] = 4, -- Lightning Storm

                -- Twin Consorts

            [GetSpellInfo(137440)] = 6, -- Icy Shadows (tank only)
            [GetSpellInfo(137417)] = 6, -- Flames of Passion
            [GetSpellInfo(138306)] = 5, -- Serpent's Vitality
            [GetSpellInfo(137408)] = 2, -- Fan of Flames (tank only)
            [GetSpellInfo(137360)] = 6, -- Corrupted Healing (tanks and healers only?)
            [GetSpellInfo(137375)] = 3, -- Beast of Nightmares
            [GetSpellInfo(136722)] = 6, -- Slumber Spores

                -- Lei Shen

            [GetSpellInfo(135695)] = 6, -- Static Shock
            [GetSpellInfo(136295)] = 6, -- Overcharged
            [GetSpellInfo(135000)] = 2, -- Decapitate (Tank only)
            [GetSpellInfo(136478)] = 5, -- Fusion Slash
            [GetSpellInfo(136543)] = 6, -- Ball Lightning
            [GetSpellInfo(134821)] = 6, -- Discharged Energy
            [GetSpellInfo(136326)] = 6, -- Overcharge
            [GetSpellInfo(137176)] = 6, -- Overloaded Circuits
            [GetSpellInfo(136853)] = 6, -- Lightning Bolt
            [GetSpellInfo(135153)] = 6, -- Crashing Thunder
            [GetSpellInfo(136914)] = 2, -- Electrical Shock
            [GetSpellInfo(135001)] = 2, -- Maim

            -- Ra-Den (Heroic only)
        },

        [L['Terrace of Endless Spring']] = {

                -- Protectors of the Endless

            [GetSpellInfo(117436)] = 5,    -- Lightning Prison
            [GetSpellInfo(118091)] = 5,    -- Defiled Ground
            [GetSpellInfo(117519)] = 5,    -- Touch of Sha

                -- Tsulong

            [GetSpellInfo(122752)] = 5,    -- Shadow Breath
            [GetSpellInfo(123011)] = 5,    -- Terrorize
            [GetSpellInfo(116161)] = 5,    -- Crossed Over

                -- Lei Shi

            [GetSpellInfo(123121)] = 5,    -- Spray

                -- Sha of Fear

            [GetSpellInfo(119985)] = 5,    -- Dread Spray
            [GetSpellInfo(119086)] = 5,    -- Penetrating Bolt
            [GetSpellInfo(119775)] = 5,    -- Reaching Attack
        },

        [L['Heart of Fear']] = {

                -- Imperial Vizier Zor'lok

            [GetSpellInfo(122761)] = 5,    -- Exhale
            [GetSpellInfo(122760)] = 5, -- Exhale
            [GetSpellInfo(122740)] = 5,    -- Convert
            [GetSpellInfo(123812)] = 5,    -- Pheromones of Zeal

                -- Blade Lord Ta'yak

            [GetSpellInfo(123180)] = 5,    -- Wind Step
            [GetSpellInfo(123474)] = 5,    -- Overwhelming Assault

                -- Garalon

            [GetSpellInfo(122835)] = 5,    -- Pheromones
            [GetSpellInfo(123081)] = 5,    -- Pungency

                -- Wind Lord Mel'jarak

            [GetSpellInfo(122125)] = 5,    -- Corrosive Resin Pool
            [GetSpellInfo(121885)] = 5,     -- Amber Prison

                -- Amber-Shaper Un'sok

            [GetSpellInfo(121949)] = 5,    -- Parasitic Growth

                -- Grand Empress Shek'zeer
        },

        [L['Mogu\'shan Vaults']] = {

                -- The Stone Guard

            [GetSpellInfo(130395)] = 6, -- Jasper Chains: Stacks
            [GetSpellInfo(130404)] = 3, -- Jasper Chains: Stacks
            [GetSpellInfo(130774)] = 6, -- Amethyst Pool

                -- Feng the Accursed

            [GetSpellInfo(116942)] = 6, -- Flaming Spear

                -- Gara'jal the Spiritbinder

            [GetSpellInfo(116161)] = 8, -- Crossed Over
            [GetSpellInfo(116161)] = 3, -- Voodoo Dolls

                -- The Spirit Kings

            [GetSpellInfo(118135)] = 6,    -- Pinned Down

                -- Elagon

                -- Will of the Emperor

            [GetSpellInfo(116778)] = 7,    -- Focused Defense
            [GetSpellInfo(116525)] = 7,    -- Focused Assault
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
