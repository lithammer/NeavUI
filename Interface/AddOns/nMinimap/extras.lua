
local select = select
local tostring = tostring

local ceil = math.ceil
local sort = table.sort
local format = string.format

local _, class = UnitClass('player')

local f = CreateFrame('Frame', nil, Minimap)
f:SetFrameStrata('BACKGROUND')
f:SetFrameLevel(Minimap:GetFrameLevel() - 1)
f:SetHeight(30)
f:SetAlpha(nMinimap.drawerNoMouseoverAlpha)
f:CreateBeautyBorder(11)
f:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
f:SetBackdropColor(0, 0, 0, 0.6)

    -- guild info frame
    
f.Guild = CreateFrame('Button', nil, f)
f.Guild:EnableMouse(true)
f.Guild:SetFrameLevel(3)
f.Guild:SetAlpha(0)

f.Guild:RegisterEvent('MODIFIER_STATE_CHANGED')
f.Guild:RegisterEvent('GUILD_ROSTER_SHOW')
f.Guild:RegisterEvent('PLAYER_ENTERING_WORLD')
f.Guild:RegisterEvent('GUILD_ROSTER_UPDATE')
f.Guild:RegisterEvent('GUILD_XP_UPDATE')
f.Guild:RegisterEvent('PLAYER_GUILD_UPDATE')
f.Guild:RegisterEvent('GUILD_MOTD')

f.Guild.Text = f.Guild:CreateFontString(nil, 'OVERLAY')
f.Guild.Text:SetFont('Fonts\\ARIALN.ttf', 12)
f.Guild.Text:SetShadowColor(0, 0, 0)
f.Guild.Text:SetShadowOffset(1, -1)
f.Guild:SetAllPoints(f.Guild.Text)
f.Guild.Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )

    -- friend info frame

f.Friends = CreateFrame('Button', nil, f)
f.Friends:EnableMouse(true)
f.Friends:SetFrameStrata('BACKGROUND')
f.Friends:SetFrameLevel(3)
f.Friends:SetAlpha(0)

f.Friends:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
f.Friends:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
f.Friends:RegisterEvent('BN_FRIEND_INFO_CHANGED')
f.Friends:RegisterEvent('BN_FRIEND_TOON_ONLINE')
f.Friends:RegisterEvent('BN_FRIEND_TOON_OFFLINE')
f.Friends:RegisterEvent('BN_TOON_NAME_UPDATED')
f.Friends:RegisterEvent('FRIENDLIST_UPDATE')
f.Friends:RegisterEvent('PLAYER_ENTERING_WORLD')

f.Friends.Text = f.Friends:CreateFontString(nil, 'OVERLAY')
f.Friends.Text:SetFont('Fonts\\ARIALN.ttf', 12)
f.Friends.Text:SetShadowColor(0, 0, 0)
f.Friends.Text:SetShadowOffset(1, -1)
f.Friends:SetAllPoints(f.Friends.Text)
f.Friends.Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )

if (nMinimap.positionDrawerBelow) then
    f.Guild.Text:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 18, -3)
	f.Friends.Text:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -18, -3)	
else
    f.Guild.Text:SetPoint('BOTTOMLEFT', Minimap, 'TOPLEFT', 18, 3)
	f.Friends.Text:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', -18, 3)
end

    -- fade fade functions
    
local function fadeOut()
	if (not nMinimap.alwaysShowDrawer) then
		securecall('UIFrameFadeOut', f.Guild, 0.1, f.Guild:GetAlpha(), 0)
		securecall('UIFrameFadeOut', f.Friends, 0.1, f.Friends:GetAlpha(), 0)

		if (nMinimap.positionDrawerBelow) then
			f:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 10, 23)
			f:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -10, 23)
		else
			f:SetPoint('BOTTOMLEFT', Minimap, 'TOPLEFT', 10, -23)
			f:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', -10, -23)
		end
		
		f:SetAlpha(nMinimap.drawerNoMouseoverAlpha)
	end

    GameTooltip:Hide() 
end

local function fadeIn()
    securecall('UIFrameFadeIn', f.Guild, 0.135, f.Guild:GetAlpha(), nMinimap.drawerMouseoverAlpha)
    securecall('UIFrameFadeIn', f.Friends, 0.135, f.Friends:GetAlpha(), nMinimap.drawerMouseoverAlpha)

	if (nMinimap.positionDrawerBelow) then
		f:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 10, 10)
		f:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -10, 10)
	else
		f:SetPoint('BOTTOMLEFT', Minimap, 'TOPLEFT', 10, -10)
		f:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', -10, -10)
	end

    f:SetAlpha(nMinimap.drawerMouseoverAlpha)
end

