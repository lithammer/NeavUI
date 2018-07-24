
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.shortBar) then
    return
end

    -- Binding Info (Used in keybinding ui.)

BINDING_HEADER_NBAGS = "nBags"
BINDING_NAME_NBAGS_TOGGLE = "Toggle Bags"

    -- Saved Variable Setup

if BagsShown == nil then
    BagsShown = false
end

    -- Clear frame position.

MainMenuBarBackpackButton:ClearAllPoints()
CharacterBag0Slot:ClearAllPoints()
CharacterBag1Slot:ClearAllPoints()
CharacterBag2Slot:ClearAllPoints()
CharacterBag3Slot:ClearAllPoints()

    -- Set new frame position.

MainMenuBarBackpackButton:SetPoint('BOTTOMRIGHT', WorldFrame, 'BOTTOMRIGHT',0, 0)
CharacterBag0Slot:SetPoint('RIGHT', MainMenuBarBackpackButton, 'LEFT',0, 0)
CharacterBag1Slot:SetPoint('RIGHT', CharacterBag0Slot, 'LEFT',0, 0)
CharacterBag2Slot:SetPoint('RIGHT', CharacterBag1Slot, 'LEFT',0, 0)
CharacterBag3Slot:SetPoint('RIGHT', CharacterBag2Slot, 'LEFT',0, 0)

MicroButtonAndBagsBar.MicroBagBar:ClearAllPoints()
MicroButtonAndBagsBar.MicroBagBar:Hide()

CharacterMicroButton:ClearAllPoints()
CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)

hooksecurefunc('MoveMicroButtons', function(anchor, achorTo, relAnchor, x, y, isStacked)
    if not isStacked then
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
    end
end)

    -- Show Bags

local function BagShow()
    MainMenuBarBackpackButton:Show()
    CharacterBag0Slot:Show()
    CharacterBag1Slot:Show()
    CharacterBag2Slot:Show()
    CharacterBag3Slot:Show()
end

    -- Hide Bags

local function BagHide()
    MainMenuBarBackpackButton:Hide()
    CharacterBag0Slot:Hide()
    CharacterBag1Slot:Hide()
    CharacterBag2Slot:Hide()
    CharacterBag3Slot:Hide()
end

    -- Used to toggle bag with keybind.

function ToggleBags()
    if not BagsShown then
        BagShow()
        BagsShown = true
    else
        BagHide()
        BagsShown = false
    end
end

    -- Hides or shows bags on statup depending on saved variable.

local function onEvent(self, event)
    if BagsShown then
        BagShow()
    else
        BagHide()
    end
end

local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', onEvent)
addon:RegisterEvent('ADDON_LOADED')

SlashCmdList['nBag_Toggle'] = function()
    ToggleBags()
end
SLASH_nBag_Toggle1 = '/neavbag'
