
local select = select
local format = string.format

local _, class = UnitClass('player')

local activezone = {r = 0.3, g = 1.0, b = 0}
local inactivezone = {r = 0.75, g = 0.75, b = 0.75}

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

local classHex = RGBToHex(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)

local f = CreateFrame('Frame', 'xFav', Minimap)
f:SetFrameStrata('BACKGROUND')
f:SetFrameLevel(Minimap:GetFrameLevel()-1)
f:SetHeight(30)
f:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
f:SetBackdropColor(0, 0, 0, 0.6)
f:SetAlpha(0.4)

CreateBorder(f, 11, 1, 1, 1)

local frameGuild = CreateFrame('Frame', 'xFavGuild', UIParent)
frameGuild:EnableMouse(true)
frameGuild:SetFrameLevel(3)
frameGuild:SetParent(xFav)
frameGuild:SetAlpha(0)

frameGuild:RegisterEvent('MODIFIER_STATE_CHANGED')
frameGuild:RegisterEvent('GUILD_ROSTER_SHOW')
frameGuild:RegisterEvent('PLAYER_ENTERING_WORLD')
frameGuild:RegisterEvent('GUILD_ROSTER_UPDATE')
frameGuild:RegisterEvent('GUILD_XP_UPDATE')
frameGuild:RegisterEvent('PLAYER_GUILD_UPDATE')
frameGuild:RegisterEvent('GUILD_MOTD')

frameGuild.Text = frameGuild:CreateFontString(nil, 'OVERLAY')
frameGuild.Text:SetFont('Fonts\\ARIALN.ttf', 12)
frameGuild.Text:SetShadowColor(0, 0, 0)
frameGuild.Text:SetShadowOffset(1, -1)
frameGuild:SetAllPoints(frameGuild.Text)
frameGuild.Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )

local frameFriends = CreateFrame('Frame', 'xFavFriend', UIParent)
frameFriends:EnableMouse(true)
frameFriends:SetFrameStrata('BACKGROUND')
frameFriends:SetFrameLevel(3)
frameFriends:SetParent(f)
frameFriends:SetAlpha(0)

frameFriends:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
frameFriends:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
frameFriends:RegisterEvent('BN_FRIEND_INFO_CHANGED')
frameFriends:RegisterEvent('BN_FRIEND_TOON_ONLINE')
frameFriends:RegisterEvent('BN_FRIEND_TOON_OFFLINE')
frameFriends:RegisterEvent('BN_TOON_NAME_UPDATED')
frameFriends:RegisterEvent('FRIENDLIST_UPDATE')
frameFriends:RegisterEvent('PLAYER_ENTERING_WORLD')

frameFriends.Text = frameFriends:CreateFontString(nil, 'OVERLAY')
frameFriends.Text:SetFont('Fonts\\ARIALN.ttf', 12)

if (nMinimap.positionDrawerBelow) then
    frameGuild.Text:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 18, -3)
	frameFriends.Text:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -18, -3)	
else
    frameGuild.Text:SetPoint('BOTTOMLEFT', Minimap, 'TOPLEFT', 18, 3)
	frameFriends.Text:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', -18, 3)
end

frameFriends.Text:SetShadowColor(0, 0, 0)
frameFriends.Text:SetShadowOffset(1, -1)
frameFriends:SetAllPoints(frameFriends.Text)
frameFriends.Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )

local function fadeOut()
    UIFrameFadeOut(xFavGuild, 0.05, xFavGuild:GetAlpha(), 0)
    UIFrameFadeOut(xFavFriend, 0.05, xFavFriend:GetAlpha(), 0)

	if (nMinimap.positionDrawerBelow) then
		f:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 10, 23)
		f:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -10, 23)
	else
		f:SetPoint('BOTTOMLEFT', Minimap, 'TOPLEFT', 10, -23)
		f:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', -10, -23)
	end
    
    xFav:SetAlpha(0.5)
    
    GameTooltip:Hide() 
end

