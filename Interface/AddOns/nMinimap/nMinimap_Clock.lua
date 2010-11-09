
local function Minimap_FormatValue(i)
    if (i > 1024) then
        return format('%.2f MB', i/1024)
    else
        return format('%.2f KB', i)
    end
end

local function Minimap_ColorGradient(perc, ...)
	if (perc > 1) then
		local r, g, b = select(select('#', ...) - 2, ...) return r, g, b
	elseif (perc < 0) then
		local r, g, b = ... return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function Minimap_CreateDropDown()
    local calendar

    if (GetLocale() == 'enUS') then
        calendar = 'Calendar'
    elseif (GetLocale() == 'deDE') then
        calendar = 'Kalender'
    else
        calendar = 'Calendar'
    end
    
    local button = {}

    button[1] = {}
    button[1].text = CHARACTER_BUTTON
    button[1].func = function() ToggleCharacter('PaperDollFrame') end
    UIDropDownMenu_AddButton(button[1])
    
    button[2] = {}
    button[2].text = SPELLBOOK_ABILITIES_BUTTON
    button[2].func = function() ToggleFrame(SpellBookFrame) end
    UIDropDownMenu_AddButton(button[2])
    
    button[3] = {}
    button[3].text = TALENTS_BUTTON
    button[3].func = function() ToggleTalentFrame() end
    UIDropDownMenu_AddButton(button[3])
    
    button[4] = {}
    button[4].text = ACHIEVEMENT_BUTTON
    button[4].func = function() ToggleAchievementFrame() end  
    UIDropDownMenu_AddButton(button[4])
    
    button[5] = {}
    button[5].text = calendar
    button[5].func = function() ToggleCalendar() end
    UIDropDownMenu_AddButton(button[5])
    
    button[6] = {}
    button[6].text = QUESTLOG_BUTTON
    button[6].func = function() ToggleFrame(QuestLogFrame) end
    UIDropDownMenu_AddButton(button[6])
    
    button[7] = {}
    button[7].text = SOCIAL_BUTTON
    button[7].func = function() ToggleFriendsFrame() end
    UIDropDownMenu_AddButton(button[7])
    
    button[8] = {}
    button[8].text = PLAYER_V_PLAYER
    button[8].func = function() ToggleFrame(PVPParentFrame) end
    UIDropDownMenu_AddButton(button[8])
    
    button[9] = {}
    button[9].text = LFG_TITLE
    button[9].func = function() ToggleLFDParentFrame() end
    UIDropDownMenu_AddButton(button[9])
    
    button[10] = {}
    button[10].text = HELP_BUTTON
    button[10].func = function() ToggleHelpFrame() end
    UIDropDownMenu_AddButton(button[10])
end 

local classColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

TimeManagerClockTicker:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
TimeManagerClockTicker:SetShadowOffset(0, 0)
TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
TimeManagerClockTicker:SetPoint('TOPRIGHT', TimeManagerClockButton, 0, 0)

TimeManagerClockButton:GetRegions():Hide()
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetWidth(40)
TimeManagerClockButton:SetHeight(18)
TimeManagerClockButton:SetPoint('BOTTOM', Minimap, 0, 2)

TimeManagerAlarmFiredTexture:SetTexture(nil)
hooksecurefunc(TimeManagerAlarmFiredTexture, 'Show', function()
    TimeManagerClockTicker:SetTextColor(1, 0, 1)
end)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Hide', function()
    TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
end)

TimeManagerClockButton:SetScript("OnEnter", function(self)
	OnLoad = function(self) RequestRaidInfo() end,
	
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	-- GameTooltip:ClearAllPoints()
	-- GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 0)
	-- GameTooltip:ClearLines()
	
	local wgtime = GetWintergraspWaitTime() or nil
	inInstance, instanceType = IsInInstance()
	
	if not (instanceType == "none") then
		wgtime = "Unavailable"
	elseif wgtime == nil then
		wgtime = "In Progress"
	else
		local hour = tonumber(format("%01.f", floor(wgtime/3600)))
		local min = format(hour > 0 and "%02.f" or "%01.f", floor(wgtime/60 - (hour*60)))
		local sec = format("%02.f", floor(wgtime - hour*3600 - min *60))            
		wgtime = (hour > 0 and hour..":" or "")..min..":"..sec            
	end
	
	GameTooltip:AddDoubleLine("Time to Wintergrasp:", wgtime)
	GameTooltip:AddLine(" ")
	
	local oneraid
	for i = 1, GetNumSavedInstances() do
	local name,_,reset,difficulty,locked,extended,_,isRaid,maxPlayers = GetSavedInstanceInfo(i)
	
	if isRaid and (locked or extended) then
		local tr,tg,tb,diff
		if not oneraid then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Saved Raid(s)")
			oneraid = true
		end

		local function fmttime(sec,table)
		local table = table or {}
		local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
		local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
		local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
		return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
	end
	
	if extended then tr,tg,tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end
		if difficulty == 3 or difficulty == 4 then diff = "H" else diff = "N" end
			GameTooltip:AddDoubleLine(format("%s |cffaaaaaa(%s%s)", name, maxPlayers, diff), fmttime(reset), 1, 1, 1, tr, tg, tb)
		end
	end
	
	GameTooltip:Show()
end)
TimeManagerClockButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
TimeManagerClockButton:RegisterEvent('UPDATE_INSTANCE_INFO')

TimeManagerClockButton:SetScript('OnClick', function(self, button)
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, TimeManagerClockDropDown, self, -0, -0)
        GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    else
        if (self.alarmFiring) then
            TimeManager_TurnOffAlarm()
        end
        ToggleTimeManager()
    end
    GameTooltip:Hide() 
end)

TimeManagerClockDropDown = CreateFrame('Frame', 'TimeManagerClockDropDown', nil, 'UIDropDownMenuTemplate')
UIDropDownMenu_Initialize(TimeManagerClockDropDown, Minimap_CreateDropDown, 'MENU')
