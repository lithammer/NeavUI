
local f = CreateFrame('Frame', nil, WorldMapFrame)

    -- cursor coordinates

f.Cursor = f:CreateFontString(nil, 'ARTWORK')
f.Cursor:SetFontObject('GameFontNormal')
f.Cursor:SetJustifyH('LEFT')

    -- player coordinates

f.Player = f:CreateFontString(nil, 'ARTWORK')
f.Player:SetFontObject('GameFontNormal')
f.Player:SetJustifyH('LEFT')

hooksecurefunc('WorldMapQuestShowObjectives_AdjustPosition', function()
    f.Player:ClearAllPoints()
    f.Cursor:ClearAllPoints()

    if (WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE) then
        f.Player:SetPoint('BOTTOMLEFT', WorldMapDetailFrame, 5, -20)
        f.Cursor:SetPoint('BOTTOMLEFT', WorldMapDetailFrame, 130, -20)
    else
        f.Player:SetPoint('BOTTOMRIGHT', WorldMapPositioningGuide, 'BOTTOM', -5, 10)
        f.Cursor:SetPoint('BOTTOMLEFT', WorldMapPositioningGuide, 'BOTTOM', 5, 10)
    end
end)

f:SetScript('OnUpdate', function(self, elapsed)
    local width = WorldMapDetailFrame:GetWidth() 
    local height = WorldMapDetailFrame:GetHeight()
    local mx, my = WorldMapDetailFrame:GetCenter()
    local px, py = GetPlayerMapPosition('player')
    local cx, cy = GetCursorPosition()

    mx = ((cx / WorldMapDetailFrame:GetEffectiveScale()) - (mx - width / 2)) / width
    my = ((my + height / 2) - (cy / WorldMapDetailFrame:GetEffectiveScale())) / height

    if (mx >= 0 and my >= 0 and mx <= 1 and my <= 1) then
        f.Cursor:SetText(MOUSE_LABEL..format(': %.1f x %.1f', mx * 100, my * 100))
    else
        f.Cursor:SetText('')
    end

    if (px ~= 0 and py ~= 0) then
        f.Player:SetText(PLAYER..format(': %.1f x %.1f', px * 100, py * 100))
    else
        f.Player:SetText('')
    end
end)

WorldMapQuestShowObjectives_AdjustPosition()