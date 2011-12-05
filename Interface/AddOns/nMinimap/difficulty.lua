
local _, nMinimap = ...
local cfg = nMinimap.Config

local isGuildGroup = isGuildGroup

local function HideDifficultyFrame()
    GuildInstanceDifficulty:EnableMouse(false)
    GuildInstanceDifficulty:SetAlpha(0)

    MiniMapInstanceDifficulty:EnableMouse(false)
    MiniMapInstanceDifficulty:SetAlpha(0)
end

function GetDifficultyText()
    local inInstance, instancetype = IsInInstance()
    local _, _, difficultyIndex, _, maxPlayers, playerDifficulty, isDynamic = GetInstanceInfo()

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

local f = Minimap
f.InstanceText = f:CreateFontString(nil, 'OVERLAY')
f.InstanceText:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
f.InstanceText:SetPoint('TOP', Minimap, 0, -3.5)
f.InstanceText:SetTextColor(1, 1, 1)
f.InstanceText:Show()

--[[
MiniMapInstanceDifficulty:UnregisterAllEvents()
MiniMapInstanceDifficulty:Hide()
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 1, 5)
MiniMapInstanceDifficulty:SetScale(0.9)

GuildInstanceDifficulty:UnregisterAllEvents()
GuildInstanceDifficulty:Hide()
GuildInstanceDifficulty:Show()
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint('TOPLEFT', Minimap, 1, 5)
GuildInstanceDifficulty:SetScale(0.9)   
--]]

hooksecurefunc(GuildInstanceDifficulty, 'Show', function()
    isGuildGroup = true
    HideDifficultyFrame()
end)

hooksecurefunc(GuildInstanceDifficulty, 'Hide', function()
    isGuildGroup = false
end)

hooksecurefunc(MiniMapInstanceDifficulty, 'Show', function()
    HideDifficultyFrame()
end)

GuildInstanceDifficulty:HookScript('OnEvent', function(self)
    if (self:IsShown()) then
        isGuildGroup = true
    else
        isGuildGroup = false
    end

    Minimap.InstanceText:SetText(GetDifficultyText())
end)

MiniMapInstanceDifficulty:HookScript('OnEvent', function(self)
    Minimap.InstanceText:SetText(GetDifficultyText())
end)

if (cfg.mouseover.instanceDifficulty) then
    f.InstanceText:SetAlpha(0)

    Minimap:HookScript('OnEnter', function(self)
        securecall('UIFrameFadeIn', self.InstanceText, 0.235, 0, 1)
    end)

    Minimap:HookScript('OnLeave', function(self)
        securecall('UIFrameFadeOut', self.InstanceText, 0.235, 1, 0)
    end)
end
