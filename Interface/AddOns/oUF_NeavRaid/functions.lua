local addon, ns = ...

local GetTime = GetTime
local floor, fmod = floor, math.fmod
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
        location = {"TOPLEFT", ns.toggleButton, "TOPRIGHT", 5, 0}
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

function ns.CreateCheckBox(name, parent, label, tooltip, relativeTo, x, y, disableInCombat)
    local checkBox = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x, y)
    checkBox.Text:SetText(label)

    if tooltip then
        checkBox.tooltipText = tooltip
    end

    if disableInCombat then
        ns.LockInCombat(checkBox)
    end

    return checkBox
end

function ns.CreateSlider(name, parent, label, relativeTo, x, y, isCvar, data, fromatString, defaultValue, minValue, maxValue, step, disableInCombat)
    local value
    if isCvar then
        value = BlizzardOptionsPanel_GetCVarSafe(data)
    else
        value = data
    end

    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    slider:SetWidth(180)
    slider:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x, y)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.text = _G[name.."Text"]

    slider:SetMinMaxValues(minValue, maxValue)
    slider.minValue, slider.maxValue = slider:GetMinMaxValues()
    slider:SetValue(value)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)

    slider.text:SetFormattedText(fromatString, defaultValue)
    slider.text:ClearAllPoints()
    slider.text:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT")

    slider.textHigh:Hide()

    slider.textLow:ClearAllPoints()
    slider.textLow:SetPoint("BOTTOMLEFT", slider, "TOPLEFT")
    slider.textLow:SetPoint("BOTTOMRIGHT", slider.text, "BOTTOMLEFT", -4, 0)
    slider.textLow:SetText(label)
    slider.textLow:SetJustifyH("LEFT")

    if disableInCombat then
        ns.LockInCombat(slider)
    end

    return slider
end

function ns.CreateDropdown(optionsTable, name, desc, var, parent, relativeTo, x, y)
    --[[
    Example optionsTable

    local optionsTable = {
        { text = L.OptionOne, value = ValueOne, },
        { text = L.OptionTwo, value = ValueTwo, },
        { text = L.OptionThree, value = ValueThree, },
        { text = L.OptionFour, value = ValueFour, },
    }
    ]]

    local dropdown = CreateFrame("Button", name, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x, y)
    dropdown:EnableMouse(true)

    dropdown.title = dropdown:CreateFontString("$parentTitle", "BACKGROUND", "GameFontNormalSmall")
    dropdown.title:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 20, 5)
    dropdown.title:SetText(desc)

    dropdown.dummyFrame = CreateFrame("Frame", "$parentDummyFrame", dropdown)
    dropdown.dummyFrame:SetAllPoints(dropdown)

    local function Dropdown_OnClick(self)
        nRaidDB[var] = optionsTable[self.value].value
        UIDropDownMenu_SetText(dropdown, optionsTable[self.value].text)
        UIDropDownMenu_SetSelectedValue(dropdown, self.value)
    end

    local function Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()

        for i, filter in ipairs(optionsTable) do
            info.text = filter.text
            info.value = i
            info.value2 = filter.value
            info.func = Dropdown_OnClick
            if info.value2 == nRaidDB[var] then
                info.checked = 1
                UIDropDownMenu_SetText(self, filter.text)
            else
                info.checked = nil
            end
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_SetWidth(dropdown, 180)
    UIDropDownMenu_Initialize(dropdown, Initialize)
end
