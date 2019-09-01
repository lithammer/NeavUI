
local _, nMinimap = ...
local cfg = nMinimap.Config

local isGuildGroup = nil

local function HideDifficultyFrame()
    GuildInstanceDifficulty:EnableMouse(false)
    GuildInstanceDifficulty:SetAlpha(0)

    MiniMapInstanceDifficulty:EnableMouse(false)
    MiniMapInstanceDifficulty:SetAlpha(0)

    MiniMapChallengeMode:EnableMouse(false)
    MiniMapChallengeMode:SetAlpha(0)
end

local function GetDifficultyText()
    local inInstance, instancetype = IsInInstance()
    local _, _, difficultyIndex, _, _, _, _, _, instanceGroupSize = GetInstanceInfo()
    local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic, _, isLFR = GetDifficultyInfo(difficultyIndex)

    local instanceText = ""
    local guildStyle
    local mythicStyle = "|cffff0000M|r"
    local heroStyle = "|cffff00ffH|r"
    local lookingForRaidStyle = "|cffffffffLFR|r"
    local timewalkerStyle = "|cffffffffTW|r"

    if isGuildGroup or GuildInstanceDifficulty:IsShown() then
        guildStyle = "|cffffff00G|r"
    else
        guildStyle = ""
    end

    if inInstance then
        instanceText = instanceGroupSize..guildStyle

        if displayMythic then
            instanceText = instanceText..mythicStyle
        elseif displayHeroic or isHeroic then
            instanceText = instanceText..heroStyle
        elseif isLFR then
            instanceText = lookingForRaidStyle
        end

        if difficultyIndex == 24 then
            instanceText = timewalkerStyle
        elseif difficultyIndex == 12 or difficultyIndex == 147 then
            instanceText = ""
        end
    end

    return instanceText
end

function nMinimapDifficulty_OnLoad(self)
    if cfg.mouseover.instanceDifficulty then
        self.Text:SetAlpha(0)

        Minimap:HookScript("OnEnter", function(self)
            securecall("UIFrameFadeIn", nMinimapDifficulty.Overlay.Text, 0.15, 0, 1)
        end)

        Minimap:HookScript("OnLeave", function(self)
            securecall("UIFrameFadeOut", nMinimapDifficulty.Overlay.Text, 0.15, 1, 0)
        end)
    end
end

if MiniMapInstanceDifficulty then
    hooksecurefunc("MiniMapInstanceDifficulty_Update", function(self, event, ...)
        if event == "GUILD_PARTY_STATE_UPDATED" then
            local isGuild = ...
            if isGuild ~= isGuildGroup then
                isGuildGroup = isGuild
            end
        end
        HideDifficultyFrame()
        nMinimapDifficulty.Overlay.Text:SetText(GetDifficultyText())
    end)
end
