--[[
if (not IsAddOnLoaded('Blizzard_TimeManager')) then
    LoadAddOn('Blizzard_TimeManager')
end

local select = select
local modf = math.modf
local sort = table.sort

local gradientColor = {
    0, 1, 0, 
    1, 1, 0, 
    1, 0, 0
}

    -- damn! blizz must create a global for this
    
local function GetCalendarName()
    if (GetLocale() == 'enUS') then
        return 'Calendar'
    elseif (GetLocale() == 'frFR') then
        return 'Calandre'
    elseif (GetLocale() == 'esES') then
        return 'Calendario'
    elseif (GetLocale() == 'ruRU') then
        return '?????????'
    elseif (GetLocale() == 'deDE') then
        return 'Kalender'
    else
        return 'Calendar'
    end
end

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

	local segment, relperc = modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function RGBGradient(num)
    local r, g, b = ColorGradient(num, unpack(gradientColor))
    return r, g, b
end











local menuFrame = CreateFrame('Frame', 'MinMapCuDropDownMenu', UIParent, 'UIDropDownMenuTemplate')


local menuList = {
    {
        text = CHARACTER_BUTTON,

        func = function() 
            securecall('ToggleCharacter', 'PaperDollFrame') 
        end,

        notCheckable = true,
    },
    {
        text = TALENTS_BUTTON,
        icon = 'Interface\\GossipFrame\\\BattleMasterGossipIcon',
        
        func = function() 
            securecall('ToggleTalentFrame') 
        end,
        
        notCheckable = true,
    },
    {
        text = ACHIEVEMENT_BUTTON,

        func = function() 
            securecall('ToggleAchievementFrame') 
        end,
        
        notCheckable = true,
    },
    {
        text = GetCalendarName(),

        func = function() 
            securecall('ToggleCalendar') 
        end,
        
        notCheckable = true,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = 'Interface\\GossipFrame\\\ActiveQuestIcon',
        
        func = function() 
            securecall('ToggleFrame', QuestLogFrame) 
        end,
            
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        icon = 'Interface\\\FriendsFrame\\\UI-Toast-FriendOnlineIcon',

        func = function() 
            ToggleFriendsFrame() 
        end,
        
        notCheckable = true,
    },
    {
        text = GUILD,
        icon = 'Interface\\GossipFrame\\\TabardGossipIcon',
        
        -- arg1 = IsInGuild('player')
        func = function() 
            if (IsInGuild('player')) then
                securecall('ToggleGuildFrame')
            else
                return
            end
        end,
        
        notCheckable = true,
    },
    {
        text = PLAYER_V_PLAYER,

        func = function() 
            securecall('ToggleFrame', PVPFrame) 
        end,

        notCheckable = true,
    },
    {
        text = DUNGEONS_BUTTON,

        func = function() 
            securecall('ToggleLFDParentFrame')
        end,
        
        notCheckable = true,
    },
    {
        text = GM_EMAIL_NAME,
      --  notCheckable = true,

        func = function() 
            securecall('ToggleHelpFrame') 
        end,
        
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        --notCheckable = 1,

        func = function() 
            securecall('ToggleFriendsFrame') 
        end,
        
        notCheckable = true,
    },
    {
        text = BATTLEFIELD_MINIMAP,
        colorCode = '|cff999999',

        func = function() 
            securecall('ToggleBattlefieldMinimap') 
        end,
            
        notCheckable = true,
    }
}


    -- function for creating the dropdown menu

local function Test1_DropDown_Initialize()
    securecall(UIDropDownMenu_AddButton, buttonChar)
    securecall(UIDropDownMenu_AddButton, buttonTalents)
    
    securecall(UIDropDownMenu_AddButton, buttonAcm)
   
    securecall(UIDropDownMenu_AddButton, buttonCal)
    securecall(UIDropDownMenu_AddButton, buttonQuest)
    
    securecall(UIDropDownMenu_AddButton, buttonSocial)
    securecall(UIDropDownMenu_AddButton, buttonGuild)
    
    securecall(UIDropDownMenu_AddButton, buttonPVP)
    securecall(UIDropDownMenu_AddButton, buttonDungeon)
    
    securecall(UIDropDownMenu_AddButton, buttonHelp)
    securecall(UIDropDownMenu_AddButton, buttonMap)
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

--TimeManagerClockButton:EnableMouse(true)

TimeManagerAlarmFiredTexture:SetTexture(nil)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Show', function()
    TimeManagerClockTicker:SetTextColor(1, 0, 1)
end)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Hide', function()
    TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
end)

local entry
local total
local addonTable = {}

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

local f = CreateFrame('Button', nil)
f:SetAllPoints(Minimap)
f:EnableMouse(true)
f:RegisterEvent('MODIFIER_STATE_CHANGED')
f:RegisterForClicks('AnyUp')

