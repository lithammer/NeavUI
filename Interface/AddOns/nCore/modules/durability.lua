
local gradientColor = {
    1, 0, 0, 
    1, 1, 0, 
    0, 1, 0
}

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

    -- move some buttons
    
local leftRotate = CharacterModelFrameRotateLeftButton 
leftRotate:ClearAllPoints() 
leftRotate:SetPoint('BOTTOMLEFT', CharacterModelFrame, 7, 0) 
    
local rightRotate = CharacterModelFrameRotateRightButton 
rightRotate:ClearAllPoints() 
rightRotate:SetPoint('BOTTOMRIGHT', CharacterModelFrame, -7, 0)

    -- bigger text

local charString = CharacterLevelText 
charString:SetFont('Fonts\\ARIALN.ttf', 14)

    -- create all frames and font strings
    
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

    -- create the tab-like textures
        
f.TabLeft = f:CreateTexture(nil, 'BACKGROUND', self)
f.TabLeft:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab')
f.TabLeft:SetSize(21, 32)     
f.TabLeft:SetTexCoord(0, 0.15625, 0, 1)
f.TabLeft:SetPoint('BOTTOMLEFT', f)

f.TabRight = f:CreateTexture(nil, 'BACKGROUND', self)
f.TabRight:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab')
f.TabRight:SetSize(21, 32)     
f.TabRight:SetTexCoord(0.84375, 1, 0, 1)
f.TabRight:SetPoint('BOTTOMRIGHT', f)

f.TabMiddle = f:CreateTexture(nil, 'BACKGROUND', self)
f.TabMiddle:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab')
f.TabMiddle:SetSize(88, 32)     
f.TabMiddle:SetTexCoord(0.15625, 0.84375, 0, 1)
f.TabMiddle:SetPoint('LEFT', f.TabLeft, 'RIGHT')
f.TabMiddle:SetPoint('RIGHT', f.TabRight, 'LEFT')
    
        -- create the durability font string

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetFont('Fonts\\ARIALN.ttf', 13)
f.Text:SetPoint('CENTER', f, 0, 3)
f.Text:SetShadowColor(0, 0, 0, 0)
f.Text:SetShadowOffset(-1, -1)
f.Text:SetParent(f)
f.Text:SetJustifyH('CENTER')

    -- create the head toggle button
    
f.Head = CreateFrame('Button', nil, CharacterHeadSlot)
f.Head:SetFrameStrata('HIGH')
f.Head:SetToplevel(true)
f.Head:SetSize(22, 22)
f.Head:SetPoint('CENTER', CharacterHeadSlot, 'TOPRIGHT', -2, -2)
f.Head:SetScript('OnClick', function() 
    ShowHelm(not ShowingHelm()) 
end)

f.Head:SetNormalTexture('Interface\\Minimap\\partyraidblips')
f.Head:GetNormalTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Head:GetNormalTexture():SetVertexColor(1, 0, 1)

f.Head:SetPushedTexture('Interface\\Minimap\\partyraidblips')
f.Head:GetPushedTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Head:GetPushedTexture():SetVertexColor(0, 0.5, 1)

    -- create the cloak toggle button
    
f.Cloak = CreateFrame('Button', nil, CharacterBackSlot)
f.Cloak:SetFrameStrata('HIGH')
f.Cloak:SetToplevel(true)
f.Cloak:SetSize(22, 22)
f.Cloak:SetPoint('CENTER', CharacterBackSlot, 'TOPRIGHT', -2, -2)
f.Cloak:SetScript('OnClick', function() 
    ShowCloak(not ShowingCloak()) 
end)

f.Cloak:SetNormalTexture('Interface\\MINIMAP\\partyraidblips')
f.Cloak:GetNormalTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Cloak:GetNormalTexture():SetVertexColor(1, 0, 1)

f.Cloak:SetPushedTexture('Interface\\MINIMAP\\partyraidblips')
f.Cloak:GetPushedTexture():SetTexCoord(0.5 ,0.375 ,0.5 ,0.25)
f.Cloak:GetPushedTexture():SetVertexColor(0, 0.75, 1)

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
    
    local r, g, b = ColorGradient((floor(slotInfo[1][3]*100)/100), unpack(gradientColor))    
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
                local r, g, b = ColorGradient(avg, unpack(gradientColor))
        
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