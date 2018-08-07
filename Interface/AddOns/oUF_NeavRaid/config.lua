
local _, ns = ...

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

-----------------------------
-- UI Code
-----------------------------

OrientationTable = {
    {
        text = "Vertical",
        func = function()
            nRaidDB.orientation = "VERTICAL"
            UIDropDownMenu_SetSelectedValue(OrientationDropdown, OrientationDropdown:GetID())
        end,
        checked = function()
            if nRaidDB and nRaidDB.orientation == "VERTICAL" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = "Horizontal",
        func = function()
            nRaidDB.orientation = "HORIZONTAL"
            UIDropDownMenu_SetSelectedValue(OrientationDropdown, OrientationDropdown:GetID())
        end,
        checked = function()
            if nRaidDB and nRaidDB.orientation == "HORIZONTAL" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
}

local function OrientationDropdown_Initialize(self, level)
    local sourceTable = OrientationTable
    for index = 1, #sourceTable do
        local value = sourceTable[index]
        if value.text then
            value.index = index
            UIDropDownMenu_AddButton(value, level)
        end
    end
end

function OrientationDropdown_OnLoad(self)
    self.type = CONTROLTYPE_DROPDOWN
    _G[self:GetName().."Title"]:SetText("Orientation")

    UIDropDownMenu_SetWidth(self, 130)
    UIDropDownMenu_Initialize(self, OrientationDropdown_Initialize, "DROPDOWN")
end

InitialAnchorTable = {
    {
        text = "Top Left",
        func = function()
            nRaidDB.initialAnchor = "TOPLEFT"
            UIDropDownMenu_SetSelectedValue(InitialAnchorDropdown, InitialAnchorDropdown:GetID())
        end,
        checked = function()
            if nRaidDB and nRaidDB.initialAnchor == "TOPLEFT" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = "Bottom Left",
        func = function()
            nRaidDB.initialAnchor = "BOTTOMLEFT"
            UIDropDownMenu_SetSelectedValue(InitialAnchorDropdown, InitialAnchorDropdown:GetID())
        end,
        checked = function()
            if nRaidDB and nRaidDB.initialAnchor == "BOTTOMLEFT" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = "Top Right",
        func = function()
            nRaidDB.initialAnchor = "TOPRIGHT"
            UIDropDownMenu_SetSelectedValue(InitialAnchorDropdown, InitialAnchorDropdown:GetID())
        end,
        checked = function()
            if nRaidDB and nRaidDB.initialAnchor == "TOPRIGHT" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
    {
        text = "Bottom Right",
        func = function()
            nRaidDB.initialAnchor = "BOTTOMRIGHT"
            UIDropDownMenu_SetSelectedValue(InitialAnchorDropdown, InitialAnchorDropdown:GetID())
        end,
        checked = function()
            if nRaidDB and nRaidDB.initialAnchor == "BOTTOMRIGHT" then
                return true
            else
                return false
            end
        end,
        isNotRadio = true,
    },
}

local function InitialAnchorDropdown_Initialize(self, level)
    local sourceTable = InitialAnchorTable
    for index = 1, #sourceTable do
        local value = sourceTable[index]
        if value.text then
            value.index = index
            UIDropDownMenu_AddButton(value, level)
        end
    end
end

function InitialAnchorDropdown_OnLoad(self)
    self.type = CONTROLTYPE_DROPDOWN
    _G[self:GetName().."Title"]:SetText("Initial Anchor")

    UIDropDownMenu_SetWidth(self, 130)
    UIDropDownMenu_Initialize(self, InitialAnchorDropdown_Initialize, "DROPDOWN")
end

function NameLengthSlider_OnLoad(self)
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(4, 20)
    self:SetValue(4)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText("|cffffd200"..NAME.." Length:|r "..self:GetValue())
    self.textLow:SetText(self.minValue)
    self.textHigh:SetText(self.maxValue)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(1)
end

function NameLengthSlider_OnValueChanged(self)
    self.value = self:GetValue()
    self.text:SetText("|cffffd200"..NAME.." Length:|r "..self.value)
    if nRaidDB then nRaidDB.nameLength = tonumber(self.value) end
end

function FrameWidthSlider_OnLoad(self)
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(20, 150)
    self:SetValue(48)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText("|cffffd200"..COMPACT_UNIT_FRAME_PROFILE_FRAMEWIDTH..":|r "..self:GetValue())
    self.textLow:SetText(self.minValue)
    self.textHigh:SetText(self.maxValue)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(1)
end

function FrameWidthSlider_OnValueChanged(self)
    self.value = self:GetValue()
    self.text:SetText("|cffffd200"..COMPACT_UNIT_FRAME_PROFILE_FRAMEWIDTH..":|r "..self.value)
    if nRaidDB then nRaidDB.frameWidth = tonumber(self.value) end
end

function FrameHeightSlider_OnLoad(self)
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(20, 100)
    self:SetValue(46)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText("|cffffd200"..COMPACT_UNIT_FRAME_PROFILE_FRAMEHEIGHT..":|r "..self:GetValue())
    self.textLow:SetText(self.minValue)
    self.textHigh:SetText(self.maxValue)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(1)
end

function FrameHeightSlider_OnValueChanged(self)
    self.value = self:GetValue()
    self.text:SetText("|cffffd200"..COMPACT_UNIT_FRAME_PROFILE_FRAMEHEIGHT..":|r "..self.value)
    if nRaidDB then nRaidDB.frameHeight = tonumber(self.value) end
end

function FrameScaleSlider_OnLoad(self)
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(0.50, 2)
    self:SetValue(1.2)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText("|cffffd200"..UI_SCALE..":|r "..format("%.2f", self:GetValue()))
    self.textLow:SetText(self.minValue)
    self.textHigh:SetText(self.maxValue)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(0.10)
end

function FrameScaleSlider_OnValueChanged(self)
    self.value = self:GetValue()
    self.text:SetText("|cffffd200"..UI_SCALE..":|r "..format("%.2f",self.value))
    if nRaidDB then nRaidDB.frameScale = tonumber(self.value) end
end

function IndicatorSizeSlider_OnLoad(self)
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(6, 20)
    self:SetValue(7)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText("|cffffd200Indicator Size:|r "..self:GetValue())
    self.textLow:SetText(self.minValue)
    self.textHigh:SetText(self.maxValue)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(1)
end

function IndicatorSizeSlider_OnValueChanged(self)
    self.value = self:GetValue()
    self.text:SetText("|cffffd200Indicator Size:|r "..self:GetValue())
    if nRaidDB then nRaidDB.indicatorSize = tonumber(self.value) end
end

function DebuffSizeSlider_OnLoad(self)
    local name = self:GetName()

    self.type = CONTROLTYPE_SLIDER
    self.text = _G[name.."Text"]
    self.textLow = _G[name.."Low"]
    self.textHigh = _G[name.."High"]
    self:SetMinMaxValues(10, 30)
    self:SetValue(22)
    self.minValue, self.maxValue = self:GetMinMaxValues()
    self.text:SetText("|cffffd200Debuff Size:|r "..self:GetValue())
    self.textLow:SetText(self.minValue)
    self.textHigh:SetText(self.maxValue)
    self:SetObeyStepOnDrag(true)
    self:SetValueStep(1)
end

function DebuffSizeSlider_OnValueChanged(self)
    self.value = self:GetValue()
    self.text:SetText("|cffffd200Debuff Size:|r "..self.value)
    if nRaidDB then nRaidDB.debuffSize = tonumber(self.value) end
end
