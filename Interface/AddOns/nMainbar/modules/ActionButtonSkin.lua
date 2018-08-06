local _, nMainbar = ...
local cfg = nMainbar.Config

local pairs = pairs
local unpack = unpack

local MEDIA_PATH = "Interface\\AddOns\\nMainbar\\Media\\"

local function IsSpecificButton(self, name)
    local sbut = self:GetName():match(name)
    if sbut then
        return true
    else
        return false
    end
end

hooksecurefunc("PetActionBar_Update", function(self)
    local petActionButton, petActionIcon
    for i=1, NUM_PET_ACTION_SLOTS, 1 do
        local buttonName = "PetActionButton" .. i
        petActionButton = _G[buttonName]
        petActionIcon = _G[buttonName.."Icon"]

        local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

        if texture then
            petActionIcon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            petActionButton:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
        else
            petActionButton:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
        end

        local hotkey = _G[buttonName.."HotKey"]

        if hotkey then
            if cfg.button.showKeybinds then
                hotkey:ClearAllPoints()
                hotkey:SetPoint("TOPRIGHT", buttonName, 0, -3)
                hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.petHotKeyFontsize, "OUTLINE")
                hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
            else
                hotkey:Hide()
            end
        end
    end
end)
securecall("PetActionBar_Update")

hooksecurefunc("PossessBar_UpdateState", function()
    local button, icon

    for i=1, NUM_POSSESS_SLOTS do
        button = _G["PossessButton"..i]
        icon = _G["PossessButton"..i.."Icon"]

        if not button.iconUpdated then
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

            button:SetCheckedTexture(MEDIA_PATH.."textureChecked")
            button:GetCheckedTexture():SetAllPoints(icon)

            button:SetPushedTexture(MEDIA_PATH.."texturePushed")
            button:GetPushedTexture():SetAllPoints(icon)

            button:SetHighlightTexture(MEDIA_PATH.."textureHighlight")
            button:GetHighlightTexture():SetAllPoints(icon)

            button.iconUpdated = true
        end
    end
end)

local stancesUpdated = false
local oldNumForms = 0

hooksecurefunc("StanceBar_UpdateState", function()
    local numForms = GetNumShapeshiftForms()
    if stancesUpdated and numForms == oldNumForms then
        return
    end

    local button, icon
    for i=1, NUM_STANCE_SLOTS do
        button = StanceBarFrame.StanceButtons[i]
        icon = button.icon
        if i <= numForms then
            button:SetCheckedTexture(MEDIA_PATH.."textureChecked")
            button:GetCheckedTexture():SetAllPoints(button.icon)

            button:SetPushedTexture(MEDIA_PATH.."texturePushed")
            button:GetPushedTexture():SetAllPoints(button.icon)

            button:SetHighlightTexture(MEDIA_PATH.."textureHighlight")
            button:GetHighlightTexture():SetAllPoints(button.icon)
        end
    end
    stancesUpdated = true
    oldNumForms = numForms
end)

local function UpdateVehicleButton()
    for i = 1, NUM_OVERRIDE_BUTTONS do
        local button = _G["OverrideActionBarButton"..i]
        local hotkey = _G["OverrideActionBarButton"..i.."HotKey"]
        if cfg.button.showVehicleKeybinds then
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize + 3, "OUTLINE")
            hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
            hotkey:ClearAllPoints()
            hotkey:SetPoint("TOPRIGHT", button, -4, -8)
        else
            hotkey:Hide()
        end
    end
end

hooksecurefunc("ActionButton_UpdateHotkeys", function(self, actionButtonType)
    local hotkey = self.HotKey
    local text = hotkey:GetText()

    text = gsub(text, "(s%-)", "S-")
    text = gsub(text, "(a%-)", "A-")
    text = gsub(text, "(c%-)", "C-")
    text = gsub(text, "(st%-)", "C-") -- German Control "Steuerung"

    for i = 1, 30 do
        text = gsub(text, _G["KEY_BUTTON"..i], "M"..i)
    end

    for i = 1, 9 do
        text = gsub(text, _G["KEY_NUMPAD"..i], "Nu"..i)
    end

    text = gsub(text, KEY_NUMPADDECIMAL, "Nu.")
    text = gsub(text, KEY_NUMPADDIVIDE, "Nu/")
    text = gsub(text, KEY_NUMPADMINUS, "Nu-")
    text = gsub(text, KEY_NUMPADMULTIPLY, "Nu*")
    text = gsub(text, KEY_NUMPADPLUS, "Nu+")

    text = gsub(text, KEY_MOUSEWHEELUP, "MU")
    text = gsub(text, KEY_MOUSEWHEELDOWN, "MD")
    text = gsub(text, KEY_NUMLOCK, "NuL")
    text = gsub(text, KEY_PAGEUP, "PU")
    text = gsub(text, KEY_PAGEDOWN, "PD")
    text = gsub(text, KEY_SPACE, "_")
    text = gsub(text, KEY_INSERT, "Ins")
    text = gsub(text, KEY_HOME, "Hm")
    text = gsub(text, KEY_DELETE, "Del")

    hotkey:SetText(text)

    if not IsSpecificButton(self, "OverrideActionBarButton") and not self.hotkeyUpdated then
        if cfg.button.showKeybinds then
            hotkey:ClearAllPoints()
            hotkey:SetPoint("TOPRIGHT", self, 0, -3)
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize, "OUTLINE")
            hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
            self.hotkeyUpdated = true
        else
            hotkey:Hide()
        end
    else
        UpdateVehicleButton()
    end
end)