local function ShowTip()
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(f, 'ANCHOR_BOTTOMLEFT')
    
    AddonMem()

    GameTooltip:AddLine(COMBAT_MISC_INFO)    
    
    GameTooltip:AddLine(' ')

    local _, _, lagHome, lagWorld = GetNetStats()
    GameTooltip:AddLine('|cffffffffHome:|r '..format('%d ms', lagHome), RGBGradient(select(3, GetNetStats()) / 100))
    GameTooltip:AddLine('|cffffffff'..CHANNEL_CATEGORY_WORLD..':|r '..format('%d ms', lagWorld), RGBGradient(select(4, GetNetStats()) / 100))
    
    GameTooltip:AddLine(' ')

    for _, table in pairs(addonTable) do
        GameTooltip:AddDoubleLine(table.name, FormatValue(table.memory), 1, 1, 1, RGBGradient(table.memory / 800))
    end

    GameTooltip:AddLine(' ')
    
    GameTooltip:AddDoubleLine('Total', FormatValue(total), nil, nil, nil, RGBGradient(total / (1024*10)))
    
    if (SHOW_NEWBIE_TIPS == '1') then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
    end

    GameTooltip:Show()
end

f:SetScript('OnEvent', function()
    if (IsShiftKeyDown()) then
        if (f:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowTip()
        end
    else
        if (f:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowTip()
        end
    end
end)

f:SetScript('OnEnter', function(self)
    ShowTip()
end)

f:SetScript('OnLeave', function(self)
    GameTooltip:Hide()
end)

--local xClockDropDown = CreateFrame('Frame', 'MinimapMenuDropDownXX', f, 'UIDropDownMenuTemplate')
--securecall('UIDropDownMenu_Initialize', xClockDropDown, XCreateDropDown, 'MENU')


--local dropdown = CreateFrame("Frame", "Test_DropDown", UIParent, "UIDropDownMenuTemplate");
--UIDropDownMenu_Initialize(dropdown, Test1_DropDown_Initialize, "MENU");

 
f:SetScript('OnClick', function(self, button)
    if (button == 'LeftButton') then
        --ToggleDropDownMenu(1, nil, dropdown, self, -0, -0)
        EasyMenu(menuList, menuFrame, self, 0, 0, 'MENU', 2)
        GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    else
        if (self.alarmFiring) then
            TimeManager_TurnOffAlarm()
        end
        ToggleTimeManager()
        DropDownList1:Hide()
    end
    
    GameTooltip:Hide()
end)
--]]

