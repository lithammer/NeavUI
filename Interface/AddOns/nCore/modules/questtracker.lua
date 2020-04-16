local _, nCore = ...

function nCore:QuestTracker()
    local function UpdateQuestText()
        local _, numQuests = GetNumQuestLogEntries()
        -- Classic TODO: 'WorldMapFrameTitleText' doesn't appear to exist, is there an alternative?
        -- Have commented out the config option for now

        -- WorldMapFrameTitleText:SetFormattedText("%s - %d/%s", MAP_AND_QUEST_LOG, numQuests, MAX_QUESTS)
        -- WorldMapFrameTitleText:Show()
    end

    UpdateQuestText()

    local watcher = CreateFrame("Frame")
    watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
    watcher:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    watcher:RegisterEvent("QUEST_ACCEPTED")
    watcher:RegisterEvent("QUEST_AUTOCOMPLETE")
    watcher:RegisterEvent("QUEST_LOG_UPDATE")
    watcher:RegisterEvent("QUEST_REMOVED")

    watcher:SetScript("OnEvent", function(self, event, ...)
        if nCoreDB.QuestTracker then
            UpdateQuestText()
        else
            -- WorldMapFrameTitleText:SetText(MAP_AND_QUEST_LOG)
            -- WorldMapFrameTitleText:Show()
        end
    end)
end
