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

function NeavRaid_GetLabelText(value)
    if value == "VERTICAL" then
        return "Vertical"
    elseif value == "HORIZONTAL" then
        return "Horizontal"
    elseif value == "TOPLEFT" then
        return "Top Left"
    elseif value == "TOPRIGHT" then
        return "Top Right"
    elseif value == "BOTTOMLEFT" then
        return "Bottom Left"
    elseif value == "BOTTOMRIGHT" then
        return "Bottom Right"
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
