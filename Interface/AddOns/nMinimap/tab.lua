
local _, nMinimap = ...
local cfg = nMinimap.Config

if (not cfg.tab.show) then
    return
end

local _, class = UnitClass('player')
local a = CreateFrame('Frame')
a:SetScript('OnEvent', function(self, event)
    if (event=='PLAYER_LOGIN') then
        if (not GuildFrame and IsInGuild()) then 
            LoadAddOn('Blizzard_GuildUI') 
        end
    end
end)
a:RegisterEvent('PLAYER_LOGIN')

local select = select
local tostring = tostring
local ceil = math.ceil
local modf = math.modf
local sort = table.sort
local format = string.format

local entry, total
local addonTable = {}

local totalGuildOnline = 0
local totalFriendsOnline = 0
local totalBattleNetOnline = 0

local guildXP = {}
local guildTable = {}

local BNTable = {}
local friendTable  = {}

local statusTable = { '<AFK>', '<DND>', '' }
local groupedTable = { '|cffaaaaaa*|r', '' } 

local activezone = {r = 0.3, g = 1.0, b = 0}
local inactivezone = {r = 0.75, g = 0.75, b = 0.75}

local guildIcon = '|TInterface\\GossipFrame\\TabardGossipIcon:13|t'
local friendIcon = '|TInterface\\FriendsFrame\\PlusManz-BattleNet:13|t'
local performanceIcon = '|TInterface\\AddOns\\nMinimap\\media\\texturePerformance:10|t'

local gradientColor = {
    0, 1, 0, 
    1, 1, 0, 
    1, 0, 0
}

local function ShortValue(v)
    if (v >= 1e6) then
        return ('%.1fm'):format(v / 1e6):gsub('%.?0+([km])$', '%1')
    elseif (v >= 1e3 or v <= -1e3) then
        return ('%.1fk'):format(v / 1e3):gsub('%.?0+([km])$', '%1')
    else
        return v
    end
end

local function FormatMemoryValue(i)
    if (i > 1024) then
        return format('%.2f |cffffffffMB|r', i/1024)
    else
        return format('%.2f |cffffffffkB|r', i)
    end
end

local function ColorGradient(perc, ...)
    if (perc > 1) then
        local r, g, b = select(select('#', ...) - 2, ...) return r, g, b
    elseif (perc < 0) then
        local r, g, b = ... return r, g, b
    end

    local num = select('#', ...) / 3

    local segment, relperc = modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function RGBGradient(num)
    local r, g, b = ColorGradient(num, unpack(gradientColor))
    return r, g, b
end

local function RGBToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return format('|cff%02x%02x%02x', r*255, g*255, b*255)
end

    -- Create the tab frame

local f = CreateFrame('Frame', nil, Minimap)
f:SetFrameStrata('BACKGROUND')
f:SetFrameLevel(Minimap:GetFrameLevel() - 1)
f:SetHeight(30)
f:SetAlpha(cfg.tab.alphaNoMouseover)
f:CreateBeautyBorder(11)
f:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
f:SetBackdropColor(0, 0, 0, 0.6)
f.parent = Minimap

    -- The left button

f.Left = CreateFrame('Button', nil, f)
f.Left:RegisterForClicks('anyup')
f.Left:RegisterEvent('PLAYER_ENTERING_WORLD')
f.Left:RegisterEvent('MODIFIER_STATE_CHANGED')
f.Left:RegisterEvent('PLAYER_GUILD_UPDATE')
f.Left:RegisterEvent('GUILD_ROSTER_SHOW')
f.Left:RegisterEvent('GUILD_ROSTER_UPDATE')
f.Left:RegisterEvent('GUILD_MOTD')
f.Left:RegisterEvent('GUILD_XP_UPDATE')
f.Left:RegisterEvent('PLAYER_GUILD_UPDATE')
f.Left:RegisterEvent('CHAT_MSG_SYSTEM')

