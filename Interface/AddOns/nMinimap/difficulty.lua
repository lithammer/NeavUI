
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
    local _, _, difficultyIndex, _, maxPlayers, playerDifficulty, _ = GetInstanceInfo()

    local instanceText = ''
    local guildStyle
    local mythicStyle = '|cffff0000M|r'
    local heroStyle = '|cffff00ffH|r'
    local lookingForRaidStyle = '|cffffffffLFR'

    if (isGuildGroup or GuildInstanceDifficulty:IsShown()) then
        guildStyle = '|cffffff00G|r'
    else
        guildStyle = ''
    end

    local isMythicIndex = {
        [DIFFICULTY_PRIMARYRAID_MYTHIC] = true
    }

    local isHeroicIndex = {
        [DIFFICULTY_DUNGEON_HEROIC] = true,
        [DIFFICULTY_PRIMARYRAID_HEROIC] = true,
        [DIFFICULTY_RAID10_HEROIC] = true,
        [DIFFICULTY_RAID25_HEROIC] = true,
        [DIFFICULTY_DUNGEON_CHALLENGE] = true
    }

    local isLookingForRaidIndex = {
        [DIFFICULTY_PRIMARYRAID_LFR] = true,
        [DIFFICULTY_RAID_LFR] = true
    }

    if (inInstance) then
        instanceText = maxPlayers..guildStyle

        if (isMythicIndex[difficultyIndex]) then
            instanceText = instanceText..mythicStyle
        end

        if (isHeroicIndex[difficultyIndex]) then
            instanceText = instanceText..heroStyle
        end

        if (isLookingForRaidIndex[difficultyIndex]) then
            instanceText = lookingForRaidStyle
        end
    end

    return instanceText
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
    Minimap.InstanceText:SetAlpha(0)

    Minimap:HookScript('OnEnter', function(self)
        securecall('UIFrameFadeIn', self.InstanceText, 0.235, 0, 1)
    end)

    Minimap:HookScript('OnLeave', function(self)
        securecall('UIFrameFadeOut', self.InstanceText, 0.235, 1, 0)
    end)
end
