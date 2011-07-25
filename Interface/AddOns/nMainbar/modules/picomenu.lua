
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.showPicomenu) then
    return
end

INTERFACE_ACTION_BLOCKED = ''

    -- Creating the dropdown menu, using the EasyMenu function

local menuFrame = CreateFrame('Frame', 'PicoMenuDropDownMenu', MainMenuBar, 'UIDropDownMenuTemplate')
local menuList = {
    {
        text = MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true,
    },
    {
        text = CHARACTER_BUTTON,
        icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
        func = function() 
            securecall(ToggleCharacter, 'PaperDollFrame') 
        end,
        notCheckable = true,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Class',
        func = function() 
            securecall(ToggleSpellBook, BOOKTYPE_SPELL)
        end,
        notCheckable = true,
    },
    {
        text = TALENTS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
        -- icon = 'Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuTalents',
        func = function() 
            securecall(ToggleTalentFrame) 
        end,
        notCheckable = true,
    },
    {
        text = ACHIEVEMENT_BUTTON,
        icon = 'Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuAchievement',
        func = function() 
            securecall(ToggleAchievementFrame) 
        end,
        notCheckable = true,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
        func = function() 
            securecall(ToggleFrame, QuestLogFrame) 
        end,
        notCheckable = true,
    },
    {
        text = GUILD,
        icon = 'Interface\\GossipFrame\\TabardGossipIcon',
        arg1 = IsInGuild('player'),
        func = function() 
            if (IsInGuild('player')) then
                securecall(ToggleGuildFrame)
            else
                return
            end
        end,
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
        func = function() 
            securecall(ToggleFriendsFrame, 1) 
        end,
        notCheckable = true,
    },
    {
        text = PLAYER_V_PLAYER,
        icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
        func = function() 
            securecall(ToggleFrame, PVPFrame) 
        end,
        notCheckable = true,
    },
    {
        text = DUNGEONS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\None',
        func = function() 
            securecall(ToggleLFDParentFrame)
        end,
        notCheckable = true,
    },
    {
        text = RAID,
        icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
        func = function() 
            securecall(ToggleFriendsFrame, 4)
        end,
        notCheckable = true,
    },
    {
        text = ENCOUNTER_JOURNAL,
        icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
        func = function() 
            securecall(ToggleFrame, EncounterJournal)
        end,
        notCheckable = true,
    },
    {
        text = GM_EMAIL_NAME,
        icon = 'Interface\\TUTORIALFRAME\\TutorialFrame-QuestionMark',
        func = function() 
            securecall(ToggleHelpFrame) 
        end,
        notCheckable = true,
    },
    {
        text = BATTLEFIELD_MINIMAP,
        colorCode = '|cff999999',
        func = function() 
            securecall(ToggleBattlefieldMinimap) 
        end,
        notCheckable = true,
    }
}

local f = CreateFrame('Button', nil, MainMenuBar)
f:SetFrameStrata('HIGH')
f:SetToplevel(true)
f:SetSize(30, 30)
f:SetPoint('BOTTOM', MainMenuBarRightEndCap, -13, 8)
f:RegisterForClicks('Anyup')

f:SetNormalTexture('Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuNormal')
f:GetNormalTexture():SetSize(30, 30)

f:SetHighlightTexture('Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuHighlight')
f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())

f:SetScript('OnMouseDown', function(self)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint('CENTER', 1, -1)
end)

f:SetScript('OnMouseUp', function(self, button)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint('CENTER')
    
    if (button == 'LeftButton') then
        if (self:IsMouseOver()) then
            if (DropDownList1:IsShown()) then
                DropDownList1:Hide()
            else
                securecall(EasyMenu, menuList, menuFrame, self, 25, 25, 'MENU', 0.01)
            end
        end
    else
        if (self:IsMouseOver()) then
            ToggleFrame(GameMenuFrame)
        end
    end

    GameTooltip:Hide()
end)

f:SetScript('OnEnter', function(self) 
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 25, -5)
    GameTooltip:AddLine(MAINMENU_BUTTON)
    GameTooltip:Show()
end)

f:SetScript('OnLeave', function() 
    GameTooltip:Hide()
end)