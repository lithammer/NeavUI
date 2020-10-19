
local _, nPower = ...

nPower.Config = {
    position = {"CENTER", UIParent, 0, -100},
    sizeWidth = 200,
    scale = 1.0,

    activeAlpha = 1,
    inactiveAlpha = 0.3,
    emptyAlpha = 0,

    valueAbbrev = true,

    valueFont = "Fonts\\ARIALN.ttf",
    valueFontSize = 20,
    valueFontOutline = true,
    valueFontAdjustmentX = 0,

    hp = {
        show = true,
        hpFont = "Fonts\\ARIALN.ttf",
        hpFontOutline = true,
        hpFontSize = 25,
        hpFontColor = {0.0, 1.0, 0.0},
        hpFontHeightAdjustment = 10,
    },

    -- Resource text shown above the bar.
    showSoulshards = true,
    showHolypower = true,
    showComboPoints = true,
    showChi = true,
    showRunes = true,
    showArcaneCharges = true,

    extraFont = "Fonts\\ARIALN.ttf",
    extraFontSize = 16,
    extraFontOutline = true,

    -- Power Bar
    showPowerType = {
        ["MANA"] = true,
        ["ENERGY"] = true,
        ["RAGE"] = true,
        ["FOCUS"] = true,
        ["RUNIC_POWER"] = true,
        ["FURY"] = true,
        ["PAIN"] = true,
        ["LUNAR_POWER"] = true,
        ["INSANITY"] = true,
        ["MAELSTROM"] = true,
    },

    holyPower = {
        -- Displays holy power as a rune (#) instead of a number.
        showRunes = false,

        holyFont = "Fonts\\ARIALN.ttf",
        holyFontSize = 15,
        holyFontOutline = true,
    },

    rune = {
        show = true,

        runeFont = "Fonts\\ARIALN.ttf",
        runeFontSize = 15,
        runeFontOutline = true,
    },
}