--[[


if (not IsAddOnLoaded('Blizzard_TimeManager')) then
    LoadAddOn('Blizzard_TimeManager')
end

local select = select
local modf = math.modf
local sort = table.sort

local gradientColor = {
    0, 1, 0, 
    1, 1, 0, 
    1, 0, 0
}

    -- damn! blizz must create a global for this
    
local function GetCalendarName()
    if (GetLocale() == 'enUS') then
        return 'Calendar'
    elseif (GetLocale() == 'frFR') then
        return 'Calandre'
    elseif (GetLocale() == 'esES') then
        return 'Calendario'
    elseif (GetLocale() == 'ruRU') then
        return '?????????'
    elseif (GetLocale() == 'deDE') then
        return 'Kalender'
    else
        return 'Calendar'
    end
end

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

	local segment, relperc = modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function RGBGradient(num)
    local r, g, b = ColorGradient(num, unpack(gradientColor))
    return r, g, b
end

local gf = CreateFrame('Frame')
gf:SetParent(DropDownList1)

local num = 1
local buttonTable = {}
local tex = DropDownList1Button1Highlight:GetTexture()
    
local function CreateOverlayButton()

    buttonTable[num] = CreateFrame('Button', nil, _G['DropDownList1Button'..num])
    buttonTable[num]:RegisterForClicks('anyup')
    buttonTable[num]:EnableMouse(true)
    buttonTable[num]:SetAllPoints(_G['DropDownList1Button'..num])
    --buttonTable[num]:SetParent(_G['DropDownList1Button'..num])


    buttonTable[num].high = buttonTable[num]:CreateTexture('OVERLAY')
    buttonTable[num].high:SetAllPoints(buttonTable[num])
    buttonTable[num].high:SetTexture(tex)
    buttonTable[num].high:SetBlendMode("ADD")
    buttonTable[num].high:Hide()
    
    buttonTable[num]:SetScript('OnEnter', function(self)
        self.high:Show()
    end)
    
    buttonTable[num]:SetScript('OnLeave', function(self)
        self.high:Hide()
    end)
    
    num = num + 1
end

CreateOverlayButton()
buttonTable[1]:SetScript('OnClick', function() 
    securecall(ToggleCharacter, 'PaperDollFrame')
    
    DropDownList1:Hide()
        for i = 1, 12 do
        buttonTable[i]:Hide()
    end
end)


    
CreateOverlayButton()
buttonTable[2]:SetScript('OnClick', function() 
    securecall(ToggleFrame, SpellBookFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[3]:SetScript('OnClick', function() 
    securecall(ToggleTalentFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[4]:SetScript('OnClick', function() 
    securecall(ToggleAchievementFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[5]:SetScript('OnClick', function() 
    securecall(ToggleCalendar)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[6]:SetScript('OnClick', function() 
    securecall(ToggleFrame, QuestLogFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[7]:SetScript('OnClick', function() 
    securecall(ToggleFriendsFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[8]:SetScript('OnClick', function() 
    if (IsInGuild('player')) then
        securecall(ToggleGuildFrame())
    else
        return
    end
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[9]:SetScript('OnClick', function() 
    securecall(ToggleFrame, PVPFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[10]:SetScript('OnClick', function() 
    securecall(ToggleLFDParentFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[11]:SetScript('OnClick', function() 
    securecall(ToggleHelpFrame)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

CreateOverlayButton()
buttonTable[12]:SetScript('OnClick', function() 
    securecall(ToggleBattlefieldMinimap)
    DropDownList1:Hide()        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

DropDownList1:HookScript('OnHide', function()
for i = 1, 12 do
            buttonTable[i]:Hide()
        end
end)

for i = 1, 12 do
    buttonTable[i]:Hide()
end
        
    -- function for creating the dropdown menu
    
local function CreateDropDown()
    local button = {}
    
    for i = 1, 12 do
        button[i] = {}
        ---button[i].notCheckable = true
        -- button[i].notClickable = true
    end
    
    button[1].text = CHARACTER_BUTTON
    UIDropDownMenu_AddButton(button[1])
    
    button[2].text = SPELLBOOK_ABILITIES_BUTTON
    UIDropDownMenu_AddButton(button[2])
    
    button[3].text = TALENTS_BUTTON
    UIDropDownMenu_AddButton(button[3])

    button[4].text = ACHIEVEMENT_BUTTON
    UIDropDownMenu_AddButton(button[4])

    button[5].text = GetCalendarName()
    UIDropDownMenu_AddButton(button[5])
    
    button[6].text = QUESTLOG_BUTTON
    UIDropDownMenu_AddButton(button[6])
    
    button[7].text = SOCIAL_BUTTON
    UIDropDownMenu_AddButton(button[7])

    button[8].text = GUILD..(IsInGuild('player') and (': |cff00aaff'.. GetGuildInfo('player')..'|r') or '')
    UIDropDownMenu_AddButton(button[8])
    
    button[9].text = PLAYER_V_PLAYER
    UIDropDownMenu_AddButton(button[9])
    
    button[10].text = DUNGEONS_BUTTON
    UIDropDownMenu_AddButton(button[10])
    
    button[11].text = GM_EMAIL_NAME
    UIDropDownMenu_AddButton(button[11])
    
    button[12].text = '|cff999999'..BATTLEFIELD_MINIMAP..'|r'
    UIDropDownMenu_AddButton(button[12])
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

local entry
local total
local addonTable = {}

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

local function ShowTip()
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(TimeManagerClockButton, 'ANCHOR_BOTTOMLEFT')
    
    AddonMem()

    GameTooltip:AddLine(COMBAT_MISC_INFO)    
    
    GameTooltip:AddLine(' ')

    local _, _, lagHome, lagWorld = GetNetStats()
    GameTooltip:AddLine('|cffffffffHome:|r '..format('%d ms', lagHome), RGBGradient(select(3, GetNetStats()) / 100))
    GameTooltip:AddLine('|cffffffff'..CHANNEL_CATEGORY_WORLD..':|r '..format('%d ms', lagWorld), RGBGradient(select(4, GetNetStats()) / 100))
    
    GameTooltip:AddLine(' ')

    for _, table in pairs(addonTable) do
        GameTooltip:AddDoubleLine(table.name, FormatValue(table.memory), 1, 1, 1, RGBGradient(table.memory / 800))
    end

    GameTooltip:AddLine(' ')
    
    GameTooltip:AddDoubleLine('Total', FormatValue(total), nil, nil, nil, RGBGradient(total / (1024*10)))
    
    if (SHOW_NEWBIE_TIPS == '1') then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
    end

    GameTooltip:Show()
end



local f = CreateFrame('Frame')
f:RegisterEvent('MODIFIER_STATE_CHANGED')
f:SetScript('OnEvent', function()
    if (IsShiftKeyDown()) then
        if (TimeManagerClockButton:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowTip()
        end
    else
        if (TimeManagerClockButton:IsMouseOver() and not DropDownList1:IsShown()) then
            GameTooltip:Hide()
            ShowTip()
        end
    end
end)

TimeManagerClockButton:SetScript('OnEnter', function(self)
    ShowTip()
end)

local dropDown = CreateFrame('Frame', '$parentGameMenuDropDown', nil, 'UIDropDownMenuTemplate')
UIDropDownMenu_Initialize(dropDown, CreateDropDown, 'MENU')

TimeManagerClockButton:SetScript('OnClick', function(self, button)
    if (button == 'LeftButton') then
        ToggleDropDownMenu(1, nil, dropDown, self, -0, -0)
        GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
        
        for i = 1, 12 do
            buttonTable[i]:Show()
        end

    else
        if (self.alarmFiring) then
            TimeManager_TurnOffAlarm()
        end
        ToggleTimeManager()
        DropDownList1:Hide()
        
        for i = 1, 12 do
            buttonTable[i]:Hide()
        end
    end
    
    GameTooltip:Hide()
end)
--]]
