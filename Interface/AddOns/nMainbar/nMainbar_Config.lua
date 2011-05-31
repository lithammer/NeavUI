
nMainbar = {
    indicator = { 
        range = 'R',             -- you can set everything as range indicator, but only shown if you use 'hotkey' as OutOfRangeColoring :)  -- \226\128\162 
    },
    
    button = { 
        showVehicleKeybinds = true,
        showKeybinds = false,
        showMacronames = false, 
        OutOfRangeColoring = 'ICON',    -- 'ICON'
                                        -- 'HOTKEY' (will show the range indicator instead of the hotkey if ['Keybind = false'] )
                                        --  false (no range indicator)

        countFontsize = 19,
        countFont = 'Interface\\AddOns\\nMainbar\\media\\font.ttf',
        
        macronameFontsize = 18,
        macronameFont = 'Interface\\AddOns\\nMainbar\\media\\font.ttf',
        
        hotkeyFontsize = 18,
        hotkeyFont = 'Interface\\AddOns\\nMainbar\\media\\font.ttf',
    },
        
    color = {   -- Red, Green, Blue
        Normal = { 1, 1, 1 },
        IsEquipped = { 0, 1, 0 },
        
        OutOfRange = { 0.9, 0, 0 },
        OutOfMana = { 0.3, 0.3, 1 },
        
        NotUsable = { 0.35, 0.35, 0.35 },
        
        HotKeyText = { 0.6, 0.6, 0.6 },
        MacroText = { 1, 1, 1 },
        CountText = { 1, 1, 1 },
    },

    expBar = {
        mouseover = true,
        fontsize = 14,
        font = 'Fonts\\ARIALN.ttf',
    },
    
    repBar = {
        mouseover = true,
        fontsize = 14,
        font = 'Fonts\\ARIALN.ttf',
    },
    
    MainMenuBar = {
        scale = 1,
        hideGryphons = false,
        
        shortBar = true,
        skinButton = true,
        
        moveableExtraBars = false,  -- make the pet, possess, shapeshift and totembar maveable, even when the mainmenubar is not "short"
    },

    vehicle = {
        scale = 0.8,
    },
    
    petBar = {
		mouseover = false,
		scale = 1,
		alpha = 1,
		vertical = false,
    },
    
    possessBar = {
        scale = 1,
        alpha = 1,
    },
    
    stanceBar = {
        mouseover = false,
        hide = false,
        scale = 1,
        alpha = 1,
    },
    
    multiBarLeft = {
        mouseover = true,
        alpha = 1,
        orderHorizontal = false,
    },
    
    multiBarRight = {
        mouseover = true,
        alpha = 1,
        orderHorizontal = false,
    },
    
    multiBarBottomLeft = {
        mouseover = false,
        alpha = 1,
    },
    
    multiBarBottomRight = {
        mouseover = false,
        alpha = 1,
        orderVertical = false,
        verticalPosition = 'LEFT', -- 'LEFT' or 'RIGHT'
    },
    
    totemManager = {
        scale = 1,
        alpha = 1,
        hideRecallButton = false,
    },
}