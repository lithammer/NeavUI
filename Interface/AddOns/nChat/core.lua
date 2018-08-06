
local _, nChat = ...
local cfg = nChat.Config

local type = type
local select = select
local unpack = unpack
local gsub = string.gsub
local format = string.format

_G.CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
_G.CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

_G.CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.5
_G.CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0

_G.CHAT_FRAME_FADE_OUT_TIME = 0.25
_G.CHAT_FRAME_FADE_TIME = 0.1

_G.CHAT_FONT_HEIGHTS = {
    [1] = 8,
    [2] = 9,
    [3] = 10,
    [4] = 11,
    [5] = 12,
    [6] = 13,
    [7] = 14,
    [8] = 15,
    [9] = 16,
    [10] = 17,
    [11] = 18,
    [12] = 19,
    [13] = 20,
}

_G.CHAT_FLAG_AFK = "[AFK] "
_G.CHAT_FLAG_DND = "[DND] "
_G.CHAT_FLAG_GM = "[GM] "

_G.CHAT_GUILD_GET = "(|Hchannel:Guild|hG|h) %s:\32"
_G.CHAT_OFFICER_GET = "(|Hchannel:o|hO|h) %s:\32"

_G.CHAT_PARTY_GET = "(|Hchannel:party|hP|h) %s:\32"
_G.CHAT_PARTY_LEADER_GET = "(|Hchannel:party|hPL|h) %s:\32"
_G.CHAT_PARTY_GUIDE_GET = "(|Hchannel:party|hDG|h) %s:\32"
_G.CHAT_MONSTER_PARTY_GET = "(|Hchannel:raid|hR|h) %s:\32"

_G.CHAT_RAID_GET = "(|Hchannel:raid|hR|h) %s:\32"
_G.CHAT_RAID_WARNING_GET = "(RW!) %s:\32"
_G.CHAT_RAID_LEADER_GET = "(|Hchannel:raid|hL|h) %s:\32"

_G.CHAT_BATTLEGROUND_GET = "(|Hchannel:Battleground|hBG|h) %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "(|Hchannel:Battleground|hBL|h) %s:\32"

_G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h[I]|h %s:\32"
_G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h[IL]|h %s:\32"

local AddMessage = ChatFrame1.AddMessage
local function FCF_AddMessage(self, text, ...)
    if type(text) == "string" then
        text = gsub(text, "(|HBNplayer.-|h)%[(.-)%]|h", "%1%2|h")
        text = gsub(text, "(|Hplayer.-|h)%[(.-)%]|h", "%1%2|h")
        text = gsub(text, "%[(%d0?)%. (.-)%]", "(%1)")
    end

    return AddMessage(self, text, ...)
end

    -- Quick Join Button Options

if cfg.enableQuickJoinButton then
    QuickJoinToastButton:ClearAllPoints()
    QuickJoinToastButton:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 0)
else
    QuickJoinToastButton:SetAlpha(0)
    QuickJoinToastButton:EnableMouse(false)
    QuickJoinToastButton:UnregisterAllEvents()
end

    -- Hide the menu.

ChatFrameMenuButton:SetAlpha(0)
ChatFrameMenuButton:EnableMouse(false)

    -- Tab text colors for the tabs

hooksecurefunc("FCFTab_UpdateColors", function(self, selected)
    if selected then
        self:GetFontString():SetTextColor(0, 0.75, 1)
    else
        self:GetFontString():SetTextColor(1, 1, 1)
    end
end)

    -- Tab text fadeout.

