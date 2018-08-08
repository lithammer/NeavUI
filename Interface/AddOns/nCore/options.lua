local addon, nCore = ...
local L = nCore.L

local floor = math.floor

    -- Set Defaults

function nCore:RegisterDefaultSetting(key, value)
    if nCoreDB == nil then
        nCoreDB = {}
    end
    if nCoreDB[key] == nil then
        nCoreDB[key] = value
    end
end

    -- Set Defaults

function nCore:SetDefaultOptions()
    -- Global
    nCore:RegisterDefaultSetting("AltBuy", true)
    nCore:RegisterDefaultSetting("ArchaeologyHelper", true)
    nCore:RegisterDefaultSetting("AutoGreed", true)
    nCore:RegisterDefaultSetting("AutoQuest", true)
    nCore:RegisterDefaultSetting("Dressroom", true)
    nCore:RegisterDefaultSetting("Durability", true)
    nCore:RegisterDefaultSetting("ErrorFilter", true)
    nCore:RegisterDefaultSetting("Fonts", true)
    nCore:RegisterDefaultSetting("ObjectiveTracker", true)
    nCore:RegisterDefaultSetting("MapCoords", true)
    nCore:RegisterDefaultSetting("MoveTalkingHeads", true)
    nCore:RegisterDefaultSetting("QuestTracker", true)
    nCore:RegisterDefaultSetting("Skins", true)
    nCore:RegisterDefaultSetting("SpellID", true)
    nCore:RegisterDefaultSetting("VignetteAlert", true)
end

function nCore:LockInCombat(frame)
    frame:SetScript("OnUpdate", function(self)
        if not InCombatLockdown() then
            self:Enable()
        else
            self:Disable()
        end
    end)
end

function nCore:CreateCheckBox(name, parent, label, tooltip, relativeTo, x, y, disableInCombat)
    local checkBox = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x, y)
    checkBox.Text:SetText(label)

    if tooltip then
        checkBox.tooltipText = tooltip
    end

    if disableInCombat then
        nCore:LockInCombat(checkBox)
    end

    return checkBox
end

