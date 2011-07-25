
local select = select
local modf = math.modf
local sort = table.sort

local gradientColor = {
    0, 1, 0, 
    1, 1, 0, 
    1, 0, 0
}

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

TimeManagerClockButton:SetScript('OnEnter', function()
    ShowTip()
end)