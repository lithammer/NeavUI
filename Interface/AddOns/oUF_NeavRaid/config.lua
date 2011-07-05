
local _, ns = ...

ns.config = {
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

            nameLength = 4,

            width = 42,
            height = 40,
            scale = 1.1, 

            layout = {
                frameSpacing = 7,
                numGroups = 8,

                initialAnchor = 'TOPLEFT',                                                  -- 'TOPLEFT' 'BOTTOMLEFT' 'TOPRIGHT' 'BOTTOMRIGHT'
                orientation = 'HORIZONTAL',                                                 -- 'VERTICAL' 'HORIZONTAL'
            },

            showThreatText = false,                                                         -- Show a red 'THREAT' text on the raidframes in addition to the glow
            showRolePrefix = false,                                                         -- A simple role abbrev..tanks = '>'..healer = '+'..dds = '-'
            showNotHereTimer = true,                                                        -- A afk and offline timer
            showMainTankIcon = true,                                                        -- A little shield on the top of a raidframe if the unit is marked as maintank
            -- showRessurectText = false,                                                   -- Not working atm. just a placeholder
            showMouseoverHighlight = true,

            showTargetBorder = true,                                                        -- Ahows a little border on the raid/party frame if this unit is your target
            targetBorderColor = {1, 1, 1},

            smoothUpdatesForAllClasses = true,                                              -- Set to true to enable smooth updates for healing classes

            iconSize = 22,                                                                  -- The size of the debufficon
            indicatorSize = 7,

            horizontalHealthBars = false,

            manabar = {
                show = true,
                horizontalOrientation = false,
            },
        },
    },
}
