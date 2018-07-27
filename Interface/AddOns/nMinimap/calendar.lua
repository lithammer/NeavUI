
local _, nMinimap = ...
local cfg = nMinimap.Config

if (not IsAddOnLoaded("Blizzard_TimeManager")) then
    LoadAddOn("Blizzard_TimeManager")
end

for i = 1, select("#", GameTimeFrame:GetRegions()) do
    local texture = select(i, GameTimeFrame:GetRegions())
    if (texture and texture:GetObjectType() == "Texture") then
        texture:SetTexture(nil)
    end
end

GameTimeFrame:SetSize(14, 14)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, -3.5, -3.5)

GameTimeFrame:GetFontString():SetFont("Fonts\\ARIALN.ttf", 15, "OUTLINE")
GameTimeFrame:GetFontString():SetShadowOffset(0, 0)
GameTimeFrame:GetFontString():SetPoint("TOPRIGHT", GameTimeFrame)

for _, texture in pairs({
    GameTimeCalendarEventAlarmTexture,
    GameTimeCalendarInvitesTexture,
    GameTimeCalendarInvitesGlow,
    TimeManagerAlarmFiredTexture,
}) do
    texture:SetTexture(nil)

    local classColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

    if (texture:IsShown()) then
        GameTimeFrame:GetFontString():SetTextColor(1, 0, 1)
    else
        GameTimeFrame:GetFontString():SetTextColor(classColor.r, classColor.g, classColor.b)
    end

    hooksecurefunc(texture, "Show", function()
        GameTimeFrame:GetFontString():SetTextColor(1, 0, 1)
    end)

    hooksecurefunc(texture, "Hide", function()
        GameTimeFrame:GetFontString():SetTextColor(classColor.r, classColor.g, classColor.b)
    end)
end