hooksecurefunc("FCF_FadeOutChatFrame", function(chatFrame)
    local frameName = chatFrame:GetName()
    local chatTab = _G[frameName.."Tab"]
    local tabGlow = _G[frameName.."TabGlow"]

    if not tabGlow:IsShown() then
        if frameName.isDocked then
            securecall("UIFrameFadeOut", chatTab, CHAT_FRAME_FADE_OUT_TIME, chatTab:GetAlpha(), CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
        else
            securecall("UIFrameFadeOut", chatTab, CHAT_FRAME_FADE_OUT_TIME, chatTab:GetAlpha(), CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
        end
    end
end)

    -- Improve mousewheel scrolling.

hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(self, direction)
    if direction > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        else
            self:ScrollUp()
            self:ScrollUp()
        end
    elseif direction < 0 then
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        else
            self:ScrollDown()
            self:ScrollDown()
        end
    end
end)

    -- Reposit toast frame.

BNToastFrame:HookScript("OnShow", function(self)
    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetPoint("BOTTOMLEFT", ChatFrame1EditBox, "TOPLEFT", 0, 15)
end)

    -- Modify the chat tabs.

local function SkinTab(self)
    local chat = _G[self]
    local font, _, _ = chat:GetFont()

    local tab = _G[self.."Tab"]
    for i = 1, select("#", tab:GetRegions()) do
        local texture = select(i, tab:GetRegions())
        if texture and texture:GetObjectType() == "Texture" then
            texture:SetTexture(nil)
        end
    end

    local tabText = _G[self.."TabText"]
    tabText:SetJustifyH("CENTER")
    tabText:SetWidth(60)
    if cfg.tab.fontOutline then
        tabText:SetFont(font, cfg.tab.fontSize, "OUTLINE")
        tabText:SetShadowOffset(0, 0)
    else
        tabText:SetFont(font, cfg.tab.fontSize)
        tabText:SetShadowOffset(1, -1)
    end

    local a1, a2, a3, a4, a5 = tabText:GetPoint()
    tabText:SetPoint(a1, a2, a3, a4, 1)

    local s1, s2, s3 = unpack(cfg.tab.specialColor)
    local e1, e2, e3 = unpack(cfg.tab.selectedColor)
    local n1, n2, n3 = unpack(cfg.tab.normalColor)

    local tabGlow = _G[self.."TabGlow"]
    hooksecurefunc(tabGlow, "Show", function()
        tabText:SetTextColor(s1, s2, s3, CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
    end)

    hooksecurefunc(tabGlow, "Hide", function()
        tabText:SetTextColor(n1, n2, n3)
    end)

    tab:SetScript("OnEnter", function()
        tabText:SetTextColor(s1, s2, s3, tabText:GetAlpha())
    end)

    tab:SetScript("OnLeave", function()
        local hasNofication = tabGlow:IsShown()

        local r, g, b
        if _G[self] == SELECTED_CHAT_FRAME and chat.isDocked then
            r, g, b = e1, e2, e3
        elseif hasNofication then
            r, g, b = s1, s2, s3
        else
            r, g, b = n1, n2, n3
        end

        tabText:SetTextColor(r, g, b)
    end)

    hooksecurefunc(tab, "Show", function()
        if not tab.wasShown then
            local hasNofication = tabGlow:IsShown()

            if chat:IsMouseOver() then
                tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
            else
                tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
            end

            local r, g, b
            if _G[self] == SELECTED_CHAT_FRAME and chat.isDocked then
                r, g, b = e1, e2, e3
            elseif hasNofication then
                r, g, b = s1, s2, s3
            else
                r, g, b = n1, n2, n3
            end

            tabText:SetTextColor(r, g, b)

            tab.wasShown = true
        end
    end)
end

local function ModChat(self)
    local chat = _G[self]

    if not cfg.chatOutline then
        chat:SetShadowOffset(1, -1)
    end

    if cfg.disableFade then
        chat:SetFading(false)
    end

    SkinTab(self)

    local font, fontsize, fontflags = chat:GetFont()
    chat:SetFont(font, fontsize, cfg.chatOutline and "OUTLINE" or fontflags)
    chat:SetClampedToScreen(true)

    chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    chat:SetMinResize(150, 25)

    if self ~= "ChatFrame2" then
        chat.AddMessage = FCF_AddMessage
    end

    for _, texture in pairs({
        "ButtonFrameBackground",
        "ButtonFrameTopLeftTexture",
        "ButtonFrameBottomLeftTexture",
        "ButtonFrameTopRightTexture",
        "ButtonFrameBottomRightTexture",
        "ButtonFrameLeftTexture",
        "ButtonFrameRightTexture",
        "ButtonFrameBottomTexture",
        "ButtonFrameTopTexture",
    }) do
        _G[self..texture]:SetTexture(nil)
    end

        -- Modify the editbox

    for k = 3, 8 do
        select(k, _G[self.."EditBox"]:GetRegions()):SetTexture(nil)
    end

    _G[self.."EditBox"]:SetAltArrowKeyMode(cfg.ignoreArrows)

    if cfg.showInputBoxAbove then
        local tabHeight = _G[self.."Tab"]:GetHeight()
        _G[self.."EditBox"]:ClearAllPoints()
        _G[self.."EditBox"]:SetPoint("BOTTOMLEFT", chat, "TOPLEFT", 0, tabHeight + 5)
        _G[self.."EditBox"]:SetPoint("BOTTOMRIGHT", chat, "TOPRIGHT", 0, tabHeight + 5)
    end
    _G[self.."EditBox"]:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        insets = {
            left = 3, right = 3, top = 2, bottom = 2
        },
    })

    _G[self.."EditBox"]:SetBackdropColor(0, 0, 0, 0.5)
    _G[self.."EditBox"]:CreateBeautyBorder(11)
    _G[self.."EditBox"]:SetBeautyBorderPadding(-2, -1, -2, -1, -2, -1, -2, -1)

    if cfg.enableBorderColoring then
        _G[self.."EditBox"]:SetBeautyBorderTexture("white")

        hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
            local type = editBox:GetAttribute("chatType")
            if not type then
                return
            end

            local info = ChatTypeInfo[type]
            _G[self.."EditBox"]:SetBeautyBorderColor(info.r, info.g, info.b)
        end)
    end
