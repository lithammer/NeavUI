
local _, nMinimap = ...
local cfg = nMinimap.Config

local select = select
local ceil = math.ceil
local modf = math.modf
local format = string.format
local sort = table.sort
local tinsert = tinsert

local playerName, _ = UnitName("player")
local playerRealm = GetRealmName()

local NUM_ADDONS_TO_DISPLAY = cfg.tab.numberOfAddons or GetNumAddOns()
local activezone = CreateColor(0.3, 1.0, 0.0, 1)
local inactivezone = CreateColor(0.75, 0.75, 0.75, 1)
local guildIcon = CreateTextureMarkup("Interface\\GossipFrame\\TabardGossipIcon", 16, 16, 16, 16, 0, 1, 0, 1, 0, 0)
local friendIcon = CreateAtlasMarkup("groupfinder-icon-friend", 18, 18)
local performanceIcon = CreateTextureMarkup("Interface\\AddOns\\nMinimap\\media\\texturePerformance", 32, 32, 10, 10, 0, 1, 0, 1, 0, 0)

local FriendListEntries = { }
local GuildListEntries = { }
local MemoryListEntries = { }
local AddonTable = { }

for i = 1, NUM_ADDONS_TO_DISPLAY do
    AddonTable[i] = { value = 0, name = "" }
end

local statusText = {
    [0] = "",
    [1] = CHAT_MSG_AFK,
    [2] = DEFAULT_DND_MESSAGE
}

local gradientColor = {
 [0] = CreateColor(0, 1, 0, 1),
 [1] = CreateColor(1, 1, 0, 1),
 [2] = CreateColor(1, 0, 0, 1)
}

local function ColorGradient(perc, colors)
    local num = #colors

    if perc >= 1 then
        return colors[num]
    elseif perc <= 0 then
        return colors[0]
    end

    local segment, relperc = modf(perc*num)

    local r1, g1, b1, r2, g2, b2
    r1, g1, b1 = colors[segment]:GetRGB()
    r2, g2, b2 = colors[segment+1]:GetRGB()

    if not r2 or not g2 or not b2 then
        return colors[0]
    else
        local r = r1 + (r2-r1)*relperc
        local g = g1 + (g2-g1)*relperc
        local b = b1 + (b2-b1)*relperc

        return CreateColor(r, g, b, 1)
    end
end

local function RGBGradient(num)
    num = num or 0
    local r, g, b = ColorGradient(num, gradientColor):GetRGB()
    return r, g, b
end

