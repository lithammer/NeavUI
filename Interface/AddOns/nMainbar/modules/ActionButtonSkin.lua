local _, nMainbar = ...
local cfg = nMainbar.Config
local Color = cfg.color

local pairs = pairs
local gsub = string.gsub
local match = string.match

local MEDIA_PATH = "Interface\\AddOns\\nMainbar\\Media\\"

local function IsSpecificButton(self, name)
    local sbut = self:GetName():match(name)
    if sbut then
        return true
    else
        return false
    end
end

local function SkinButton(button, icon)
    local buttonName = button:GetName()
    local border = button.Border
    local cooldown = _G[buttonName.."Cooldown"]
    local floatingBG = _G[buttonName.."FloatingBG"]
    local normalTexture = _G[buttonName.."NormalTexture2"] or _G[buttonName.."NormalTexture"]

    if not InCombatLockdown() then
        if cooldown then
            cooldown:ClearAllPoints()
            cooldown:SetPoint("TOPRIGHT", button, -2, -2)
            cooldown:SetPoint("BOTTOMLEFT", button, 1, 1)
        end
    end

    button:SetNormalTexture(MEDIA_PATH.."textureNormal")

    if not button.Skinned then
        if icon then
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        end

        if normalTexture then
            normalTexture:ClearAllPoints()
            normalTexture:SetPoint("TOPRIGHT", button, 1.5, 1.5)
            normalTexture:SetPoint("BOTTOMLEFT", button, -1.5, -1.5)
            normalTexture:SetVertexColor(Color.Normal:GetRGBA())

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
        end

        if border then
            border:SetBlendMode("BLEND")
            border:SetTexture(MEDIA_PATH.."UI-ActionButton-Glow")
            border:ClearAllPoints()
            border:SetAllPoints(normalTexture)
        end

        if floatingBG then
            floatingBG:ClearAllPoints()
            floatingBG:SetPoint("TOPRIGHT", button, 5, 5)
            floatingBG:SetPoint("BOTTOMLEFT", button, -5, -5)
            floatingBG:SetTexture(MEDIA_PATH.."textureShadow")
            floatingBG:SetVertexColor(0.0, 0.0, 0.0, 1.0)
        else
            button.Shadow = button:CreateTexture(nil, "BACKGROUND")
            button.Shadow:SetParent(button)
            button.Shadow:SetPoint("TOPRIGHT", normalTexture, 5, 5)
            button.Shadow:SetPoint("BOTTOMLEFT", normalTexture, -5, -5)
            button.Shadow:SetTexture(MEDIA_PATH.."textureShadow")
            button.Shadow:SetVertexColor(0.0, 0.0, 0.0, 1.0)
        end

        button.Skinned = true
    end
end

local function UpdateVehicleButton()
    for i = 1, NUM_OVERRIDE_BUTTONS do
        local button = _G["OverrideActionBarButton"..i]
        local hotkey = _G["OverrideActionBarButton"..i.."HotKey"]
        if cfg.button.showVehicleKeybinds then
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize + 3, "OUTLINE")
            hotkey:SetVertexColor(Color.HotKeyText:GetRGB())
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
            hotkey:SetVertexColor(Color.HotKeyText:GetRGB())
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
    local border = self.Border
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
            actionName:SetVertexColor(Color.MacroText:GetRGB())
        end
    end

    if not IsSpecificButton(self, "ExtraActionButton") then
        SkinButton(self)
    end

    if border then
        if IsEquippedAction(action) then
            border:SetVertexColor(Color.IsEquipped:GetRGB())
            border:SetAlpha(1)
        else
            border:SetAlpha(0)
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
        text:SetVertexColor(Color.CountText:GetRGB())
    end
end)

hooksecurefunc("ActionButton_ShowGrid", function(self)
    if self.NormalTexture then
        self.NormalTexture:SetVertexColor(Color.Normal:GetRGBA())
    end
end)

local function UpdateUsable(self, checksRange, inRange)
    if IsAddOnLoaded("tullaRange") then
        return
    end

    local icon = self.icon
    local normalTexture = self.NormalTexture
    if not normalTexture then
        return
    end

    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if isUsable then
        icon:SetVertexColor(1.0, 1.0, 1.0)
        normalTexture:SetVertexColor(Color.Normal:GetRGBA())
    elseif notEnoughMana then
        icon:SetVertexColor(Color.OutOfMana:GetRGB())
        normalTexture:SetVertexColor(Color.OutOfMana:GetRGB())
    else
        icon:SetVertexColor(Color.NotUsable:GetRGB())
        normalTexture:SetVertexColor(Color.NotUsable:GetRGB())
    end

    if checksRange and not inRange then
        icon:SetVertexColor(Color.OutOfRange:GetRGB())
    end
end
hooksecurefunc("ActionButton_UpdateUsable", UpdateUsable)

hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
    local icon = self.icon

    if self.action and cfg.button.buttonOutOfRange then
        UpdateUsable(self, checksRange, inRange)
    end

    if self.HotKey:GetText() == RANGE_INDICATOR then
        if checksRange then
            self.HotKey:Show()
            if inRange then
                self.HotKey:SetVertexColor(Color.HotKeyText:GetRGB())
            else
                self.HotKey:SetVertexColor(Color.OutOfRange:GetRGB())
            end
        else
            self.HotKey:Hide()
        end
    else
        if checksRange and not inRange then
            self.HotKey:SetVertexColor(Color.OutOfRange:GetRGB())
        else
            self.HotKey:SetVertexColor(Color.HotKeyText:GetRGB())
        end
    end
end)

hooksecurefunc("PetActionBar_Update", function(self)
    local button, icon
    for i=1, NUM_PET_ACTION_SLOTS, 1 do
        local buttonName = "PetActionButton"..i
        button = _G[buttonName]
        icon = _G[buttonName.."Icon"]

        SkinButton(button, icon)

        local hotkey = _G[buttonName.."HotKey"]
        if hotkey then
            if cfg.button.showKeybinds then
                hotkey:ClearAllPoints()
                hotkey:SetPoint("TOPRIGHT", buttonName, 0, -3)
                hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.petHotKeyFontsize, "OUTLINE")
                hotkey:SetVertexColor(Color.HotKeyText:GetRGB())
            else
                hotkey:Hide()
            end
        end
    end
end)
securecall("PetActionBar_Update")

hooksecurefunc("StanceBar_UpdateState", function(self)
    local button, icon, buttonName
    for i=1, NUM_STANCE_SLOTS do
        button = StanceBarFrame.StanceButtons[i]
        icon = button.icon

        SkinButton(button, icon)
    end
end)

hooksecurefunc("PossessBar_UpdateState", function()
    local button, icon

    for i=1, NUM_POSSESS_SLOTS do
        button = _G["PossessButton"..i]
        icon = _G["PossessButton"..i.."Icon"]

        SkinButton(button, icon)
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
