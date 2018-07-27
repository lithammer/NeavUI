
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.showPicomenu) then
    return
end

local x, x2, n = nil, false
local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11

local menuFrame = CreateFrame("Frame", "picomenuDropDownMenu", MainMenuBar, "UIDropDownMenuTemplate")

local menuList = {
    {
        text = MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true,
    },
    {
        text = CHARACTER_BUTTON,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            securecall(ToggleCharacter, "PaperDollFrame")
        end,
        notCheckable = true,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        icon = "Interface\\MINIMAP\\TRACKING\\Class",
        func = function()
            securecall(ToggleFrame, SpellBookFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK"),
        tooltipText = NEWBIE_TOOLTIP_SPELLBOOK,
        notCheckable = true,
    },
    {
        text = TALENTS_BUTTON,
        icon = "Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuTalents",
        func = function()
            if (not PlayerTalentFrame) then
                LoadAddOn("Blizzard_TalentUI")
            end

            if (not GlyphFrame) then
                LoadAddOn("Blizzard_GlyphUI")
            end

            securecall(ToggleFrame, PlayerTalentFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, TALENTS_BUTTON, "TOGGLETALENTS"),
        tooltipText = NEWBIE_TOOLTIP_TALENTS,
        notCheckable = true,
    },
    {
        text = ACHIEVEMENT_BUTTON,
        icon = "Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuAchievement",
        func = function()
            securecall(ToggleAchievementFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT"),
        tooltipText = NEWBIE_TOOLTIP_ACHIEVEMENT,
        notCheckable = true,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = "Interface\\GossipFrame\\ActiveQuestIcon",
        func = function()
            securecall(ToggleFrame, WorldMapFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, QUESTLOG_BUTTON, "TOGGLEQUESTLOG"),
        tooltipText = NEWBIE_TOOLTIP_QUESTLOG,
        notCheckable = true,
    },
    {
        text = GUILD,
        icon = "Interface\\GossipFrame\\TabardGossipIcon",
        arg1 = IsInGuild("player"),
        func = function()
            if (IsTrialAccount()) then
                UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT, 1, 0, 0)
            else
                securecall(ToggleGuildFrame)
            end
        end,
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        icon = "Interface\\FriendsFrame\\PlusManz-BattleNet",
        func = function()
            securecall(ToggleFriendsFrame, 1)
        end,
        notCheckable = true,
    },
    {
        text = PLAYER_V_PLAYER,
        icon = "Interface\\MINIMAP\\TRACKING\\BattleMaster",
        func = function()
            securecall(PVEFrame_ToggleFrame, "PVPUIFrame", HonorFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, PLAYER_V_PLAYER, "TOGGLECHARACTER4"),
        tooltipText = NEWBIE_TOOLTIP_PVP,
        notCheckable = true,
    },
    {
        text = DUNGEONS_BUTTON,
        icon = "Interface\\LFGFRAME\\BattleNetWorking0",
        func = function()
            securecall(PVEFrame_ToggleFrame, "GroupFinderFrame")
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, DUNGEONS_BUTTON, "TOGGLELFGPARENT"),
        tooltipText = NEWBIE_TOOLTIP_LFGPARENT,
        notCheckable = true,
    },
    {
        text = CHALLENGES,
        icon = "Interface\\BUTTONS\\UI-GroupLoot-DE-Up",
        func = function()
            securecall(PVEFrame_ToggleFrame, "ChallengesFrame")
        end,
        notCheckable = true,
    },
    {
        text = RAID,
        icon = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull",
        func = function()
            securecall(ToggleFriendsFrame, 4)
        end,
        notCheckable = true,
    },
    {
        text = MOUNTS,
        icon = "Interface\\MINIMAP\\TRACKING\\StableMaster",
        func = function()
            securecall(ToggleCollectionsJournal, 1)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, MOUNTS_AND_PETS, "TOGGLEPETJOURNAL"),
        tooltipText = NEWBIE_TOOLTIP_MOUNTS_AND_PETS,
        notCheckable = true,
    },
	{
        text = PETS,
        icon = "Interface\\MINIMAP\\TRACKING\\StableMaster",
        func = function()
            securecall(ToggleCollectionsJournal, 2)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, MOUNTS_AND_PETS, "TOGGLEPETJOURNAL"),
        tooltipText = NEWBIE_TOOLTIP_MOUNTS_AND_PETS,
        notCheckable = true,
    },
    {
        text = TOY_BOX,
        icon = "Interface\\MINIMAP\\TRACKING\\Reagents",
        func = function()
            securecall(ToggleCollectionsJournal, 3)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, TOY_BOX, "TOGGLETOYBOX"),
        tooltipText = TOY_BOX,
        notCheckable = true,
    },
    {
        text = HEIRLOOMS,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            securecall(ToggleCollectionsJournal, 4)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, HEIRLOOMS, "TOGGLEHEIRLOOMS"),
        tooltipText = HEIRLOOMS,
        notCheckable = true,
    },
    {
        text = WARDROBE,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            securecall(ToggleCollectionsJournal, 5)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, WARDROBE, "TOGGLEHEIRLOOMS"),
        tooltipText = WARDROBE,
        notCheckable = true,
    },
    {
        text = ENCOUNTER_JOURNAL,
        icon = "Interface\\MINIMAP\\TRACKING\\Profession",
        func = function()
            securecall(ToggleEncounterJournal)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, ENCOUNTER_JOURNAL, "TOGGLEENCOUNTERJOURNAL"),
        tooltipText = NEWBIE_TOOLTIP_ENCOUNTER_JOURNAL,
        notCheckable = true,
    },
    {
        text = GM_EMAIL_NAME,
        icon = "Interface\\CHATFRAME\\UI-ChatIcon-Blizz",
        func = function()
            securecall(ToggleHelpFrame)
        end,
        tooltipTitle = HELP_BUTTON,
        tooltipText = NEWBIE_TOOLTIP_HELP,
        notCheckable = true,
    },
    {
        text = BATTLEFIELD_MINIMAP,
        colorCode = "|cff999999",
        func = function()
            securecall(ToggleBattlefieldMinimap)
        end,
        notCheckable = true,
    },
}

