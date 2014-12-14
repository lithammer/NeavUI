
local f = CreateFrame('Frame', nil, WorldMapFrame)
f:SetParent(WorldMapButton)

f.Player = f:CreateFontString(nil, 'OVERLAY')
f.Player:SetFont('Fonts\\ARIALN.ttf', 26)
f.Player:SetShadowOffset(1, -1)
f.Player:SetJustifyH('LEFT')
f.Player:SetPoint('BOTTOMLEFT', WorldMapButton, 7, 4)
f.Player:SetTextColor(1, 0.82, 0)

f.Cursor = f:CreateFontString(nil, 'OVERLAY')
f.Cursor:SetFont('Fonts\\ARIALN.ttf', 26)
f.Cursor:SetShadowOffset(1, -1)
f.Cursor:SetJustifyH('LEFT')
f.Cursor:SetPoint('BOTTOMLEFT', f.Player, 'TOPLEFT')
f.Cursor:SetTextColor(1, 0.82, 0)

f:SetScript('OnUpdate', function(self, elapsed)
    local width = WorldMapDetailFrame:GetWidth()
    local height = WorldMapDetailFrame:GetHeight()
    local mx, my = WorldMapDetailFrame:GetCenter()
    local px, py = GetPlayerMapPosition('player')
    local cx, cy = GetCursorPosition()

    mx = ((cx / WorldMapDetailFrame:GetEffectiveScale()) - (mx - width / 2)) / width
    my = ((my + height / 2) - (cy / WorldMapDetailFrame:GetEffectiveScale())) / height

    if (mx >= 0 and my >= 0 and mx <= 1 and my <= 1) then
        f.Cursor:SetText(MOUSE_LABEL..format(': %.0f x %.0f', mx * 100, my * 100))
    else
        f.Cursor:SetText('')
    end

    if (px ~= 0 and py ~= 0) then
        f.Player:SetText(PLAYER..format(': %.0f x %.0f', px * 100, py * 100))
    else
        f.Player:SetText('')
    end
end)