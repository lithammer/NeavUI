
local function FormatValue(i)
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

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function CreateDropDown()
    local calendar

    if (GetLocale() == 'enUS') then
        calendar = 'Calendar'
    elseif (GetLocale() == 'deDE') then
        calendar = 'Kalender'
    else
        calendar = 'Calendar'
    end
    
    local button = {}
    
    for i = 1, 11 do
        button[i] = {}
        button[i].notCheckable = true
    end
    
    button[1].text = CHARACTER_BUTTON
    button[1].func = function() 
        ToggleCharacter('PaperDollFrame') 
    end
    
    UIDropDownMenu_AddButton(button[1])
    
    button[2].text = SPELLBOOK_ABILITIES_BUTTON
    button[2].func = function() 
        ToggleFrame(SpellBookFrame) 
    end
    
    UIDropDownMenu_AddButton(button[2])
    
    button[3].text = TALENTS_BUTTON
    button[3].func = function() 
        ToggleTalentFrame() 
    end
    
    UIDropDownMenu_AddButton(button[3])
    
    button[4].text = ACHIEVEMENT_BUTTON
    button[4].func = function() 
        ToggleAchievementFrame() 
    end  
    
    UIDropDownMenu_AddButton(button[4])

    button[5].text = calendar
    button[5].func = function() 
        ToggleCalendar() 
    end
    
    UIDropDownMenu_AddButton(button[5])
    
    button[6].text = QUESTLOG_BUTTON
    button[6].func = function() 
        ToggleFrame(QuestLogFrame) 
    end
    
    UIDropDownMenu_AddButton(button[6])
    
    button[7].text = SOCIAL_BUTTON
    button[7].func = function() 
        ToggleFriendsFrame() 
    end
    
    UIDropDownMenu_AddButton(button[7])

    if (IsInGuild('player')) then
        button[8].text = GUILD..(IsInGuild('player') and (': |cff00aaff'.. GetGuildInfo('player')..'|r') or '')
        button[8].func = function() 
            if (IsInGuild('player')) then
                ToggleGuildFrame() 
            else
                return
            end
        end

        UIDropDownMenu_AddButton(button[8])
    end
    
    button[9].text = PLAYER_V_PLAYER
    button[9].func = function() 
        ToggleFrame(PVPFrame) 
    end
    
    UIDropDownMenu_AddButton(button[9])
    

    button[10].text = DUNGEONS_BUTTON
    button[10].func = function() 
        ToggleLFDParentFrame() 
    end
    
    UIDropDownMenu_AddButton(button[10])
    
    button[11].text = GM_EMAIL_NAME
    button[11].func = function() 
        ToggleHelpFrame() 
    end
    
    UIDropDownMenu_AddButton(button[11])
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

local addons = {}   
local entry
local total

local function AddonMem()
    total = 0

    for i = 1, GetNumAddOns() do
        if (IsAddOnLoaded(i)) then
            local memory = GetAddOnMemoryUsage(i)
            total = total + memory
            
            entry = {
                name = select(2, GetAddOnInfo(i)), 
                memory = memory
            }
          
        tinsert(addons, entry)
        --[[
        table.sort(addons, function(a, b) 
            return a.memory > b.memory 
        end)
        --]]
        end
    end
end

TimeManagerClockButton:SetScript('OnEnter', function(self)
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    
    local gradient = {0, 1, 0, 1, 1, 0, 1, 0, 0}
    
    collectgarbage()
    wipe(addons)

    UpdateAddOnMemoryUsage()

    AddonMem()

    GameTooltip:AddLine(COMBAT_MISC_INFO)    
    
    GameTooltip:AddLine(' ')

    local _, _, lagHome, lagWorld = GetNetStats();
    local r, g, b = ColorGradient((select(3, GetNetStats()) / 100), unpack(gradient))
    GameTooltip:AddLine('|cffffffffHome:|r '..format('%d ms', lagHome), r, g, b)
    GameTooltip:AddLine('|cffffffff'..CHANNEL_CATEGORY_WORLD..':|r '..format('%d ms', lagWorld), r, g, b)
    
    GameTooltip:AddLine(' ')
           
    for _, table in pairs(addons) do
        local r, g, b = ColorGradient((table.memory / 800), unpack(gradient))
        GameTooltip:AddDoubleLine(table.name, FormatValue(table.memory), 1, 1, 1, r, g, b)
    end

    GameTooltip:AddLine(' ')
    
    local r, g, b = ColorGradient((total / (1024*10)), unpack(gradient)) 
    GameTooltip:AddDoubleLine('Total', FormatValue(total), nil, nil, nil, r, g, b)
    
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

TimeManagerClockDropDown = CreateFrame('Frame', '$parentDropDown', nil, 'UIDropDownMenuTemplate')
UIDropDownMenu_Initialize(TimeManagerClockDropDown, CreateDropDown, 'MENU')