local _, nMainbar = ...
local cfg = nMainbar.Config
local Color = cfg.color

local MEDIA_PATH = "Interface\\AddOns\\nMainbar\\media\\"

local LAB = LibStub("LibActionButton-1.0-nMainbar")

if IsAddOnLoaded("AdiButtonAuras") then
    AdiButtonAuras:RegisterLAB("LibActionButton-1.0-nMainbar")
end

local DefaultConfig = {
    outOfRangeColoring = cfg.button.buttonOutOfRange and "button" or "hotkey",
    tooltip = "enabled",
    showGrid = false,
    useColoring = true,
    colors = {
        range = {Color.OutOfRange:GetRGB()},
        mana = {Color.OutOfMana:GetRGB()},
        usable = {Color.Normal:GetRGB()},
        notUsable = {Color.NotUsable:GetRGB()},
        equipped = {Color.IsEquipped:GetRGB()},
    },
    hideElements = {
        macro = not cfg.button.showMacroNames,
        hotkey = not cfg.button.showKeybinds,
        equipped = false,
    },
    clickOnDown = false,
    flyoutDirection = "UP",
    disableCountDownNumbers = false,
    useDrawBling = true,
    useDrawSwipeOnCharges = true,
}

local function FixKeybindText(text)
    if text then
        text = gsub(text, "(s%-)", "S-")
        text = gsub(text, "(SHIFT%-)", "S-")
        text = gsub(text, "(a%-)", "A-")
        text = gsub(text, "(ALT%-)", "A-")
        text = gsub(text, "(c%-)", "C-")
        text = gsub(text, "(CTRL%-)", "C-")
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

        return text
    else
        return ""
    end
end

local function StyleButton(self)
    local name = self:GetName()
    local icon = self.icon
    local border = self.Border
    local count = self.Count
    local macro = self.Name
    local cooldown = self.cooldown
    local hotkey = self.HotKey
    local normal = self.NormalTexture
    local floatingBG = _G[name.."FloatingBG"]

    if hotkey then
        hotkey:ClearAllPoints()
        hotkey:SetPoint("TOPRIGHT", self, 0, -3)
        hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize, "OUTLINE")
        hotkey:SetVertexColor(Color.HotKeyText:GetRGB())
    end

    if count then
        count:SetPoint("BOTTOMRIGHT", self, 0, 1)
        count:SetFont(cfg.button.countFont, cfg.button.countFontsize, "OUTLINE")
        count:SetVertexColor(Color.CountText:GetRGB())
    end

    if macro then
        macro:SetFont(cfg.button.macronameFont, cfg.button.macronameFontsize, "OUTLINE")
        macro:SetVertexColor(Color.MacroText:GetRGB())
    end

    if icon then
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        icon:SetPoint("TOPRIGHT", self, "TOPRIGHT", -1, -1)
        icon:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 1)
    end

    if normal then
        normal:ClearAllPoints()
        normal:SetPoint("TOPRIGHT", self, "TOPRIGHT", 1, 1)
        normal:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -1, -1)
        normal:SetVertexColor(Color.Normal:GetRGBA())

        self:SetNormalTexture(MEDIA_PATH.."textureNormal")

        self:SetCheckedTexture(MEDIA_PATH.."textureChecked")
        self:GetCheckedTexture():SetAllPoints(normal)

        self:SetPushedTexture(MEDIA_PATH.."texturePushed")
        self:GetPushedTexture():SetAllPoints(normal)

        self:SetHighlightTexture(MEDIA_PATH.."textureHighlight")
        self:GetHighlightTexture():SetAllPoints(normal)
    end

    if border then
        border:SetBlendMode("BLEND")
        border:SetTexture(MEDIA_PATH.."UI-ActionButton-Glow")
        border:ClearAllPoints()
        border:SetAllPoints(normal)
    end

    if cooldown and not nMainbar:IsTaintable() then
        cooldown:ClearAllPoints()
        cooldown:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -2.5)
        cooldown:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2)
    end

    if not self.Background then
        self.Background = self:CreateTexture(nil, "BACKGROUND", nil, -8)
        self.Background:SetTexture(MEDIA_PATH.."textureBackground")
        self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", 14, 12)
        self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -14, -16)
    end

    if not floatingBG then
        self.floatingBG = self:CreateTexture("$parentFloatingBG", "BACKGROUND")
        self.floatingBG:SetPoint("TOPRIGHT", normal, "TOPRIGHT", 4, 4)
        self.floatingBG:SetPoint("BOTTOMLEFT", normal, "BOTTOMLEFT", -4, -4)
        self.floatingBG:SetTexture(MEDIA_PATH.."textureShadow")
        self.floatingBG:SetVertexColor(0.0, 0.0, 0.0, 1.0)
    end
