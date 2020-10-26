local sub = string.sub
local match = string.match

StaticPopupDialogs["NCHAT_ALTCLICK"] = {
    text = ERR_INVITE_PLAYER_S,
    button1 = INVITE,
    button2 = CANCEL,
    OnAccept = function(self)
        C_PartyInfo.InviteUnit(self.data)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    enterClicksFirstButton = true,
    preferredIndex = 3,
}

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
    local linkType = sub(link, 1, 6)
    if IsAltKeyDown() and linkType == "player" then
        for i = 1, NUM_CHAT_WINDOWS do
            local editBox = _G['ChatFrame'..i..'EditBox']
            editBox:Hide()
        end
        local name = match(link, "player:([^:]+)")
        StaticPopup_Show("NCHAT_ALTCLICK", name, nil, name)
    end
end)

local eventWatcher = CreateFrame("Frame")
eventWatcher:RegisterEvent("ADDON_LOADED")
