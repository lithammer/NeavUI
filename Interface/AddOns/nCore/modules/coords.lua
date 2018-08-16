local _, nCore = ...

function nCore:MapCoords()
    local unpack = unpack

    -- Temp fix until Blizzard removed the ! icon from the global string.
    local _, MOUSE_LABEL = strsplit("1", MOUSE_LABEL, 2)

    local cfg = {
        location = {"BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 10, 0},
    }

    local MapRects = {};
    local TempVec2D = CreateVector2D(0,0);
    local function GetPlayerMapPos(mapID)
        local R,P,_ = MapRects[mapID],TempVec2D;
        if not R then
            R = {};
            _, R[1] = C_Map.GetWorldPosFromMapPos(mapID,CreateVector2D(0,0));
            _, R[2] = C_Map.GetWorldPosFromMapPos(mapID,CreateVector2D(1,1));
            R[2]:Subtract(R[1]);
            MapRects[mapID] = R;
        end
        P.x, P.y = UnitPosition("Player");
        P:Subtract(R[1]);
        return (1/R[2].y)*P.y, (1/R[2].x)*P.x;
    end

    local nCore_CoordsFrame = CreateFrame("Frame", "nCore_Coords", WorldMapFrame, "nCore_Coords")

    nCore_CoordsFrame:SetScript("OnLoad", function(self)
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:SetPoint(unpack(cfg.location))
    end)

    nCore_CoordsFrame:SetScript("OnUpdate", function(self, elapsed)
        if IsInInstance() or not nCoreDB.MapCoords  then
            self.Mouse.Text:SetText("")
            self.Player.Text:SetText("")
            return
        end

        local mapID = C_Map.GetBestMapForUnit("player")
        local px, py = GetPlayerMapPos(mapID)

        if px then
            if px ~= 0 and py ~= 0 then
                self.Player.Text:SetFormattedText("%s: %.1f x %.1f", PLAYER, px * 100, py * 100)
            else
                self.Player.Text:SetText("")
            end
        end

        if WorldMapFrame.ScrollContainer:IsMouseOver() then
            local cx, cy = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()

            if cx then
                if cx >= 0 and cy >= 0 and cx <= 1 and cy <= 1 then
                    self.Mouse.Text:SetFormattedText("%s: %.1f x %.1f", MOUSE_LABEL, cx * 100, cy * 100)
                else
                    self.Mouse.Text:SetText("")
                end
            end
        else
            self.Mouse.Text:SetText("")
        end
    end)
end