local function fadeIn()
    UIFrameFadeIn(xFavGuild, 0.135, xFavGuild:GetAlpha(), 1)
    UIFrameFadeIn(xFavFriend, 0.135, xFavFriend:GetAlpha(), 1)

	if (nMinimap.positionDrawerBelow) then
		f:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 10, 10)
		f:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -10, 10)
	else
		f:SetPoint('BOTTOMLEFT', Minimap, 'TOPLEFT', 10, -10)
		f:SetPoint('BOTTOMRIGHT', Minimap, 'TOPRIGHT', -10, -10)
	end

    xFav:SetAlpha(1)
end

xFav:SetScript('OnEnter', function(self)
    fadeIn()
end)

xFav:SetScript('OnLeave', function(self)
    fadeOut()
end)

frameGuild:SetScript('OnLeave', function(self) 
    fadeOut()
end)

frameFriends:SetScript('OnLeave', function(self) 
    fadeOut()
end)

if nMinimap.showDrawerOnMinimapMouseOver then
	Minimap:SetScript('OnEnter', function(self)
		fadeIn()
	end)

	Minimap:SetScript('OnLeave', function(self)
		fadeOut()
	end)
end

fadeOut()

    ------------------------
    -- source TukUI - www.tukui.org
    ------------------------

local totalOnline = 0
local guildTable, guildXP = {}, {}

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
	totalOnline = 0
	wipe(guildTable)
    
	local name, rank, level, zone, note, officernote, connected, status, class
    
	for i = 1, GetNumGuildMembers() do
		name, rank, _, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
		guildTable[i] = { name, rank, level, zone, note, officernote, connected, status, class }
		if (connected) then 
            totalOnline = totalOnline + 1 
        end
	end
    
	table.sort(guildTable, function(a, b)
		if (a and b) then
			return a[1] < b[1]
		end
	end)
    
end

local function UpdateGuildXP()
	local currentXP, remainingXP, dailyXP, maxDailyXP = UnitGetGuildXP('player')
	local nextLevelXP = currentXP + remainingXP
	local percentTotal = tostring(math.ceil((currentXP / nextLevelXP) * 100))
	local percentDaily = tostring(math.ceil((dailyXP / maxDailyXP) * 100))
	
	guildXP[0] = { currentXP, nextLevelXP, percentTotal }
	guildXP[1] = { dailyXP, maxDailyXP, percentDaily }
end

local function GuildTip(self)
	if (not IsInGuild()) then
        return 
    end
    
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    
    fadeIn()
    
    local col = RGBToHex(1, 0, 1)
	local zonec, classc, levelc
	local online = totalOnline

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
		GameTooltip:AddLine(format('|cFFFFFFFF%s/%s (%s%%)', ShortValue(curr), ShortValue(max), math.ceil((curr / max) * 100)))
	end
    
    GameTooltip:AddLine(' ')
        
    GameTooltip:AddLine('Online')
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

frameGuild:SetScript('OnEvent', function(self, event, ...)	
	if (IsInGuild()) then
		BuildGuildTable()
        UpdateGuildXP() 
        
        frameGuild.Text:SetFormattedText(format('%s |cffffffff%d|r', GUILD, (totalOnline == 1 and 0) or totalOnline))
	else
		frameGuild.Text:SetText('No guild')
		frameGuild:SetScript('OnMouseDown', nil)
	end
    
    if (event == 'MODIFIER_STATE_CHANGED') then
        if (IsShiftKeyDown()) then
            if (self:IsMouseOver()) then
                GameTooltip:Hide()
                GuildTip(self)
            end
        else
             if (self:IsMouseOver()) then
                GameTooltip:Hide()
                GuildTip(self)
            end   
        end
    end
end)

frameGuild:SetScript('OnEnter', function(self)
    GuildTip(self)
end)