local function SetupChildFrames(self, template, numEntries, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
    local round = function (num) return math.floor(num + .5) end

    local scrollChild = self.scrollChild
    local entry, entryHeight, entries

    local parentName = self:GetName()
    local entryName = parentName and (parentName .. "Entry") or nil

    initialPoint = initialPoint or "TOPLEFT"
    initialRelative = initialRelative or "TOPLEFT"
    point = point or "TOPLEFT"
    relativePoint = relativePoint or "BOTTOMLEFT"
    offsetX = offsetX or 0
    offsetY = offsetY or 0

    if self.entries then
        entries = self.entries
        entryHeight = entries[1]:GetHeight()
    else
        entry = CreateFrame("FRAME", entryName and (entryName .. 1) or nil, scrollChild, template)
        entryHeight = entry:GetHeight()
        entry:SetPoint(initialPoint, scrollChild, initialRelative, initialOffsetX, initialOffsetY)
        entry:SetPoint("TOPRIGHT", scrollChild, initialOffsetX, initialOffsetY)
        entries = {}
        tinsert(entries, entry)
    end

    self.entryHeight = round(entryHeight) - offsetY

    local numEntries = numEntries or math.ceil(self:GetHeight() / self.entryHeight) + 1

    for i = #entries + 1, numEntries do
        entry = CreateFrame("FRAME", entryName and (entryName .. i) or nil, scrollChild, template)
        entry:SetPoint(point, entries[i-1], relativePoint, offsetX, offsetY)
        entry:SetPoint("TOPRIGHT", entries[i-1], "BOTTOMRIGHT", offsetX, offsetY)
        tinsert(entries, entry)
    end

    scrollChild:SetWidth(self:GetWidth())
    scrollChild:SetHeight(numEntries * self.entryHeight)
    self:SetVerticalScroll(0)
    self:UpdateScrollChildRect()

    self.entries = entries
end

local function CreateScrollFrame(name, width, height, numChild)
    local scrollFrame = CreateFrame("ScrollFrame",  name.."ScrollFrame", UIParent, "TooltipScrollFrameTemplate")
    scrollFrame:SetSize(width, height)
    scrollFrame:SetPoint("CENTER")
    scrollFrame:Hide()

    scrollFrame.scrollChild = CreateFrame("FRAME",  name.."ScrollChild")
    scrollFrame:SetScrollChild(scrollFrame.scrollChild)

    scrollFrame.scrollBar = _G[scrollFrame:GetName().."ScrollBar"]
    scrollFrame.scrollBar:SetAlpha(0)

    SetupChildFrames(scrollFrame, "DoubleTemplate", numChild)

    scrollFrame:SetScript("OnSizeChanged", function(self, width, height)
        if self:IsShown() then
            GameTooltip:SetMinimumWidth(width)
            GameTooltip:SetPadding(0, 0)
        end
    end)

    return scrollFrame
end

function nMinimapTab_OnLoad(self)
    if not cfg.tab.show then
        self:Hide()
        self:UnregisterAllEvents()
        self.Guild:UnregisterAllEvents()
        self.Friends:UnregisterAllEvents()
        self.Info:UnregisterAllEvents()
        return
    end

    self.lastUpdate = 0

    self:RegisterEvent("PLAYER_LOGIN")
    self:SetWidth(Minimap:GetWidth()-6)
    self:CreateBeautyBorder(11)
    nMinimapTab_HideTab()

    if cfg.tab.showBelowMinimap then
        self:ClearAllPoints()
        self:SetPoint("TOP", Minimap, "BOTTOM", 0, 2)
    end
end

function nMinimapTab_OnUpdate(self, elapsed)
    self.lastUpdate = self.lastUpdate + elapsed

    if self.lastUpdate > 5 then
        local _, _, _, lagWorld = GetNetStats()
        self.Info.Text:SetText(performanceIcon..lagWorld)
        self.lastUpdate = 0
    end
end

function nMinimapTab_ShowTab()
    if not cfg.tab.show then
        return
    end

    securecall("UIFrameFadeIn", nMinimapTab, 0.20, nMinimapTab:GetAlpha(), 1)
end

function nMinimapTab_HideTab()
    GameTooltip:Hide()

    if cfg.tab.showAlways or not cfg.tab.show then
        return
    end

    securecall("UIFrameFadeOut", nMinimapTab, 0.20, nMinimapTab:GetAlpha(), 0)
end

    --// Guild Frame

function nMinimap:UpdateGuildText(self)
    if IsInGuild() then
        local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers()
        self.Text:SetFormattedText("%s%d", guildIcon, onlineMembers)
    else
        self.Text:SetText(guildIcon.." -")
    end
end

local GuildScroll = CreateScrollFrame("Guild", 300, 340, 1000)

function nMinimap_UpdateGuildButton(entry)
    local scrollFrame = GuildScrollFrame

    local index = entry.index
    entry.id = GuildListEntries[index].id

    local height = scrollFrame.entryHeight
    local minWidth = scrollFrame:GetWidth()
    local zonec, classc, levelc

    local name, rank, _, level, _, zone, note, officernote, connected, status, class, _ = GetGuildRosterInfo(entry.id)

    if connected then
        zone = zone or UNKNOWN

        if GetRealZoneText() == zone then
            zonec = activezone
        else
            zonec = inactivezone
        end

        levelc = GetQuestDifficultyColor(level)
        classc = RAID_CLASS_COLORS[class]

        level = WrapTextInColorCode(level, CreateColor(levelc.r, levelc.g, levelc.b, 1):GenerateHexColor())
        name = WrapTextInColorCode(name, classc:GenerateHexColor())
        zone = WrapTextInColorCode(zone, zonec:GenerateHexColor())

        entry.LeftText:SetFormattedText("%s %s %s", level, name, statusText[status])
        entry.RightText:SetText(zone)

        minWidth = math.max(minWidth, entry.LeftText:GetWidth()+entry.RightText:GetWidth()+100)
        entry:Show()
    end

    scrollFrame:SetWidth(minWidth)
    scrollFrame.scrollChild:SetWidth(minWidth)

    return height
end

function nMinimap_UpdateGuildMembers()
    local scrollFrame = GuildScrollFrame
    local offset = scrollFrame.offset
    local entries = scrollFrame.entries
    local numEntries = #entries
    local numFrames = scrollFrame.numEntries

    sort(GuildListEntries, function(a, b)
        if a.name and b.name then
            return a.name < b.name
        end
    end)

    local usedHeight = 0

    for i = 1, numEntries do
        local frame = entries[i]
        local index = offset + i
        if frame then
            if index <= numFrames then
                frame.index = index
                local height = nMinimap_UpdateGuildButton(frame)
                frame:SetHeight(height)
                usedHeight = usedHeight + height
            else
                frame.index = nil
                frame:Hide()
            end
        end
    end

    usedHeight = math.min(usedHeight, 340)

    if not scrollFrame:IsVisible() then
        scrollFrame:SetHeight(usedHeight)
    else
        scrollFrame.isPendingHeight = true
        scrollFrame.pendingHeight = usedHeight
    end
    scrollFrame.scrollChild:SetHeight(usedHeight)
end

function nMinimapTab_Guild_UpdateScrollFrame()
    local scrollFrame = GuildScrollFrame

    local addButtonIndex = 0
    local totalButtonHeight = 0
    local function AddButtonInfo(id, name)
        addButtonIndex = addButtonIndex + 1
        if not GuildListEntries[addButtonIndex] then
            GuildListEntries[addButtonIndex] = { }
        end
        GuildListEntries[addButtonIndex].id = id
        GuildListEntries[addButtonIndex].name = name
        totalButtonHeight = totalButtonHeight + scrollFrame.entryHeight
    end

    for i = 1, GetNumGuildMembers() do
        local name, rank, _, level, _, zone, note, officernote, connected, status, class, _ = GetGuildRosterInfo(i)
        if connected and name ~= playerName.."-"..playerRealm then
            AddButtonInfo(i, name)
        end
    end

    scrollFrame.totalEntriesHeight = totalButtonHeight
    scrollFrame.numEntries = addButtonIndex

    nMinimap_UpdateGuildMembers()
end

function nMinimapTab_Guild_OnEvent(self, event, ...)
    if event == "PLAYER_GUILD_UPDATE" or event == "GUILD_ROSTER_UPDATE" then
        GuildRoster()
    end
    nMinimap:UpdateGuildText(self)
    nMinimapTab_Guild_UpdateScrollFrame()
end

function nMinimapTab_Guild_ShowTooltip(self)
    if not IsInGuild() then
        return
    end

    if IsShiftKeyDown() then
        nMinimap:UpdateGuildText(self)
        nMinimapTab_Guild_UpdateScrollFrame()
    end

    local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers()
    local zonec, classc, levelc

    GameTooltip:ClearLines()
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 2)
    GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
    GameTooltip:AddLine(GetGuildInfo("player"))
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(GUILD_MOTD)
    GameTooltip:AddLine(GetGuildRosterMOTD() or "-", 1, 1, 1, true)
    GameTooltip:AddLine(" ")

    if onlineMembers > 1 then
        GameTooltip_InsertFrame(GameTooltip, GuildScroll)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(GUILD_MEMBERS_ONLINE_COLON.." "..format("|cffffffff%d/%d|r", onlineMembers, totalMembers))
    GameTooltip:Show()
