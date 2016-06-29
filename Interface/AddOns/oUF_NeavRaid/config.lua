
local _, ns = ...

ns.Config = {
    media = {
        statusbar = 'Interface\\AddOns\\oUF_NeavRaid\\media\\statusbarTexture',                 -- Health- and Powerbar texture
    },

    font = {
        fontSmall = 'Interface\\AddOns\\oUF_NeavRaid\\media\\fontSmall.ttf',                    -- Name font
        fontSmallSize = 11,

        fontBig = 'Interface\\AddOns\\oUF_NeavRaid\\media\\fontThick.ttf',                      -- Health, dead/ghost/offline etc. font
        fontBigSize = 12,
    },

    units = {
        ['raid'] = {
            showSolo = true,
            showParty = true,

            nameLength = 5,

            width = 45,
            height = 43,
            scale = 1.1,

            layout = {
                frameSpacing = 7,
                numGroups = 8,

                initialAnchor = 'TOPLEFT',                                                  -- 'TOPLEFT' 'BOTTOMLEFT' 'TOPRIGHT' 'BOTTOMRIGHT'
                orientation = 'HORIZONTAL',                                                 -- 'VERTICAL' 'HORIZONTAL'
            },

            smoothUpdates = true,                                                           -- Enable smooth updates for all bars
            showThreatText = false,                                                         -- Show a red 'AGGRO' text on the raidframes in addition to the glow
            showRolePrefix = false,                                                         -- A simple role abbrev..tanks = '>'..healer = '+'..dds = '-'
            showNotHereTimer = true,                                                        -- A afk and offline timer
            showMainTankIcon = true,                                                        -- A little shield on the top of a raidframe if the unit is marked as maintank
            showResurrectText = true,                                                       -- Not working atm. just a placeholder
            showMouseoverHighlight = true,

            showTargetBorder = true,                                                        -- Ahows a little border on the raid/party frame if this unit is your target
            targetBorderColor = {1, 1, 1},

            iconSize = 22,                                                                  -- The size of the debufficon
            indicatorSize = 10,                                                             -- Player buffs
            useSpellIcon = true,                                                            -- Uses spell texture or indicator icon.
            
            horizontalHealthBars = false,
            deficitThreshold = 0.95,

            manabar = {
                show = true,
                horizontalOrientation = false,
            },
        },
    },
}