end

local function SetChatStyle()
    for _, frame in pairs(CHAT_FRAMES) do
        local chat = _G[frame]

        if chat then
            chat:SetClampRectInsets(-37, 56, 0, -12)

            if not chat.hasModification then
                ModChat(chat:GetName())

                if cfg.enableChatWindowBorder then
                    if chat.Background then
                        chat.BorderFrame = CreateFrame("Frame")
                        chat.BorderFrame:SetParent(chat)
                        chat.BorderFrame:SetAllPoints(chat.Background)
                        chat.BorderFrame:CreateBeautyBorder(12)
                        chat.BorderFrame:SetBeautyBorderPadding(2)
                    end
                end

                chat.hasModification = true
            end
        end
    end
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetChatStyle)
SetChatStyle()

    -- Chat menu, just a middle click on the chatframe 1 tab

hooksecurefunc("ChatFrameMenu_UpdateAnchorPoint", function()
    if FCF_GetButtonSide(DEFAULT_CHAT_FRAME) == "right" then
        ChatMenu:ClearAllPoints()
        ChatMenu:SetPoint("BOTTOMRIGHT", ChatFrame1Tab, "TOPLEFT")
    else
        ChatMenu:ClearAllPoints()
        ChatMenu:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPRIGHT")
    end
end)

ChatFrame1Tab:RegisterForClicks("AnyUp")
ChatFrame1Tab:HookScript("OnClick", function(self, button)
    if button == "MiddleButton" or button == "Button4" or button == "Button5" then
        if ChatMenu:IsShown() then
            ChatMenu:Hide()
        else
            ChatMenu:Show()
        end
    else
        ChatMenu:Hide()
    end
end)

    -- Modify the gm chatframe and add a sound notification on incoming whispers

local eventWatcher = CreateFrame("Frame")
eventWatcher:RegisterEvent("ADDON_LOADED")
eventWatcher:RegisterEvent("CHAT_MSG_WHISPER")
eventWatcher:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == "Blizzard_GMChatUI" then
            GMChatFrame:EnableMouseWheel(true)
            GMChatFrame:SetScript("OnMouseWheel", ChatFrame1:GetScript("OnMouseWheel"))
            GMChatFrame:SetHeight(200)

            GMChatFrameUpButton:SetAlpha(0)
            GMChatFrameUpButton:EnableMouse(false)

            GMChatFrameDownButton:SetAlpha(0)
            GMChatFrameDownButton:EnableMouse(false)

            GMChatFrameBottomButton:SetAlpha(0)
            GMChatFrameBottomButton:EnableMouse(false)
        elseif name == "Blizzard_CombatLog" then
            hooksecurefunc("FCF_DockUpdate", function()
                if COMBATLOG.isDocked then
                    COMBATLOG:SetClampRectInsets(-37, 56, 0, -12)
                end
            end)
        end
    end

    if event == "CHAT_MSG_WHISPER" then
        if cfg.alwaysAlertOnWhisper then
            PlaySound(SOUNDKIT.TELL_MESSAGE)
        end
    end
end)

    -- Combat and chat log menu options.

local combatLog = {
    text = "CombatLog",
    colorCode = "|cffFFD100",
    isNotRadio = true,

    func = function()
        if not LoggingCombat() then
            LoggingCombat(true)
            DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGENABLED, 1, 1, 0)
        else
            LoggingCombat(false)
            DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGDISABLED, 1, 1, 0)
        end
    end,

    checked = function()
        if LoggingCombat() then
            return true
        else
            return false
        end
    end
}

local chatLog = {
    text = "ChatLog",
    colorCode = "|cffFFD100",
    isNotRadio = true,

    func = function()
        if not LoggingChat() then
            LoggingChat(true)
            DEFAULT_CHAT_FRAME:AddMessage(CHATLOGENABLED, 1, 1, 0)
        else
            LoggingChat(false)
            DEFAULT_CHAT_FRAME:AddMessage(CHATLOGDISABLED, 1, 1, 0)
        end
    end,

    checked = function()
        if LoggingChat() then
            return true
        else
            return false
        end
    end
}

hooksecurefunc("FCF_Tab_OnClick", function(self, button)
    combatLog.arg1 = self
    UIDropDownMenu_AddButton(combatLog)

    chatLog.arg1 = self
    UIDropDownMenu_AddButton(chatLog)
end)
