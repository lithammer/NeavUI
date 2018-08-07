-- Forked from rRaidManager by Zork

local addon, ns = ...

local backdrop = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local TEX_WORLD_RAID_MARKERS = {
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:14:14|t",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:14:14|t",
}

local WORLD_RAID_MARKERS_TOOLTIP = {
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:14:14|t |cff0070ddBlue|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14|t |cff1eff00Green|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14|t |cffa335eePurple|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14|t |cffff2020Red|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t |cffffff00Yellow|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:14:14|t |cffff7f3fOrange|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:14:14|t |cffaaaaddSilver|r World Marker",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:14:14|t |cffffffffWhite|r World Marker",
}

local button, leftButton, previousButton

local manager = CreateFrame("Frame", addon.."Frame", UIParent, "SecureHandlerStateTemplate")

-----------------------------
-- Functions
-----------------------------

-- ButtonOnEnter
local function ButtonOnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:AddLine(self.tooltipText, 0.0, 1.0, 0.5, 1.0, 1.0, 1.0)
    GameTooltip:Show()
end

-- ButtonOnLeave
local function ButtonOnLeave(self)
    GameTooltip:Hide()
end

-- Manager:CreateButton
function manager:CreateButton(name, text, tooltipText)
    local button = CreateFrame("Button", name, self, "SecureActionButtonTemplate, UIPanelButtonTemplate")
    button.text = _G[button:GetName().."Text"]
    button.text:SetText(text)
    button.tooltipText = tooltipText
    button:SetWidth(30)
    button:SetHeight(30)
    button:SetScript("OnEnter", ButtonOnEnter)
    button:SetScript("OnLeave", ButtonOnLeave)
    button:RegisterForClicks("AnyUp")
    return button
end

-- Manager:CreateWorldMarkerButtons
function manager:CreateWorldMarkerButtons()
    for i=1, #TEX_WORLD_RAID_MARKERS do
        local text = TEX_WORLD_RAID_MARKERS[i]
        local tooltip = WORLD_RAID_MARKERS_TOOLTIP[i]

        local button = self:CreateButton(addon.."Button"..i, text, tooltip)
        button:SetAttribute("type", "macro")
        button:SetAttribute("macrotext", format("/wm %d", i))

        if not previousButton then
            button:SetPoint("TOPRIGHT", manager, -25, -10)
        else
            button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
        end

        local cancelButton = self:CreateButton(addon.."Button"..i.."Cancel", "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t", "Clear "..tooltip)
        cancelButton:SetAttribute("type", "macro")
        cancelButton:SetAttribute("macrotext", format("/cwm %d", i))
        cancelButton:SetPoint("RIGHT", button, "LEFT", 0, 0)
        previousButton = button
    end
end

local function DisableBlizzard()
    local isLoaded = LoadAddOn("Blizzard_CompactRaidFrames")

    if isLoaded then
        CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager:Hide()
        CompactRaidFrameContainer:UnregisterAllEvents()
        CompactRaidFrameContainer:Hide()
    end
end

---------------------------
-- INIT
---------------------------

-- Create manager frame.

manager:SetFrameStrata("DIALOG")
manager:SetSize(200, 390)
manager:SetPoint("TOPLEFT", -190, -180)
manager:SetAlpha(0.5)
manager:SetBackdrop(backdrop)
manager:SetBackdropColor(0.10, 0.10, 0.10, 0.90)
manager:SetBackdropBorderColor(0.70, 0.70, 0.70)
manager:RegisterEvent("PLAYER_LOGIN")
manager:SetScript("OnEvent", DisableBlizzard)
RegisterStateDriver(manager, "visibility", "[group] show; hide")

manager:CreateWorldMarkerButtons()

-- Clear all world markers button.
button = manager:CreateButton(addon.."ButtonWMCancel", "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t", REMOVE_WORLD_MARKERS)
button:SetScript("OnClick", ClearRaidMarker)
button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
previousButton = button

-- RoleCheck Button
button = manager:CreateButton(addon.."ButtonRoleCheck", "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:32:48:0:16|t", LFG_LIST_ROLE_CHECK)
button:SetScript("OnClick", InitiateRolePoll)
button:SetPoint("TOP", previousButton, "BOTTOM", 0, -10)
previousButton = button

-- Convert raid to party button.
leftButton = manager:CreateButton(addon.."ButtonRaidToParty", "|TInterface\\GroupFrame\\UI-Group-AssistantIcon:14:14:0:0|t", CONVERT_TO_PARTY)
leftButton:SetScript("OnClick", ConvertToParty)
leftButton:SetPoint("RIGHT", button, "LEFT", 0, 0)

-- Readycheck Button
button = manager:CreateButton(addon.."ButtonReady", "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t", READY_CHECK)
button:SetScript("OnClick", DoReadyCheck)
button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
previousButton = button

-- Convert party to raid button.
leftButton = manager:CreateButton(addon.."ButtonPartyToRaid", "|TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t", CONVERT_TO_RAID)
leftButton:SetScript("OnClick", ConvertToRaid)
leftButton:SetPoint("RIGHT", button, "LEFT", 0, 0)

-- Pull Button
button = manager:CreateButton(addon.."ButtonPullCounter", "|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14:0:0|t", VOICEMACRO_2_Hu_1)
button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
button:SetAttribute("type1", "macro")
button:SetAttribute("macrotext1", format("/pull %d", 10))
button:SetAttribute("type2", "macro")
button:SetAttribute("macrotext2", format("/pull %d", 0))
previousButton = button

-- Stopwatch Toggle
leftButton = manager:CreateButton(addon.."ButtonStopWatch", "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0|t", STOPWATCH_TITLE)
leftButton:SetScript("OnClick", Stopwatch_Toggle)
leftButton:SetPoint("RIGHT", button, "LEFT", 0, 0)

-- ToggleButton
ns.toggleButton = CreateFrame("BUTTON", addon.."ToggleButton", manager, "SecureHandlerClickTemplate")
ns.toggleButton:SetPoint("TOPRIGHT",-3,-3)
ns.toggleButton:SetPoint("BOTTOMRIGHT",-3,3)
ns.toggleButton:SetWidth(15)

local bg = ns.toggleButton:CreateTexture(nil, "BACKGROUND", nil, -8)
bg:SetAllPoints()
bg:SetColorTexture(1,1,1)
bg:SetAlpha(0.05)
ns.toggleButton.bg = bg
ns.toggleButton.tooltipText = "Toggle World Markers"
ns.toggleButton:SetScript("OnEnter", ButtonOnEnter)
ns.toggleButton:SetScript("OnLeave", ButtonOnLeave)

-- ToggleButton secure onclick.
ns.toggleButton:SetAttribute("_onclick", [=[
    local ref = self:GetFrameRef("manager")
    if not ref:GetAttribute("state") then
        ref:SetAttribute("state","closed")
    end
    local state = ref:GetAttribute("state")
    if state == "closed" then
        ref:SetAlpha(1)
        ref:SetWidth(275)
        ref:SetAttribute("state","open")
    else
        ref:SetAlpha(0.5)
        ref:SetWidth(200)
        ref:SetAttribute("state","closed")
    end
]=])

-- ToggleButton frame reference.
ns.toggleButton:SetFrameRef("manager", manager)
