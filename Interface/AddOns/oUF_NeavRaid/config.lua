
local addon, ns = ...
local L = ns.L

ns.Config = {
    media = {
        statusbar = "Interface\\AddOns\\oUF_NeavRaid\\media\\statusbarTexture",             -- Health- and Powerbar texture
    },

    font = {
        fontSmall = "Interface\\AddOns\\oUF_NeavRaid\\media\\fontSmall.ttf",                -- Name font
        fontSmallSize = 11,

        fontBig = "Interface\\AddOns\\oUF_NeavRaid\\media\\fontThick.ttf",                  -- Health, dead/ghost/offline etc. font
        fontBigSize = 12,
    },
}


local floor = math.floor

local Options = CreateFrame("Frame", "nRaidOptions", InterfaceOptionsFramePanelContainer)
Options.name = "oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid"
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

    -- Left Side

    local GeneralOptions = Options:CreateFontString("GeneralOptions", "ARTWORK", "GameFontNormalLarge")
    GeneralOptions:SetPoint("TOPLEFT", LeftSide, 16, -16)
    GeneralOptions:SetText(L.GeneralOptions)

    local ShowSolo = ns.CreateCheckBox("ShowSolo", LeftSide, L.ShowSolo, nil, nil, GeneralOptions, 8, -8)
    ShowSolo:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.showSolo = self:GetChecked()
    end)

    local ShowParty = ns.CreateCheckBox("ShowParty", LeftSide, L.ShowParty, nil, nil, ShowSolo)
    ShowParty:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.showParty = self:GetChecked()
    end)

    local AssistFrame = ns.CreateCheckBox("AssistFrame", LeftSide, L.AssistFrame, nil, nil, ShowParty)
    AssistFrame:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.assistFrame = self:GetChecked()
    end)

    local SortByRole = ns.CreateCheckBox("SortByRole", LeftSide, L.SortByRole, L.SortByRoleTooltip, nil, AssistFrame)
    SortByRole:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.sortByRole = self:GetChecked()
    end)

    local ShowRoleIcons = ns.CreateCheckBox("ShowRoleIcons", LeftSide, L.ShowRoleIcons, nil, nil, SortByRole)
    ShowRoleIcons:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.showRoleIcons = self:GetChecked()
    end)

    local AnchorToControls = ns.CreateCheckBox("AnchorToControls", LeftSide, L.AnchorToControls, nil, nil, ShowRoleIcons)
    AnchorToControls:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.anchorToControls = self:GetChecked()
    end)

    local HorizontalHealthBars = ns.CreateCheckBox("HorizontalHealthBars", LeftSide, L.HorizontalHealthBars, nil, nil, AnchorToControls)
    HorizontalHealthBars:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.horizontalHealthBars = self:GetChecked()
    end)

    local ShowPowerBars = ns.CreateCheckBox("ShowPowerBars", LeftSide, L.ShowPowerBars, nil, nil, HorizontalHealthBars)
    ShowPowerBars:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.powerBars = self:GetChecked()

        if not self:GetChecked() then
            ManaPowerBarsOnly:Disable()
        else
            ManaPowerBarsOnly:Enable()
        end
    end)

    local ManaPowerBarsOnly = ns.CreateCheckBox("ManaPowerBarsOnly", LeftSide, L.ManaPowerBarsOnly, nil, nil, ShowPowerBars, 15, -8)
    ManaPowerBarsOnly:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.manaOnlyPowerBars = self:GetChecked()
    end)

    local HorizontalPowerBars = ns.CreateCheckBox("HorizontalPowerBars", LeftSide, L.HorizontalPowerBars, nil, nil, ManaPowerBarsOnly, -15, -8)
    HorizontalPowerBars:SetScript("OnClick", function(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        nRaidDB.horizontalPowerBars = self:GetChecked()
    end)

    -- Buff/Debuff Options

    local AuraOptions = Options:CreateFontString("AuraOptions", "ARTWORK", "GameFontNormalLarge")
    AuraOptions:SetPoint("TOPLEFT", HorizontalPowerBars, "BOTTOMLEFT", 0, -16)
    AuraOptions:SetText(L.AuraOptions)

    local indicatorSize = nRaidDB.indicatorSize or 7
    local IndicatorSizeSlider = ns.CreateSlider("IndicatorSizeSlider", LeftSide, L.IndicatorSizeSlider, nil, nRaidDB.indicatorSize, "%.0f", indicatorSize, 6, 20, 1, nil, AuraOptions, 8, -24)
    IndicatorSizeSlider:SetScript("OnValueChanged", function(self, value)
        value = floor(value)
        IndicatorSizeSlider.text:SetFormattedText("%.0f", value)
        nRaidDB.indicatorSize = value
    end)

    local debuffSize = nRaidDB.debuffSize or 22
    local DebuffSizeSlider = ns.CreateSlider("DebuffSizeSlider", LeftSide, L.DebuffSizeSlider, nil, nRaidDB.debuffSize, "%.0f", debuffSize, 10, 30, 1, nil, IndicatorSizeSlider)
    DebuffSizeSlider:SetScript("OnValueChanged", function(self, value)
        value = floor(value)
        DebuffSizeSlider.text:SetFormattedText("%.0f", value)
        nRaidDB.debuffSize = value
    end)

    -- Right Side

    -- Layout Options

    local LayoutOptions = Options:CreateFontString("LayoutOptions", "ARTWORK", "GameFontNormalLarge")
    LayoutOptions:SetPoint("TOPLEFT", RightSide, 16, -16)
    LayoutOptions:SetText(L.LayoutOptions)

    local OrientationTable = {
        { text = L.Vertical, value = "VERTICAL", },
        { text = L.Horizontal, value = "HORIZONTAL", },
    }

    local OrientationDropdown = ns.CreateDropdown(OrientationTable, "OrientationDropdown", L.Orientation, "orientation", RightSide, LayoutOptions)

    local InitialAnchorTable = {
        { text = L.TopLeft, value = "TOPLEFT", },
        { text = L.BottomLeft, value = "BOTTOMLEFT", },
        { text = L.TopRight, value = "TOPRIGHT", },
        { text = L.BottomRight, value = "BOTTOMRIGHT", },
    }

    local InitialAnchorDropdown = ns.CreateDropdown(InitialAnchorTable, "InitialAnchorDropdown", L.InitialAnchor, "initialAnchor", RightSide, _G["OrientationDropdown"])

    local nameLength = nRaidDB.nameLength or 4
    local NameLengthSlider = ns.CreateSlider("NameLengthSlider", RightSide, L.NameLengthSlider, nil, nRaidDB.nameLength, "%.0f", nameLength, 4, 20, 1, nil, _G["InitialAnchorDropdown"], 22, -42)
    NameLengthSlider:SetScript("OnValueChanged", function(self, value)
        value = floor(value)
        NameLengthSlider.text:SetFormattedText("%.0f", value)
        nRaidDB.nameLength = value
    end)

    local frameWidth = nRaidDB.frameWidth or 48
    local FrameWidthSlider = ns.CreateSlider("FrameWidthSlider", RightSide, L.FrameWidthSlider, nil, nRaidDB.frameWidth, "%.0f", frameWidth, 20, 150, 1, nil, NameLengthSlider)
    FrameWidthSlider:SetScript("OnValueChanged", function(self, value)
        value = floor(value)
        FrameWidthSlider.text:SetFormattedText("%.0f", value)
        nRaidDB.frameWidth = value
    end)

    local frameHeight = nRaidDB.frameHeight or 46
    local FrameHeightSlider = ns.CreateSlider("FrameHeightSlider", RightSide, L.FrameHeightSlider, nil, nRaidDB.frameHeight, "%.0f", frameHeight, 20, 100, 1, nil, FrameWidthSlider)
    FrameHeightSlider:SetScript("OnValueChanged", function(self, value)
        value = floor(value)
        FrameHeightSlider.text:SetFormattedText("%.0f", value)
        nRaidDB.frameHeight = value
    end)

    local frameOffset = nRaidDB.frameOffset or 7
    local FrameOffsetSlider = ns.CreateSlider("FrameOffsetSlider", RightSide, L.FrameOffsetSlider, nil, nRaidDB.frameOffset, "%.0f", frameOffset, 1, 15, 1, nil, FrameHeightSlider)
    FrameOffsetSlider:SetScript("OnValueChanged", function(self, value)
        value = floor(value)
        FrameOffsetSlider.text:SetFormattedText("%.0f", value)
        nRaidDB.frameOffset = value
    end)

    local frameScale = nRaidDB.frameScale or 1.2
    local FrameScaleSlider = ns.CreateSlider("FrameScaleSlider", RightSide, L.FrameScaleSlider, nil, nRaidDB.frameScale, "%.2f", frameScale, 0.50, 2, 0.10, nil, FrameOffsetSlider)
    FrameScaleSlider:SetScript("OnValueChanged", function(self, value)
        FrameScaleSlider.text:SetFormattedText("%.2f", value)
        nRaidDB.frameScale = value
    end)

    local ReloadButton = CreateFrame("BUTTON", "ReloadButton", RightSide, "UIPanelButtonTemplate")
    ReloadButton:SetSize(100, 24)
    ReloadButton:SetPoint("BOTTOMRIGHT", RightSide, -10, 10)
    ReloadButton:SetText(RELOADUI)
    ReloadButton:SetScript("OnClick", function(self)
        ReloadUI()
    end)

    function Options:Refresh()
        ShowSolo:SetChecked(nRaidDB.showSolo)
        ShowParty:SetChecked(nRaidDB.showParty)
        SortByRole:SetChecked(nRaidDB.sortByRole)
        ShowRoleIcons:SetChecked(nRaidDB.showRoleIcons)
        AnchorToControls:SetChecked(nRaidDB.anchorToControls)
        AssistFrame:SetChecked(nRaidDB.assistFrame)
        HorizontalHealthBars:SetChecked(nRaidDB.horizontalHealthBars)
        ShowPowerBars:SetChecked(nRaidDB.powerBars)
        ManaPowerBarsOnly:SetChecked(nRaidDB.manaOnlyPowerBars)
        HorizontalPowerBars:SetChecked(nRaidDB.horizontalPowerBars)

        IndicatorSizeSlider:SetValue(nRaidDB.indicatorSize)
        DebuffSizeSlider:SetValue(nRaidDB.debuffSize)

        NameLengthSlider:SetValue(nRaidDB.nameLength)
        FrameWidthSlider:SetValue(nRaidDB.frameWidth)
        FrameHeightSlider:SetValue(nRaidDB.frameHeight)
        FrameOffsetSlider:SetValue(nRaidDB.frameOffset)
        FrameScaleSlider:SetValue(nRaidDB.frameScale)
    end

    Options:Refresh()
    Options:SetScript("OnShow", nil)
end)
