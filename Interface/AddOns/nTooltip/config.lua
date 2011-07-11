
nTooltip = {
    position = {
        'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -27.35, 27.35
    },

    disableFade = false,                        -- Can cause errors or a buggy tooltip!

    reactionBorderColor = false,
    itemqualityBorderColor = true,

    showUnitRole = true,
    showPlayerTitles = false,
    showPVPIcons = false,                       -- Show pvp icons instead of just a prefix
    abbrevRealmNames = false, 
    showMouseoverTarget = true,
    showItemLevel = false,

    healthbar = {
        showHealthValue = false,
        healthFullFormat = '$cur',              -- if the tooltip unit has 100% hp 
        healthValueFormat = '$cur / $max',      -- Possible: $perc, $cur, $max

        fontSize = 13,
        font = 'Fonts\\ARIALN.ttf',
        showOutline = true,
        textPos = 'CENTER',                     -- Possible 'TOP' 'BOTTOM' 'CENTER'

        reactionColoring = false,               -- Overrides customColor 
        customColor = {
            apply = false, 
            r = 0, 
            g = 1, 
            b = 1
        } 
    },
}