end

    -- // Friends Frame

local FriendsScroll = CreateScrollFrame("Friends", 300, 340, 200)

function nMinimap_UpdateFriendButton(entry)
    local scrollFrame = FriendsScrollFrame

    local index = entry.index
    entry.buttonType = FriendListEntries[index].buttonType
    entry.id = FriendListEntries[index].id
    local height = scrollFrame.entryHeight
    local minWidth = scrollFrame:GetWidth()
    local zonec, classc, levelc

    if entry.buttonType == FRIENDS_BUTTON_TYPE_BNET then
        local _, accountName, battleTag, _, characterName, bnetIDGameAccount, client, isOnline, _, isAFK, isDND = BNGetFriendInfo(FriendListEntries[index].id)

        if isOnline then
            local _, _, _, realmName, realmID, faction, race, class, _, zoneName, level, gameText = BNGetGameAccountInfo(bnetIDGameAccount)

            characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client)
            accountName = WrapTextInColorCode(accountName, FRIENDS_BNET_NAME_COLOR:GenerateHexColor())
            local clientIcon = BNet_GetClientEmbeddedTexture(client, 14)

            for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
                if class == v then
                    classc = RAID_CLASS_COLORS[k]
                    break
                end
            end

            if not classc then
                for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
                    if class == v then
                        classc = RAID_CLASS_COLORS[k]
                        break
                    end
                end
            end

            if client == BNET_CLIENT_WOW then
                if isAFK == true then
                    status = 1
                elseif isDND == true then
                    status = 2
                else
                    status = 0
                end

                level = tonumber(level)
                levelc = GetQuestDifficultyColor(level)

                level = WrapTextInColorCode(level, CreateColor(levelc.r, levelc.g, levelc.b, 1):GenerateHexColor())
                characterName = WrapTextInColorCode(characterName, classc:GenerateHexColor())

                entry.LeftText:SetFormattedText("%s (%s %s) %s", accountName, level, characterName, statusText[status])
                entry.RightText:SetText(clientIcon)
            else
                 entry.LeftText:SetFormattedText(accountName)
                 entry.RightText:SetText(clientIcon)
            end

            minWidth = math.max(minWidth, entry.LeftText:GetWidth()+entry.RightText:GetWidth()+100)
            entry:Show()
        end
    elseif entry.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        local info = C_FriendList.GetFriendInfoByIndex(FriendListEntries[index].id)

        if info then
            if info.connected then
                for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
                    if info.className == v then
                        classc = RAID_CLASS_COLORS[k]
                        break
                    end
                end

                if not classc then
                    for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
                        if info.className == v then
                            classc = RAID_CLASS_COLORS[k]
                            break
                        end
                    end
                end

                info.name = info.name or UNKNOWN

                local chatFlag = ""
                if info.dnd then
                    chatFlag = DEFAULT_DND_MESSAGE
                elseif info.afk then
                    chatFlag = CHAT_FLAG_AFK
                end

                if GetRealZoneText() == info.area then
                    zonec = activezone
                else
                    zonec = inactivezone
                end

                levelc = GetQuestDifficultyColor(info.level)

                info.level = WrapTextInColorCode(info.level, CreateColor(levelc.r, levelc.g, levelc.b, 1):GenerateHexColor())
                info.name = WrapTextInColorCode(info.name, classc:GenerateHexColor())
                info.area = WrapTextInColorCode(info.area, zonec:GenerateHexColor())

                entry.LeftText:SetFormattedText("%s %s %s", info.level, info.name, chatFlag)
                entry.RightText:SetFormattedText(info.area)

                minWidth = math.max(minWidth, entry.LeftText:GetWidth()+entry.RightText:GetWidth()+100)
                entry:Show()
            end
        end
    end

    scrollFrame.scrollChild:SetWidth(minWidth)
    scrollFrame:SetWidth(minWidth)

    return height
