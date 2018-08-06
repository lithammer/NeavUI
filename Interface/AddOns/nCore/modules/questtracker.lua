local _, nCore = ...

function nCore:QuestTracker()
    if not nCoreDB.QuestTracker then return end

    local function UpdateQuestText()
        local _, numQuests = GetNumQuestLogEntries()
        WorldMapFrameTitleText:SetFormattedText("%s - %d/%s", MAP_AND_QUEST_LOG, numQuests, MAX_QUESTS)
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
        UpdateQuestText()
    end)
end
