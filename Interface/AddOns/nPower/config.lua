
local _, nPower = ...

nPower.Config = {
    position = {"CENTER", UIParent, 0, -100},
    sizeWidth = 200,
    scale = 1.0,

    showCombatRegen = true,

    activeAlpha = 1,
    inactiveAlpha = 0.3,
    emptyAlpha = 0,

    valueAbbrev = true,

    valueFont = "Fonts\\ARIALN.ttf",
    valueFontSize = 20,
    valueFontOutline = true,
    valueFontAdjustmentX = 0,

    -- Resource text shown above the bar.
    showComboPoints = true,

    extraFont = "Fonts\\ARIALN.ttf",
    extraFontSize = 16,
    extraFontOutline = true,

    -- Power Bar
    showPowerType = {
        ["MANA"] = true,
        ["ENERGY"] = true,
    },
}
