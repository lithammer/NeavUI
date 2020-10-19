
local _, ns = ...
local L = ns.L

local Options = CreateFrame("Frame", "nRaidOptions", InterfaceOptionsFramePanelContainer)
Options.name = "oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid"
Options.okay = function(self)
    for _, control in pairs(self.controls) do
        nRaidDB[control.var] = control:GetValue()
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
            control:SetControl()
        end
    end
end
Options.default = function(self)
    for _, control in pairs(self.controls) do
        nRaidDB[control.var] = ns.GetDefaultValue(control.var)
    end
    ReloadUI()
end
Options.refresh = function(self)
    for _, control in pairs(self.controls) do
        control:SetControl()
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
            name = "GeneralOptions",
            parent = Options,
            label = L.GeneralOptions,
            relativeTo = LeftSide,
            relativePoint = "TOPLEFT",
            offsetX = 16,
            offsetY = -16,
        },
        {
            type = "CheckBox",
            name = "ShowSolo",
            parent = Options,
            label = L.ShowSolo,
            var = "showSolo",
            offsetX = 8,
            offsetY = -8,
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "ShowParty",
            parent = Options,
            label = L.ShowParty,
            var = "showParty",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "AssistFrame",
            parent = Options,
            label = L.AssistFrame,
            var = "assistFrame",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "SortByRole",
            parent = Options,
            label = L.SortByRole,
            var = "sortByRole",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "ShowRoleIcons",
            parent = Options,
            label = L.ShowRoleIcons,
            var = "showRoleIcons",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "AnchorToControls",
            parent = Options,
            label = L.AnchorToControls,
            var = "anchorToControls",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "HorizontalHealthBars",
            parent = Options,
            label = L.HorizontalHealthBars,
            var = "horizontalHealthBars",
            needsRestart = true,
        },
        {
            type = "CheckBox",
            name = "ShowPowerBars",
            parent = Options,
            label = L.ShowPowerBars,
            var = "powerBars",
            needsRestart = true,
            func = function(self)
                if not self:GetChecked() then
                    ManaPowerBarsOnly:Disable()
                else
                    ManaPowerBarsOnly:Enable()
                end
            end,
        },
        {
            type = "CheckBox",
            name = "ManaPowerBarsOnly",
            parent = Options,
            label = L.ManaPowerBarsOnly,
            var = "manaOnlyPowerBars",
            needsRestart = true,
            offsetX = 15,
        },
        {
            type = "CheckBox",
            name = "HorizontalPowerBars",
            parent = Options,
            label = L.HorizontalPowerBars,
            var = "horizontalPowerBars",
            needsRestart = true,
            offsetX = -15,
        },
        {
            type = "Label",
            name = "AuraOptions",
            parent = Options,
            label = L.AuraOptions,
            offsetY = -16,
        },
        {
            type = "Slider",
            name = "IndicatorSizeSlider",
            parent = Options,
            label = L.IndicatorSizeSlider,
            var = "indicatorSize",
            fromatString = "%.0f",
            minValue = 6,
            maxValue = 20,
            step = 1,
            needsRestart = true,
        },
        {
            type = "Slider",
            name = "DebuffSizeSlider",
            parent = Options,
            label = L.DebuffSizeSlider,
            var = "debuffSize",
            fromatString = "%.0f",
            minValue = 10,
            maxValue = 30,
            step = 1,
            needsRestart = true,
        },
        {
            type = "Label",
            name = "LayoutOptions",
            parent = Options,
            label = L.LayoutOptions,
            relativeTo = RightSide,
            relativePoint = "TOPLEFT",
            offsetX = 16,
            offsetY = -16,
        },
        {
            type = "Dropdown",
            name = "OrientationDropdown",
            parent = Options,
            label = L.Orientation,
            var = "orientation",
            needsRestart = true,
            optionsTable = {
                ["VERTICAL"] = L.Vertical,
                ["HORIZONTAL"] = L.Horizontal,
            },
        },
        {
            type = "Dropdown",
            name = "InitialAnchorDropdown",
            parent = Options,
            label = L.InitialAnchor,
            var = "initialAnchor",
            needsRestart = true,
            optionsTable = {
                ["TOPLEFT"] = L.TopLeft,
                ["TOPRIGHT"] = L.TopRight,
                ["BOTTOMRIGHT"] = L.BottomRight,
                ["BOTTOMLEFT"] = L.BottomLeft,
            },
        },
        {
            type = "SharedMedia",
            name = "StatusBarDropdown",
            parent = Options,
            label = L.StatusBarTexture,
            var = "texture",
            needsRestart = true,
            mediaType = "statusbar",
        },
        {
            type = "SharedMedia",
            name = "FontDropdown",
            parent = Options,
            label = L.Font,
            var = "font",
            needsRestart = true,
            mediaType = "font",
        },
        {
            type = "Slider",
            name = "FontSize",
            parent = Options,
            label = L.FontSize,
            var = "fontSize",
            fromatString = "%.0f",
            minValue = 6,
            maxValue = 20,
            step = 1,
            offsetX = 22,
            needsRestart = true,
        },
        {
            type = "Slider",
            name = "NameLengthSlider",
            parent = Options,
            label = L.NameLengthSlider,
            var = "nameLength",
            fromatString = "%.0f",
            minValue = 4,
            maxValue = 20,
            step = 1,
            needsRestart = true,
        },
        {
            type = "Slider",
            name = "FrameWidthSlider",
            parent = Options,
            label = L.FrameWidthSlider,
            var = "frameWidth",
            fromatString = "%.0f",
            minValue = 20,
            maxValue = 150,
            step = 1,
            needsRestart = true,
        },
        {
            type = "Slider",
            name = "FrameHeightSlider",
            parent = Options,
            label = L.FrameHeightSlider,
            var = "frameHeight",
            fromatString = "%.0f",
            minValue = 20,
            maxValue = 100,
            step = 1,
            needsRestart = true,
        },
        {
            type = "Slider",
            name = "FrameOffsetSlider",
            parent = Options,
            label = L.FrameOffsetSlider,
            var = "frameOffset",
            fromatString = "%.0f",
            minValue = 1,
            maxValue = 15,
            step = 1,
            needsRestart = true,
        },
        {
            type = "Slider",
            name = "FrameScaleSlider",
            parent = Options,
            label = L.FrameScaleSlider,
            var = "frameScale",
            fromatString = "%.2f",
            minValue = 0.50,
            maxValue = 2,
            step = 0.10,
            needsRestart = true,
        },
    }

    for _, control in pairs(UIControls) do
        if control.type == "Label" then
            ns.CreateLabel(control)
        elseif control.type == "CheckBox" then
            ns.CreateCheckBox(control)
        elseif control.type == "Slider" then
            ns.CreateSlider(control)
        elseif control.type == "Dropdown" then
            ns.CreateDropdown(control)
        elseif control.type == "SharedMedia" then
            ns.CreateSharedMeidaDropdown(control)
        end
    end

    function Options:Refresh()
        for _, control in pairs(self.controls) do
            if control.SetControl then
                control:SetControl()
            end
            control.oldValue = control:GetValue()
        end
    end

    Options:Refresh()
    Options:SetScript("OnShow", nil)
end)
