local _, nCore = ...

function nCore_OnLoad(self)
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("ADDON_LOADED")

    if AddonList then
        _G["ADDON_DEMAND_LOADED"] = "On Demand"
    end

    if MerchantFrame then
        _G["MerchantRepairText"]:SetText("")
    end
end

function nCore_OnEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        SetCVar("ScreenshotQuality", 10)
    elseif event == "ADDON_LOADED" then
        local name = ...
        if name == "nCore" then
            nCore:SetDefaultOptions()
            nCore:AltBuy()
            nCore:ArchaeologyHelper()
            nCore:AutoGreed()
            nCore:AutoQuest()
            nCore:Dressroom()
            nCore:Durability()
            nCore:ErrorFilter()
            nCore:Fonts()
            nCore:MapCoords()
            nCore:MoveTalkingHeads()
            nCore:QuestTracker()
            nCore:ObjectiveTracker()
            nCore:Skins()
            nCore:SpellID()
            nCore:VignetteAlert()
        end
    end
end

SlashCmdList["RELOADUI"] = function()
    ReloadUI()
end
SLASH_RELOADUI1 = "/rl"

SlashCmdList["ACTIONCAM"] = function(msg)
    if msg == "basic" or msg == "full" or msg == "off" then
        ConsoleExec("actioncam "..msg)
    else
        print("ActionCam Options: basic, full, off")
    end
end
SLASH_ACTIONCAM1 = "/actioncam"