frameGuild:SetScript('OnMouseDown', function(self, button)
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

local function GetTableIndex(table, fieldIndex, value)
	for k, v in ipairs(table) do
		if v[fieldIndex] == value then return k end
	end
	return -1
end

local wowString = 'WoW'

local statusTable = { '[AFK]', '[DND]', '' }
local groupedTable = { '|cffaaaaaa*|r', '' } 

local friendTable, BNTable = {}, {}
local totalOnline, BNTotalOnline = 0, 0

local function BuildFriendTable(total)
	totalOnline = 0
	wipe(friendTable)
	local name, level, class, area, connected, status, note
	for i = 1, total do
		name, level, class, area, connected, status, note = GetFriendInfo(i)
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
		
		friendTable[i] = { name, level, class, area, connected, status, note }
		if connected then totalOnline = totalOnline + 1 end
	end
	table.sort(friendTable, function(a, b)
		if a[1] and b[1] then
			return a[1] < b[1]
		end
	end)
end

local function UpdateFriendTable(total)
	totalOnline = 0
	local name, level, class, area, connected, status, note
    
	for i = 1, #friendTable do
		name, level, class, area, connected, status, note = GetFriendInfo(i)
        
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

		if connected then
			friendTable[index][2] = level
			friendTable[index][3] = class
			friendTable[index][4] = area
			friendTable[index][6] = status
			friendTable[index][7] = note
			totalOnline = totalOnline + 1
		end
	end
end

local function BuildBNTable(total)
	BNTotalOnline = 0
	wipe(BNTable)

	for i = 1, total do
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
		local _, _, _, realmName, faction, race, class, _, zoneName, level = BNGetToonInfo(presenceID)
		
        for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if class == v then 
                class = k 
            end 
        end
		
		BNTable[i] = { presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
		
        if (isOnline) then 
            BNTotalOnline = BNTotalOnline + 1 
        end
	end
    
	table.sort(BNTable, function(a, b)
		if (a[2] and b[2]) then
			if a[2] == b[2] then return a[3] < b[3] end
			return a[2] < b[2]
		end
	end)
end

local function UpdateBNTable(total)
	BNTotalOnline = 0
    
	for i = 1, #BNTable do
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
		local _, _, _, realmName, faction, race, class, _, zoneName, level = BNGetToonInfo(presenceID)
        
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do 
            if class == v then 
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
			
			BNTotalOnline = BNTotalOnline + 1
		end
	end
end

frameFriends:SetScript('OnMouseDown', function(self, button) 
    if (button == 'LeftButton') then 
        ToggleFriendsFrame(1) 
    else
        GameTooltip:Hide()
	
        local menuCountWhispers = 0
        local menuCountInvites = 0
        local classc, levelc
        
        menuList[2].menuList = {}
        menuList[3].menuList = {}
        
        if (totalOnline > 0) then
            for i = 1, #friendTable do
                if (friendTable[i][5]) then
                    menuCountInvites = menuCountInvites + 1
                    menuCountWhispers = menuCountWhispers + 1

                    classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[friendTable[i][3]], GetQuestDifficultyColor(friendTable[i][2])
                    if classc == nil then 
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
        
        if (BNTotalOnline > 0) then
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
                    
                    if (BNTable[i][6] == wowString and BNTable[i][11] == GetRealmName() and playerFaction == BNTable[i][12]) then
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

frameFriends:SetScript('OnEvent', function(self, event)
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
    
    frameFriends.Text:SetFormattedText(format('%s |cffffffff%d|r', 'Friends', totalOnline + BNTotalOnline))
end)

frameFriends:SetScript('OnEnter', function(self)
    fadeIn()
    
	local totalonline = totalOnline + BNTotalOnline
	local totalfriends = #friendTable + #BNTable
	local zonec, classc, levelc, realmc, grouped
    
	if (totalonline > 0) then
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
		GameTooltip:ClearLines()
		GameTooltip:AddLine(format('Online: %s/%s', totalonline, totalfriends))
        
		if (totalOnline > 0) then
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
        
		if (BNTotalOnline > 0) then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine('Battle.NET')

			local status = 0
			for i = 1, #BNTable do
				if (BNTable[i][7]) then
					if BNTable[i][6] == wowString then
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
