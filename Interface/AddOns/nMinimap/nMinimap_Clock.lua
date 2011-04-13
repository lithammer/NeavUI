
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
    button[8].func = function() ToggleFrame(PVPFrame) end
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

TimeManagerClockButton:SetScript('OnEnter', function(self)
    collectgarbage()
    UpdateAddOnMemoryUsage()
       
    local entry
        
    local total = 0
    local addons = {}
        
    local gradient = {0, 1, 0, 1, 1, 0, 1, 0, 0}
        
    for index = 1, GetNumAddOns() do
        if (IsAddOnLoaded(index)) then
            local memory = GetAddOnMemoryUsage(index)
            total = total + memory
            
            entry = {
                name = GetAddOnInfo(index), 
                memory = memory
            }
            
        tinsert(addons, entry)
        
        table.sort(addons, function(a, b) 
            return a.memory > b.memory 
        end)
            
        end
    end
        
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    GameTooltip:AddLine(date('%A, %d %B'), 1, 1, 1)
    GameTooltip:AddLine(' ') 
        
    local r, g, b = Minimap_ColorGradient((GetFramerate() / 40), 1, 0, 0, 1, 1, 0, 0, 1, 0)
    GameTooltip:AddDoubleLine('Framerate:', format('%.0f fps', GetFramerate()), classColor.r, classColor.g, classColor.b, r, g, b)
    
    local _, _, lagHome, lagWorld = GetNetStats();
    local r, g, b = Minimap_ColorGradient((select(3, GetNetStats()) / 200), unpack(gradient))
    GameTooltip:AddLine(' ')
    GameTooltip:AddDoubleLine('Home Latency:', format('%d ms', lagHome), classColor.r, classColor.g, classColor.b, r, g, b)
    GameTooltip:AddDoubleLine('World Latency:', format('%d ms', lagWorld), classColor.r, classColor.g, classColor.b, r, g, b)
    GameTooltip:AddLine(' ')

    for _, content in pairs(addons) do
        local r, g, b = Minimap_ColorGradient((content.memory / 800), unpack(gradient))
        GameTooltip:AddDoubleLine(content.name, Minimap_FormatValue(content.memory), 1, 1, 1, r, g, b)
    end
        
    local r, g, b = Minimap_ColorGradient((entry.memory / 800), unpack(gradient)) 
    GameTooltip:AddLine(' ')
    GameTooltip:AddDoubleLine('AddOns', Minimap_FormatValue(total), classColor.r, classColor.g, classColor.b, r, g, b)
    GameTooltip:AddDoubleLine('Total', Minimap_FormatValue(collectgarbage('count')), classColor.r, classColor.g, classColor.b, r, g, b)
    GameTooltip:Show()
end)

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