hooksecurefunc("ActionButton_Update", function(self)
    local action = self.action
    local icon = self.icon
    local buttonCooldown = self.cooldown
    local texture = GetActionTexture(action)

    if texture then
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end

    local actionName = self.Name
    if actionName then
        if not cfg.button.showMacroNames then
            actionName:SetText("")
        else
            actionName:SetFont(cfg.button.macronameFont, cfg.button.macronameFontsize, "OUTLINE")
            actionName:SetVertexColor(unpack(cfg.color.MacroText))
        end
    end

    if not IsSpecificButton(self, "ExtraActionButton") then
        local button = self

        if not button.Background then

            local normalTexture = self.NormalTexture

            if normalTexture then
                normalTexture:ClearAllPoints()
                normalTexture:SetPoint("TOPRIGHT", button, 1, 1)
                normalTexture:SetPoint("BOTTOMLEFT", button, -1, -1)
                normalTexture:SetVertexColor(unpack(cfg.color.Normal))
            end

            button:SetNormalTexture(MEDIA_PATH.."textureNormal")

            button:SetCheckedTexture(MEDIA_PATH.."textureChecked")
            button:GetCheckedTexture():SetAllPoints(normalTexture)

            button:SetPushedTexture(MEDIA_PATH.."texturePushed")
            button:GetPushedTexture():SetAllPoints(normalTexture)

            button:SetHighlightTexture(MEDIA_PATH.."textureHighlight")
            button:GetHighlightTexture():SetAllPoints(normalTexture)

            button.Background = button:CreateTexture(nil, "BACKGROUND", nil, -8)
            button.Background:SetTexture(MEDIA_PATH.."textureBackground")
            button.Background:SetPoint("TOPRIGHT", button, 14, 12)
            button.Background:SetPoint("BOTTOMLEFT", button, -14, -16)

            if not nMainbar:IsTaintable() then
                buttonCooldown:ClearAllPoints()
                buttonCooldown:SetPoint("TOPRIGHT", button, -2, -2.5)
                buttonCooldown:SetPoint("BOTTOMLEFT", button, 2, 2)
            end

            local border = self.Border
            if border then
                if IsEquippedAction(action) then
                    border:SetVertexColor(unpack(cfg.color.IsEquipped))
                    border:SetAlpha(1)
                else
                    border:SetAlpha(0)
                end
            end

            local floatingBG = _G[self:GetName().."FloatingBG"]
            if floatingBG then
                floatingBG:ClearAllPoints()
                floatingBG:SetPoint("TOPRIGHT", button, 5, 5)
                floatingBG:SetPoint("BOTTOMLEFT", button, -5, -5)
                floatingBG:SetTexture(MEDIA_PATH.."textureShadow")
                floatingBG:SetVertexColor(0, 0, 0, 1)
            end
        end
    end
end)

hooksecurefunc("ExtraActionBar_Update", function(self)
    local bar = ExtraActionBarFrame
    if HasExtraActionBar() and not bar.Skinned then
        bar.button.style:Hide()

        local normalTexture = bar.button.NormalTexture
        normalTexture:ClearAllPoints()
        normalTexture:SetPoint("TOPRIGHT", bar.button, 4, 4)
        normalTexture:SetPoint("BOTTOMLEFT", bar.button, -4, -4)

        bar.button:SetNormalTexture(MEDIA_PATH.."textureNormal")

        bar.button:SetCheckedTexture(MEDIA_PATH.."textureChecked")
        bar.button:GetCheckedTexture():SetAllPoints(normalTexture)

        bar.button:SetPushedTexture(MEDIA_PATH.."texturePushed")
        bar.button:GetPushedTexture():SetAllPoints(normalTexture)

        bar.button:SetHighlightTexture(MEDIA_PATH.."textureHighlight")
        bar.button:GetHighlightTexture():SetAllPoints(normalTexture)

        bar.Skinned = true
    end
end)

hooksecurefunc("ActionButton_UpdateCount", function(self)
    local text = self.Count

    if text then
        text:SetPoint("BOTTOMRIGHT", self, 0, 1)
        text:SetFont(cfg.button.countFont, cfg.button.countFontsize, "OUTLINE")
        text:SetVertexColor(unpack(cfg.color.CountText))
    end
end)

hooksecurefunc("ActionButton_ShowGrid", function(self)
    if self.NormalTexture then
        self.NormalTexture:SetVertexColor(unpack(cfg.color.Normal))
    end
end)

hooksecurefunc("ActionButton_UpdateUsable", function(self)
    if IsAddOnLoaded("tullaRange") then
        return
    end

    local normal = _G[self:GetName().."NormalTexture"]
    if normal then
        normal:SetVertexColor(unpack(cfg.color.Normal))
    end

    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if isUsable then
        _G[self:GetName().."Icon"]:SetVertexColor(1, 1, 1)
    elseif notEnoughMana then
        _G[self:GetName().."Icon"]:SetVertexColor(unpack(cfg.color.OutOfMana))
    else
        _G[self:GetName().."Icon"]:SetVertexColor(unpack(cfg.color.NotUsable))
    end
end)

-- Hide Possess Frame Background

do
    for i = 2, 3 do
        for _, object in pairs({
                _G["PossessBackground1"],
                _G["PossessBackground2"],
            }) do
            if object:IsObjectType("Frame") or object:IsObjectType("Button") then
                object:UnregisterAllEvents()
                object:SetScript("OnEnter", nil)
                object:SetScript("OnLeave", nil)
                object:SetScript("OnClick", nil)
            end

            hooksecurefunc(object, "Show", function(self)
                self:Hide()
            end)

            object:Hide()
        end
    end
end

-- Force Hotkey Update

local frame = CreateFrame("Frame", nil)
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        local bagBinding = GetBindingKey("NBAGS_TOGGLE") or "ALT-CTRL-B"
        local binding = SetBinding(bagBinding,"NBAGS_TOGGLE")
        frame:UnregisterEvent("PLAYER_LOGIN")
    end
end)
