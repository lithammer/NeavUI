
local _, nTooltip = ...

nTooltip.Config = {
    fontSize = 15,
    fontOutline = false,

    position = {
        'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -27.35, 27.35
    },

    disableFade = false,                        -- Can cause errors or a buggy tooltip!
    showOnMouseover = false,

    reactionBorderColor = false,
    itemqualityBorderColor = true,

    abbrevRealmNames = false, 
    showPlayerTitles = true,
    showUnitRole = true,
    showPVPIcons = false,                       -- Show pvp icons instead of just a prefix
    showMouseoverTarget = true,
    showItemLevel = false,

    healthbar = {
        showHealthValue = true,

        healthFormat = '$cur / $max',           -- Possible: $cur, $max, $deficit, $perc, $smartperc, $smartcolorperc, $colorperc
        healthFullFormat = '$cur',              -- if the tooltip unit has 100% hp 

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
