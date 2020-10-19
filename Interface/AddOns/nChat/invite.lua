
local sub = string.sub
local match = string.match

StaticPopupDialogs["NCHAT_ALTCLICK"] = {
    text = ERR_INVITE_PLAYER_S,
    button1 = INVITE,
    button2 = CANCEL,
    OnAccept = function(self)
        InviteUnit(self.data)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    enterClicksFirstButton = true,
    preferredIndex = 3,
}

local eventWatcher = CreateFrame("Frame")
eventWatcher:RegisterEvent("ADDON_LOADED")

eventWatcher:SetScript("OnEvent", function(self, event, ...)
    local addonName = ...
    if addonName == "Blizzard_CombatLog" then
        local origSetItemRef = SetItemRef
        function SetItemRef(link, text, button, chatFrame)
            local linkType = sub(link, 1, 6)
            if IsAltKeyDown() and linkType == "player" then
                local name = match(link, "player:([^:]+)")
                StaticPopup_Show("NCHAT_ALTCLICK", name, nil, name)
                return nil
            end

            return origSetItemRef(link, text, button, chatFrame)
        end
    end
end)