end

function nMinimap_UpdateFriends()
    local scrollFrame = FriendsScrollFrame
    local offset = 0
    local entries = scrollFrame.entries
    local numEntries = #entries
    local numFrames = scrollFrame.numEntries

    local usedHeight = 0

    for i = 1, numEntries do
        local frame = entries[i]
        local index = offset + i
        if index <= numFrames then
            frame.index = index
            local height = nMinimap_UpdateFriendButton(frame)
            frame:SetHeight(height)
            usedHeight = usedHeight + height
        else
            frame.index = nil
            frame:Hide()
        end
    end

    usedHeight = math.min(usedHeight, 340)

    if not scrollFrame:IsVisible() then
        scrollFrame:SetHeight(usedHeight)
    else
        scrollFrame.isPendingHeight = true
        scrollFrame.pendingHeight = usedHeight
    end
    scrollFrame.scrollChild:SetHeight(usedHeight)
end

function nMinimapTab_Friends_UpdateScrollFrame()
    local BNTotal, BNOnline = BNGetNumFriends()
    local WoWTotal, WoWOnline = C_FriendList.GetNumFriends(), C_FriendList.GetNumOnlineFriends()

    local scrollFrame = FriendsScrollFrame

    local addButtonIndex = 0
    local totalButtonHeight = 0
    local function AddButtonInfo(buttonType, id)
        addButtonIndex = addButtonIndex + 1
        if not FriendListEntries[addButtonIndex] then
            FriendListEntries[addButtonIndex] = { }
        end
        FriendListEntries[addButtonIndex].buttonType = buttonType
        FriendListEntries[addButtonIndex].id = id
        totalButtonHeight = totalButtonHeight + scrollFrame.entryHeight
    end

    -- Online Battlenet Friends
    for i = 1, BNOnline do
        AddButtonInfo(FRIENDS_BUTTON_TYPE_BNET, i)
    end
    -- Online WoW Friends
    for i = 1, WoWOnline do
        AddButtonInfo(FRIENDS_BUTTON_TYPE_WOW, i)
    end

    scrollFrame.totalEntriesHeight = totalButtonHeight
    scrollFrame.numEntries = addButtonIndex

    nMinimap_UpdateFriends()
