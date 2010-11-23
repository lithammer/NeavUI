--[[

    nMainbar
    Copyright (c) 2008-2010, Anton "Neav" I. (Neav @ Alleria-EU)
    All rights reserved.

--]]

local neav
if (UnitName('player') == 'Neava') then
    neav = false
else
    neav = true
end

nMainbar = {
    indicator = { 
        range = 'R',             -- you can set everything as range indicator, but only shown if you use 'hotkey' as OutOfRangeColoring :)  -- \226\128\162 
    },
    
    button = { 
        showKeybinds            = false,
        showMacronames          = false, 
        OutOfRangeColoring      = 'icon',   -- you can use:
                                            -- 'icon'
                                            -- 'hotkey' (will show the range indicator instead of the hotkey if ['Keybind = false'] )
                                            -- false (no range indicator)

        countFontsize           = 19,
        countFont               = 'Interface\\AddOns\\nMainbar\\media\\font.ttf',
        
        macronameFontsize       = 18,
        macronameFont           = 'Interface\\AddOns\\nMainbar\\media\\font.ttf',
        
        hotkeyFontsize          = 18,
        hotkeyFont              = 'Interface\\AddOns\\nMainbar\\media\\font.ttf',
    },
        
    color = {           -- Red, Green, Blue
        Normal      =   { 1, 1, 1 },
        IsEquipped  =   { 0, 1, 0 },
        
        OutOfRange  =   { 0.9, 0, 0 },
        OutOfMana   =   { 0.3, 0.3, 1 },
        
        NotUsable   =   { 0.35, 0.35, 0.34 },
        
        HotKeyText  =   { 0.6, 0.6, 0.6 },
        MacroText   =   { 1, 1, 1 },
        CountText   =   { 1, 1, 1 },
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
    },
    
    vehicle = {
        scale               = 0.8,
    },
    
    petbar = {
		mouseover			= false,
		scale				= 1,
		alpha				= 1,
		vertical			= false,
    },
    
    possessbar = {
        scale               = 1,
        alpha               = 1,
    },
    
    stanceBar = {
        mouseover           = false,
        hide                = false,
        scale               = 1,
        alpha               = 1,
    },
    
    multiBarLeft = {
        mouseover           = false,
        alpha               = 1,
    },
    
    multiBarRight = {
        mouseover           = false,
        alpha               = 1,
    },
    
    multiBarBottomLeft = {
        mouseover           = false,
        alpha               = 1,
    },
    
    multiBarBottomRight = {
        mouseover           = true,
        alpha               = 1,
    },
    
    totemManager = {
        scale               = 1,
        alpha               = 1,
        hideRecallButton    = false,
    },
}
