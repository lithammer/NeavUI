local _, nCore = ...

function nCore:AutoQuest()
    if not nCoreDB.AutoQuest then return end

    -- Function to show quest dialog for popup quests in the objective tracker
    local function PopupQuestComplete()
        if GetNumAutoQuestPopUps() > 0 then
            local questId, questType = GetAutoQuestPopUp(1)
            if questType == "COMPLETE" then
                local index = GetQuestLogIndexByID(questId)
                ShowQuestComplete(index)
            end
            nCore.PopupQuestTicker:Cancel()
        end
    end

    -- Funcion to ignore specific NPCs
    local function isNpcBlocked(actionType)
        local npcGuid = UnitGUID("target") or nil
        if npcGuid then
            local _, _, _, _, _, npcID = strsplit("-", npcGuid)
            if npcID then
                -- Ignore specific NPCs for selecting, accepting and turning-in quests (required if automation has consequences)
                if npcID == "45400"     -- Fiona"s Caravan (Eastern Plaguelands)
                or npcID == "18166"     -- Khadgar (Allegiance to Aldor/Scryer, Shattrath)
                or npcID == "114719"    -- Trader Caelen (Obliterum Forge, Dalaran, Broken Isles)
                or npcID == "6294"      -- Krom Stoutarm (Heirloom Curator, Ironforge)
                or npcID == "6566"      -- Estelle Gendry (Heirloom Curator, Undercity)
                then
                    return true
                end
                -- Ignore specific NPCs for selecting quests only (required if incomplete quest turn-ins are selected automatically)
                if actionType == "Select" then
                    if npcID == "15192"     -- Anachronos (Caverns of Time)
                    or npcID == "111243"    -- Archmage Lan"dalock (Seal quest, Dalaran)
                    or npcID == "119388"    -- Chieftain Hatuun (Krokul Hovel, Krokuun)
                    or npcID == "87391"     -- Fate-Twister Seress (Seal quest, Stormshield)
                    or npcID == "88570"     -- Fate-Twister Tiklal (Seal quest, Horde)
                    or npcID == "87706"     -- Gazmolf Futzwangler (Reputation quests, Nagrand, Draenor)
                    or npcID == "55402"     -- Korgol Crushskull (Darkmoon Faire, Pit Master)
                    or npcID == "70022"     -- Ku"ma (Isle of Giants, Pandaria)
                    or npcID == "12944"     -- Lokhtos Darkbargainer (Thorium Brotherhood, Blackrock Depths)
                    or npcID == "109227"    -- Meliah Grayfeather (Tradewind Roost, Highmountain)
                    or npcID == "99183"     -- Renegade Ironworker (Tanaan Jungle, repeatable quest)
                    or npcID == "87393"     -- Sallee Silverclamp (Reputation quests, Nagrand, Draenor)
                    then
                        return true
                    end
                end
            end
        end
    end

    -- Function to check if quest requires currency
    local function QuestRequiresCurrency()
        for i = 1, 6 do
            local progItem = _G["QuestProgressItem" ..i] or nil
            if progItem and progItem:IsShown() and progItem.type == "required" and progItem.objectType == "currency" then
                return true
            end
        end
    end

    -- Function to check if quest requires gold
    local function QuestRequiresGold()
        local goldRequiredAmount = GetQuestMoneyToGet()
        if goldRequiredAmount and goldRequiredAmount > 0 then
            return true
        end
    end

    -- Register events
    local qFrame = CreateFrame("FRAME")
    qFrame:RegisterEvent("QUEST_DETAIL")
    qFrame:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    qFrame:RegisterEvent("QUEST_PROGRESS")
    qFrame:RegisterEvent("QUEST_COMPLETE")
    qFrame:RegisterEvent("QUEST_GREETING")
    qFrame:RegisterEvent("QUEST_AUTOCOMPLETE")
    qFrame:RegisterEvent("GOSSIP_SHOW")
    qFrame:RegisterEvent("QUEST_FINISHED")
    qFrame:SetScript("OnEvent", function(self, event)

        -- Clear progress items when quest interaction has ceased
        if event == "QUEST_FINISHED" then
            for i = 1, 6 do
                local progItem = _G["QuestProgressItem" ..i] or nil
                if progItem and progItem:IsShown() then
                    progItem:Hide()
                end
            end
            return
        end

        -- Check for modifier.
        if not IsShiftKeyDown() then return end

        ----------------------------------------------------------------------
        -- Accept quests automatically
        ----------------------------------------------------------------------

        -- Accept quests with a quest detail window
        if event == "QUEST_DETAIL" then
            -- Don"t accept blocked quests
            if isNpcBlocked("Accept") then return end
            -- Accept quest
            if QuestGetAutoAccept() then
                -- Quest has already been accepted by Wow so close the quest detail window
                CloseQuest()
            else
                -- Quest has not been accepted by Wow so accept it
                AcceptQuest()
                HideUIPanel(QuestFrame)
            end
        end

        -- Accept quests which require confirmation (such as sharing escort quests)
        if event == "QUEST_ACCEPT_CONFIRM" then
            ConfirmAcceptQuest()
            StaticPopup_Hide("QUEST_ACCEPT")
        end

        ----------------------------------------------------------------------
        -- Turn-in quests automatically
        ----------------------------------------------------------------------

        -- Turn-in progression quests
        if event == "QUEST_PROGRESS" and IsQuestCompletable() then
            -- Don"t continue quests for blocked NPCs
            if isNpcBlocked("Complete") then return end
            -- Don"t continue if quest requires currency
            if QuestRequiresCurrency() then return end
            -- Don"t continue if quest requires gold
            if QuestRequiresGold() then return end
            -- Continue quest
            CompleteQuest()
        end

        -- Turn in completed quests if only one reward item is being offered
        if event == "QUEST_COMPLETE" then
            -- Don"t complete quests for blocked NPCs
            if isNpcBlocked("Complete") then return end
            -- Don"t complete if quest requires currency
            if QuestRequiresCurrency() then return end
            -- Don"t complete if quest requires gold
            if QuestRequiresGold() then return end
            -- Complete quest
            if GetNumQuestChoices() <= 1 then
                GetQuestReward(GetNumQuestChoices())
            end
        end

        -- Show quest dialog for quests that use the objective tracker (it will be completed automatically)
        if event == "QUEST_AUTOCOMPLETE" then
            nCore.PopupQuestTicker = C_Timer.NewTicker(0.25, PopupQuestComplete, 20)
        end

        ----------------------------------------------------------------------
        -- Select quests automatically
        ----------------------------------------------------------------------

        if event == "GOSSIP_SHOW" or event == "QUEST_GREETING" then

            -- Select quests
            if UnitExists("npc") or QuestFrameGreetingPanel:IsShown() or GossipFrameGreetingPanel:IsShown() then

                -- Don"t select quests for blocked NPCs
                if isNpcBlocked("Select") then return end

                -- Select quests
                if event == "QUEST_GREETING" then
                    -- Quest greeting
                    local availableCount = GetNumAvailableQuests() + GetNumActiveQuests()
                    if availableCount >= 1 then
                        for i = 1, availableCount do
                            if _G["QuestTitleButton" .. i].isActive == 0 then
                                -- Select available quests
                                C_Timer.After(0.01, function() SelectAvailableQuest(_G["QuestTitleButton" .. i]:GetID()) end)
                            else
                                -- Select completed quests
                                local _, isComplete = GetActiveTitle(i)
                                if isComplete then
                                    SelectActiveQuest(_G["QuestTitleButton" .. i]:GetID())
                                end
                            end
                        end
                    end
                else
                    -- Gossip frame
                    local availableCount = GetNumGossipAvailableQuests() + GetNumGossipActiveQuests()
                    if availableCount >= 1 then
                        for i = 1, availableCount do
                            if _G["GossipTitleButton" .. i].type == "Available" then
                                -- Select available quests
                                C_Timer.After(0.01, function() SelectGossipAvailableQuest(i) end)
                            else
                                -- Select completed quests
                                local isComplete = select(i * 6 - 5 + 3, GetGossipActiveQuests()) -- 4th argument of 6 argument line
                                if isComplete then
                                    if _G["GossipTitleButton" .. i].type == "Active" then
                                        SelectGossipActiveQuest(_G["GossipTitleButton" .. i]:GetID())
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end