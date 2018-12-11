local _, nMainbar = ...

nMainbar.Config = {
    showPicomenu = true,
    useFakeBottomRightBar = true,

    button = {
        showVehicleKeybinds = true,
        showKeybinds = true,
        showMacroNames = false,
        buttonOutOfRange = false,

        watchbarFontsize = 12,
        watchbarFont = STANDARD_TEXT_FONT,

        countFontsize = 19,
        countFont = "Interface\\AddOns\\nMainbar\\Media\\font.ttf",

        macronameFontsize = 15,
        macronameFont = "Interface\\AddOns\\nMainbar\\Media\\font.ttf",

        hotkeyFontsize = 18,
        hotkeyFont = "Interface\\AddOns\\nMainbar\\Media\\font.ttf",

        petHotKeyFontsize = 15,
    },

    color = {   -- Red, Green, Blue, Alpha
        Normal = CreateColor(1.0, 1.0, 1.0, 1.0),
        IsEquipped = CreateColor(0.0, 1.0, 0.0, 1.0),
        OutOfRange = CreateColor(0.8, 0.1, 0.1, 1.0),
        OutOfMana = CreateColor(0.3, 0.3, 1.0, 1.0),
        NotUsable = CreateColor(0.35, 0.35, 0.35, 1.0),

        HotKeyText = CreateColor(0.6, 0.6, 0.6, 1.0),
        MacroText = CreateColor(1.0, 1.0, 1.0, 1.0),
        CountText = CreateColor(1.0, 1.0, 1.0, 1.0),
    },

    MainMenuBar = {
        moveableExtraBars = true,
        hideGryphons = false,
    },

    vehicleBar = {
        scale = 0.80,
    },

    petBar = {
        mouseover = false,
        scale = 1,
        hiddenAlpha = 0,
        alpha = 1,
        vertical = false,
    },

    stanceBar = {
        hide = false,
        scale = 1,
        alpha = 1,
    },

    possessBar = {
        scale = 1,
        alpha = 1,
    },

    multiBarRight = {
        mouseover = false,
        scale = 1,
        hiddenAlpha = 0,
        alpha = 1,
    },

    multiBarBottomLeft = {
        mouseover = false,
        hiddenAlpha = 0,
        alpha = 1,
    },

    -- Only works with "useFakeBottomRightBar" option.
    multiBarBottomRight = {
        mouseover = false,
        hiddenAlpha = 0,
        alpha = 1,
    },
}
