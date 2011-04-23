MiniMapInstanceDifficulty:UnregisterAllEvents()
MiniMapInstanceDifficulty:Hide()

GuildInstanceDifficulty:UnregisterAllEvents()
GuildInstanceDifficulty:Hide()

local IS_GUILD_GROUP

Minimap:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
Minimap:RegisterEvent('PLAYER_GUILD_UPDATE')

Minimap:HookScript('OnEvent', function(self, event, ...)
	if (event == "GUILD_PARTY_STATE_UPDATED") then
		local isGuildGroup = ...
        
		if (isGuildGroup ~= IS_GUILD_GROUP) then
			IS_GUILD_GROUP = isGuildGroup
		end
	elseif ( event == "PLAYER_GUILD_UPDATE" ) then
		if (not IsInGuild()) then
			IS_GUILD_GROUP = nil
		end
	end
end)

local f = CreateFrame('Frame')
f:SetAlpha(0)
f:SetParent(Minimap)

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetParent(f)
f.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
f.Text:SetPoint('TOP', Minimap, 0, -3.5)
f.Text:SetTextColor(1, 1, 1)


f.Text1 = f:CreateFontString(nil, 'OVERLAY')
f.Text1:SetParent(f)
f.Text1:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
-- f.Text1:SetPoint('TOP', f.Text, 'BOTTOM', 0, 1)
-- f.Text1:SetTextColor(1, 1, 1)

--[[
f.Text2 = f:CreateFontString(nil, 'OVERLAY')
f.Text2:SetParent(f)
f.Text2:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
f.Text2:SetPoint('TOP', f.Text1, 'BOTTOM', 0, 1)
f.Text2:SetTextColor(1, 1, 1)
--]]

local function SetDifficultyText()
    local _, instancetype, _, difficultyName, maxPlayers = GetInstanceInfo()
    
    if (instancetype == 'party' or instancetype == 'raid') then
        local guildgrp
            
        if (IS_GUILD_GROUP) then
            guildgrp = '|cffffff00G|r' -- ..GUILD_GROUP..'|r'
        else
            guildgrp = ''
        end

        f.Text1:SetText(difficultyName)
        
        if (f.Text1:GetText() and f.Text1:GetText():match(PLAYER_DIFFICULTY2)) then
            f.Text:SetText(maxPlayers..guildgrp..'|cffff00ffH|r')
            -- f.Text1:SetText(PLAYER_DIFFICULTY2)
        elseif (not difficultyName)then
            f.Text:SetText(maxPlayers..guildgrp)
        else
            f.Text:SetText(maxPlayers..guildgrp)
            -- f.Text1:SetText('')
        end
            
        -- f.Text2:SetText(guildgrp)
    end
end

Minimap:HookScript('OnEnter', function()
    if (IsInInstance()) then
        SetDifficultyText()
    end
    
    if (not IsInInstance()) then
        f.Text:SetText('')
        f.Text1:SetText('')
        -- f.Text2:SetText('')
    end
    
    UIFrameFadeIn(f, 0.235, f:GetAlpha(), 1)
end)

Minimap:HookScript('OnLeave', function()
    UIFrameFadeOut(f, 0.235, f:GetAlpha(), 0)
    
    if (not IsInInstance()) then
        f.Text:SetText('')
        f.Text1:SetText('')
        -- f.Text2:SetText('')
    end
end)

--[[
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

    
    GuildInstanceDifficulty:SetSize(14, 14)
    GuildInstanceDifficulty:ClearAllPoints()
    GuildInstanceDifficulty:SetPoint('TOP', Minimap, 0, 3)
  --  GuildInstanceDifficulty.SetPoint = function() end 

    local function hideGuildTex()
        GuildInstanceDifficultyHanger:SetTexture(nil)
        
        
        GuildInstanceDifficultyBorder:SetTexture(nil)
        
        
        GuildInstanceDifficultyDarkBackground:SetTexture(nil)
        
        
        GuildInstanceDifficultyHeroicTexture:SetTexture(nil)
        
        
        GuildInstanceDifficulty.emblem:SetTexture(nil)
        --GuildInstanceDifficulty.SetTexture = function() end
         
        GuildInstanceDifficultyBackground:SetVertexColor(1, 1, 1)
        GuildInstanceDifficultyBackground.SetVertexColor = function() end
        
        GuildInstanceDifficultyText:SetTextColor(1, 1, 1)
    end
    
    GuildInstanceDifficulty:HookScript('OnEvent', function(self)
        hideGuildTex()
    end)

    hooksecurefunc(GuildInstanceDifficulty, 'Show', function()
        hideGuildTex()
        
        GuildInstanceDifficultyText:ClearAllPoints()
        GuildInstanceDifficultyText:SetPoint('CENTER', GuildInstanceDifficulty, 0, 3);
        GuildInstanceDifficultyText.SetPoint = function() end 
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
    

    GuildInstanceDifficultyText:SetDrawLayer('OVERLAY')
    
    GuildInstanceDifficultyText:SetFont('Interface\\AddOns\\nMinimap\\media\\fontDifficultNumber.ttf', 9)

    GuildInstanceDifficulty.emblem:ClearAllPoints()
    GuildInstanceDifficulty.emblem:SetPoint('CENTER', 0, -50000);
    -- GuildInstanceDifficulty.emblem:SetDrawLayer('OVERLAY')
end

]]