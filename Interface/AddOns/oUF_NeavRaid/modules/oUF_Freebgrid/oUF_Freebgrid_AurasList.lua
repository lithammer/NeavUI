
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
    ['Siege of Orgrimmar'] = 953,
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
        [L['Siege of Orgrimmar']] = {

                -- Immerseus

            [GetSpellInfo(143297)] = 5, -- Sha Splash
            [GetSpellInfo(143459)] = 4, -- Sha Residue
            [GetSpellInfo(143524)] = 4, -- Purified Residue
            [GetSpellInfo(143286)] = 4, -- Seeping Sha
            [GetSpellInfo(143413)] = 3, -- Swirl
            [GetSpellInfo(143411)] = 3, -- Swirl
            [GetSpellInfo(143436)] = 2, -- Corrosive Blast (tanks)
            [GetSpellInfo(143579)] = 3, -- Sha Corruption (Heroic Only)

                -- Fallen Protectors

            [GetSpellInfo(143239)] = 4, -- Noxious Poison
            [GetSpellInfo(144176)] = 2, -- Lingering Anguish
            [GetSpellInfo(143023)] = 3, -- Corrupted Brew
            [GetSpellInfo(143301)] = 2, -- Gouge
            [GetSpellInfo(143564)] = 3, -- Meditative Field
            [GetSpellInfo(143010)] = 3, -- Corruptive Kick
            [GetSpellInfo(143434)] = 6, -- Shadow Word:Bane (Dispell)
            [GetSpellInfo(143840)] = 6, -- Mark of Anguish
            [GetSpellInfo(143959)] = 4, -- Defiled Ground
            [GetSpellInfo(143423)] = 6, -- Sha Sear
            [GetSpellInfo(143292)] = 5, -- Fixate
            [GetSpellInfo(144176)] = 5, -- Shadow Weakness
            [GetSpellInfo(147383)] = 4, -- Debilitation (Heroic Only)

                -- Norushen

            [GetSpellInfo(146124)] = 2, -- Self Doubt (tanks)
            [GetSpellInfo(146324)] = 4, -- Jealousy
            [GetSpellInfo(144639)] = 6, -- Corruption
            [GetSpellInfo(144850)] = 5, -- Test of Reliance
            [GetSpellInfo(145861)] = 6, -- Self-Absorbed (Dispell)
            [GetSpellInfo(144851)] = 2, -- Test of Confiidence (tanks)
            [GetSpellInfo(146703)] = 3, -- Bottomless Pit
            [GetSpellInfo(144514)] = 6, -- Lingering Corruption
            [GetSpellInfo(144849)] = 4, -- Test of Serenity

                -- Sha of Pride

            [GetSpellInfo(144358)] = 2, -- Wounded Pride (tanks)
            [GetSpellInfo(144843)] = 3, -- Overcome
            [GetSpellInfo(146594)] = 4, -- Gift of the Titans
            [GetSpellInfo(144351)] = 6, -- Mark of Arrogance
            [GetSpellInfo(144364)] = 4, -- Power of the Titans
            [GetSpellInfo(146822)] = 6, -- Projection
            [GetSpellInfo(146817)] = 5, -- Aura of Pride
            [GetSpellInfo(144774)] = 2, -- Reaching Attacks (tanks)
            [GetSpellInfo(144636)] = 5, -- Corrupted Prison
            [GetSpellInfo(144574)] = 6, -- Corrupted Prison
            [GetSpellInfo(145215)] = 4, -- Banishment (Heroic)
            [GetSpellInfo(147207)] = 4, -- Weakened Resolve (Heroic)
            [GetSpellInfo(144574)] = 6, -- Corrupted Prison
            [GetSpellInfo(144574)] = 6, -- Corrupted Prison

                -- Galakras

            [GetSpellInfo(146765)] = 5, -- Flame Arrows
            [GetSpellInfo(147705)] = 5, -- Poison Cloud
            [GetSpellInfo(146902)] = 2, -- Poison Tipped blades

                -- Iron Juggernaut

            [GetSpellInfo(144467)] = 2, -- Ignite Armor
            [GetSpellInfo(144459)] = 5, -- Laser Burn
            [GetSpellInfo(144498)] = 5, -- Napalm Oil
            [GetSpellInfo(144918)] = 5, -- Cutter Laser
            [GetSpellInfo(146325)] = 6, -- Cutter Laser Target

                -- Kor'kron Dark Shaman

            [GetSpellInfo(144089)] = 6, -- Toxic Mist
            [GetSpellInfo(144215)] = 2, -- Froststorm Strike (Tank only)
            [GetSpellInfo(143990)] = 2, -- Foul Geyser (Tank only)
            [GetSpellInfo(144304)] = 2, -- Rend
            [GetSpellInfo(144330)] = 6, -- Iron Prison (Heroic)

                -- General Nazgrim

            [GetSpellInfo(143638)] = 6, -- Bonecracker
            [GetSpellInfo(143480)] = 5, -- Assassin's Mark
            [GetSpellInfo(143431)] = 6, -- Magistrike (Dispell)
            [GetSpellInfo(143494)] = 2, -- Sundering Blow (Tanks)
            [GetSpellInfo(143882)] = 5, -- Hunter's Mark

                -- Malkorok

            [GetSpellInfo(142990)] = 2, -- Fatal Strike (Tank debuff)
            [GetSpellInfo(142913)] = 6, -- Displaced Energy (Dispell)
            [GetSpellInfo(143919)] = 5, -- Languish (Heroic)

                -- Spoils of Pandaria

            [GetSpellInfo(145685)] = 2, -- Unstable Defensive System
            [GetSpellInfo(144853)] = 3, -- Carnivorous Bite
            [GetSpellInfo(145987)] = 5, -- Set to Blow
            [GetSpellInfo(145218)] = 4, -- Harden Flesh
            [GetSpellInfo(145230)] = 1, -- Forbidden Magic
            [GetSpellInfo(146217)] = 4, -- Keg Toss
            [GetSpellInfo(146235)] = 4, -- Breath of Fire
            [GetSpellInfo(145523)] = 4, -- Animated Strike
            [GetSpellInfo(142983)] = 6, -- Torment (the new Wrack)
            [GetSpellInfo(145715)] = 3, -- Blazing Charge
            [GetSpellInfo(145747)] = 5, -- Bubbling Amber
            [GetSpellInfo(146289)] = 4, -- Mass Paralysis

                -- Thok the Bloodthirsty

            [GetSpellInfo(143766)] = 2, -- Panic (tanks)
            [GetSpellInfo(143773)] = 2, -- Freezing Breath (tanks)
            [GetSpellInfo(143452)] = 1, -- Bloodied
            [GetSpellInfo(146589)] = 5, -- Skeleton Key (tanks)
            [GetSpellInfo(143445)] = 6, -- Fixate
            [GetSpellInfo(143791)] = 5, -- Corrosive Blood
            [GetSpellInfo(143777)] = 3, -- Frozen Solid (tanks)
            [GetSpellInfo(143780)] = 4, -- Acid Breath
            [GetSpellInfo(143800)] = 5, -- Icy Blood
            [GetSpellInfo(143428)] = 4, -- Tail Lash

                -- Siegecrafter Blackfuse

            [GetSpellInfo(144236)] = 4, -- Pattern Recognition
            [GetSpellInfo(144466)] = 5, -- Magnetic Crush
            [GetSpellInfo(143385)] = 2, -- Electrostatic Charge (tank)
            [GetSpellInfo(143856)] = 6, -- Superheated

                -- Paragons of the Klaxxi

            [GetSpellInfo(143617)] = 5, -- Blue Bomb
            [GetSpellInfo(143701)] = 5, -- Whirling (stun)
            [GetSpellInfo(143702)] = 5, -- Whirling
            [GetSpellInfo(142808)] = 6, -- Fiery Edge
            [GetSpellInfo(143609)] = 5, -- Yellow Sword
            [GetSpellInfo(143610)] = 5, -- Red Drum
            [GetSpellInfo(142931)] = 2, -- Exposed Veins
            [GetSpellInfo(143619)] = 5, -- Yellow Bomb
            [GetSpellInfo(143735)] = 6, -- Caustic Amber
            [GetSpellInfo(146452)] = 5, -- Resonating Amber
            [GetSpellInfo(142929)] = 2, -- Tenderizing Strikes
            [GetSpellInfo(142797)] = 5, -- Noxious Vapors
            [GetSpellInfo(143939)] = 5, -- Gouge
            [GetSpellInfo(143275)] = 2, -- Hewn
            [GetSpellInfo(143768)] = 2, -- Sonic Projection
            [GetSpellInfo(142532)] = 6, -- Toxin: Blue
            [GetSpellInfo(142534)] = 6, -- Toxin: Yellow
            [GetSpellInfo(143279)] = 2, -- Genetic Alteration
            [GetSpellInfo(143339)] = 6, -- Injection
            [GetSpellInfo(142649)] = 4, -- Devour
            [GetSpellInfo(146556)] = 6, -- Pierce
            [GetSpellInfo(142671)] = 6, -- Mesmerize
            [GetSpellInfo(143979)] = 2, -- Vicious Assault
            [GetSpellInfo(143607)] = 5, -- Blue Sword
            [GetSpellInfo(143614)] = 5, -- Yellow Drum
            [GetSpellInfo(143612)] = 5, -- Blue Drum
            [GetSpellInfo(142533)] = 6, -- Toxin: Red
            [GetSpellInfo(143615)] = 5, -- Red Bomb
            [GetSpellInfo(143974)] = 2, -- Shield Bash (tanks)

                -- Garrosh Hellscream

            [GetSpellInfo(144582)] = 4, -- Hamstring
            [GetSpellInfo(144954)] = 4, -- Realm of Y'Shaarj
            [GetSpellInfo(145183)] = 2, -- Gripping Despair (tanks)
            [GetSpellInfo(144762)] = 4, -- Desecrated
            [GetSpellInfo(145071)] = 5, -- Touch of Y'Sharrj
            [GetSpellInfo(148718)] = 4, -- Fire Pit
        },
        [L['Throne of Thunder']] = {

                -- Jin'rokh the Breaker

            [GetSpellInfo(138006)] = 4, -- Electrified Waters
            [GetSpellInfo(137399)] = 6, -- Focused Lightning fixate
            [GetSpellInfo(138732)] = 5, -- Ionization
            [GetSpellInfo(138349)] = 2, -- Static Wound (tank only)
            [GetSpellInfo(137371)] = 2, -- Thundering Throw (tank only)

                -- Horridon

            [GetSpellInfo(136769)] = 6, -- Charge
            [GetSpellInfo(136767)] = 2, -- Triple Puncture (tanks only)
            [GetSpellInfo(136708)] = 6, -- Stone Gaze
            [GetSpellInfo(136723)] = 5, -- Sand Trap
            [GetSpellInfo(136587)] = 5, -- Venom Bolt Volley (dispellable)
            [GetSpellInfo(136710)] = 5, -- Deadly Plague (disease)
            [GetSpellInfo(136670)] = 4, -- Mortal Strike
            [GetSpellInfo(136573)] = 5, -- Frozen Bolt (Debuff used by frozen orb)
            [GetSpellInfo(136512)] = 6, -- Hex of Confusion
            [GetSpellInfo(136719)] = 6, -- Blazing Sunlight
            [GetSpellInfo(136654)] = 6, -- Rending Charge
            [GetSpellInfo(140946)] = 4, -- Dire Fixation (Heroic Only)

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
            [GetSpellInfo(136932)] = 6, -- Force of Will
            [GetSpellInfo(134122)] = 5, -- Blue Beam
            [GetSpellInfo(134123)] = 5, -- Red Beam
            [GetSpellInfo(134124)] = 5, -- Yellow Beam
            [GetSpellInfo(133795)] = 6, -- Life Drain
            [GetSpellInfo(133597)] = 6, -- Dark Parasite
            [GetSpellInfo(133732)] = 3, -- Infrared Light (the stacking red debuff)
            [GetSpellInfo(133677)] = 3, -- Blue Rays (the stacking blue debuff)
            [GetSpellInfo(133738)] = 3, -- Bright Light (the stacking yellow debuff)
            [GetSpellInfo(133737)] = 4, -- Bright Light (The one that says you are actually in a beam)
            [GetSpellInfo(133675)] = 4, -- Blue Rays (The one that says you are actually in a beam)
            [GetSpellInfo(134626)] = 5, -- Lingering Gaze

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
            [GetSpellInfo(136615)] = 6, -- Electrified

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
            [GetSpellInfo(136543)] = 5, -- Ball Lightning
            [GetSpellInfo(134821)] = 4, -- Discharged Energy
            [GetSpellInfo(136326)] = 6, -- Overcharge
            [GetSpellInfo(137176)] = 4, -- Overloaded Circuits
            [GetSpellInfo(136853)] = 4, -- Lightning Bolt
            [GetSpellInfo(135153)] = 6, -- Crashing Thunder
            [GetSpellInfo(136914)] = 2, -- Electrical Shock
            [GetSpellInfo(135001)] = 2, -- Maim

                -- Ra-Den (Heroic only)

            [GetSpellInfo(138308)] = 6, --Unstable Vita
            [GetSpellInfo(138372)] = 5, --Vita Sensitivity
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