local Options = CreateFrame("Frame", "nCoreOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(addon, "Title")
InterfaceOptions_AddCategory(Options)

Options:Hide()
Options:SetScript("OnShow", function()
    local panelWidth = Options:GetWidth()/2

    local LeftSide = CreateFrame("Frame", "LeftSide", Options)
    LeftSide:SetHeight(Options:GetHeight())
    LeftSide:SetWidth(panelWidth)
    LeftSide:SetPoint("TOPLEFT", Options)

    local RightSide = CreateFrame("Frame", "RightSide", Options)
    RightSide:SetHeight(Options:GetHeight())
    RightSide:SetWidth(panelWidth)
    RightSide:SetPoint("TOPRIGHT", Options)

    -- Left Side --

    local OptionsLabel = Options:CreateFontString("OptionsLabel", "ARTWORK", "GameFontNormalLarge")
    OptionsLabel:SetPoint("TOPLEFT", LeftSide, 16, -16)
    OptionsLabel:SetText(L.OptionsLabel)

    local AltBuy = nCore:CreateCheckBox("AltBuy", LeftSide, L.AltBuy, L.AltBuyTooltip, OptionsLabel, 0, -12, false)
    AltBuy:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.AltBuy = checked
    end)

    local ArchaeologyHelper = nCore:CreateCheckBox("ArchaeologyHelper", LeftSide, L.ArchaeologyHelper, L.ArchaeologyHelperTooltip, AltBuy, 0, -6, false)
    ArchaeologyHelper:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.ArchaeologyHelper = checked
    end)

    local AutoGreed = nCore:CreateCheckBox("AutoGreed", LeftSide, L.AutoGreed, L.AutoGreedTooltip, ArchaeologyHelper, 0, -6, false)
    AutoGreed:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.AutoGreed = checked
    end)

    local AutoQuest = nCore:CreateCheckBox("AutoQuest", LeftSide, L.AutoQuest, L.AutoQuestTooltip, AutoGreed, 0, -6, false)
    AutoQuest:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.AutoQuest = checked
    end)

    local Dressroom = nCore:CreateCheckBox("Dressroom", LeftSide, L.Dressroom, L.DressroomTooltip, AutoQuest, 0, -6, false)
    Dressroom:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.Dressroom = checked
    end)

    local Durability = nCore:CreateCheckBox("Durability", LeftSide, L.Durability, L.DurabilityTooltip, Dressroom, 0, -6, false)
    Durability:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.Durability = checked
    end)

    local ErrorFilter = nCore:CreateCheckBox("ErrorFilter", LeftSide, L.ErrorFilter, L.ErrorFilterTooltip, Durability, 0, -6, false)
    ErrorFilter:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.ErrorFilter = checked
    end)

    local Fonts = nCore:CreateCheckBox("Fonts", LeftSide, L.Fonts, L.FontsTooltip, ErrorFilter, 0, -6, false)
    Fonts:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.Fonts = checked
    end)

    local MapCoords = nCore:CreateCheckBox("MapCoords", LeftSide, L.MapCoords, L.MapCoordsTooltip, Fonts, 0, -6, false)
    MapCoords:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.MapCoords = checked
    end)

    local ObjectiveTracker = nCore:CreateCheckBox("ObjectiveTracker", LeftSide, L.ObjectiveTracker, L.ObjectiveTrackerTooltip, MapCoords, 0, -6, false)
    ObjectiveTracker:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.ObjectiveTracker = checked
    end)

    local MoveTalkingHeads = nCore:CreateCheckBox("MoveTalkingHeads", LeftSide, L.MoveTalkingHeads, L.MoveTalkingHeadsTooltip, ObjectiveTracker, 0, -6, false)
    MoveTalkingHeads:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.MoveTalkingHeads = checked
    end)

    local QuestTracker = nCore:CreateCheckBox("QuestTracker", LeftSide, L.QuestTracker, L.QuestTrackerTooltip, MoveTalkingHeads, 0, -6, false)
    QuestTracker:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.QuestTracker = checked
    end)

    local Skins = nCore:CreateCheckBox("Skins", LeftSide, L.Skins, L.SkinsTooltip, QuestTracker, 0, -6, false)
    Skins:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.Skins = checked
    end)

    local SpellID = nCore:CreateCheckBox("SpellID", LeftSide, L.SpellID, L.SpellIDTooltip, Skins, 0, -6, false)
    SpellID:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.SpellID = checked
    end)

    local VignetteAlert = nCore:CreateCheckBox("VignetteAlert", LeftSide, L.VignetteAlert, L.VignetteAlertTooltip, SpellID, 0, -6, false)
    VignetteAlert:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nCoreDB.VignetteAlert = checked
    end)

    -- Right Side --

    local ReloadButton = CreateFrame("BUTTON", "ReloadButton", RightSide, "UIPanelButtonTemplate")
    ReloadButton:SetSize(100, 24)
    ReloadButton:SetPoint("BOTTOMRIGHT", RightSide, -10, 10)
    ReloadButton:SetText(RELOADUI)
    ReloadButton:SetScript("OnClick", function(self)
        ReloadUI()
    end)

    function Options:Refresh()
        AltBuy:SetChecked(nCoreDB.AltBuy)
        ArchaeologyHelper:SetChecked(nCoreDB.ArchaeologyHelper)
        AutoGreed:SetChecked(nCoreDB.AutoGreed)
        AutoQuest:SetChecked(nCoreDB.AutoQuest)
        Dressroom:SetChecked(nCoreDB.Dressroom)
        Durability:SetChecked(nCoreDB.Durability)
        ErrorFilter:SetChecked(nCoreDB.ErrorFilter)
        Fonts:SetChecked(nCoreDB.Fonts)
        ObjectiveTracker:SetChecked(nCoreDB.ObjectiveTracker)
        MapCoords:SetChecked(nCoreDB.MapCoords)
        MoveTalkingHeads:SetChecked(nCoreDB.MoveTalkingHeads)
        QuestTracker:SetChecked(nCoreDB.QuestTracker)
        Skins:SetChecked(nCoreDB.Skins)
        SpellID:SetChecked(nCoreDB.SpellID)
        VignetteAlert:SetChecked(nCoreDB.VignetteAlert)
    end

    Options:Refresh()
    Options:SetScript("OnShow", nil)
end)
