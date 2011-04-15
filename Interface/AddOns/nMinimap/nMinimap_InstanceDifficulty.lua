
if (nMinimap.diffIndicator.mode == 'TEXT') then

        -- difficult indicator for normal groups
    
    MiniMapInstanceDifficultyText:Show()
    MiniMapInstanceDifficultyText:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
    MiniMapInstanceDifficultyText:SetShadowOffset(0, 0)
    MiniMapInstanceDifficultyText:ClearAllPoints()

    if (nMinimap.diffIndicatorText.show == 'RIGHT') then
        MiniMapInstanceDifficultyText:SetPoint('TOPRIGHT', Minimap, -3.5, -20)
    elseif (nMinimap.diffIndicatorText.show == 'TOP') then
        MiniMapInstanceDifficultyText:SetPoint('TOP', Minimap, 0, -3.5)
    else
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

    if (nMinimap.diffIndicatorText.show == 'RIGHT') then
        GuildInstanceDifficultyText:SetPoint('TOPRIGHT', Minimap, -3.5, -20)
    elseif (nMinimap.diffIndicatorText.show == 'TOP') then
        GuildInstanceDifficultyText:SetPoint('TOP', Minimap, 0, -3.5)
    else
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
    
else

        -- difficult indicator for normal groups
    
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint('TOP', Minimap, 0, 5)

    MiniMapInstanceDifficultyTexture:ClearAllPoints()
    MiniMapInstanceDifficultyTexture:SetPoint('TOP', Minimap, 0, 5)

    MiniMapInstanceDifficultyText:SetTextColor(1, 1, 1)

    hooksecurefunc(MiniMapInstanceDifficulty, 'Show', function()
        MiniMapInstanceDifficultyText:ClearAllPoints()
        MiniMapInstanceDifficultyText:SetPoint('CENTER', MiniMapInstanceDifficulty, 0, 16);
    end)
    
    hooksecurefunc(MiniMapInstanceDifficultyTexture, 'SetTexCoord', function()
        MiniMapInstanceDifficultyText:ClearAllPoints()
        MiniMapInstanceDifficultyText:SetPoint('CENTER', MiniMapInstanceDifficulty, 0, 16);
    end)
    
    MiniMapInstanceDifficultyText:SetFont('Interface\\AddOns\\nMinimap\\media\\fontDifficultNumber.ttf', 9)

        -- guild indicator 
        
    local tex = MiniMapInstanceDifficultyTexture:GetTexture()
    GuildInstanceDifficultyBackground:SetTexture(tex)
    
    local x1, y1 = MiniMapInstanceDifficultyTexture:GetSize()
    GuildInstanceDifficultyBackground:SetSize(x1, y1)   
    
    GuildInstanceDifficultyBackground:ClearAllPoints()
    GuildInstanceDifficultyBackground:SetPoint('TOP', Minimap, 0, 5)

    GuildInstanceDifficulty:ClearAllPoints()
    GuildInstanceDifficulty:SetSize(14, 14)
    GuildInstanceDifficulty:SetPoint('TOP', Minimap, 0, 3)

    local function hideGuildTex()
        GuildInstanceDifficultyHanger:SetTexture(nil)
        GuildInstanceDifficultyBorder:SetTexture(nil)
        GuildInstanceDifficultyDarkBackground:SetTexture(nil)
        GuildInstanceDifficultyHeroicTexture:SetTexture(nil)
        GuildInstanceDifficulty.emblem:SetTexture(nil)
        
        GuildInstanceDifficultyBackground:SetVertexColor(1, 1, 1)
        GuildInstanceDifficultyText:SetTextColor(1, 1, 1)
    end

    hooksecurefunc(GuildInstanceDifficulty, 'Show', function()
        hideGuildTex()
    end)

    hooksecurefunc(GuildInstanceDifficultyBackground, 'Show', function()
        hideGuildTex()
    end)
    
    GuildInstanceDifficultyBackground:SetTexCoord(0, 0.25, 0.5703125, 0.9140625);
    
    hooksecurefunc(GuildInstanceDifficultyHeroicTexture, 'Show', function()
        GuildInstanceDifficultyBackground:SetTexCoord(0, 0.25, 0.0703125, 0.4140625);
        hideGuildTex()
    end)

    hooksecurefunc(GuildInstanceDifficultyHeroicTexture, 'Hide', function()
        GuildInstanceDifficultyBackground:SetTexCoord(0, 0.25, 0.5703125, 0.9140625);
        hideGuildTex()
    end)
    
    GuildInstanceDifficultyText:ClearAllPoints()
    GuildInstanceDifficultyText:SetPoint('CENTER', GuildInstanceDifficulty, 0, 3);
    GuildInstanceDifficultyText:SetDrawLayer('OVERLAY')
    
    GuildInstanceDifficultyText:SetFont('Interface\\AddOns\\nMinimap\\media\\fontDifficultNumber.ttf', 9)

    GuildInstanceDifficulty.emblem:ClearAllPoints()
    GuildInstanceDifficulty.emblem:SetPoint('CENTER', 0, -50000);
    -- GuildInstanceDifficulty.emblem:SetDrawLayer('OVERLAY')
end