
local _, ns = ...

ns.Config = {
    media = {
        statusbar = 'Interface\\AddOns\\oUF_NeavRaid\\media\\statusbarTexture',             -- Health- and Powerbar texture
    },

    font = {
        fontSmall = 'Interface\\AddOns\\oUF_NeavRaid\\media\\fontSmall.ttf',                -- Name font
        fontSmallSize = 11,

        fontBig = 'Interface\\AddOns\\oUF_NeavRaid\\media\\fontThick.ttf',                  -- Health, dead/ghost/offline etc. font
        fontBigSize = 12,
    },

    units = {
        ['raid'] = {
            showSolo = true,
            showParty = true,

            nameLength = 4,

            width = 42,
            height = 40,
            scale = 1.1,

            layout = {
                frameSpacing = 7,

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

            showMainTankFrames = false,                                                     -- Show Main Tank/Assist Group

            showTargetBorder = true,                                                        -- Ahows a little border on the raid/party frame if this unit is your target
            targetBorderColor = {1, 1, 1},

            iconSize = 22,                                                                  -- The size of the debufficon
            indicatorSize = 7,

            horizontalHealthBars = false,
            deficitThreshold = 0.95,

            manabar = {
                show = true,
                horizontalOrientation = false,
            },
        },
    },
}
