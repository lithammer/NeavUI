local f = CreateFrame("Frame", nil, WorldMapFrame)
f:SetFrameLevel(90)

f.Player = f:CreateFontString(nil, "OVERLAY")
f.Player:SetFont("Fonts\\ARIALN.ttf", 15, "THINOUTLINE")
f.Player:SetJustifyH("LEFT")
f.Player:SetPoint("BOTTOMLEFT", WorldMapFrame.BorderFrame, "BOTTOMLEFT", 5, 5)
f.Player:SetTextColor(1, 0.82, 0)

f.Cursor = f:CreateFontString(nil, "OVERLAY")
f.Cursor:SetFont("Fonts\\ARIALN.ttf", 15, "THINOUTLINE")
f.Cursor:SetJustifyH("LEFT")
f.Cursor:SetPoint("BOTTOMLEFT", WorldMapFrame.BorderFrame, "BOTTOMLEFT", 115, 5)
f.Cursor:SetTextColor(1, 0.82, 0)

f:SetScript("OnUpdate", function(self, elapsed)
    if (WorldMapFrame:IsVisible()) then
        local width = WorldMapFrame.ScrollContainer:GetWidth()
        local height = WorldMapFrame.ScrollContainer:GetHeight()
        local mx, my = WorldMapFrame.ScrollContainer:GetCenter()
        local cx, cy = GetCursorPosition()
        local px, py = 0, 0

        local mapid = C_Map.GetBestMapForUnit("player")
        if mapid then
            local mp = C_Map.GetPlayerMapPosition(mapid, "player")
            if mp then
                px, py = mp:GetXY()
            end
        end

        if (px) then
            mx = ((cx / WorldMapFrame:GetEffectiveScale()) - (mx - width / 2)) / width
            my = ((my + height / 2) - (cy / WorldMapFrame:GetEffectiveScale())) / height

            if (mx >= 0 and my >= 0 and mx <= 1 and my <= 1) then
                f.Cursor:SetText(MOUSE_LABEL..format(": %.0f x %.0f", mx * 100, my * 100))
            else
                f.Cursor:SetText("")
            end

            if (px ~= 0 and py ~= 0) then
                f.Player:SetText(PLAYER..format(": %.0f x %.0f", px * 100, py * 100))
            else
                f.Player:SetText("")
            end
        else
            f.Cursor:SetText("")
            f.Player:SetText("")
        end
    end
end)

f:Show()