f:SetScript('OnEnter', function()
    fadeIn()
end)

f:SetScript('OnLeave', function()
    fadeOut()
end)

f.Guild:SetScript('OnLeave', function() 
    fadeOut()
end)

f.Friends:SetScript('OnLeave', function() 
    fadeOut()
end)

if (nMinimap.showDrawerOnMinimapMouseOver) then
	Minimap:HookScript('OnEnter', function()
		fadeIn()
	end)

	Minimap:HookScript('OnLeave', function()
		fadeOut()
	end)
end

    -- make sure that the frame is faded out on login

if (nMinimap.alwaysShowDrawer) then
	fadeIn()
else
	fadeOut()
end

    -- some local function
    
local function ShortValue(v)
	if (v >= 1e6) then
		return ('%.1fm'):format(v / 1e6):gsub('%.?0+([km])$', '%1')
	elseif (v >= 1e3 or v <= -1e3) then
		return ('%.1fk'):format(v / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return v
	end
end

local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format('|cff%02x%02x%02x', r*255, g*255, b*255)
end

    -- source TukUI - www.tukui.org
    
local totalGuildOnline = 0
local totalFriendsOnline = 0
local totalBattleNetOnline = 0

local guildXP = {}
local guildTable = {}

local BNTable = {}
local friendTable  = {}

local statusTable = { '[AFK]', '[DND]', '' }
local groupedTable = { '|cffaaaaaa*|r', '' } 

local activezone = {r = 0.3, g = 1.0, b = 0}
local inactivezone = {r = 0.75, g = 0.75, b = 0.75}

local function GetTableIndex(table, fieldIndex, value)
	for k, v in ipairs(table) do
		if v[fieldIndex] == value then return k end
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
		local name, rank, _, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
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
	local currentXP, remainingXP, dailyXP, maxDailyXP = UnitGetGuildXP('player')
	local nextLevelXP = currentXP + remainingXP
	local percentTotal = tostring(ceil((currentXP / nextLevelXP) * 100))
	local percentDaily = tostring(ceil((dailyXP / maxDailyXP) * 100))
	
	guildXP[0] = { currentXP, nextLevelXP, percentTotal }
	guildXP[1] = { dailyXP, maxDailyXP, percentDaily }
end

local function GuildTip(self)
    fadeIn()
    
	if (not IsInGuild()) then
        return 
    end
    
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')

    local col = RGBToHex(1, 0, 1)
	local zonec, classc, levelc
	local online = totalGuildOnline

	GameTooltip:AddLine(GetGuildInfo('player')..' - '..LEVEL..' '..GetGuildLevel())

	GameTooltip:AddLine(' ')
	
    GameTooltip:AddLine(GUILD_MOTD, nil, nil, nil) 
    GameTooltip:AddLine(GetGuildRosterMOTD() or '-', 1, 1, 1, true) 
	
	GameTooltip:AddLine(' ')
    
	if (GetGuildLevel() ~= 25) then
		local currentXP, nextLevelXP, percentTotal = unpack(guildXP[0])
		local dailyXP, maxDailyXP, percentDaily = unpack(guildXP[1])
		GameTooltip:AddLine(format(col..GUILD_EXPERIENCE_CURRENT, '|r |cFFFFFFFF'..ShortValue(currentXP), ShortValue(nextLevelXP), percentTotal))
		GameTooltip:AddLine(format(col..GUILD_EXPERIENCE_DAILY, '|r |cFFFFFFFF'..ShortValue(dailyXP), ShortValue(maxDailyXP), percentDaily))
	end
	
	local _, _, standingID, min, max, curr = GetGuildFactionInfo()
    
	if (standingID ~= 4) then
		max = max - min
		curr = curr - min
		min = 0
        GameTooltip:AddLine(COMBAT_FACTION_CHANGE)
		GameTooltip:AddLine(format('|cFFFFFFFF%s/%s (%s%%)', ShortValue(curr), ShortValue(max), ceil((curr / max) * 100)))
	end
    
    GameTooltip:AddLine(' ')
        
    GameTooltip:AddLine(GUILD_ONLINE_LABEL)
    GameTooltip:AddLine(format('|cffffffff%d/%d|r', online, #guildTable))
    
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
                    local pii = RGBToHex(1, 0, 1)
                    GameTooltip:AddDoubleLine(format('|cff%02x%02x%02x%d|r %s '..pii..'(%s)|r', levelc.r*255, levelc.g*255, levelc.b*255, level, name, rank), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
					
                    if (note ~= '') then 
                        GameTooltip:AddLine(format("    |cffffffff'%s'|r", note), 1, 1, 0, 1) 
                    end
                    
					if (officernote ~= '') then 
                        local oCOL = RGBToHex(0.3, 1, 0.15)
                        GameTooltip:AddLine(format(oCOL.."    o: '%s'", officernote), 1, 0, 1, 1) 
                    end
				else
					GameTooltip:AddDoubleLine(format('|cff%02x%02x%02x%d|r %s %s', levelc.r*255, levelc.g*255, levelc.b*255, level, name, status), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
				end
            end
		end
	end
    
	GameTooltip:Show()
end

local function UpdateGuildText()
	if (IsInGuild()) then
		BuildGuildTable()
        UpdateGuildXP() 
        
        f.Guild.Text:SetFormattedText(format('%s |cffffffff%d|r', GUILD, (totalGuildOnline == 1 and 0) or totalGuildOnline))
        return
    else
		f.Guild.Text:SetText('No guild')
		f.Guild:SetScript('OnMouseDown', nil)
        return
	end
end

f.Guild:HookScript('OnEnter', function(self)
    GuildTip(self)
    UpdateGuildText()
end)

f.Guild:SetScript('OnEvent', function(self, event, ...)	
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
end)

f.Guild:RegisterForClicks('anyup')
f.Guild:SetScript('OnClick', function(self, button) 
    if (button == 'LeftButton') then      
        if (not GuildFrame and IsInGuild()) then 
            LoadAddOn('Blizzard_GuildUI') 
        end

        GuildFrame_Toggle() 
    else
        GameTooltip:Hide()
    
        UpdateGuildXP() 

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

		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
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

		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
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

        for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if class == v then 
                class = k 
            end 
        end

		BNTable[i] = { presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
		
        if (isOnline) then 
            totalBattleNetOnline = totalBattleNetOnline + 1 
        end
	end

	sort(BNTable, function(a, b)
		if (a[2] and b[2]) then
			if a[2] == b[2] then return a[3] < b[3] end
			return a[2] < b[2]
		end
	end)
end

local function UpdateBNTable(total)
	totalBattleNetOnline = 0

	for i = 1, #BNTable do
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
		local _, _, _, realmName, faction, _, race, class, _, zoneName, level = BNGetToonInfo(presenceID)

		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
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

f.Friends:RegisterForClicks('anyup')
f.Friends:SetScript('OnClick', function(self, button) 
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
                            text = format('|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r',levelc.r*255,levelc.g*255,levelc.b*255,BNTable[i][16],classc.r*255,classc.g*255,classc.b*255,BNTable[i][4]), 
                            arg1 = BNTable[i][4],
                            notCheckable=true, 
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

f.Friends:SetScript('OnEvent', function(self, event)
	if (event == 'BN_FRIEND_INFO_CHANGED' or 'BN_FRIEND_ACCOUNT_ONLINE' or 'BN_FRIEND_ACCOUNT_OFFLINE' or 'BN_TOON_NAME_UPDATED' or 'BN_FRIEND_TOON_ONLINE' or 'BN_FRIEND_TOON_OFFLINE' or 'PLAYER_ENTERING_WORLD') then
		local BNTotal = BNGetNumFriends()
        
		if (BNTotal == #BNTable) then
			UpdateBNTable(BNTotal)
		else
			BuildBNTable(BNTotal)
		end
	end
	
	if (event == 'FRIENDLIST_UPDATE' or 'PLAYER_ENTERING_WORLD') then
		local total = GetNumFriends()
        
		if (total == #friendTable) then
			UpdateFriendTable(total)
		else
			BuildFriendTable(total)
		end
	end
    
    f.Friends.Text:SetFormattedText(format('%s.. |cffffffff%d|r', FRIENDS:sub(1, 5), totalFriendsOnline + totalBattleNetOnline))
end)

f.Friends:HookScript('OnEnter', function(self)
    fadeIn()
    
	local totalFriendsOnline = totalFriendsOnline + totalBattleNetOnline
	local totalfriends = #friendTable + #BNTable
	local zonec, classc, levelc, realmc, grouped

	if (totalFriendsOnline > 0) then
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
		GameTooltip:ClearLines()
		GameTooltip:AddLine(FRIENDS_LIST_ONLINE..format(': %s/%s', totalFriendsOnline, totalfriends))
        
		if (totalFriendsOnline > 0) then
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
                    
					GameTooltip:AddDoubleLine(format('|cff%02x%02x%02x%d|r %s%s%s',levelc.r*255,levelc.g*255,levelc.b*255,friendTable[i][2],friendTable[i][1],groupedTable[grouped],' '..friendTable[i][6]),friendTable[i][4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
				end
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
	
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14]], GetQuestDifficultyColor(BNTable[i][16])
                        
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
end)
