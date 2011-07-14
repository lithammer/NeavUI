
local _, nChat = ...

nChat.Config = {
    disableFade = false,
    chatOutline = false,

    enableBottomButton = false, 
    enableHyperlinkTooltip = false, 
    enableBorderColoring = true,

    tab = {
        fontSize = 15,
        fontOutline = true, 
        normalColor = {1, 1, 1},
        specialColor = {1, 0, 1},
        selectedColor = {0, 0.75, 1},
    },
}

CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.5
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0

CHAT_FRAME_FADE_OUT_TIME = 0.25
CHAT_FRAME_FADE_TIME = 0.1