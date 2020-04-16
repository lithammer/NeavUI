local _, nCore = ...

function nCore:ArchaeologyHelper()
    local SURVEY_SPELL_ID = 80451
    local FISHING_POLE = GetItemSubClassInfo(2, 20)

    local override_binding_on = nil
    local previousClickTime = nil
    local regen_clear_override = nil


    local surveyButtonName = "nArch_EasySurveyButton"
    local surveyButton = CreateFrame("Button", surveyButtonName, UIParent, "SecureActionButtonTemplate")
    surveyButton:SetPoint("LEFT", UIParent, "RIGHT", 10000, 0)
    surveyButton:Hide()
    surveyButton:SetFrameStrata("LOW")
    surveyButton:EnableMouse(true)
    surveyButton:RegisterForClicks("RightButtonDown")
    surveyButton:SetAttribute("type", "spell")
    surveyButton:SetAttribute("spell", SURVEY_SPELL_ID)
    surveyButton:SetAttribute("action", nil)

    surveyButton:SetScript("PostClick", function(self, button, down)
        if override_binding_on and not nCore:IsTaintable() then
            ClearOverrideBindings(self)
            override_binding_on = nil
        else
            regen_clear_override = true
        end
    end)

    local watcher = CreateFrame("Frame", nil)
    watcher:RegisterEvent("PLAYER_REGEN_ENABLED")

    watcher:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_REGEN_ENABLED" then
            if regen_clear_override then
                ClearOverrideBindings(surveyButtonName)
                override_binding_on = nil
                regen_clear_override = nil
            end
        end
    end)

    WorldFrame:HookScript("OnMouseDown", function(frame, button, down)
        if button ~= "RightButton" or nCore:IsTaintable() or not nCoreDB.ArchaeologyHelper then return end

        local mapID = C_Map.GetBestMapForUnit("player")
        
        if not mapID then return end

        -- Classic: Doesn't support Archaeology
        if ArchaeologyMapUpdateAll == nil then return end

        if ArchaeologyMapUpdateAll(mapID) > 0  and CanScanResearchSite() and GetSpellCooldown(SURVEY_SPELL_ID) == 0 and not IsEquippedItemType(FISHING_POLE) then
            if GetNumLootItems() == 0 and previousClickTime then
                local doubleClickTime = GetTime() - previousClickTime

                if doubleClickTime < 0.2 and doubleClickTime > 0.04 then
                    previousClickTime = nil

                    SetOverrideBindingClick(surveyButton, true, "BUTTON2", surveyButtonName)
                    override_binding_on = true
                end
            end

            previousClickTime = GetTime()
        end
    end)
end