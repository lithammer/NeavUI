
local _, nTooltip = ...

nTooltip.Config = {
    fontSize = 15,
    fontOutline = false,

    position = {
        "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -39, 82
    },

    showOnMouseover = false,
    hideInCombat = false,                       -- Hide unit frame tooltips during combat

    reactionBorderColor = false,
    itemqualityBorderColor = true,

    abbrevRealmNames = false,
    showPlayerTitles = true,
    showUnitRole = true,
    showPVPIcons = true,                       -- Show pvp icons instead of just a prefix
    showMouseoverTarget = true,
    showSpecializationIcon = true,

    healthbar = {
        showHealthValue = true,

        healthFormat = "$cur / $max",           -- Possible: $cur, $max, $deficit, $perc, $smartperc, $smartcolorperc, $colorperc
        healthFullFormat = "$cur",              -- if the tooltip unit has 100% hp

        fontSize = 13,
        font = STANDARD_TEXT_FONT,
        showOutline = true,
        textPos = "CENTER",                     -- Possible "TOP" "BOTTOM" "CENTER"

        reactionColoring = false,               -- Overrides customColor
        customColor = {
            apply = false,
            r = 0,
            g = 1,
            b = 1
        }
    },
}