f.Left.Text = f.Left:CreateFontString(nil, 'BACKGROUND')
f.Left.Text:SetFont('Fonts\\ARIALN.ttf', 12)
f.Left.Text:SetShadowColor(0, 0, 0)
f.Left.Text:SetShadowOffset(1, -1)
f.Left:SetAllPoints(f.Left.Text)

    -- The right button

f.Right = CreateFrame('Button', nil, f)
f.Right:RegisterEvent('MODIFIER_STATE_CHANGED')

f.Right.Text = f.Right:CreateFontString(nil, 'BACKGROUND')
f.Right.Text:SetFont('Fonts\\ARIALN.ttf', 12)
f.Right.Text:SetShadowColor(0, 0, 0)
f.Right.Text:SetShadowOffset(1, -1)
f.Right.Text:SetText(performanceIcon..select(3, GetNetStats()))
f.Right:SetAllPoints(f.Right.Text)

local last = 0
f.Right:SetScript('OnUpdate', function(_, elapsed)
    last = last + elapsed

    if (last > 5) then
        f.Right.Text:SetText(performanceIcon..select(3, GetNetStats()))
        last = 0
    end
end)

    -- The middle button

f.Center = CreateFrame('Button', nil, f)
f.Center:RegisterForClicks('anyup')
f.Center:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
f.Center:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
f.Center:RegisterEvent('BN_FRIEND_INFO_CHANGED')
f.Center:RegisterEvent('BN_FRIEND_TOON_ONLINE')
f.Center:RegisterEvent('BN_FRIEND_TOON_OFFLINE')
f.Center:RegisterEvent('BN_TOON_NAME_UPDATED')
f.Center:RegisterEvent('FRIENDLIST_UPDATE')
f.Center:RegisterEvent('PLAYER_ENTERING_WORLD')

f.Center.Text = f.Center:CreateFontString(nil, 'BACKGROUND')
f.Center.Text:SetFont('Fonts\\ARIALN.ttf', 12)
f.Center.Text:SetShadowColor(0, 0, 0)
f.Center.Text:SetShadowOffset(1, -1)
f.Center:SetAllPoints(f.Center.Text)
f.Center.Text:SetPoint('TOPLEFT', f.Left, 'TOPRIGHT', 12, 0)
f.Center.Text:SetPoint('TOPRIGHT', f.Right, 'TOPLEFT', -12, 0)

local function HideTab()
    GameTooltip:Hide() 

    if (cfg.tab.showAlways) then
        return
    end

    securecall('UIFrameFadeOut', f.Left, 0.15, f.Left:GetAlpha(), 0)
    securecall('UIFrameFadeOut', f.Right, 0.15, f.Right:GetAlpha(), 0)
    securecall('UIFrameFadeOut', f.Center, 0.15, f.Center:GetAlpha(), 0)
    securecall('UIFrameFadeOut', f, 0.15, f:GetAlpha(), cfg.tab.alphaNoMouseover)
end

local function ShowTab()
    securecall('UIFrameFadeIn', f.Left, 0.15, f.Left:GetAlpha(), 1)
    securecall('UIFrameFadeIn', f.Right, 0.15, f.Right:GetAlpha(), 1)
    securecall('UIFrameFadeIn', f.Center, 0.15, f.Center:GetAlpha(), 1)
    securecall('UIFrameFadeIn', f, 0.15, f:GetAlpha(), cfg.tab.alphaMouseover)
end

if (cfg.tab.showBelowMinimap) then
    f.Left.Text:SetPoint('BOTTOMLEFT', f, 6, 5)
    f.Right.Text:SetPoint('BOTTOMRIGHT', f, -6, 5)

    if (cfg.tab.showAlways) then
        ShowTab()

        f:SetPoint('LEFT', Minimap, 'BOTTOMLEFT', 10, -6)
        f:SetPoint('RIGHT', Minimap, 'BOTTOMRIGHT', -10, -6)
    else
        f:SetPoint('LEFT', Minimap, 'BOTTOMLEFT', 10, 9)
        f:SetPoint('RIGHT', Minimap, 'BOTTOMRIGHT', -10, 9)
    end
