
nPower = {
    position = {'CENTER', UIParent, 0, -100},
    sizeWidth = 200,
    
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
    
    extraFont = 'Fonts\\ARIALN.ttf',                -- The font for the holypower and soulshard number
    extraFontSize = 16,                             -- The fontsiz for the holypower and soulshard number
    extraFontOutline = true,                        
        
    mana = {
        show = true,
    },
    
    energy = {
        show = true,
        showComboPoints = true,
        comboPointsBottom = false,
        
        comboColor = {
            [1] = {r = 1.0, g = 1.0, b = 1.0},
            [2] = {r = 1.0, g = 1.0, b = 1.0},
            [3] = {r = 1.0, g = 1.0, b = 1.0},
            [4] = {r = 0.9, g = 0.7, b = 0.0},
            [5] = {r = 1.0, g = 0.0, b = 0.0},
        },
        
        comboFont = 'Fonts\\ARIALN.ttf',
        comboFontSize = 16,
        comboFontOutline = true,
    },
    
    focus = {
        show = true,
    },
    
    rage = {
        show = true,
    },
    
    rune = {
        show = true,
        showRuneCooldown = false,
        
        runeFont = 'Fonts\\ARIALN.ttf',
        runeFontSize = 16,
        runeFontOutline = true,
    },
}