end

local function ReassignBindings(bar)
    for i = 1, #bar.buttons do
        local blizzardButton = (bar.bindButtons.."%d"):format(i)
        local myButton = bar.buttons[i]

        local key = GetBindingKey(blizzardButton)
        local hotkey = myButton.HotKey
        if key and key ~= "" then
            if key == RANGE_INDICATOR then
                hotkey:Hide()
            else
                hotkey:SetText(FixKeybindText(key))
                hotkey:Show()
            end
        else
            hotkey:SetText("")
            hotkey:Hide()
        end
    end
end

local function CheckFakeStatus()
    if nMainbar:IsTaintable() then
        return
    end

    local bar = _G["FakeMultiBarBottomRight1"]

    if bar then
        if not cfg.useFakeBottomRightBar or SHOW_MULTI_ACTIONBAR_2 then
            bar:Hide()
        else
            bar:Show()
        end
    end
end

-- hooksecurefunc(MainMenuBar, "ChangeMenuBarSizeAndPosition", CheckFakeStatus)
hooksecurefunc("MultiActionBar_Update", CheckFakeStatus)

 -- Disable bottom right bar checkbox during combat.

local eventWatcher = CreateFrame("Frame")
eventWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")
eventWatcher:RegisterEvent("PLAYER_REGEN_DISABLED")
eventWatcher:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        InterfaceOptionsActionBarsPanelBottomRight:Disable()
    elseif event == "PLAYER_REGEN_ENABLED" then
        InterfaceOptionsActionBarsPanelBottomRight:Enable()
    end
end)

local function CreateBar(id)
    local bottomRightShown = select(2, GetActionBarToggles())
    local bar = CreateFrame("Frame", "FakeMultiBarBottomRight"..id, MainMenuBar, "SecureHandlerStateTemplate")
    bar:SetFrameRef("MainMenuBarArtFrame", MainMenuBarArtFrame)
    bar:SetFrameStrata("MEDIUM")
    bar:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6)
    bar:SetSize(510, 40)

    if not cfg.useFakeBottomRightBar or bottomRightShown then
        bar:Hide()
    end

    bar.id = id
    bar.buttons = {}
    bar.buttonConfig = DefaultConfig
    bar.bindButtons = "MULTIACTIONBAR2BUTTON"

    for i=1, 12 do
        local name = format(bar:GetName().."Button%d", i)

        bar.buttons[i] = LAB:CreateButton(i, name, bar, DefaultConfig)
        bar.buttons[i]:SetSize(36, 36)
        bar.buttons[i]:SetState(0, "action", i+48)

        if i == 1 then
            bar.buttons[i]:SetPoint("LEFT")
        else
            bar.buttons[i]:SetPoint("LEFT", bar.buttons[i-1], "RIGHT", 6, 0)
        end
        for k = 1, 14 do
            bar.buttons[i]:SetState(k, "action", (k - 1) * 12 + i)
        end

        StyleButton(bar.buttons[i])
    end

    bar:RegisterEvent("UPDATE_BINDINGS")
    bar:SetScript("OnEvent", function(self, event, ...)
        ReassignBindings(self)
    end)
end

CreateBar(1)
