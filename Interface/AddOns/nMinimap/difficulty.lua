
local _, nMinimap = ...
local cfg = nMinimap.Config

local isGuildGroup = nil

local function GetDifficultyText()
    local inInstance, instancetype = IsInInstance()
    local _, _, difficultyIndex, _, _, _, _, _, instanceGroupSize = GetInstanceInfo()
    local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic = GetDifficultyInfo(difficultyIndex)

    local instanceText = ""
    local guildStyle
    local heroStyle = "|cffff00ffH|r"

    if isGuildGroup or GuildInstanceDifficulty:IsShown() then
        guildStyle = "|cffffff00G|r"
    else
        guildStyle = ""
    end

    if inInstance then
        instanceText = instanceGroupSize..guildStyle

        if displayHeroic or isHeroic then
            instanceText = instanceText..heroStyle
        end

        if difficultyIndex == 12 or difficultyIndex == 147 then
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
