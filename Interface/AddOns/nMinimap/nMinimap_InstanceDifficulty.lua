
local isGuildGroup = isGuildGroup

local function HideDiffFrame()
    GuildInstanceDifficulty:EnableMouse(false)
    GuildInstanceDifficulty:SetAlpha(0)
    
    MiniMapInstanceDifficulty:EnableMouse(false)
    MiniMapInstanceDifficulty:SetAlpha(0)
end

function GetDifficultyText()
	local inInstance, instancetype = IsInInstance()
	local _, _, difficultyIndex, difficultyName, maxPlayers, playerDifficulty, isDynamic = GetInstanceInfo()
    
    local guildStyle
    local heroStyle = '|cffff00ffH|r'

    if (isGuildGroup or GuildInstanceDifficulty:IsShown()) then
        guildStyle = '|cffffff00G|r'
    else
        guildStyle = ''
    end
    
	if (inInstance and instancetype == 'raid') then
    
		if (isDynamic) then
            if (difficultyIndex == 4 or difficultyIndex == 3) then
                if (playerDifficulty == 0) then
                    return maxPlayers..guildStyle..heroStyle
                end
            end
        
            if (difficultyIndex == 2) then
                return maxPlayers..guildStyle
            end
        
            if (difficultyIndex == 1) then
                if (playerDifficulty == 0) then
                    return maxPlayers..guildStyle
                end
                
                if (playerDifficulty == 1) then
                    return maxPlayers..guildStyle..heroStyle
                end
            end
        end
        
		if (not isDynamic) then
			if (difficultyIndex == 1 or difficultyIndex == 2) then
				return maxPlayers..guildStyle
			end

			if (difficultyIndex == 3 or difficultyIndex == 4) then
				return maxPlayers..guildStyle..heroStyle
			end
		end
	end
    
    if (inInstance and instancetype == 'party') then
        if (difficultyIndex == 2)then
            return maxPlayers..guildStyle..heroStyle
        elseif (difficultyIndex == 1)then
            return maxPlayers..guildStyle
        end
    end
    
	if (not inInstance) then
		return '' 
	end
end

    -- create the mouseover frame
    
local f = CreateFrame('Frame')
f:SetAlpha(0)
f:SetParent(Minimap)

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetParent(f)
f.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
f.Text:SetPoint('TOP', Minimap, 0, -3.5)
f.Text:SetTextColor(1, 1, 1)

    -- no real hide, just a fake hide because we need it for the guild indicator
    
-- MiniMapInstanceDifficulty:UnregisterAllEvents()
MiniMapInstanceDifficulty:Hide()
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 1, 5)
MiniMapInstanceDifficulty:SetScale(0.9)

-- GuildInstanceDifficulty:UnregisterAllEvents()
-- GuildInstanceDifficulty:Hide()
GuildInstanceDifficulty:Show()
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 1, 5)
GuildInstanceDifficulty:SetScale(0.9)   

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

Minimap:HookScript('OnEnter', function()
    f.Text:SetText(GetDifficultyText())
    securecall('UIFrameFadeIn', f, 0.235, f:GetAlpha(), 1)
end)

Minimap:HookScript('OnLeave', function()
    securecall('UIFrameFadeOut', f, 0.235, f:GetAlpha(), 0)
    f.Text:SetText(GetDifficultyText())
end)