local _, nCore = ...

function nCore:MoveTalkingHeads()
    if not nCoreDB.MoveTalkingHeads then return end
    
    local L = nCore.L

    local location = {"LEFT", UIParent, "LEFT", 0, 0}
    local AlertFrameAnchor = nCore:CreateAnchor("AlertFrame", 570, 155, location)

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGIN")
    f:SetScript("OnEvent", function(self, event, arg1)
        if event == "PLAYER_LOGIN" then
            AlertFrame:ClearAllPoints()
            AlertFrame:SetPoint("BOTTOM", AlertFrameAnchor)
        end
    end)

    local function MoveTalkingHeads()
        hooksecurefunc(TalkingHeadFrame, "Show", function(self)
            self:ClearAllPoints()
            self:SetPoint("BOTTOMLEFT", AlertFrameAnchor)
        end)
    end

    if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
        MoveTalkingHeads()
    else
        local waitFrame = CreateFrame("FRAME")
        waitFrame:RegisterEvent("ADDON_LOADED")
        waitFrame:SetScript("OnEvent", function(self, event, ...)
            local name = ...
            if name == "Blizzard_TalkingHeadUI" then
                MoveTalkingHeads()
            end
        end)
    end

    SlashCmdList["AlertFrameAnchor_AnchorToggle"] = function()
        if InCombatLockdown() then
            print(L.CombatWarning)
            return
        end
        if not AlertFrameAnchor:IsShown() then
            AlertFrameAnchor:Show()
        else
            AlertFrameAnchor:Hide()
        end
    end
    SLASH_AlertFrameAnchor_AnchorToggle1 = "/alertframemover"
end