
local _, nChat = ...

local sub = string.sub
local match = string.match

local eventWatcher = CreateFrame("Frame")
eventWatcher:RegisterEvent("ADDON_LOADED")

eventWatcher:SetScript("OnEvent", function(self, event, ...)
    local name = ...
    if name == "Blizzard_CombatLog" then
        local origSetItemRef = SetItemRef
        function SetItemRef(link, text, button, chatFrame)
            local linkType = sub(link, 1, 6)
            if IsAltKeyDown() and linkType == "player" then
                local name = match(link, "player:([^:]+)")
                InviteUnit(name)
                return nil
            end

            return origSetItemRef(link, text, button, chatFrame)
        end
    end
end)
