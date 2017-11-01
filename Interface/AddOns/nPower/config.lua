
local _, nPower = ...

nPower.Config = {
    position = {'CENTER', UIParent, 0, -100},
    sizeWidth = 200,
    scale = 1.0,

    showCombatRegen = true,

    activeAlpha = 1,
    inactiveAlpha = 0.3,
    emptyAlpha = 0,

    valueAbbrev = true,

    valueFont = 'Fonts\\ARIALN.ttf',
    valueFontSize = 20,
    valueFontOutline = true,
    valueFontAdjustmentX = 0,

    showSoulshards = true,
    showHolypower = true,
    showComboPoints = true,
    showChi = true,
    showRunes = true,
    showArcaneCharges = true,

    -- Resource text shown above the bar.
    extraFont = 'Fonts\\ARIALN.ttf',
    extraFontSize = 16,
    extraFontOutline = true,

    hp = {
        show = false,
        hpFont = 'Fonts\\ARIALN.ttf',
        hpFontOutline = true,
        hpFontSize = 25,
        hpFontColor = {0.0, 1.0, 0.0},
        hpFontHeightAdjustment = 10,
    },

    mana = {
        show = true,
    },

    energy = {
        show = true,
    },

    focus = {
        show = true,
    },

    rage = {
        show = true,
    },

    lunarPower = {
        show = true,
    },

    rune = {
        show = true,

        runeFont = 'Fonts\\ARIALN.ttf',
        runeFontSize = 15,
        runeFontOutline = true,
    },

    insanity = {
        show = true,
    },

    maelstrom = {
        show = true,
    },

    fury = {
        show = true,
    },

    pain = {
        show = true,
    },
}