local addonMenuTable = {
    {
        text = "                               ",
        isTitle = true,
        notCheckable = true,
    },
    {   text = ADDONS,
        hasArrow = true,
        notCheckable = true,
        menuList = {
            {
                text = ADDONS,
                isTitle = true,
                notCheckable = true,
            },
        }
    }
}

local function UpdateAddOnTable()
    if (IsAddOnLoaded("oUF_NeavRaid") and not v1) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v1 = true
        addonMenuTable[2].menuList[n] = {
            text = "NeavRaid",
            func = function()
                SlashCmdList["oUF_Neav_Raid_AnchorToggle"]()
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("VuhDo") and not v2) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v2 = true
        addonMenuTable[2].menuList[n] = {
            text = "VuhDo",
            func = function()
                SlashCmdList["VUHDO"]("toggle")
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if ((IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2")) and not v3) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v3 = true
        addonMenuTable[2].menuList[n] = {
            text = "Grid",
            func = function()
                if (IsAddOnLoaded("Grid2")) then
                    ToggleFrame(Grid2LayoutFrame)
                elseif (IsAddOnLoaded("Grid")) then
                    ToggleFrame(GridLayoutFrame)
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("Omen") and not v4) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v4 = true
        addonMenuTable[2].menuList[n] = {
            text = "Omen",
            func = function()
                if (IsShiftKeyDown()) then
                    Omen:Toggle()
                else
                    Omen:ShowConfig()
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("PhoenixStyle") and not v5) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v5 = true
        addonMenuTable[2].menuList[n] = {
                text = "PhoenixStyle",
                func = function()
                    ToggleFrame(PSFmain1)
                    ToggleFrame(PSFmain2)
                    ToggleFrame(PSFmain3)
                end,
                notCheckable = true,
                keepShownOnClick = true,
            }
    end

    if (IsAddOnLoaded("DBM-Core") and not v6) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v6 = true
        addonMenuTable[2].menuList[n] = {
            text = "DBM",
            func = function()
                DBM:LoadGUI()
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("Skada") and not v7) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v7 = true
        addonMenuTable[2].menuList[n] = {
            text = "Skada",
            func = function()
                Skada:ToggleWindow()
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("Recount") and not v8) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v8 = true
        addonMenuTable[2].menuList[n] = {
            text = "Recount",
            func = function()
                ToggleFrame(Recount.MainWindow)
                if (Recount.MainWindow:IsShown()) then
                    Recount:RefreshMainWindow()
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("TinyDPS") and not v9) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v9 = true
        addonMenuTable[2].menuList[n] = {
            text = "TinyDPS",
            func = function()
                ToggleFrame(tdpsFrame)
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("Numeration") and not v10) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v10 = true
        addonMenuTable[2].menuList[n] = {
            text = "Numeration",
            func = function()
                if (not IsShiftKeyDown()) then
                    ToggleFrame(NumerationFrame)
                else
                    StaticPopup_Show("RESET_DATA")
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("AtlasLoot") and not v11) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v11 = true
        addonMenuTable[2].menuList[n] = {
            text = "AtlasLoot",
            func = function()
                AtlasLoot.GUI:Toggle()
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (IsAddOnLoaded("Altoholic") and not v12) then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v12 = true
        addonMenuTable[2].menuList[n] = {
            text = "Altoholic",
            func = function()
                ToggleFrame(AltoholicFrame)
            end,
            notCheckable = true,
            keepShownOnClick = true,
        }
    end

    if (x and not x2) then
        table.insert(menuList, addonMenuTable[1])
        table.insert(menuList, addonMenuTable[2])
        x2 = true
    end
end

local f = CreateFrame("Button", nil, MainMenuBar)
f:SetFrameStrata("HIGH")
f:SetToplevel(true)
f:SetSize(30, 30)
f:SetPoint("BOTTOM", MainMenuBarArtFrame.RightEndCap, -13, 8)
f:RegisterForClicks("Anyup")
f:RegisterEvent("ADDON_LOADED")

f:SetNormalTexture("Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuNormal")
f:GetNormalTexture():SetSize(30, 30)

f:SetHighlightTexture("Interface\\AddOns\\nMainbar\\media\\picomenu\\picomenuHighlight")
f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())

f:SetScript("OnEvent", function()
    UpdateAddOnTable(arg1)
end)

f:SetScript("OnMouseDown", function(self)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint("CENTER", 1, -1)
end)

f:SetScript("OnMouseUp", function(self, button)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint("CENTER")

    if (button == "LeftButton") then
        if (self:IsMouseOver()) then
            if (DropDownList1:IsShown()) then
                DropDownList1:Hide()
            else
                securecall(EasyMenu, menuList, menuFrame, self, 3, 290, "MENU", 8)
                -- DropDownList1:ClearAllPoints()
                -- DropDownList1:SetPoint("BOTTOMLEFT", self, "TOPRIGHT")
            end
        end
    else
        if (self:IsMouseOver()) then
            ToggleFrame(GameMenuFrame)
        end
    end

    GameTooltip:Hide()
end)

f:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 25, -5)
    GameTooltip:AddLine(MAINMENU_BUTTON)
    GameTooltip:Show()
end)

f:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

HelpOpenWebTicketButton:ClearAllPoints()
HelpOpenWebTicketButton:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", -26, 26)
HelpOpenWebTicketButton:SetScale(0.6)
HelpOpenWebTicketButton:SetParent(f)