else
    f.Left.Text:SetPoint('TOPLEFT', f, 6, -5)
    f.Right.Text:SetPoint('TOPRIGHT', f, -6, -5)

    if (cfg.tab.showAlways) then
        ShowTab()

        f:SetPoint('LEFT', Minimap, 'TOPLEFT', 10, 6)
        f:SetPoint('RIGHT', Minimap, 'TOPRIGHT', -10, 6)
    else
        f:SetPoint('LEFT', Minimap, 'TOPLEFT', 10, -9)
        f:SetPoint('RIGHT', Minimap, 'TOPRIGHT', -10, -9)
    end
end

local function SlideFrame(self, t)
    self.pos = self.pos + t * self.speed
    self:SetPoint(self.point, self.parent, self.point, 0, self.pos or 0)

    if (self.pos * self.mod >= self.limit * self.mod) then
        self:SetPoint(self.point, self.parent, self.point, 0, self.limit or 0)
        self.pos = self.limit
        self:SetScript('OnUpdate', nil)

        if (self.finish_hide) then
            self:Hide()
        end

        if (self.finish_function) then
            self:finish_function()
        end
    end
end

if (cfg.tab.showBelowMinimap) then
    f.point = 'BOTTOM'
    f.pos = -6
else
    f.point = 'TOP'
    f.pos = 6
end

local function SlideUp()
    f.mod = 1
    f.limit = cfg.tab.showBelowMinimap and -6 or 21
    f.speed = 200
    f:SetScript('OnUpdate', SlideFrame)
end

local function SlideDown()
    f.mod = -1
    f.limit = cfg.tab.showBelowMinimap and -21 or 6
    f.speed = -200
    f:SetScript('OnUpdate', SlideFrame)
end

local function AddonMem()
    total = 0
    collectgarbage()
    UpdateAddOnMemoryUsage()
    wipe(addonTable)

    for i = 1, GetNumAddOns() do
        if (IsAddOnLoaded(i)) then
            local memory = GetAddOnMemoryUsage(i)
            total = total + memory

            entry = {
                name = select(2, GetAddOnInfo(i)), 
                memory = GetAddOnMemoryUsage(i)
            }

            tinsert(addonTable, entry)

            if (IsShiftKeyDown()) then
                sort(addonTable, function(a, b) 
                    return a.memory > b.memory 
                end)
            end
        end
    end
end

local function ShowMemoryTip(self)
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')

    AddonMem()

    GameTooltip:AddLine(COMBAT_MISC_INFO)    
    GameTooltip:AddLine(' ')

    local _, _, lagHome, lagWorld = GetNetStats()
    GameTooltip:AddLine('|cffffffffHome:|r '..format('%d ms', lagHome), RGBGradient(select(3, GetNetStats()) / 100))
    GameTooltip:AddLine('|cffffffff'..CHANNEL_CATEGORY_WORLD..':|r '..format('%d ms', lagWorld), RGBGradient(select(4, GetNetStats()) / 100))

    GameTooltip:AddLine(' ')

    for _, table in pairs(addonTable) do
        GameTooltip:AddDoubleLine(table.name, FormatMemoryValue(table.memory), 1, 1, 1, RGBGradient(table.memory / 800))
    end

    GameTooltip:AddLine(' ')
    GameTooltip:AddDoubleLine(ALL, FormatMemoryValue(total), nil, nil, nil, RGBGradient(total / (1024*10)))

    if (SHOW_NEWBIE_TIPS == '1') then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
    end

    GameTooltip:Show()
end

