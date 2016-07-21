
local _, ns = ...

--[[

    The 'Tag-System'
        Possible:
            $cur                - Shows the current hp of the unit > 53,4k
            $max                - Shows the maximum hp of the unit > 105,3k
            $deficit            - Shows the deficit value > -10k
            $perc               - Show the percent > 100%
            $smartperc          - Show the percent without the '%' > 100
            $colorperc          - Same as $perc, but color the number depended on the percent of the unit. Green if full, red if low percent
            $smartcolorperc     - Same as above, but without the '%'
            $alt                - Only for power value, shows the current alternative power of the unit (like Cho'gall fight)

    Its possible to add hex color
        Example:
            |cffff0000 YOUTAGHERE |r

            -->   '$cur / $perc |cffff0000$deficit|r'

        So you have a red deficit value
--]]

ns.Config = {
    show = {
        castbars = true,
        pvpicons = true,
        classPortraits = false,
        threeDPortraits = false,                                                            -- 3DPortraits; Overrides classPortraits
        disableCooldown = false,                                                            -- Disable custom cooldown text to use addons like omnicc
        portraitTimer = true,
    },

    media = {
        border = 'Interface\\AddOns\\oUF_Neav\\media\\borderTexture',                       -- Buffborder Texture
        statusbar = 'Interface\\AddOns\\oUF_Neav\\media\\statusbarTexture',                 -- Statusbar texture
    },

    font = {
        normal = 'Interface\\AddOns\\oUF_Neav\\media\\fontSmall.ttf',                       -- General font for all other
        normalSize = 13,

        normalBig = 'Interface\\AddOns\\oUF_Neav\\media\\fontThick.ttf',                    -- Name font
        normalBigSize = 14,
    },

    units = {
        ['player'] = {
            scale = 1.193,
            style = 'NORMAL',                                                               -- 'NORMAL' 'RARE' 'ELITE' 'CUSTOM'
            customTexture = 'Interface\\AddOns\\oUF_Neav\\media\\customFrameTexture',       -- Custom texture if style = 'CUSTOM'

            mouseoverText = false,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showStatusFlash = true,
            showCombatFeedback = false,

            position = {'TOPLEFT', UIParent, 34, -30},

            castbar = {
                show = true,

                width = 220,
                height = 19,
                scale = 0.93,

                showLatency = true,
                showSafezone = true,
                safezoneColor = {1, 0, 1},

                classcolor = true,
                color = {1, 0.7, 0},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },

                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 141},
            },
        },

        ['pet'] = {
            scale = 1.193,

            auraSize = 22,
            disableAura = false,                                                            -- Disable Auras on this unitframe

            mouseoverText = true,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showPowerPercent = false,

            position = {43, -20},

            castbar = {
                show = true,

                width = 220,
                height = 19,
                scale = 0.93,

                color = {0, 0.65, 1},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },

                position = {'TOP', oUF_Neav_Player, 'BOTTOM', 0, -50},

                ignoreSpells = true,                                                        -- Hides castbar for spells listed in 'ignoreList'
                ignoreList = {
                    3110,   -- firebolt (imp)
                    31707,  -- waterbolt (water elemental)
                },
            },
        },

        ['target'] = {
            scale = 1.193,

            numBuffs = 20,
            numDebuffs = 20,

            disableAura = false,                                                            -- Disable Auras on this unitframe
            colorPlayerDebuffsOnly = true,
            showAllTimers = false,                                                          -- If false, only the player debuffs have timer
            onlyShowPlayer = false,                                                          -- Only shows player created buffs/debuffs.

            -- Debuffs on top options. Overrides onlyShowPlayer option.
            showDebuffsOnTop = false,
            onlyShowPlayerDebuffs = true,
            onlyShowPlayerBuffs = false,

            mouseoverText = false,
            healthTag = '$cur - $perc',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showCombatFeedback = false,

            showThreatValue = true,                                                         -- Show a Blizzard style threat indicator

            position = {'TOPLEFT', UIParent, 300, -30},

            castbar = {
                show = true,

                width = 220,
                height = 19,
                scale = 0.93,

                color = {0.9, 0.1, 0.1},
                interruptColor = {1, 0, 1},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = false,
                },

                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 380},
            },
        },

        ['targettarget'] = {
            scale = 1.193,
            disableAura = false,                                                             -- Disable Auras on this unitframe

            mouseoverText = false,
            healthTag = '$perc',
            healthTagFull = '',
       },

        ['focus'] = {
            scale = 1.193,

            numDebuffs = 6,
            disableAura = false,                                                            -- Disable Auras on this unitframe.
            debuffsOnly = false,                                                            -- Only show debuffs.

            mouseoverText = false,
            healthTag = '$cur - $perc',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showPowerPercent = false,

            showCombatFeedback = false,

            enableFocusToggleKeybind = true,
            focusToggleKey = 'type4',                                                       -- type1, type2 (mousebutton 1 or 2, 3, 4, 5 etc. works too)

            position = {'LEFT', 30, 0},

            castbar = {
                show = true,

                width = 176,
                height = 19,
                scale = 0.93,

                color = {0, 0.65, 1},
                interruptColor = {1, 0, 1},

                icon = {
                    show = false,
                    position = 'LEFT',   -- 'LEFT' or 'RIGHT'
                    positionOutside = true,
                },
            },
        },

        ['focustarget'] = {
            scale = 1.193,

            mouseoverText = false,
            healthTag = '$perc',
            healthTagFull = '',
        },

        ['party'] = {
            scale = 1.11,
            show = true,
            hideInRaid = true,

            mouseoverText = true,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            position = {'TOPLEFT', UIParent, 25, -200},
        },

        ['boss'] = {
            scale = 1,

            mouseoverText = true,
            healthTag = '$cur - $perc',
            healthTagFull = '$cur',
            powerTag = '$cur',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -95, -250},

            castbar = {
                color = {1, 0, 0},
                interruptColor = {1, 0, 1},

                icon = {
                    size = 22,
                    show = false,
                    position = 'LEFT'   -- 'LEFT' or 'RIGHT'
                },
            },
        },

        ['arena'] = {
            show = true,
            scale = 1,

            auraSize = 22,
            filterBuffs = true,

            mouseoverText = true,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -95, -300},

            castbar = {
                icon = {
                    size = 22,
                },

                color = {1, 0, 0},
            },

            buffList = { -- A whitelist for buffs to display on arena frames
                ['Power Word: Shield'] = true,
            },
        },
    },
}
