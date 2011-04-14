
nMinimap = {
    diffText = {
        show = "TOP", -- possible: TOP, RIGHT, TOPRIGHT
    },
}

    -- difficult indicator for normal groups

MiniMapInstanceDifficultyText:Show()
MiniMapInstanceDifficultyText:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapInstanceDifficultyText:SetShadowOffset(0, 0)
MiniMapInstanceDifficultyText:ClearAllPoints()

if (nMinimap.diffText.show == 'RIGHT') then
    MiniMapInstanceDifficultyText:SetPoint('TOPRIGHT', Minimap, -3.5, -20)
end

if (nMinimap.diffText.show == 'TOP') then
    MiniMapInstanceDifficultyText:SetPoint('TOP', Minimap, 0, -3.5)
end

if (nMinimap.diffText.show == 'TOPRIGHT') then
    MiniMapInstanceDifficultyText:SetPoint('RIGHT', GameTimeFrame, 'Left', -6, 0)
end

local function colorDifficultTex()
    MiniMapInstanceDifficultyTexture:SetTexture(nil)

    local a, b, c, d = MiniMapInstanceDifficultyTexture:GetTexCoord()
    if (d == 0.4140625) then
        MiniMapInstanceDifficultyText:SetTextColor(1, 0, 1)
    else
        MiniMapInstanceDifficultyText:SetTextColor(1, 1, 1)
    end
end

hooksecurefunc(MiniMapInstanceDifficultyTexture, 'SetTexCoord', function()
    colorDifficultTex()
end)

hooksecurefunc(MiniMapInstanceDifficulty, 'Show', function()
    colorDifficultTex()
end)

hooksecurefunc(MiniMapInstanceDifficulty, 'Hide', function()
    colorDifficultTex()
end)

    -- guild indicator 

GuildInstanceDifficultyText:Show()
GuildInstanceDifficultyText:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
GuildInstanceDifficultyText:SetShadowOffset(0, 0)
GuildInstanceDifficultyText:ClearAllPoints()

if (nMinimap.diffText.show == 'RIGHT') then
    GuildInstanceDifficultyText:SetPoint('TOPRIGHT', Minimap, -3.5, -20)
end

if (nMinimap.diffText.show == 'TOP') then
    GuildInstanceDifficultyText:SetPoint('TOP', Minimap, 0, -3.5)
end

if (nMinimap.diffText.show == 'TOPRIGHT') then
    GuildInstanceDifficultyText:SetPoint('RIGHT', GameTimeFrame, 'Left', -6, 0)
end

GuildInstanceDifficulty:SetSize(14, 14)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint('CENTER', GuildInstanceDifficultyText)

local function colorGuildTex()
    if (GuildInstanceDifficultyHeroicTexture:IsShown()) then
        GuildInstanceDifficultyText:SetTextColor(1, 0, 1)
    else
        GuildInstanceDifficultyText:SetTextColor(1, 1, 1)
    end
    
    for _, textures in pairs({
        GuildInstanceDifficulty.emblem,
        GuildInstanceDifficultyHanger,
        GuildInstanceDifficultyBorder,
        GuildInstanceDifficultyDarkBackground,
        GuildInstanceDifficultyHeroicTexture,
        GuildInstanceDifficultyBackground,
    }) do
        textures:SetTexture(nil)
        textures:ClearAllPoints()
        textures:SetPoint('TOP', 7000)
    end
end

hooksecurefunc(GuildInstanceDifficulty, 'Show', function()
    colorGuildTex()
end)

hooksecurefunc(GuildInstanceDifficultyHeroicTexture, 'Show', function()
    colorGuildTex()
end)

hooksecurefunc(GuildInstanceDifficultyHeroicTexture, 'Hide', function()
    colorGuildTex()
end)

--[[

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint('TOP', Minimap, 0, 7)
-- MiniMapInstanceDifficulty:SetPoint('TOP', Minimap, 32, 8)

MiniMapInstanceDifficultyText:ClearAllPoints()
MiniMapInstanceDifficultyText:SetPoint("CENTER", 0, 14);
MiniMapInstanceDifficultyText.SetPoint = function() end
MiniMapInstanceDifficultyText:SetTextColor(1, 1, 1)

MiniMapInstanceDifficultyText:SetFont('Interface\\AddOns\\nMinimap\\media\\fontDifficultNumber.ttf', 9)

local a = MiniMapInstanceDifficultyTexture:GetHeight()
MiniMapInstanceDifficultyTexture:SetHeight(a*0.9)

local b = MiniMapInstanceDifficultyTexture:GetWidth()
MiniMapInstanceDifficultyTexture:SetWidth(b*0.9)

local tex = MiniMapInstanceDifficultyTexture:GetTexture()

    -- raid difficult indicator for guilds
    
GuildInstanceDifficultyBackground:SetTexture(tex)
GuildInstanceDifficultyBackground:SetSize(b*0.9, a*0.9)
GuildInstanceDifficultyBackground:ClearAllPoints()
GuildInstanceDifficultyBackground:SetPoint('TOP', Minimap, 0, 5)

GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint('TOP', Minimap, 0, 7)

GuildInstanceDifficultyBackground:SetTexCoord(0, 0.25, 0.5703125, 0.9140625);

GuildInstanceDifficultyBackground:SetVertexColor(1, 1, 1)
GuildInstanceDifficultyBackground.SetVertexColor = function() end

hooksecurefunc(GuildInstanceDifficultyHeroicTexture, 'Show', function()
    GuildInstanceDifficultyBackground:SetTexCoord(0, 0.25, 0.0703125, 0.4140625);
end)

hooksecurefunc(GuildInstanceDifficultyHeroicTexture, 'Hide', function()
    GuildInstanceDifficultyBackground:SetTexCoord(0, 0.25, 0.5703125, 0.9140625);
end)

GuildInstanceDifficultyHanger:SetTexture(nil)
GuildInstanceDifficultyBorder:SetTexture(nil)
GuildInstanceDifficultyDarkBackground:SetTexture(nil)
GuildInstanceDifficultyHeroicTexture:SetTexture(nil)

GuildInstanceDifficultyText:ClearAllPoints()
GuildInstanceDifficultyText:SetPoint("CENTER", 0, 15);
GuildInstanceDifficultyText.SetPoint = function() end
GuildInstanceDifficultyText:SetDrawLayer('OVERLAY')
GuildInstanceDifficultyText:SetTextColor(1, 1, 1)

GuildInstanceDifficultyText:SetFont('Interface\\AddOns\\nMinimap\\media\\fontDifficultNumber.ttf', 9)

GuildInstanceDifficulty.emblem:ClearAllPoints()
GuildInstanceDifficulty.emblem:SetPoint("CENTER", 0, -50000);
-- GuildInstanceDifficulty.emblem:SetDrawLayer('OVERLAY')
GuildInstanceDifficulty.emblem:SetTexture(nil)
--]]