end

function nMinimapTab_Friends_ShowTooltip(self)
    local BNTotal, BNOnline = BNGetNumFriends()
    local WoWTotal, WoWOnline = C_FriendList.GetNumFriends(), C_FriendList.GetNumOnlineFriends()
    local totalFriendsOnline = BNOnline + WoWOnline
    local totalfriends = BNTotal + WoWTotal
    local invites = BNGetNumFriendInvites()
    local zonec, classc, levelc, realmc

    if totalFriendsOnline == 0 then return end

    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 2)
    GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(format("%s: %s/%s", FRIENDS_LIST_ONLINE, totalFriendsOnline, totalfriends))

    if totalFriendsOnline > 0 then
        GameTooltip:AddLine(" ")
        GameTooltip_InsertFrame(GameTooltip, FriendsScroll)
    end

    if invites > 0 then
        GameTooltip:AddLine(format(BN_INLINE_TOAST_FRIEND_PENDING, invites))
    end
    GameTooltip:Show()
end

function nMinimapTab_Friends_OnEvent(self, event, ...)
    local BNTotal, BNOnline = BNGetNumFriends()
    local WoWTotal, WoWOnline = C_FriendList.GetNumFriends(), C_FriendList.GetNumOnlineFriends()
    local totalFriendsOnline = BNOnline + WoWOnline

    self.Text:SetFormattedText("%s%d", friendIcon, totalFriendsOnline)
    nMinimapTab_Friends_UpdateScrollFrame()
end

    --// Info Frame

local function AddonMem()
    local totalMem = 0

    if IsAltKeyDown() then
        collectgarbage()
    end

    for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
        AddonTable[i].value = 0
    end

    UpdateAddOnMemoryUsage()

    for i=1, GetNumAddOns(), 1 do
        local mem = GetAddOnMemoryUsage(i)
        totalMem = totalMem + mem
        for j = 1, NUM_ADDONS_TO_DISPLAY, 1 do
            if mem > AddonTable[j].value then
                for k = NUM_ADDONS_TO_DISPLAY, 1, -1 do
                    if k == j then
                        AddonTable[k].value = mem
                        AddonTable[k].name = GetAddOnInfo(i)
                        break
                    elseif k ~= 1 then
                        AddonTable[k].value = AddonTable[k-1].value
                        AddonTable[k].name = AddonTable[k-1].name
                    end
                end
                break
            end
        end
    end

    return totalMem
end

local function NumberOfActiveAddon()
    local active = 0
    for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
        if AddonTable[i].value ~= 0 then
            active = active+1
        end
    end
    return active
end

local MemoryScroll = CreateScrollFrame("Memory", 300, 340, NUM_ADDONS_TO_DISPLAY)