local function InfoOnEvent(self)
    if (IsShiftKeyDown()) then
        if (self:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowMemoryTip(self)
        end
    else
        if (self:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowMemoryTip(self)
        end
    end
end

    -- source TukUI - www.tukui.org

local function GetTableIndex(table, fieldIndex, value)
    for k, v in ipairs(table) do
        if (v[fieldIndex] == value) then 
            return k 
        end
    end

    return -1
end

local menuFrame = CreateFrame('Frame', 'ContactDropDownMenu', UIParent, 'UIDropDownMenuTemplate')
local menuList = {
    { 
        text = OPTIONS_MENU, 
        isTitle = true, 
        notCheckable = true
    },
    { 
        text = INVITE, 
        hasArrow = true, 
        notCheckable = true,
    },
    { 
        text = CHAT_MSG_WHISPER_INFORM, 
        hasArrow = true,  
        notCheckable = true,
    }
}

local function BuildGuildTable()
    totalGuildOnline = 0
    wipe(guildTable)

    for i = 1, GetNumGuildMembers() do
        local name, rank, _, level, _, zone, note, officernote, connected, status, class, reputationStanding = GetGuildRosterInfo(i)
        guildTable[i] = { 
            name, 
            rank, 
            level, 
            zone, 
            note, 
            officernote, 
            connected, 
            status, 
            class 
        }

        if (connected) then 
            totalGuildOnline = totalGuildOnline + 1 
        end
    end

    sort(guildTable, function(a, b)
        if (a and b) then
            return a[1] < b[1]
        end
    end)
end

local function UpdateGuildXP()
    local currentXP, remainingXP = UnitGetGuildXP('player')
    local nextLevelXP = currentXP + remainingXP
	if (nextLevelXP == 0) then
		nextLevelXP = 1
	end
    local percentTotal = tostring(ceil((currentXP / nextLevelXP) * 100))

    guildXP = {
        currentXP,
        nextLevelXP,
        percentTotal
    }
end

local function GuildTip(self)
    if (not IsInGuild()) then
        return 
    end

    local zonec, classc, levelc
    local online = totalGuildOnline

    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    GameTooltip:AddLine(GetGuildInfo('player')..' - '..LEVEL..' '..GetGuildLevel())
    GameTooltip:AddLine(' ')
    GameTooltip:AddLine(GUILD_MOTD, nil, nil, nil) 
    GameTooltip:AddLine(GetGuildRosterMOTD() or '-', 1, 1, 1, true) 
    GameTooltip:AddLine(' ')

    if (GetGuildLevel() ~= 25) then
        local currentXP, nextLevelXP, percentTotal = unpack(guildXP)
        GameTooltip:AddLine(format(GUILD_EXPERIENCE_CURRENT, '|r |cFFFFFFFF'..ShortValue(currentXP), ShortValue(nextLevelXP), percentTotal))
    end

    if (online > 1) then
        GameTooltip:AddLine(' ')

        for i = 1, #guildTable do
            if (online <= 1) then
                if (online > 1) then 
                    GameTooltip:AddLine(format('+ %d More...', online - modules.Guild.maxguild), nil, nil, nil) 
                end

                break
            end

            local name, rank, level, zone, note, officernote, connected, status, class = unpack(guildTable[i])
            if (connected and name ~= select(1, UnitName('player'))) then
                if (GetRealZoneText() == zone) then 
                    zonec = activezone 
                else 
                    zonec = inactivezone 
                end

                local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
                if (IsShiftKeyDown()) then
                    GameTooltip:AddDoubleLine(format('|cff%02x%02x%02x%d|r %s |r', levelc.r*255, levelc.g*255, levelc.b*255, level, name), RGBToHex(0.75, 0.75, 0.75)..rank, classc.r, classc.g, classc.b)

                    if (note ~= '') then 
                        GameTooltip:AddLine(format('        |cffffffff%s|r', note), 1, 1, 0, 1) 
                    end

                    if (officernote ~= '') then 
                        GameTooltip:AddLine(format(RGBToHex(0.3, 1, 0)..'        %s', officernote), 1, 0, 1, 1) 
                    end
                else
                    GameTooltip:AddDoubleLine(format('|cff%02x%02x%02x%d|r %s %s', levelc.r*255, levelc.g*255, levelc.b*255, level, name, status), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
                end
            end
        end
    end
    
    GameTooltip:AddLine(' ')
    GameTooltip:AddLine(GUILD_MEMBERS_ONLINE_COLON..' '..format('|cffffffff%d/%d|r', online, #guildTable))
    GameTooltip:Show()
end

local function UpdateGuildText()
    if (IsInGuild()) then
        BuildGuildTable()
        UpdateGuildXP() 

        f.Left.Text:SetFormattedText(format('%s|cffffffff%d|r', guildIcon, (totalGuildOnline == 1 and 0) or totalGuildOnline))
    else
        f.Left.Text:SetText(guildIcon..' -')
    end
end

local function GuildOnEvent(self, event)
    UpdateGuildText()

    if (event == 'MODIFIER_STATE_CHANGED') then
        if (IsShiftKeyDown()) then
            if (self:IsMouseOver() and not DropDownList1:IsShown()) then
                GameTooltip:Hide()
                GuildTip(self)
            end
        else
            if (self:IsMouseOver() and not DropDownList1:IsShown()) then
                GameTooltip:Hide()
                GuildTip(self)
            end   
        end
    end
end

f.Left:SetScript('OnClick', function(self, button) 
    if (not IsInGuild()) then 
        return
    end

    if (button == 'LeftButton') then
        GuildFrame_Toggle() 
    else
        GameTooltip:Hide()

        local classc, levelc, grouped
        local menuCountWhispers = 0
        local menuCountInvites = 0
        menuList[2].menuList = {}
        menuList[3].menuList = {}

        for i = 1, #guildTable do
            if (guildTable[i][7] and guildTable[i][1] ~= select(1, UnitName('player'))) then
                local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])
                if (UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1])) then
                    grouped = '|cffaaaaaa*|r'
                else
                    menuCountInvites = menuCountInvites +1
                    grouped = ''
                    menuList[2].menuList[menuCountInvites] = {
                        text = format('|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s', levelc.r*255, levelc.g*255, levelc.b*255, guildTable[i][3], classc.r*255, classc.g*255, classc.b*255, guildTable[i][1], ''), 
                        arg1 = guildTable[i][1], 
                        notCheckable = true, 
                        func = function(self, arg1)
                            menuFrame:Hide()
                            InviteUnit(arg1)
                        end
                    }
                end

                menuCountWhispers = menuCountWhispers + 1
                menuList[3].menuList[menuCountWhispers] = {
                    text = format('|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s', levelc.r*255, levelc.g*255, levelc.b*255, guildTable[i][3], classc.r*255, classc.g*255, classc.b*255, guildTable[i][1], grouped), 
                    arg1 = guildTable[i][1], 
                    notCheckable = true, 
                    func = function(self, arg1)
                        menuFrame:Hide()
                        SetItemRef('player:'..arg1, ('|Hplayer:%1$s|h[%1$s]|h'):format(arg1), 'LeftButton')
                    end
                }
            end
        end

        EasyMenu(menuList, menuFrame, self, 0, 0, 'MENU', 2)
    end
end)

local function BuildFriendTable(total)
    totalFriendsOnline = 0
    wipe(friendTable)

    for i = 1, total do
        local name, level, class, area, connected, status, note = GetFriendInfo(i)
        for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if (class == v) then 
                class = k 
            end 
        end

        friendTable[i] = { 
            name, 
            level, 
            class, 
            area, 
            connected, 
            status, 
            note 
        }

        if (connected) then 
            totalFriendsOnline = totalFriendsOnline + 1 
        end
    end

    sort(friendTable, function(a, b)
        if a[1] and b[1] then
            return a[1] < b[1]
        end
    end)
end

local function UpdateFriendTable(total)
    totalFriendsOnline = 0

    for i = 1, #friendTable do
        local name, level, class, area, connected, status, note = GetFriendInfo(i)
        for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if class == v then 
                class = k 
            end 
        end

        index = GetTableIndex(friendTable, 1, name)
        if (index == -1) then
            BuildFriendTable(total)
            break
        end

        friendTable[index][5] = connected

        if (connected) then
            friendTable[index][2] = level
            friendTable[index][3] = class
            friendTable[index][4] = area
            friendTable[index][6] = status
            friendTable[index][7] = note
            totalFriendsOnline = totalFriendsOnline + 1
        end
    end
end

local function BuildBNTable(total)
    totalBattleNetOnline = 0
    wipe(BNTable)

    for i = 1, total do
        local presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
        local _, _, _, realmName, faction, _, race, class, _, zoneName, level = BNGetToonInfo(presenceID)

        for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if (class == v) then 
                class = k 
            end 
        end

        BNTable[i] = { 
            presenceID, 
            givenName, 
            surname, 
            toonName, 
            toonID, 
            client, 
            isOnline, 
            isAFK, 
            isDND, 
            noteText, 
            realmName, 
            faction, 
            race, 
            class, 
            zoneName, 
            level 
        }

        if (isOnline) then 
            totalBattleNetOnline = totalBattleNetOnline + 1 
        end
    end

    sort(BNTable, function(a, b)
        if (a[2] and b[2]) then
            if (a[2] == b[2]) then 
                return a[3] < b[3] 
            end

            return a[2] < b[2]
        end
    end)
end

local function UpdateBNTable(total)
    totalBattleNetOnline = 0

    for i = 1, #BNTable do
        local presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
        local _, _, _, realmName, faction, _, race, class, _, zoneName, level = BNGetToonInfo(presenceID)

        for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if (class == v) then 
                class = k 
            end 
        end

        index = GetTableIndex(BNTable, 1, presenceID)
        if (index == -1) then
            BuildBNTable(total)
            return
        end

        BNTable[index][7] = isOnline
        if (isOnline) then
            BNTable[index][2] = givenName
            BNTable[index][3] = surname
            BNTable[index][4] = toonName
            BNTable[index][5] = toonID
            BNTable[index][6] = client
            BNTable[index][8] = isAFK
            BNTable[index][9] = isDND
            BNTable[index][10] = noteText
            BNTable[index][11] = realmName
            BNTable[index][12] = faction
            BNTable[index][13] = race
            BNTable[index][14] = class
            BNTable[index][15] = zoneName
            BNTable[index][16] = level
            totalBattleNetOnline = totalBattleNetOnline + 1
        end
    end
end

f.Center:SetScript('OnClick', function(self, button) 
    if (button == 'LeftButton') then 
        ToggleFriendsFrame(1) 
    else
        GameTooltip:Hide()

        local menuCountWhispers = 0
        local menuCountInvites = 0
        local classc, levelc

        menuList[2].menuList = {}
        menuList[3].menuList = {}

        if (totalFriendsOnline > 0) then
            for i = 1, #friendTable do
                if (friendTable[i][5]) then
                    menuCountInvites = menuCountInvites + 1
                    menuCountWhispers = menuCountWhispers + 1

                    classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[friendTable[i][3]], GetQuestDifficultyColor(friendTable[i][2])
                    if (classc == nil) then 
                        classc = GetQuestDifficultyColor(friendTable[i][2]) 
                    end

                    menuList[2].menuList[menuCountInvites] = {
                        text = format('|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r', levelc.r*255, levelc.g*255, levelc.b*255, friendTable[i][2], classc.r*255, classc.g*255, classc.b*255, friendTable[i][1]), 
                        arg1 = friendTable[i][1], 
                        notCheckable = true, 
                        func = function(self, arg1)
                            menuFrame:Hide()
                            InviteUnit(arg1)
                        end
                    }

                    menuList[3].menuList[menuCountWhispers] = {
                        text = format('|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r', levelc.r*255, levelc.g*255, levelc.b*255, friendTable[i][2], classc.r*255, classc.g*255, classc.b*255, friendTable[i][1]), 
                        arg1 = friendTable[i][1], 
                        notCheckable = true, 
                        func = function(self, arg1)
                            menuFrame:Hide() 
                            SetItemRef('player:'..arg1, ('|Hplayer:%1$s|h[%1$s]|h'):format(arg1), 'LeftButton')
                        end
                    }
                end
            end
        end

        if (totalBattleNetOnline > 0) then
            local realID, playerFaction, grouped
            for i = 1, #BNTable do
                if (BNTable[i][7]) then
                    realID = (BATTLENET_NAME_FORMAT):format(BNTable[i][2], BNTable[i][3])
                    menuCountWhispers = menuCountWhispers + 1
                    menuList[3].menuList[menuCountWhispers] = {
                        text = realID, 
                        arg1 = realID, 
                        notCheckable = true, 
                        func = function(self, arg1)
                            menuFrame:Hide() 
                            SetItemRef('player:'..arg1, ('|Hplayer:%1$s|h[%1$s]|h'):format(arg1), 'LeftButton')
                        end
                    }

                    if (select(1, UnitFactionGroup('player')) == 'Horde') then 
                        playerFaction = 0 
                    else 
                        playerFaction = 1 
                    end

                    if (BNTable[i][6] == 'WoW' and BNTable[i][11] == GetRealmName() and playerFaction == BNTable[i][12]) then
                        classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14]], GetQuestDifficultyColor(BNTable[i][16])
                        if (classc == nil) then 
                            classc = GetQuestDifficultyColor(BNTable[i][16]) 
                        end

                        if (UnitInParty(BNTable[i][4]) or UnitInRaid(BNTable[i][4])) then 
                            grouped = 1 
                        else 
                            grouped = 2 
                        end

                        menuCountInvites = menuCountInvites + 1
                        menuList[2].menuList[menuCountInvites] = {
                            text = format('|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r', levelc.r*255, levelc.g*255, levelc.b*255, BNTable[i][16], classc.r*255, classc.g*255, classc.b*255, BNTable[i][4]), 
                            arg1 = BNTable[i][4],
                            notCheckable = true, 
                            func = function(self, arg1)
                                menuFrame:Hide()
                                InviteUnit(arg1)
                            end
                        }
                    end
                end
            end
        end

        EasyMenu(menuList, menuFrame, self, 0, 0, 'MENU', 2)
    end 
