
local left = CharacterModelFrameRotateLeftButton 
left:ClearAllPoints() 
left:SetPoint('BOTTOMLEFT', CharacterModelFrame, 7, 0) 
    
local right = CharacterModelFrameRotateRightButton 
right:ClearAllPoints() 
right:SetPoint('BOTTOMRIGHT', CharacterModelFrame, -7, 0)

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

local frame = CreateFrame('Frame', nil, CharacterFrame)
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
frame:RegisterEvent('MERCHANT_SHOW')

local duraText = CharacterModelFrame:CreateFontString(nil, 'OVERLAY')
duraText:SetFont('Fonts\\ARIALN.ttf', 15, 'THINOUTLINE')
duraText:SetPoint('TOPRIGHT', CharacterModelFrame, -7, -6)
duraText:SetShadowColor(0, 0, 0, 0)
duraText:SetShadowOffset(0, 0)
duraText:SetParent(CharacterModelFrame)
duraText:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)

local Slots = {
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

local Total = 0

local function SetEquipDurability()
	for i = 1, #Slots do
		if (GetInventoryItemLink('player', Slots[i][1]) ~= nil) then
			local current, max = GetInventoryItemDurability(Slots[i][1])
			if (current) then 
				Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end

	if (Total > 0) then
		duraText:SetText(floor(Slots[1][3]*100)..'% |cffffffff'..DURABILITY..'|r')
	else
		duraText:SetText('100% |cffffffff'..DURABILITY..'|r')
	end
    
	Total = 0
end

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

frame:SetScript('OnEvent', function(event)
    for i = 1, #Slots do
        local id = GetInventorySlotInfo(Slots[i][2] .. 'Slot') 
        local curr, max = GetInventoryItemDurability(Slots[i][1])
        local itemSlot = _G['Character'..Slots[i][2]..'Slot']
        
		if (curr and max and max ~= 0) then
            if (not itemSlot.Text) then
                itemSlot.Text = itemSlot:CreateFontString(nil, 'OVERLAY')
                itemSlot.Text:SetFont(NumberFontNormal:GetFont(), 15, 'THINOUTLINE')
                itemSlot.Text:SetPoint('BOTTOM', itemSlot, 0, 1)
            end

            if (itemSlot.Text) then
                local avg = curr/max
                local gradient = {1, 0, 0, 1, 1, 0, 0, 1, 0}
                local r, g, b = ColorGradient(avg, unpack(gradient))
        
                itemSlot.Text:SetTextColor(r, g, b)
                itemSlot.Text:SetText(string.format('%d%%', avg * 100))
            end
		else
            if (itemSlot.Text) then
                itemSlot.Text:SetText('')
            end
		end
        
        SetEquipDurability()

    end
end)