function nMinimap_UpdateMemoryButton(entry)
    local scrollFrame = MemoryScrollFrame

    local index = entry.index
    entry.id = MemoryListEntries[index].id
    local height = scrollFrame.entryHeight
    local minWidth = scrollFrame:GetWidth()

    local name = AddonTable[entry.id].name
    local value = AddonTable[entry.id].value

    if value ~= 0 then
        entry.LeftText:SetText(name)

        if value > 1000 then
            entry.RightText:SetFormattedText("%.2f MB", value/1000)
        else
            entry.RightText:SetFormattedText("%.0f KB", value)
        end
    end

    minWidth = math.max(minWidth, entry.LeftText:GetWidth()+entry.RightText:GetWidth()+75)

    scrollFrame.scrollChild:SetWidth(minWidth)
    scrollFrame:SetWidth(minWidth)

    return height
end

function nMinimap_UpdateMemory()
    local scrollFrame = MemoryScrollFrame
    local entries = scrollFrame.entries
    local numEntries = #entries
    local numFrames = scrollFrame.numEntries

    local usedHeight = 0

    for index = 1, numEntries do
        local frame = entries[index]
        if index <= numFrames then
            frame.index = index
            local height = nMinimap_UpdateMemoryButton(frame)
            frame:SetHeight(height)
            usedHeight = usedHeight + height
        else
            frame.index = nil
            frame:Hide()
        end
    end

    usedHeight = math.min(usedHeight, 340)

    scrollFrame:SetHeight(usedHeight)
    scrollFrame.scrollChild:SetHeight(usedHeight)
end

function nMinimapTab_Memory_UpdateScrollFrame()
    local scrollFrame = MemoryScrollFrame

    local addButtonIndex = 0
    local totalButtonHeight = 0
    local function AddButtonInfo(id)
        addButtonIndex = addButtonIndex + 1
        if not MemoryListEntries[addButtonIndex] then
            MemoryListEntries[addButtonIndex] = { }
        end
        MemoryListEntries[addButtonIndex].id = id
        totalButtonHeight = totalButtonHeight + scrollFrame.entryHeight
    end

    for i = 1, NumberOfActiveAddon() do
        AddButtonInfo(i)
    end

    scrollFrame.totalEntriesHeight = totalButtonHeight
    scrollFrame.numEntries = addButtonIndex

    nMinimap_UpdateMemory()
end

function nMinimapTab_Info_ShowTooltip(self)
    local totalMem = AddonMem()

    GameTooltip:ClearLines()
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 2)
    GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
    GameTooltip:AddLine(COMBAT_MISC_INFO)
    GameTooltip:AddLine(" ")

    -- Ping
    local _, _, lagHome, lagWorld = GetNetStats()

    GameTooltip:AddLine("|cffFFFFFF"..HOME..":|r "..format("%s ms", lagHome), RGBGradient(lagHome / 100))
    GameTooltip:AddLine("|cffFFFFFF"..WORLD..":|r "..format("%d ms", lagWorld), RGBGradient(lagWorld / 100))

    -- Protocol Types
    if GetCVarBool("useIPv6") then
        local ipTypes = { "IPv4", "IPv6" }
        local ipTypeHome, ipTypeWorld = GetNetIpTypes()
        local ip6 = format(MAINMENUBAR_PROTOCOLS_LABEL, ipTypes[ipTypeHome or 0] or UNKNOWN, ipTypes[ipTypeWorld or 0] or UNKNOWN)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(ip6, 1.0, 1.0, 1.0)
    end

    -- Bandwidth
    local bandwidth = GetAvailableBandwidth()
    if bandwidth > 0 then
        local bandwidthText = format(MAINMENUBAR_BANDWIDTH_LABEL, bandwidth)
        local downloadText = format(MAINMENUBAR_DOWNLOAD_PERCENT_LABEL, floor(GetDownloadedPercentage()*100+0.5))
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(bandwidthText, downloadText, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
    end

    -- Memory
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(format(TOTAL_MEM_MB_ABBR, totalMem/1000), 1.0, 1.0, 1.0)

    if NUM_ADDONS_TO_DISPLAY > 0 then
        nMinimapTab_Memory_UpdateScrollFrame()
        GameTooltip_InsertFrame(GameTooltip, MemoryScroll)
    end

    GameTooltip:Show()
end

    --// Minimap Scripts

if not cfg.tab.showAlways then
    Minimap:HookScript("OnEnter",function()
        nMinimapTab_ShowTab()
    end)

    Minimap:HookScript("OnLeave", function()
        nMinimapTab_HideTab()
    end)
end
