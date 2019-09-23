
local _, nChat = ...

nChat.Config = {
    alwaysAlertOnWhisper = true,

    disableFade = false,
    chatOutline = false,

    enableChatWindowBorder = false,

    enableVoiceChatButtons = false,
    enableHyperlinkTooltip = false,
    enableBorderColoring = true,

    showInputBoxAbove = true,  -- Show the chat input box above the chat window
    ignoreArrows = false, -- Ignore the arrow keys when typing in the input box unless alt is pressed

    tab = {
        fontSize = 15,
        fontOutline = true,
        normalColor = {1, 1, 1},
        specialColor = {1, 0, 1},
        selectedColor = {0, 0.75, 1},
    },
}
