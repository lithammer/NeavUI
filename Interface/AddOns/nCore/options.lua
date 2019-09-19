local addon, nCore = ...
local L = nCore.L

local pairs = pairs

local Options = CreateFrame("Frame", "nCoreOptions", InterfaceOptionsFramePanelContainer)
Options.controlTable = {}
Options.name = GetAddOnMetadata(addon, "Title")
Options.okay = function(self)
    for _, control in pairs(self.controls) do
        nCoreDB[control.var] = control:GetValue()
    end

    for _, control in pairs(self.controls) do
        if control.restart then
            ReloadUI()
        end
    end
end
Options.cancel = function(self)
    for _, control in pairs(self.controls) do
        if control.oldValue and control.oldValue ~= control:GetValue() then
            control:SetValue()
        end
    end
end
Options.default = function(self)
    for _, control in pairs(self.controls) do
        nCoreDB[control.var] = true
    end
    ReloadUI()
end
Options.refresh = function(self)
    for _, control in pairs(self.controls) do
        control:SetValue()
        control.oldValue = control:GetValue()
    end
end
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

    local UIControls = {
        {
            type = "Label",
            name = "OptionsLabel",
            parent = Options,
            label = L.OptionsLabel,
            relativeTo = LeftSide,
            relativePoint = "TOPLEFT",
            offsetX = 16,
            offsetY = -16,
        },
        {
            type = "CheckBox",
            name = "AltBuy",
            parent = Options,
            label = L.AltBuy,
            tooltip = L.AltBuyTooltip,
            var = "AltBuy",
            relativeTo = OptionsLabel,
            offsetY = -12,
        },
        {
            type = "CheckBox",
            name = "Dressroom",
            parent = Options,
            label = L.Dressroom,
            tooltip = L.DressroomTooltip,
            var = "Dressroom",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "Durability",
            parent = Options,
            label = L.Durability,
            tooltip = L.DurabilityTooltip,
            var = "Durability",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "ErrorFilter",
            parent = Options,
            label = L.ErrorFilter,
            tooltip = L.ErrorFilterTooltip,
            var = "ErrorFilter",
        },
        {
            type = "CheckBox",
            name = "Fonts",
            parent = Options,
            label = L.Fonts,
            tooltip = L.FontsTooltip,
            var = "Fonts",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "MapCoords",
            parent = Options,
            label = L.MapCoords,
            tooltip = L.MapCoordsTooltip,
            var = "MapCoords",
        },
        {
            type = "CheckBox",
            name = "Skins",
            parent = Options,
            label = L.Skins,
            tooltip = L.SkinsTooltip,
            var = "Skins",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "SpellID",
            parent = Options,
            label = L.SpellID,
            tooltip = L.SpellIDTooltip,
            var = "SpellID",
        },
    }

    for i, control in pairs(UIControls) do
        if control.type == "Label" then
            nCore:CreateLabel(control)
        elseif control.type == "CheckBox" then
            nCore:CreateCheckBox(control)
        end
    end

    function Options:Refresh()
        for _, control in pairs(self.controls) do
            control:SetValue(control)
            control.oldValue = control:GetValue()
        end
    end

    Options:Refresh()
    Options:SetScript("OnShow", nil)
end)
