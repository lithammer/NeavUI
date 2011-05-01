
local f = CreateFrame('Frame', nil, WorldMapFrame)
   
    -- cursor coordinates
    
f.cursor = f:CreateFontString(nil, 'ARTWORK')
f.cursor:SetFontObject('GameFontNormal')
f.cursor:SetJustifyH('LEFT')

    -- player coordinates
    
f.player = f:CreateFontString(nil, 'ARTWORK')
f.player:SetFontObject('GameFontNormal')
f.player:SetJustifyH('LEFT')

hooksecurefunc('WorldMapQuestShowObjectives_AdjustPosition', function()
	f.player:ClearAllPoints()
	f.cursor:ClearAllPoints()
	
	if (WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE) then
		f.player:SetPoint('BOTTOMLEFT', WorldMapDetailFrame, 5, -20)
		f.cursor:SetPoint('BOTTOMLEFT', WorldMapDetailFrame, 130, -20)
	else
		f.player:SetPoint('BOTTOMRIGHT', WorldMapPositioningGuide, 'BOTTOM', -5, 10)
		f.cursor:SetPoint('BOTTOMLEFT', WorldMapPositioningGuide, 'BOTTOM', 5, 10)
	end
end)

WorldMapQuestShowObjectives_AdjustPosition()

f:SetScript('OnUpdate', function(self, elapsed)
	local width = WorldMapDetailFrame:GetWidth() 
	local height = WorldMapDetailFrame:GetHeight()
	local mx, my = WorldMapDetailFrame:GetCenter()
	local px, py = GetPlayerMapPosition('player')
	local cx, cy = GetCursorPosition()

	mx = ((cx / WorldMapDetailFrame:GetEffectiveScale()) - (mx - width / 2)) / width
	my = ((my + height / 2) - (cy / WorldMapDetailFrame:GetEffectiveScale())) / height

	if (mx >= 0 and my >= 0 and mx <= 1 and my <= 1) then
		f.cursor:SetText(MOUSE_LABEL..format(': %.1f x %.1f', mx * 100, my * 100))
	else
		f.cursor:SetText('')
	end
	
	if (px ~= 0 and py ~= 0) then
		f.player:SetText(PLAYER..format(': %.1f x %.1f', px * 100, py * 100))
	else
		f.player:SetText('')
	end
end)