end)

local function FriendsOnEvent(self, event)
    if (event:match('BN_FRIEND') or  event == 'PLAYER_ENTERING_WORLD') then
        local BNTotal = BNGetNumFriends()
        if (BNTotal == #BNTable) then
            UpdateBNTable(BNTotal)
        else
            BuildBNTable(BNTotal)
        end
    end

    if (event == 'FRIENDLIST_UPDATE' or event == 'PLAYER_ENTERING_WORLD') then
        local total = GetNumFriends()
        if (total == #friendTable) then
            UpdateFriendTable(total)
        else
            BuildFriendTable(total)
        end
    end

    f.Center.Text:SetFormattedText(format('%s|cffffffff%d|r', friendIcon, totalFriendsOnline + totalBattleNetOnline))
end

local function FriendsOnEnter(self)
    local totalFriendsOnline = totalFriendsOnline + totalBattleNetOnline
    local totalfriends = #friendTable + #BNTable
    local zonec, classc, levelc, realmc, grouped

    if (totalFriendsOnline > 0) then
        GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
        GameTooltip:ClearLines()
        GameTooltip:AddLine(FRIENDS_LIST_ONLINE..format(': %s/%s', totalFriendsOnline, totalfriends))
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine('World of Warcraft')

        for i = 1, #friendTable do
            if (friendTable[i][5]) then
                if (GetRealZoneText() == friendTable[i][4]) then 
                    zonec = activezone 
                else 
                    zonec = inactivezone 
                end

                classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[friendTable[i][3]], GetQuestDifficultyColor(friendTable[i][2])
                if (classc == nil) then 
                    classc = GetQuestDifficultyColor(friendTable[i][2]) 
                end

                if (UnitInParty(friendTable[i][1]) or UnitInRaid(friendTable[i][1])) then 
                    grouped = 1 
                else 
                    grouped = 2 
                end

                GameTooltip:AddDoubleLine(format('|cff%02x%02x%02x%d|r %s%s%s', levelc.r*255, levelc.g*255, levelc.b*255, friendTable[i][2], friendTable[i][1], groupedTable[grouped],' '..friendTable[i][6]), friendTable[i][4], classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
            end
        end

        if (totalBattleNetOnline > 0) then
            GameTooltip:AddLine(' ')
            GameTooltip:AddLine('Battle.NET')

            local status = 0
            for i = 1, #BNTable do
                if (BNTable[i][7]) then
                    if (BNTable[i][6] == 'WoW') then
                        if (BNTable[i][8] == true) then 
                            status = 1 
                        elseif (BNTable[i][9] == true) then 
                            status = 2 
                        else 
                            status = 3 
                        end

                        classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14]]
                        levelc = GetQuestDifficultyColor(BNTable[i][16])
                        if (classc == nil) then 
                            classc = GetQuestDifficultyColor(BNTable[i][16]) 
                        end

                        if (UnitInParty(BNTable[i][4]) or UnitInRaid(BNTable[i][4])) then 
                            grouped = 1 
                        else 
                            grouped = 2 
                        end

                        GameTooltip:AddDoubleLine(format('%s (|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r', BNTable[i][6],levelc.r*255,levelc.g*255,levelc.b*255,BNTable[i][16],classc.r*255,classc.g*255,classc.b*255, BNTable[i][4], groupedTable[grouped], 255, 0, 0, statusTable[status]),BNTable[i][2]..' '..BNTable[i][3],238,238,238,238,238,238)
                    else
                        GameTooltip:AddDoubleLine('|cffeeeeee'..BNTable[i][6]..' ('..BNTable[i][4]..')|r', '|cffeeeeee'..BNTable[i][2]..' '..BNTable[i][3]..'|r')
                    end
                end
            end
        end

        GameTooltip:Show()
    else 
        return
    end
end

    -- the 'OnEnter' functions

f:SetScript('OnEnter', function()
    if (not cfg.tab.showAlways) then
        ShowTab()
        if (cfg.tab.showBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

f.Center:SetScript('OnEnter', function(self)
    FriendsOnEnter(self)

    if (not cfg.tab.showAlways) then
        ShowTab()
        if (cfg.tab.showBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

f.Right:SetScript('OnEnter', function(self)
    ShowMemoryTip(self)

    if (not cfg.tab.showAlways) then
        ShowTab()
        if (cfg.tab.showBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

f.Left:SetScript('OnEnter', function(self)
    GuildTip(self)
    UpdateGuildText()

    if (not cfg.tab.showAlways) then
        ShowTab()
        if (cfg.tab.showBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end
end)

    -- the 'OnLeave' functions
    
for _, leaveFrame in pairs({
    f,
    f.Right,    
    f.Left,
    f.Center,
}) do
    leaveFrame:SetScript('OnLeave', function()
        HideTab()

        if (not cfg.tab.showAlways) then
            if (cfg.tab.showBelowMinimap) then
                SlideUp()
            else
                SlideDown()
            end
        end
    end)
end

    -- the Minimap scripts

if (not cfg.tab.showAlways) then
    Minimap:HookScript('OnEnter',function()
        ShowTab()

        if (cfg.tab.showBelowMinimap) then
            SlideDown()
        else
            SlideUp()
        end
    end)
    
    Minimap:HookScript('OnLeave', function()
        HideTab()

        if (cfg.tab.showBelowMinimap) then
            SlideUp()
        else
            SlideDown()
        end
    end)
end

    -- the 'OnEvent' functions

f.Center:SetScript('OnEvent', FriendsOnEvent)
f.Left:SetScript('OnEvent', GuildOnEvent)
f.Right:SetScript('OnEvent', InfoOnEvent)
