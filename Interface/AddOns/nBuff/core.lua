    
    -- import globals for faster usage
    
local _G = _G
local unpack = unpack

    -- some global/local stuff
    
BUFF_MIN_ALPHA = 1

DAY_ONELETTER_ABBR    = '|cffffffff%dd|r'
HOUR_ONELETTER_ABBR   = '|cffffffff%dh|r'
MINUTE_ONELETTER_ABBR = '|cffffffff%dm|r'
SECOND_ONELETTER_ABBR = '|cffffffff%d|r'

-- DEBUFF_MAX_DISPLAY = 32

TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -15, 0)
TemporaryEnchantFrame.SetPoint = function() end

TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -nBuff.paddingX, 0)

ConsolidatedBuffs:SetSize(20, 20)
ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint('BOTTOM', TempEnchant1, 'TOP', 1, 2)
ConsolidatedBuffs.SetPoint = function() end

ConsolidatedBuffsIcon:SetAlpha(0)
	
ConsolidatedBuffsCount:ClearAllPoints()
ConsolidatedBuffsCount:SetPoint('CENTER', ConsolidatedBuffsIcon)
ConsolidatedBuffsCount:SetFont('Fonts\\ARIALN.ttf', 16, 'OUTLINE')
ConsolidatedBuffsCount:SetShadowOffset(0, 0)

ConsolidatedBuffsContainer:SetScale(0.57)
ConsolidatedBuffsTooltip:SetScale(1.2)

local function UpdateFirstAnchor(self)
    if (self and self:IsShown()) then
        self:ClearAllPoints()
        
        if (UnitHasVehicleUI('player')) then
            self:SetPoint('TOPRIGHT', TempEnchant1)
            return
        else
            if (BuffFrame.numEnchants == 1) then
                self:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -nBuff.paddingX, 0)
                return
            elseif (BuffFrame.numEnchants == 2) then	
                self:SetPoint('TOPRIGHT', TempEnchant2, 'TOPLEFT', -nBuff.paddingX, 0)
				return
            elseif (BuffFrame.numEnchants == 3) then
                self:SetPoint('TOPRIGHT', TempEnchant3, 'TOPLEFT', -nBuff.paddingX, 0)
                return
            else
                self:SetPoint('TOPRIGHT', TempEnchant1)
                return
            end
        end
    end
end

hooksecurefunc('BuffFrame_UpdatePositions', function()
    if (CONSOLIDATED_BUFF_ROW_HEIGHT ~= 26) then
        CONSOLIDATED_BUFF_ROW_HEIGHT = 26
    end
end)

hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', function()  
    local previousBuff, aboveBuff
	-- local numBuffs = 0
    local numBuffs = 0
    local numTotal = BuffFrame.numEnchants 
    
	for i = 1, BUFF_ACTUAL_DISPLAY do
		local buff = _G['BuffButton'..i]
        
		if (buff.consolidated) then
			if (buff.parent == BuffFrame) then
				buff:SetParent(ConsolidatedBuffsContainer)
				buff.parent = ConsolidatedBuffsContainer
			end
		else
			numBuffs = numBuffs + 1
            		numTotal = numTotal + 1
            
			if (buff.parent ~= BuffFrame) then
				buff:SetParent(BuffFrame)
                		buff.parent = BuffFrame
			end
                
			buff:ClearAllPoints()

            if (numBuffs == 1) then
				UpdateFirstAnchor(buff)
            elseif (numBuffs > 1 and mod(numTotal, nBuff.buffPerRow) == 1) then
				if (numTotal == nBuff.buffPerRow + 1) then
			    		buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -nBuff.paddingY)
				else
			    		buff:SetPoint('TOP', aboveBuff, 'BOTTOM', 0, -nBuff.paddingY)
				end

				aboveBuff = buff
			else
				buff:SetPoint('RIGHT', previousBuff, 'LEFT', -nBuff.paddingX, 0)
            end

            previousBuff = buff
		end
	end
end)

hooksecurefunc('DebuffButton_UpdateAnchors', function(self, index)
    local numBuffs = BUFF_ACTUAL_DISPLAY + BuffFrame.numEnchants
    
	if (BuffFrame.numConsolidated > 0) then
		numBuffs = numBuffs - BuffFrame.numConsolidated -- + 1
	end

    local debuffSpace = nBuff.buffSize + nBuff.paddingY
    local numRows = ceil(numBuffs/nBuff.buffPerRow)

    local rowSpacing
    if (numRows and numRows > 1) then
        rowSpacing = -numRows * debuffSpace
    else
        rowSpacing = -debuffSpace
    end

    local buff = _G[self..index]
    buff:ClearAllPoints()
    
    if (index == 1) then
        buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, rowSpacing)
	elseif (index >= 2 and mod(index, nBuff.buffPerRow) == 1) then
		buff:SetPoint('TOP', _G[self..(index-nBuff.buffPerRow)], 'BOTTOM', 0, -nBuff.paddingY)
	else
		buff:SetPoint('RIGHT', _G[self..(index-1)], 'LEFT', -nBuff.paddingX, 0)
	end
