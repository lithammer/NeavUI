
local addon, ns = ...

local LSM = LibStub("LibSharedMedia-3.0")

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local sort = table.sort
local day, hour, minute = 86400, 3600, 60

ns.FormatTime = function(time)
    if time >= day then
        return format("%dd", floor(time/day + 0.5))
    elseif time>= hour then
        return format("%dh", floor(time/hour + 0.5))
    elseif time >= minute then
        return format("%dm", floor(time/minute + 0.5))
    end

    return format("%d", fmod(time, minute))
end

ns.MultiCheck = function(what, ...)
    for i = 1, select("#", ...) do
        if what == select(i, ...) then
            return true
        end
    end

    return false
end

ns.RegisterDefaultSetting = function(key, value)
    if nRaidDB == nil then
        nRaidDB = {}
    end
    if nRaidDB[key] == nil then
        nRaidDB[key] = value
    end
end

local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

ns.utf8sub = function(str)
  local startIndex = 1
  local startChar = 1
  local numChars = nRaidDB.nameLength

  while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + chsize(char)
      startChar = startChar - 1
  end

  local currentIndex = startIndex

  while numChars > 0 and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + chsize(char)
    numChars = numChars -1
  end
  return str:sub(startIndex, currentIndex - 1)
end

    -- Sorts a table by key.

