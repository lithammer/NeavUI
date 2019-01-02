local _, nMainbar = ...
local cfg = nMainbar.Config

if IsAddOnLoaded("AdiButtonAuras") then
    AdiButtonAuras:RegisterLAB("LibActionButton-1.0-nMainbar")
end

    -- Functions

function nMainbar:IsTaintable()
    return (InCombatLockdown() or (UnitAffectingCombat("player") or UnitAffectingCombat("pet")))
end

function nMainbar:CreateAnchor(name, width, height, location)
    local anchorFrame = CreateFrame("Frame", name.."_Anchor", UIParent)
    anchorFrame:SetSize(width, height)
    anchorFrame:SetScale(1)
    anchorFrame:SetPoint(unpack(location))
    anchorFrame:SetFrameStrata("HIGH")
    anchorFrame:SetMovable(true)
    anchorFrame:SetClampedToScreen(true)
    anchorFrame:SetUserPlaced(true)
    anchorFrame:SetBackdrop({bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background",})
    anchorFrame:EnableMouse(true)
    anchorFrame:RegisterForDrag("LeftButton")
    anchorFrame:Hide()

    anchorFrame.text = anchorFrame:CreateFontString(nil, "OVERLAY")
    anchorFrame.text:SetAllPoints(anchorFrame)
    anchorFrame.text:SetFont(STANDARD_TEXT_FONT, 13)
    anchorFrame.text:SetText(name)

    anchorFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    anchorFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    return anchorFrame
end

-- End Caps

if cfg.MainMenuBar.hideGryphons then
    MainMenuBarArtFrame.LeftEndCap:SetTexCoord(0, 0, 0, 0)
    MainMenuBarArtFrame.RightEndCap:SetTexCoord(0, 0, 0, 0)
end

-- Fill Status Bar Gap

if not MainMenuBarArtFrame.BottomArt then
    MainMenuBarArtFrame.BottomArt = MainMenuBarArtFrame:CreateTexture("MainMenuBarBottomArt", "OVERLAY")
    MainMenuBarArtFrame.BottomArt:SetPoint("LEFT", MainMenuBarArtFrame.LeftEndCap, "RIGHT", -30, 0)
    MainMenuBarArtFrame.BottomArt:SetPoint("RIGHT", MainMenuBarArtFrame.RightEndCap, "LEFT", 30, 0)
    MainMenuBarArtFrame.BottomArt:SetPoint("BOTTOM", UIParent)
    MainMenuBarArtFrame.BottomArt:SetColorTexture(0.40 ,0.40 ,0.40, 1.0)
    MainMenuBarArtFrame.BottomArt:SetHeight(1)
end

--  Update Action Bars

OverrideActionBar:SetScale(cfg.vehicleBar.scale)

hooksecurefunc("MultiActionBar_Update", function(self)
    if nMainbar:IsTaintable() then
        return
    end

    -- Right Bars Scale & Alpha

    MultiBarLeft:SetAlpha(cfg.multiBarRight.alpha)
    MultiBarLeft:SetScale(cfg.multiBarRight.scale)
    MultiBarRight:SetAlpha(cfg.multiBarRight.alpha)
    MultiBarRight:SetScale(cfg.multiBarRight.scale)

    -- Move Right Bars (Checks if player is using stacking right bar option.)

    if GetCVar("multiBarRightVerticalLayout") == "0" then
        VerticalMultiBarsContainer:ClearAllPoints()
        VerticalMultiBarsContainer:SetPoint("TOPRIGHT", UIParent, "RIGHT", -2, (VerticalMultiBarsContainer:GetHeight() / 2))
    end
end)

-- Extra Action Button

local ExtraActionBarFrameLocation = {"CENTER", UIParent, "CENTER", -300, -150}
local ExtraActionBarFrameAnchor = nMainbar:CreateAnchor("EAB", ExtraActionButton1:GetWidth(), ExtraActionButton1:GetHeight(), ExtraActionBarFrameLocation)

SlashCmdList["nMainbar_MoveExtraActionBar"] = function()
    if InCombatLockdown() then
        print("|cffCC3333n|rMainbar: "..ERR_NOT_IN_COMBAT)
        return
    end
    if not ExtraActionBarFrameAnchor:IsShown() then
        ExtraActionBarFrameAnchor:Show()
    else
        ExtraActionBarFrameAnchor:Hide()
    end
end
SLASH_nMainbar_MoveExtraActionBar1 = "/moveextraactionbar"

ExtraActionButton1:ClearAllPoints()
ExtraActionButton1:SetPoint("CENTER", ExtraActionBarFrameAnchor)

-- Possess Bar

PossessBarFrame:SetScale(cfg.possessBar.scale)
PossessBarFrame:SetAlpha(cfg.possessBar.alpha)

-- Stance Bar

StanceBarLeft:SetTexture(nil)
StanceBarMiddle:SetTexture(nil)
StanceBarRight:SetTexture(nil)

StanceBarFrame:SetFrameStrata("MEDIUM")

StanceBarFrame:SetScale(cfg.stanceBar.scale)
StanceBarFrame:SetAlpha(cfg.stanceBar.alpha)

if cfg.stanceBar.hide then
    hooksecurefunc("StanceBar_Update", function()
        if StanceBarFrame:IsShown() and not nMainbar:IsTaintable() then
            RegisterStateDriver(StanceBarFrame, "visibility", "hide")
        end
    end)
end

-- Pet Bar

SlidingActionBarTexture0:SetTexture(nil)
SlidingActionBarTexture1:SetTexture(nil)
PetActionBarFrame:SetFrameStrata("MEDIUM")
PetActionBarFrame:SetScale(cfg.petBar.scale)
PetActionBarFrame:SetAlpha(cfg.petBar.alpha)

if cfg.petBar.vertical then
    for i = 2, 10 do
        local button = _G["PetActionButton"..i]
        button:ClearAllPoints()
        button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -8)
    end
end

hooksecurefunc("PetActionButton_SetHotkeys", function(self)
    local hotkey = _G[self:GetName().."HotKey"]
    if not cfg.button.showKeybinds then
        hotkey:Hide()
    end
end)

if not cfg.button.showKeybinds then
    for i = 1, NUM_PET_ACTION_SLOTS, 1 do
        local buttonName = _G["PetActionButton"..i]
        PetActionButton_SetHotkeys(buttonName)
    end
end

    -- Move exit vehicle button.

hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function()
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("CENTER", MainMenuBarArtFrame.RightEndCap, "TOP", 0, 15)
end)