end)

local function UpdateFirstButton()
    if (BuffButton1) then
        if (not BuffButton1:GetParent() == ConsolidatedBuffsContainer) then
            UpdateFirstAnchor(BuffButton1)
        end
    end
end

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
    local button = _G['TempEnchant'..i]
    button:SetScale(nBuff.buffScale)
    button:SetSize(nBuff.buffSize, nBuff.buffSize)

    button:SetScript('OnShow', function()
        UpdateFirstButton()
        print('MO')
    end)
    
    button:SetScript('OnHide', function()
        UpdateFirstButton()
        print('MO')
    end)
    
    local icon = _G['TempEnchant'..i..'Icon']
    icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)

    local duration = _G['TempEnchant'..i..'Duration']
    duration:ClearAllPoints()
    duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
    duration:SetFont(nBuff.durationFont, nBuff.durationFontsize,'OUTLINE')
    duration:SetShadowOffset(0, 0)
    duration:SetDrawLayer('OVERLAY')

    local border = _G['TempEnchant'..i..'Border']
    border:ClearAllPoints()
    border:SetPoint('TOPRIGHT', button, 1, 1)
    border:SetPoint('BOTTOMLEFT', button, -1, -1)    
    border:SetTexture(nBuff.borderDebuff)
    border:SetTexCoord(0, 1, 0, 1)
    border:SetVertexColor(0.9, 0.25, 0.9)

    button.Shadow = button:CreateTexture('$parentBackground', 'BACKGROUND')
    button.Shadow:SetPoint('TOPRIGHT', border, 3.35, 3.35)
    button.Shadow:SetPoint('BOTTOMLEFT', border, -3.35, -3.35)
    button.Shadow:SetTexture('Interface\\AddOns\\nBuff\\media\\textureShadow')
    button.Shadow:SetVertexColor(0, 0, 0, 1)
end

hooksecurefunc('AuraButton_Update', function(self, index)
    local button = _G[self..index]
    if (button) then
        if (self:match('Debuff')) then
            button:SetSize(nBuff.debuffSize, nBuff.debuffSize)
            button:SetScale(nBuff.debuffScale)
        else
            button:SetSize(nBuff.buffSize, nBuff.buffSize)
            button:SetScale(nBuff.buffScale)
        end
    end
        
    local icon = _G[self..index..'Icon']
    if (icon) then
        icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
    end
        
    local duration = _G[self..index..'Duration']
    if (duration) then
        duration:ClearAllPoints()
        duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
        duration:SetFont(nBuff.durationFont, nBuff.durationFontsize, 'OUTLINE')
        duration:SetShadowOffset(0, 0)
        duration:SetDrawLayer('OVERLAY')
    end

    local count = _G[self..index..'Count']
    if (count) then
        count:ClearAllPoints()
        count:SetPoint('TOPRIGHT', button)
        count:SetFont(nBuff.countFont, nBuff.countFontsize, 'OUTLINE')
        count:SetShadowOffset(0, 0)
        count:SetDrawLayer('OVERLAY')
    end
        
    local border = _G[self..index..'Border']
    if (border) then
        border:SetTexture(nBuff.borderDebuff)
        border:SetPoint('TOPRIGHT', button, 1, 1)
        border:SetPoint('BOTTOMLEFT', button, -1, -1)
        border:SetTexCoord(0, 1, 0, 1)
    end
    
    if (button and not border) then
        if (not button.texture) then
            button.texture = button:CreateTexture('$parentOverlay', 'ARTWORK')
            button.texture:SetParent(button)
            button.texture:SetTexture(nBuff.borderBuff)
            button.texture:SetPoint('TOPRIGHT', button, 1, 1)
            button.texture:SetPoint('BOTTOMLEFT', button, -1, -1)
            button.texture:SetVertexColor(unpack(nBuff.buffBorderColor))
        end
    end
    
    if (button) then
        if (not button.Shadow) then
            button.Shadow = button:CreateTexture('$parentShadow', 'BACKGROUND')
            button.Shadow:SetTexture('Interface\\AddOns\\nBuff\\media\\textureShadow')
            button.Shadow:SetPoint('TOPRIGHT', button.texture or border, 3.35, 3.35)
            button.Shadow:SetPoint('BOTTOMLEFT', button.texture or border, -3.35, -3.35)
            button.Shadow:SetVertexColor(0, 0, 0, 1)
        end
    end
end)