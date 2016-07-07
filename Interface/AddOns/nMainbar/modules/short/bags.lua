
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.shortBar) then
    return
end

--Binding Info
BINDING_HEADER_NBAGS = "nBags"
BINDING_NAME_NBAGS_TOGGLE = "Toggle Bags"

-- Saved Variable Setup
if shown == nil then
    shown = false
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

-- Set !BeautyBorder Settings
if IsAddOnLoaded('!Beautycase') then
    MainMenuBarBackpackButton:CreateBeautyBorder(8)
    CharacterBag0Slot:CreateBeautyBorder(8)
    CharacterBag1Slot:CreateBeautyBorder(8)
    CharacterBag2Slot:CreateBeautyBorder(8)
    CharacterBag3Slot:CreateBeautyBorder(8)
end

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
    --print("Shown:"..tostring(shown))
    if not shown then
        BagShow()
        shown = true
    else
        BagHide()
        shown = false
    end
end

-- Hides or shows bags on statup depending on saved variable.
local function onEvent(self, event)
    if shown then
            BagShow()
        else
            BagHide()
    end
end

local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', onEvent)
addon:RegisterEvent('ADDON_LOADED')
