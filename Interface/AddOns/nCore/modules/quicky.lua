
local f = CreateFrame('Frame')

--local leftRotate = CharacterModelFrameControlFrameRotateLeftButton 
--leftRotate:ClearAllPoints() 
--leftRotate:SetPoint('BOTTOMLEFT', CharacterModelFrame, 7, 0) 
--
--local rightRotate = CharacterModelFrameControlFrameRotateRightButton 
--rightRotate:ClearAllPoints() 
--rightRotate:SetPoint('BOTTOMRIGHT', CharacterModelFrame, -7, 0)

f.Head = CreateFrame('Button', nil, CharacterHeadSlot)
f.Head:SetFrameStrata('HIGH')
-- f.Head:SetToplevel(true)
f.Head:SetSize(16, 32)
f.Head:SetPoint('LEFT', CharacterHeadSlot, 'CENTER', 9, 0)

f.Head:SetScript('OnClick', function() 
    ShowHelm(not ShowingHelm()) 
end)

f.Head:SetScript('OnEnter', function(self) 
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 13, -10)
    GameTooltip:AddLine(SHOW_HELM)
    GameTooltip:Show()
end)

f.Head:SetScript('OnLeave', function() 
    GameTooltip:Hide()
end)

f.Head:SetNormalTexture('Interface\\AddOns\\nCore\\media\\textureNormal')
f.Head:SetHighlightTexture('Interface\\AddOns\\nCore\\media\\textureHighlight')
f.Head:SetPushedTexture('Interface\\AddOns\\nCore\\media\\texturePushed')

CharacterHeadSlotPopoutButton:SetScript('OnShow', function()
    f.Head:ClearAllPoints()
    f.Head:SetPoint('RIGHT', CharacterHeadSlot, 'CENTER', -9, 0)
end)

CharacterHeadSlotPopoutButton:SetScript('OnHide', function()
    f.Head:ClearAllPoints()
    f.Head:SetPoint('LEFT', CharacterHeadSlot, 'CENTER', 9, 0)
end)

f.Cloak = CreateFrame('Button', nil, CharacterBackSlot)
f.Cloak:SetFrameStrata('HIGH')
-- f.Cloak:SetToplevel(true)
f.Cloak:SetSize(16, 32)
f.Cloak:SetPoint('LEFT', CharacterBackSlot, 'CENTER', 9, 0)

f.Cloak:SetScript('OnClick', function() 
    ShowCloak(not ShowingCloak()) 
end)

f.Cloak:SetScript('OnEnter', function(self) 
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 13, -10)
    GameTooltip:AddLine(SHOW_CLOAK)
    GameTooltip:Show()
end)

f.Cloak:SetScript('OnLeave', function() 
    GameTooltip:Hide()
end)

f.Cloak:SetNormalTexture('Interface\\AddOns\\nCore\\media\\textureNormal')
f.Cloak:SetHighlightTexture('Interface\\AddOns\\nCore\\media\\textureHighlight')
f.Cloak:SetPushedTexture('Interface\\AddOns\\nCore\\media\\texturePushed')

CharacterBackSlotPopoutButton:SetScript('OnShow', function()
    f.Cloak:ClearAllPoints()
   -- f.Cloak:SetPoint('LEFT', CharacterBackSlot, 'CENTER', 25, 0)
        f.Cloak:SetPoint('RIGHT', CharacterBackSlot, 'CENTER', -9, 0)
end)

CharacterBackSlotPopoutButton:SetScript('OnHide', function()
    f.Cloak:ClearAllPoints()
    f.Cloak:SetPoint('LEFT', CharacterBackSlot, 'CENTER', 9, 0)
end)
