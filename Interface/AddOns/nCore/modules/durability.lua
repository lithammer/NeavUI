
local gradientColor = {
    1, 0, 0, 
    1, 1, 0, 
    0, 1, 0
}

local slotInfo = {
	[1] = {1, 'Head'},
	[2] = {3, 'Shoulder'},
	[3] = {5, 'Chest'},
	[4] = {6, 'Waist'},
	[5] = {9, 'Wrist'},
	[6] = {10, 'Hands'},
	[7] = {7, 'Legs'},
	[8] = {8, 'Feet'},
	[9] = {16, 'MainHand'},
	[10] = {17, 'SecondaryHand'},
	[11] = {18, 'Ranged'}
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
f.Text:SetShadowOffset(1, -1)
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

f:SetScript('OnEvent', function(event)
    local total = 0
    local overAll = 0
        
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
                
                overAll = overAll + avg
                total = total + 1
            end
		else
            if (itemSlot.Text) then
                itemSlot.Text:SetText('')
            end
		end
        
        local r, g, b = ColorGradient(overAll/total, unpack(gradientColor)) 
        f.Text:SetTextColor(r, g, b)
        f.Text:SetText(string.format('%d%%', (overAll/total)*100)..' |cffffffff'..DURABILITY..'|r')
        f:SetWidth(f.Text:GetWidth() + 44)
    end
end)