ns.pairsByKeys = function(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0
    local iter = function ()
    i = i + 1
    if a[i] == nil then
        return nil
    else
        return a[i], t[a[i]]
    end
    end
    return iter
end

ns.CreateAnchor = function(name)
    local heightMulti, widthMulti, location
    if name == "Raid" then
        if nRaidDB.orientation == "VERTICAL" then
            widthMulti = 8
            heightMulti = 5
        else
            widthMulti = 5
            heightMulti = 8
        end
        location = {"TOPLEFT", _G["oUF_NeavRaidControlsFrame"], "TOPRIGHT", 5, 0}
    else
        widthMulti = 2
        heightMulti = 2
        location = {"TOPLEFT", UIParent, "CENTER", 150, 0}
    end

    local totalWidth = (nRaidDB.frameWidth*widthMulti+7*(widthMulti-1))*nRaidDB.frameScale
    local totalHeight = (nRaidDB.frameHeight*heightMulti+7*(heightMulti-1))*nRaidDB.frameScale

    local anchorFrame = CreateFrame("Frame", addon.."_"..name.."_Anchor", UIParent)
    anchorFrame:SetSize(totalWidth, totalHeight)
    anchorFrame:SetPoint(unpack(location))
    anchorFrame:SetFrameStrata("BACKGROUND")
    anchorFrame:SetMovable(true)
    anchorFrame:SetClampedToScreen(true)
    anchorFrame:SetUserPlaced(true)
    anchorFrame:SetBackdrop({bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background",})
    anchorFrame:CreateBeautyBorder(12)
    anchorFrame:EnableMouse(true)
    anchorFrame:RegisterForDrag("LeftButton")
    anchorFrame:Hide()

    anchorFrame.text = anchorFrame:CreateFontString(nil, "OVERLAY")
    anchorFrame.text:SetAllPoints(anchorFrame)
    anchorFrame.text:SetFont(STANDARD_TEXT_FONT, 13)
    anchorFrame.text:SetText(name.." Anchor")

    anchorFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    anchorFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    return anchorFrame
end

function ns.LockInCombat(frame)
    frame:SetScript("OnUpdate", function(self)
        if not InCombatLockdown() then
            self:Enable()
        else
            self:Disable()
        end
    end)
end

function ns.RegisterControl(control, parentFrame)
    if ( ( not parentFrame ) or ( not control ) ) then
        return
    end

    parentFrame.controls = parentFrame.controls or {}

    tinsert(parentFrame.controls, control)
end

function ns.GetDefaultValue(var)
    if var == "showSolo" then
        return false
    elseif var == "showParty" then
        return true
    elseif var == "assistFrame" then
        return false
    elseif var == "sortByRole" then
        return true
    elseif var == "showRoleIcons" then
        return true
    elseif var == "anchorToControls" then
        return false
    elseif var == "horizontalHealthBars" then
        return false
    elseif var == "powerBars" then
        return true
    elseif var == "manaOnlyPowerBars" then
        return true
    elseif var == "horizontalPowerBars" then
        return false
    elseif var == "orientation" then
        return "VERTICAL"
    elseif var == "initialAnchor" then
        return "TOPLEFT"
    elseif var == "font" then
        return 4
    elseif var == "fontSize" then
        return 4
    elseif var == "texture" then
        return 4
    elseif var == "nameLength" then
        return 4
    elseif var == "frameWidth" then
        return 48
    elseif var == "frameHeight" then
        return 46
    elseif var == "frameOffset" then
        return 7
    elseif var == "frameScale" then
        return 1.2
    elseif var == "indicatorSize" then
        return 7
    elseif var == "debuffSize" then
        return 22
    end
end

local prevControl

function ns.CreateLabel(cfg)
    --[[
        {
            type = "Label",
            name = "LabelName",
            parent = Options,
            label = L.LabelText,
            fontObject = "GameFontNormalLarge",
            relativeTo = LeftSide,
            relativePoint = "TOPLEFT",
            offsetX = 16,
            offsetY = -16,
        },
    --]]
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -16
    cfg.relativeTo = cfg.relativeTo or prevControl
    cfg.fontObject = cfg.fontObject or "GameFontNormalLarge"

    local label = cfg.parent:CreateFontString(cfg.name, "ARTWORK", cfg.fontObject)
    label:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    label:SetText(cfg.label)

    prevControl = label
    return label
end

function ns.CreateCheckBox(cfg)
    --[[
        {
            type = "CheckBox",
            name = "Test",
            parent = parent,
            label = L.TestLabel,
            tooltip = L.TestTooltip,
            isCvar = nil or True,
            var = "TestVar",
            needsRestart = nil or True,
            disableInCombat = nil or True,
            func = function(self)
                -- Do stuff here.
            end,
            initialPoint = "TOPLEFT",
            relativeTo = frame,
            relativePoint, "BOTTOMLEFT",
            offsetX = 0,
            offsetY = -6,
        },
    --]]
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -4
    cfg.relativeTo = cfg.relativeTo or prevControl

    local checkBox = CreateFrame("CheckButton", cfg.name, cfg.parent, "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    checkBox.Text:SetText(cfg.label)
    checkBox.GetValue = function(self) return checkBox:GetChecked() end
    checkBox.SetControl = function(self) checkBox:SetChecked(nRaidDB[cfg.var]) end
    checkBox.var = cfg.var
    checkBox.isCvar = cfg.isCvar

    if cfg.needsRestart then
        checkBox.restart = false
    end

    if cfg.tooltip then
        checkBox.tooltipText = cfg.tooltip
    end

    if cfg.disableInCombat then
        ns.LockInCombat(checkBox)
    end

    checkBox:SetScript("OnClick", function(self)
        local checked = self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        checkBox.value = checked
        if cfg.needsRestart then
            checkBox.restart = not checkBox.restart
        end
        if cfg.func then
            cfg.func(self)
        end
    end)

    ns.RegisterControl(checkBox, cfg.parent)
    prevControl = checkBox
    return checkBox
end

function ns.CreateSlider(cfg)
    --[[
        {
            type = "Slider",
            name = "Test",
            parent = parent,
            label = L.TestLabel,
            isCvar = True,
            var = "nRaidDBVariableGoesHere",
            fromatString = "%.2f",
            minValue = 0,
            maxValue = 1,
            step = .10,
            needsRestart = True,
            disableInCombat = True,
            func = function(self)
                -- Do stuff here.
            end,
            initialPoint = "TOPLEFT",
            relativeTo = frame,
            relativePoint, "BOTTOMLEFT",
            offsetX = 0,
            offsetY = -6,
        },
    --]]
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -26
    cfg.relativeTo = cfg.relativeTo or prevControl

    local value
    if cfg.isCvar then
        value = BlizzardOptionsPanel_GetCVarSafe(cfg.var)
    else
        value = nRaidDB[cfg.var]
    end

    local slider = CreateFrame("Slider", cfg.name, cfg.parent, "OptionsSliderTemplate")
    slider:SetWidth(180)
    slider:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    slider.GetValue = function(self) return slider.value end
    slider.SetControl = function(self) slider:SetValue(nRaidDB[cfg.var]) end
    slider.value = value
    slider.var = cfg.var
    slider.textLow = _G[cfg.name.."Low"]
    slider.textHigh = _G[cfg.name.."High"]
    slider.text = _G[cfg.name.."Text"]

    slider:SetMinMaxValues(cfg.minValue, cfg.maxValue)
    slider.minValue, slider.maxValue = slider:GetMinMaxValues()
    slider:SetValue(value)
    slider:SetValueStep(cfg.step)
    slider:SetObeyStepOnDrag(true)

    slider.text:SetFormattedText(cfg.fromatString, value)
    slider.text:ClearAllPoints()
    slider.text:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT")

    slider.textHigh:Hide()

    slider.textLow:ClearAllPoints()
    slider.textLow:SetPoint("BOTTOMLEFT", slider, "TOPLEFT")
    slider.textLow:SetPoint("BOTTOMRIGHT", slider.text, "BOTTOMLEFT", -4, 0)
    slider.textLow:SetText(cfg.label)
    slider.textLow:SetJustifyH("LEFT")

    if cfg.disableInCombat then
        ns.LockInCombat(slider)
    end

    slider:SetScript("OnValueChanged", function(self, value)
        slider.text:SetFormattedText(cfg.fromatString, value)
        slider.value = value

        if cfg.func then
            cfg.func(self)
        end

        if cfg.needsRestart then
            if slider.value ~= slider.oldValue then
                slider.restart = true
            else
                slider.restart = false
            end
        end
    end)

    ns.RegisterControl(slider, cfg.parent)
    prevControl = slider
    return slider
end

function ns.CreateDropdown(cfg)
    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -26
    cfg.relativeTo = cfg.relativeTo or prevControl

    --[[
        {
            type = "Dropdown",
            name = "TestDropdown",
            parent = Options,
            label = L.LocalizedName,
            var = "nRaidDBVariableGoesHere",
            needsRestart = true,
            func = function(self)
                -- Do stuff here. Only ran on click.
            end,
            optionsTable = {
                { text = L.TopLeft, value = 1, },
                { text = L.BottomLeft, value = 2, },
                { text = L.TopRight, value = 3, },
                { text = L.BottomRight, value = 4, },
            },
        },
    ]]

    local dropdown = CreateFrame("Button", cfg.name, cfg.parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    dropdown:EnableMouse(true)
    dropdown.GetValue = function(self) return UIDropDownMenu_GetSelectedValue(self) end
    dropdown.SetControl = function(self)
        self.value = nRaidDB[cfg.var]
        UIDropDownMenu_SetSelectedValue(dropdown, self.value)
        UIDropDownMenu_SetText(dropdown, cfg.optionsTable[self.value])
    end
    dropdown.var = cfg.var
    dropdown.value = nRaidDB[cfg.var]

    dropdown.title = dropdown:CreateFontString("$parentTitle", "BACKGROUND", "GameFontNormalSmall")
    dropdown.title:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 20, 5)
    dropdown.title:SetText(cfg.label)

    local function Dropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(dropdown, self.value)

        if cfg.func then
            cfg.func(dropdown)
        end

        if cfg.needsRestart then
            if self.value ~= dropdown.oldValue then
                dropdown.restart = true
            else
                dropdown.restart = false
            end
        end
    end

    local function Initialize(self, level)
        local selectedValue = UIDropDownMenu_GetSelectedValue(dropdown)
        local info = UIDropDownMenu_CreateInfo()

        for value, text in ns.pairsByKeys(cfg.optionsTable) do
            info.text = text
            info.value = value
            info.func = Dropdown_OnClick
            if info.value == selectedValue then
                info.checked = 1
                UIDropDownMenu_SetText(dropdown, text)
            else
                info.checked = nil
            end
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_SetWidth(dropdown, 180)
    UIDropDownMenu_SetSelectedValue(dropdown, nRaidDB[cfg.var])
    UIDropDownMenu_SetText(dropdown, cfg.optionsTable[nRaidDB[cfg.var]])
    UIDropDownMenu_Initialize(dropdown, Initialize)

    ns.RegisterControl(dropdown, cfg.parent)
    prevControl = dropdown
    return dropdown
end

local function GetSharedMediaName(media, value)
    for k, v in pairs(LSM:HashTable(media)) do
        if v == value then
            return k
        end
    end
end

function ns.CreateSharedMeidaDropdown(cfg)
    --[[
        {
            type = "SharedMedia",
            name = "SomethingDropdown"
            parent = Options,
            label = L.LocalizedName,
            var = "nRaidDBVariableGoesHere",
            func = function(self)
                -- Do stuff here. Only ran on click.
            end,
            needsRestart = true,
            mediaType = "font", SharedMedia types: background, border, font, statusbar, or sound.
            initialPoint = "TOPLEFT",
            relativeTo = frame,
            relativePoint, "BOTTOMLEFT",
            offsetX = 0,
            offsetY = -26,
        },
    ]]

    cfg.initialPoint = cfg.initialPoint or "TOPLEFT"
    cfg.relativePoint = cfg.relativePoint or "BOTTOMLEFT"
    cfg.offsetX = cfg.offsetX or 0
    cfg.offsetY = cfg.offsetY or -26
    cfg.relativeTo = cfg.relativeTo or prevControl

    local dropdown = CreateFrame("Button", cfg.name, cfg.parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint(cfg.initialPoint, cfg.relativeTo, cfg.relativePoint, cfg.offsetX, cfg.offsetY)
    dropdown:EnableMouse(true)
    dropdown.GetValue = function(self) return UIDropDownMenu_GetSelectedValue(self) end
    dropdown.SetControl = function(self)
        self.value = nRaidDB[cfg.var]
        UIDropDownMenu_SetSelectedValue(dropdown, self.value)
        UIDropDownMenu_SetText(dropdown, GetSharedMediaName(cfg.mediaType, nRaidDB[cfg.var]))
    end
    dropdown.var = cfg.var

    dropdown.title = dropdown:CreateFontString("$parentTitle", "BACKGROUND", "GameFontNormalSmall")
    dropdown.title:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 20, 5)
    dropdown.title:SetText(cfg.label)

    local function Dropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(dropdown, self.value)

        if cfg.func then
            cfg.func(dropdown)
        end

        if cfg.needsRestart then
            if self.value ~= dropdown.oldValue then
                dropdown.restart = true
            else
                dropdown.restart = false
            end
        end
    end

    local function Initialize(self, level)
        local selectedValue = UIDropDownMenu_GetSelectedValue(dropdown)
        local info = UIDropDownMenu_CreateInfo()

        for key, value in ns.pairsByKeys(LSM:HashTable(cfg.mediaType)) do
            info.text = key
            info.value = value
            info.func = Dropdown_OnClick
            if info.value == selectedValue then
                info.checked = 1
                UIDropDownMenu_SetText(dropdown, key)
            else
                info.checked = nil
            end
            if cfg.mediaType == "font" then
                local fontObject = CreateFont("NeavDropdownFont"..key)
                fontObject:SetFont(value, 13)
                info.fontObject = fontObject
            end
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_SetWidth(dropdown, 180)
    UIDropDownMenu_SetSelectedValue(dropdown, nRaidDB[cfg.var])
    UIDropDownMenu_SetText(dropdown, GetSharedMediaName(cfg.mediaType, nRaidDB[cfg.var]))

    UIDropDownMenu_Initialize(dropdown, Initialize)

    ns.RegisterControl(dropdown, cfg.parent)
    prevControl = dropdown
    return dropdown
end