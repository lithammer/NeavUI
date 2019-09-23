local select = select

if not IsAddOnLoaded("Blizzard_TimeManager") then
    LoadAddOn("Blizzard_TimeManager")
end

for i = 1, select("#", GameTimeFrame:GetRegions()) do
    local texture = select(i, GameTimeFrame:GetRegions())
    if texture and texture:GetObjectType() == "Texture" then
        texture:SetTexture(nil)
    end
end

GameTimeFrame:SetSize(14, 14)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, -3.5, -3.5)
