
local gradient = {1, 0, 0, 1, 1, 0, 0, 1, 0}

local left = CharacterModelFrameRotateLeftButton 
left:ClearAllPoints() 
left:SetPoint('BOTTOMLEFT', CharacterModelFrame, 7, 0) 
    
local right = CharacterModelFrameRotateRightButton 
right:ClearAllPoints() 
right:SetPoint('BOTTOMRIGHT', CharacterModelFrame, -7, 0)

local charString = CharacterLevelText 
charString:SetFont('Fonts\\ARIALN.ttf', 14)

CharacterHeadSlot:SetScript('OnClick', function() 
    if (IsControlKeyDown()) then
        ShowHelm(not ShowingHelm()) 
    end
end)

CharacterBackSlot:SetScript('OnClick', function() 
    if (IsControlKeyDown()) then
        ShowCloak(not ShowingCloak()) 
    end
end)

local _, class = UnitClass('player')

    -- CharacterModelFrame - PaperDollFrame

local f = CreateFrame('Frame')
f:SetSize(150, 32)
f:SetFrameStrata('DIALOG')
f:EnableMouse(false)
f:SetScale(0.94)
f:SetPoint('TOP', PaperDollFrame, 'BOTTOM', 170, 0)
f:SetParent(PaperDollSidebarTab1)
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
f:RegisterEvent('MERCHANT_SHOW')

f.Header = {}

for i = 1, 3 do
    f.Header[i] = f:CreateTexture(nil, 'BACKGROUND', self)
    f.Header[i]:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab')
end

f.Header[1]:SetSize(21, 32)     
f.Header[1]:SetTexCoord(0, 0.15625, 0, 1)
f.Header[1]:SetPoint('BOTTOMLEFT', f)

f.Header[2]:SetSize(88, 32)     
f.Header[2]:SetTexCoord(0.15625, 0.84375, 0, 1)
f.Header[2]:SetPoint('LEFT', f.Header[1], 'RIGHT')
f.Header[2]:SetPoint('RIGHT', f.Header[3], 'LEFT')

f.Header[3]:SetSize(21, 32)     
f.Header[3]:SetTexCoord(0.84375, 1, 0, 1)
f.Header[3]:SetPoint('BOTTOMRIGHT', f)

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetFont('Fonts\\ARIALN.ttf', 13)
f.Text:SetPoint('CENTER', f, 0, 3)
f.Text:SetShadowColor(0, 0, 0, 0)
f.Text:SetShadowOffset(-1, -1)
f.Text:SetParent(f)
f.Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
f.Text:SetJustifyH('RIGHT')

local slotInfo = {
	[1] = {1, 'Head', 1000},
	[2] = {3, 'Shoulder', 1000},
	[3] = {5, 'Chest', 1000},
	[4] = {6, 'Waist', 1000},
	[5] = {9, 'Wrist', 1000},
	[6] = {10, 'Hands', 1000},
	[7] = {7, 'Legs', 1000},
	[8] = {8, 'Feet', 1000},
	[9] = {16, 'MainHand', 1000},
	[10] = {17, 'SecondaryHand', 1000},
	[11] = {18, 'Ranged', 1000}
}

local function ColorGradient(perc, ...)
	if (perc >= 1) then
		local r, g, b = select(select('#', ...) - 2, ...) 
        return r, g, b
	elseif (perc < 0) then
		local r, g, b = ... return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local Total = 0

local function GetEquipDurability()
	for i = 1, #slotInfo do
		if (GetInventoryItemLink('player', slotInfo[i][1]) ~= nil) then
			local current, max = GetInventoryItemDurability(slotInfo[i][1])
			if (current) then 
				slotInfo[i][3] = current/max
				Total = Total + 1
			end
		end
	end
    
    table.sort(slotInfo, function(a, b) 
        return a[3] < b[3] 
    end)
    
    if (Total > 0) then
        f.Text:SetText(floor(slotInfo[1][3]*100)..'% |cffffffff'..DURABILITY..'|r')
    else
        f.Text:SetText('100% |cffffffff'..DURABILITY..'|r')
    end
    
    local r, g, b = ColorGradient((floor(slotInfo[1][3]*100)/100), unpack(gradient))    
    f.Text:SetTextColor(r, g, b)
    f:SetWidth(f.Text:GetWidth() + 44)
    
	Total = 0
end

f:SetScript('OnEvent', function(event)
    for i = 1, #slotInfo do
        local id = GetInventorySlotInfo(slotInfo[i][2] .. 'Slot') 
        local curr, max = GetInventoryItemDurability(slotInfo[i][1])
        local itemSlot = _G['Character'..slotInfo[i][2]..'Slot']
        
		if (curr and max and max ~= 0) then
            if (not itemSlot.Text) then
                itemSlot.Text = itemSlot:CreateFontString(nil, 'OVERLAY')
                itemSlot.Text:SetFont(NumberFontNormal:GetFont(), 15, 'THINOUTLINE')
                itemSlot.Text:SetPoint('BOTTOM', itemSlot, 0, 1)
            end

            if (itemSlot.Text) then
                local avg = curr/max
                local r, g, b = ColorGradient(avg, unpack(gradient))
        
                itemSlot.Text:SetTextColor(r, g, b)
                itemSlot.Text:SetText(string.format('%d%%', avg * 100))
            end
		else
            if (itemSlot.Text) then
                itemSlot.Text:SetText('')
            end
		end
        
        GetEquipDurability()

    end
end)