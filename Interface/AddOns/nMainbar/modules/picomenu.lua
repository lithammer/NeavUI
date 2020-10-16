local _, nMainbar = ...
local cfg = nMainbar.Config

if not cfg.showPicomenu then
    return
end

    -- Pico Menu Dropdown

local x, x2, n = nil, false
local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
local BLOCKED_IN_COMBAT = "UI Action Blocked"

local menuFrame = CreateFrame("Frame", "picomenuDropDownMenu", MainMenuBar, "UIDropDownMenuTemplate")

local menuList = {
    {
        text = MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = CHARACTER_BUTTON,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            ToggleCharacter("PaperDollFrame")
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        icon = "Interface\\MINIMAP\\TRACKING\\Class",
        func = function()
            if not nMainbar:IsTaintable() then
                ToggleSpellBook(BOOKTYPE_SPELL)
            else
                UIErrorsFrame:AddMessage(BLOCKED_IN_COMBAT, 1, 0, 0)
            end
        end,
        notCheckable = true,
        disabled = nMainbar:IsTaintable(),
        fontObject = Game13Font,
    },
    {
        text = TALENTS,
        icon = "Interface\\AddOns\\nMainbar\\Media\\picomenu\\picomenuTalents",
        func = function()
            ToggleTalentFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = ACHIEVEMENT_BUTTON,
        icon = "Interface\\AddOns\\nMainbar\\Media\\picomenu\\picomenuAchievement",
        func = function()
            ToggleAchievementFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = "Interface\\GossipFrame\\ActiveQuestIcon",
        func = function()
            ToggleQuestLog()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = COMMUNITIES_FRAME_TITLE,
        icon = "Interface\\GossipFrame\\TabardGossipIcon",
        arg1 = IsInGuild("player"),
        func = function()
            ToggleGuildFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = SOCIAL_BUTTON,
        icon = "Interface\\FriendsFrame\\PlusManz-BattleNet",
        func = function()
            ToggleFriendsFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = PLAYER_V_PLAYER,
        icon = "Interface\\MINIMAP\\TRACKING\\BattleMaster",
        func = function()
            TogglePVPUI()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = DUNGEONS_BUTTON,
        icon = "Interface\\LFGFRAME\\BattleNetWorking0",
        func = function()
            ToggleLFDParentFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = CHALLENGES,
        icon = "Interface\\BUTTONS\\UI-GroupLoot-DE-Up",
        func = function()
            PVEFrame_ToggleFrame("ChallengesFrame",nil)
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = RAID,
        icon = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull",
        func = function()
            ToggleRaidFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = MOUNTS,
        icon = "Interface\\MINIMAP\\TRACKING\\StableMaster",
        func = function()
            if not nMainbar:IsTaintable() then
                ToggleCollectionsJournal(1)
            else
                UIErrorsFrame:AddMessage(BLOCKED_IN_COMBAT, 1, 0, 0)
            end
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = PETS,
        icon = "Interface\\MINIMAP\\TRACKING\\StableMaster",
        func = function()
            if not nMainbar:IsTaintable() then
                ToggleCollectionsJournal(2)
            else
                UIErrorsFrame:AddMessage(BLOCKED_IN_COMBAT, 1, 0, 0)
            end
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = TOY_BOX,
        icon = "Interface\\MINIMAP\\TRACKING\\Reagents",
        func = function()
            if not nMainbar:IsTaintable() then
                ToggleCollectionsJournal(3)
            else
                UIErrorsFrame:AddMessage(BLOCKED_IN_COMBAT, 1, 0, 0)
            end
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = HEIRLOOMS,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            if not nMainbar:IsTaintable() then
                ToggleCollectionsJournal(4)
            else
                UIErrorsFrame:AddMessage(BLOCKED_IN_COMBAT, 1, 0, 0)
            end
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = WARDROBE,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            if not nMainbar:IsTaintable() then
                ToggleCollectionsJournal(5)
            else
                UIErrorsFrame:AddMessage(BLOCKED_IN_COMBAT, 1, 0, 0)
            end
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = ENCOUNTER_JOURNAL,
        icon = "Interface\\MINIMAP\\TRACKING\\Profession",
        func = function()
            ToggleEncounterJournal()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = GM_EMAIL_NAME,
        icon = "Interface\\CHATFRAME\\UI-ChatIcon-Blizz",
        func = function()
            ToggleHelpFrame()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = BATTLEFIELD_MINIMAP,
        colorCode = "|cff999999",
        func = function()
            ToggleBattlefieldMap()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
}

local addonMenuTable = {
    {
        text = "                               ",
        isTitle = true,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {   text = ADDONS,
        hasArrow = true,
        notCheckable = true,
        fontObject = Game13Font,
        menuList = {
            {
                text = ADDONS,
                isTitle = true,
                notCheckable = true,
                fontObject = Game13Font,
            },
        }
    }
}

local function UpdateAddOnTable()
    if IsAddOnLoaded("oUF_NeavRaid") and not v1 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v1 = true
        addonMenuTable[2].menuList[n] = {
            text = "NeavRaid",
            func = function()
                SlashCmdList["oUF_Neav_Raid_AnchorToggle"]("toggle")
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("VuhDo") and not v2 then
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
            fontObject = Game13Font,
        }
    end

    if (IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2")) and not v3 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v3 = true
        addonMenuTable[2].menuList[n] = {
            text = "Grid",
            func = function()
                if IsAddOnLoaded("Grid2") then
                    ToggleFrame(Grid2LayoutFrame)
                elseif IsAddOnLoaded("Grid") then
                    ToggleFrame(GridLayoutFrame)
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("Omen") and not v4 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v4 = true
        addonMenuTable[2].menuList[n] = {
            text = "Omen",
            func = function()
                if IsShiftKeyDown() then
                    Omen:Toggle()
                else
                    Omen:ShowConfig()
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("PhoenixStyle") and not v5 then
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
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("DBM-Core") and not v6 then
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
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("Skada") and not v7 then
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
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("Recount") and not v8 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v8 = true
        addonMenuTable[2].menuList[n] = {
            text = "Recount",
            func = function()
                ToggleFrame(Recount.MainWindow)
                if Recount.MainWindow:IsShown() then
                    Recount:RefreshMainWindow()
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("TinyDPS") and not v9 then
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
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("Numeration") and not v10 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v10 = true
        addonMenuTable[2].menuList[n] = {
            text = "Numeration",
            func = function()
                if not IsShiftKeyDown() then
                    Numeration:ToggleVisibility()
                else
                    StaticPopup_Show("RESET_DATA")
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("AtlasLoot") and not v11 then
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
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("Altoholic") and not v12 then
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
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("Details") and not v13 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v13 = true
        addonMenuTable[2].menuList[n] = {
            text = "Details",
            func = function()
                if not IsShiftKeyDown() then
                    _detalhes:ToggleWindow(1)
                    _detalhes:ToggleWindow(2)
                else
                    _detalhes.tabela_historico:resetar()
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if IsAddOnLoaded("BigWigs") and not v14 then
        x = true
        n = (#addonMenuTable[2].menuList)+1
        v14 = true
        addonMenuTable[2].menuList[n] = {
            text = "BigWigs",
            func = function()
                if BigWigsOptions then
                    BigWigsOptions:Open()
                else
                    LoadAddOn("BigWigs_Options")
                    BigWigsOptions:Open()
                end
            end,
            notCheckable = true,
            keepShownOnClick = true,
            fontObject = Game13Font,
        }
    end

    if x and not x2 then
        table.insert(menuList, addonMenuTable[1])
        table.insert(menuList, addonMenuTable[2])
        x2 = true
    end
end

    -- Pico Menu Button

local picoMenu = CreateFrame("Button", nil, MainMenuBar)
picoMenu:SetFrameStrata("MEDIUM")
picoMenu:SetFrameLevel(3)
picoMenu:SetToplevel(true)
picoMenu:SetSize(30, 30)
picoMenu:SetPoint("BOTTOM", MainMenuBarArtFrame.RightEndCap, 0, 8)
picoMenu:RegisterForClicks("Anyup")
picoMenu:RegisterEvent("ADDON_LOADED")
picoMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
picoMenu:RegisterEvent("PLAYER_LEVEL_UP")
picoMenu:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
picoMenu:RegisterEvent("PLAYER_TALENT_UPDATE")

picoMenu:SetNormalTexture("Interface\\AddOns\\nMainbar\\Media\\picomenu\\picomenuNormal")
picoMenu:GetNormalTexture():SetSize(30, 30)

picoMenu:SetHighlightTexture("Interface\\AddOns\\nMainbar\\Media\\picomenu\\picomenuHighlight")
picoMenu:GetHighlightTexture():SetAllPoints(picoMenu:GetNormalTexture())

-- TODO: MicroButtonAlertTemplate is gone.
-- local alertFrame = CreateFrame("Frame", "nMainbarAlertFrame", picoMenu, "MicroButtonAlertTemplate")
-- alertFrame:SetSize(220,100)
-- alertFrame.Text:SetText(TALENT_MICRO_BUTTON_UNSPENT_TALENTS)
-- alertFrame:SetPoint("BOTTOM", picoMenu, "TOP", 0, 10)

-- picoMenu:SetScript("OnEvent", function(self, event, ...)
--     if event == "ADDON_LOADED" then
--         UpdateAddOnTable(arg1)
--     elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
--         if C_SpecializationInfo.CanPlayerUseTalentUI() and GetNumUnspentTalents() > 0 then
--             alertFrame:Show()
--         else
--             alertFrame:Hide()
--         end
--     end
-- end)

picoMenu:SetScript("OnMouseDown", function(self)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint("CENTER", 1, -1)
end)

picoMenu:SetScript("OnMouseUp", function(self, button)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint("CENTER")

    if button == "LeftButton" then
        if self:IsMouseOver() then
            if DropDownList1:IsShown() then
                DropDownList1:Hide()
            else
                EasyMenu(menuList, menuFrame, self, 3, 290, "MENU", 5)
            end
        end
    else
        if self:IsMouseOver() then
            if not GameMenuFrame:IsVisible() then
                ShowUIPanel(GameMenuFrame)
            else
                HideUIPanel(GameMenuFrame)
            end
        end
    end

    GameTooltip:Hide()
end)

picoMenu:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 25, -5)
    GameTooltip:AddLine(MAINMENU_BUTTON)
    GameTooltip:Show()
end)

picoMenu:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

    -- Move Ticket Icon

HelpOpenWebTicketButton:ClearAllPoints()
HelpOpenWebTicketButton:SetPoint("LEFT", picoMenu, "RIGHT", 0, 0)
HelpOpenWebTicketButton:SetScale(0.8)
HelpOpenWebTicketButton:SetParent(picoMenu)
