
nTooltip = {
    position = {
        'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -27.35, 27.35
    },
    
    disableFade = false, -- can cause errors or a buggy tooltip!
    
    reactionBorderColor = false, -- WOHA! Try this out!
    itemqualityBorderColor = true,
    
    showPlayerTitles = false,
    showPVPIcons = false, -- show pvp icons instead of just a prefix
    abbrevRealmNames = false, 
    showMouseoverTarget = true,
    
    showItemLevel = false,
    
    healthbar = {
        showHealthValue = false,
        fontSize = 13,
        font = 'Fonts\\ARIALN.ttf',
        showOutline = false,
        textPos = 'CENTER',    -- possible 'TOP' 'BOTTOM' 'CENTER'
        
        reactionColoring = false,    -- overrides customColor 
        customColor = {
            apply = false, 
            r = 0, 
            g = 1, 
            b = 1
        } 
    },
}