
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 1, 5)
MiniMapInstanceDifficulty:SetScale(0.9)

GuildInstanceDifficulty:Show()
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 1, 5)
GuildInstanceDifficulty:SetScale(0.9)


    -- no real hide, just a fake hide because we need it for the guild indicator
    
-- MiniMapInstanceDifficulty:UnregisterAllEvents()
MiniMapInstanceDifficulty:Hide()

-- GuildInstanceDifficulty:UnregisterAllEvents()
-- GuildInstanceDifficulty:Hide()

local isGuildGroup

local function HideDiffFrame()
    GuildInstanceDifficulty:EnableMouse(false)
    GuildInstanceDifficulty:SetAlpha(0)
    
    MiniMapInstanceDifficulty:EnableMouse(false)
    MiniMapInstanceDifficulty:SetAlpha(0)
end

hooksecurefunc(GuildInstanceDifficulty, 'Show', function()
    isGuildGroup = true
    HideDiffFrame()
end)

hooksecurefunc(GuildInstanceDifficulty, 'Hide', function()
    isGuildGroup = false
end)

hooksecurefunc(MiniMapInstanceDifficulty, 'Show', function()
    HideDiffFrame()
end)

GuildInstanceDifficulty:HookScript('OnEvent', function(self)
    if (self:IsShown()) then
        isGuildGroup = true
    else
        isGuildGroup = false
    end
end)

--[[
Minimap:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
Minimap:RegisterEvent('PLAYER_GUILD_UPDATE')
Minimap:RegisterEvent('PLAYER_ENTER_WORLD')

Minimap:HookScript('OnEvent', function(self, event, ...)
    local isGuildGroup = ...
        
    if (isGuildGroup or InGuildParty()) then
        isGuildGroup = true
    elseif (not IsInGuild()) then
        isGuildGroup = nil
    else
        isGuildGroup = nil
    end
end)
--]]

local f = CreateFrame('Frame')
f:SetAlpha(0)
f:SetParent(Minimap)

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetParent(f)
f.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
f.Text:SetPoint('TOP', Minimap, 0, -3.5)
f.Text:SetTextColor(1, 1, 1)

function GetDifficultyText()
	local inInstance, instancetype = IsInInstance()
	local _, _, difficultyIndex, difficultyName, maxPlayers, playerDifficulty, isDynamic = GetInstanceInfo()
    
    -- /run print(InGuildParty())
    local guildGroup
    if (isGuildGroup or GuildInstanceDifficulty:IsShown()) then
        guildGroup = '|cffffff00G|r'
    else
        guildGroup = ''
    end
    
    local heroStyle = '|cffff00ffH|r'
	if (inInstance and instancetype == 'raid') then
    
		if (isDynamic) then
            if (difficultyIndex == 4 or difficultyIndex == 3) then
                if (playerDifficulty == 0) then
                    return maxPlayers..guildGroup..heroStyle
                end
            end
        
            if (difficultyIndex == 2) then
                return maxPlayers..guildGroup
            end
        
            if (difficultyIndex == 1) then
                if (playerDifficulty == 0) then
                    return maxPlayers..guildGroup
                end
                
                if (playerDifficulty == 1) then
                    return maxPlayers..guildGroup..heroStyle
                end
            end
        end
        
		if (not isDynamic) then
			if (difficultyIndex == 1 or difficultyIndex == 2) then
				return maxPlayers..guildGroup
			end

			if (difficultyIndex == 3 or difficultyIndex == 4) then
				return maxPlayers..guildGroup..heroStyle
			end
		end
	end
    
    if (inInstance and instancetype == 'party') then
        if (difficultyIndex == 2)then
            return maxPlayers..guildGroup..heroStyle
        elseif (difficultyIndex == 1)then
            return maxPlayers..guildGroup
        end
    end
    
	if (not inInstance) then
		return '' 
	end
end

Minimap:HookScript('OnEnter', function()
    f.Text:SetText(GetDifficultyText())
    UIFrameFadeIn(f, 0.235, f:GetAlpha(), 1)
end)

Minimap:HookScript('OnLeave', function()
    UIFrameFadeOut(f, 0.235, f:GetAlpha(), 0)
    f.Text:SetText(GetDifficultyText())
end)
