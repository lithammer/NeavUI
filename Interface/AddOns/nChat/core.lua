
local _, nChat = ...
local cfg = nChat.Config

local _G = _G
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

--[[
_G.CHAT_SAY_GET = '%s:\32'
_G.CHAT_YELL_GET = '%s:\32'

_G.CHAT_WHISPER_GET = '[from] %s:\32'
_G.CHAT_WHISPER_INFORM_GET = '[to] %s:\32'

_G.CHAT_BN_WHISPER_GET = '[from] %s:\32'
_G.CHAT_BN_WHISPER_INFORM_GET = '[to] %s:\32'
--]]

_G.CHAT_FLAG_AFK = '[AFK] '
_G.CHAT_FLAG_DND = '[DND] '
_G.CHAT_FLAG_GM = '[GM] '

_G.CHAT_GUILD_GET = '(|Hchannel:Guild|hG|h) %s:\32'
_G.CHAT_OFFICER_GET = '(|Hchannel:o|hO|h) %s:\32'

_G.CHAT_PARTY_GET = '(|Hchannel:party|hP|h) %s:\32'
_G.CHAT_PARTY_LEADER_GET = '(|Hchannel:party|hPL|h) %s:\32'
_G.CHAT_PARTY_GUIDE_GET = '(|Hchannel:party|hDG|h) %s:\32'
_G.CHAT_MONSTER_PARTY_GET = '(|Hchannel:raid|hR|h) %s:\32'

_G.CHAT_RAID_GET = '(|Hchannel:raid|hR|h) %s:\32'
_G.CHAT_RAID_WARNING_GET = '(RW!) %s:\32'
_G.CHAT_RAID_LEADER_GET = '(|Hchannel:raid|hL|h) %s:\32'

_G.CHAT_BATTLEGROUND_GET = '(|Hchannel:Battleground|hBG|h) %s:\32'
_G.CHAT_BATTLEGROUND_LEADER_GET = '(|Hchannel:Battleground|hBL|h) %s:\32'

_G.CHAT_INSTANCE_CHAT_GET = '|Hchannel:INSTANCE_CHAT|h[I]|h %s:\32';
_G.CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:INSTANCE_CHAT|h[IL]|h %s:\32';

--[[
local channelFormat
do
    local a, b = '.*%[(.*)%].*', '%%[%1%%]'
    channelFormat = {
        [1] = {gsub(CHAT_BATTLEGROUND_GET, a, b), '[BG]'},
        [2] = {gsub(CHAT_BATTLEGROUND_LEADER_GET, a, b), '[BGL]'},

        [3] = {gsub(CHAT_GUILD_GET, a, b), '[G]'},
        [4] = {gsub(CHAT_OFFICER_GET, a, b), '[O]'},

        [5] = {gsub(CHAT_PARTY_GET, a, b), '[P]'},
        [6] = {gsub(CHAT_PARTY_LEADER_GET, a, b), '[PL]'},
        [7] = {gsub(CHAT_PARTY_GUIDE_GET, a, b), '[PL]'},

        [8] = {gsub(CHAT_RAID_GET, a, b), '[R]'},
        [9] = {gsub(CHAT_RAID_LEADER_GET, a, b), '[RL]'},
        [10] = {gsub(CHAT_RAID_WARNING_GET, a, b), '[RW]'},

        [11] = {gsub(CHAT_FLAG_AFK, a, b), '[AFK] '},
        [12] = {gsub(CHAT_FLAG_DND, a, b), '[DND] '},
        [13] = {gsub(CHAT_FLAG_GM, a, b), '[GM] '},
    }
end
]]

local AddMessage = ChatFrame1.AddMessage
local function FCF_AddMessage(self, text, ...)
    if (type(text) == 'string') then
        text = gsub(text, '(|HBNplayer.-|h)%[(.-)%]|h', '%1%2|h')
        text = gsub(text, '(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')
        text = gsub(text, '%[(%d0?)%. (.-)%]', '(%1)')

        --[[
        for i = 1, #channelFormat  do
            text = gsub(text, channelFormat[i][1], channelFormat[i][2])
        end
        --]]
    end

    return AddMessage(self, text, ...)
end

    -- Quick Join Button Options

if cfg.enableQuickJoinButton then
    QuickJoinToastButton:ClearAllPoints()
    QuickJoinToastButton:SetPoint('BOTTOMLEFT', ChatFrame1Tab, 'TOPLEFT', 0, 0)
else
    QuickJoinToastButton:SetAlpha(0)
    QuickJoinToastButton:EnableMouse(false)
    QuickJoinToastButton:UnregisterAllEvents()
end

    -- Hide the menu.

ChatFrameMenuButton:SetAlpha(0)
ChatFrameMenuButton:EnableMouse(false)

    -- Tab text colors for the tabs

hooksecurefunc('FCFTab_UpdateColors', function(self, selected)
    if (selected) then
        self:GetFontString():SetTextColor(0, 0.75, 1)
    else
        self:GetFontString():SetTextColor(1, 1, 1)
    end
end)

    -- Tab text fadeout

local origFCF_FadeOutChatFrame = _G.FCF_FadeOutChatFrame
local function FCF_FadeOutChatFrameHook(chatFrame)
    origFCF_FadeOutChatFrame(chatFrame)

    local frameName = chatFrame:GetName()
    local chatTab = _G[frameName..'Tab']
    local tabGlow = _G[frameName..'TabGlow']

    if (not tabGlow:IsShown()) then
        if (frameName.isDocked) then
            securecall('UIFrameFadeOut', chatTab, CHAT_FRAME_FADE_OUT_TIME, chatTab:GetAlpha(), CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
        else
            securecall('UIFrameFadeOut', chatTab, CHAT_FRAME_FADE_OUT_TIME, chatTab:GetAlpha(), CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
        end
    end
end
FCF_FadeOutChatFrame = FCF_FadeOutChatFrameHook

    -- Improve mousewheel scrolling

hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, direction)
    if (direction > 0) then
        if (IsShiftKeyDown()) then
            self:ScrollToTop()
        else
            self:ScrollUp()
            self:ScrollUp()
        end
    elseif (direction < 0)  then
        if (IsShiftKeyDown()) then
            self:ScrollToBottom()
        else
            self:ScrollDown()
            self:ScrollDown()
        end
    end

    if (cfg.enableBottomButton) then
        local buttonBottom = _G[self:GetName() .. 'ButtonFrameBottomButton']
        if (self:AtBottom()) then
            buttonBottom:Hide()
        else
            buttonBottom:Show()
            buttonBottom:SetAlpha(0.7)
        end
    end
end)

    -- Reposit toast frame

BNToastFrame:HookScript('OnShow', function(self)
    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetPoint('BOTTOMLEFT', ChatFrame1EditBox, 'TOPLEFT', 0, 15)
end)

    -- Modify the chat tabs

local function SkinTab(self)
    local chat = _G[self]
    local font, _, _ = chat:GetFont()

    local tab = _G[self..'Tab']
    for i = 1, select('#', tab:GetRegions()) do
        local texture = select(i, tab:GetRegions())
        if (texture and texture:GetObjectType() == 'Texture') then
            texture:SetTexture(nil)
        end
    end

    local tabText = _G[self..'TabText']
    tabText:SetJustifyH('CENTER')
    tabText:SetWidth(60)
    if (cfg.tab.fontOutline) then
        tabText:SetFont(font, cfg.tab.fontSize, 'THINOUTLINE')
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

    local tabGlow = _G[self..'TabGlow']
    hooksecurefunc(tabGlow, 'Show', function()
        tabText:SetTextColor(s1, s2, s3, CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
    end)

    hooksecurefunc(tabGlow, 'Hide', function()
        tabText:SetTextColor(n1, n2, n3)
    end)

    tab:SetScript('OnEnter', function()
        tabText:SetTextColor(s1, s2, s3, tabText:GetAlpha())
    end)

    tab:SetScript('OnLeave', function()
        local hasNofication = tabGlow:IsShown()

        local r, g, b
        if (_G[self] == SELECTED_CHAT_FRAME and chat.isDocked) then
            r, g, b = e1, e2, e3
        elseif (hasNofication) then
            r, g, b = s1, s2, s3
        else
            r, g, b = n1, n2, n3
        end

        tabText:SetTextColor(r, g, b)
    end)

    hooksecurefunc(tab, 'Show', function()
        if (not tab.wasShown) then
            local hasNofication = tabGlow:IsShown()

            if (chat:IsMouseOver()) then
                tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
            else
                tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
            end

            local r, g, b
            if (_G[self] == SELECTED_CHAT_FRAME and chat.isDocked) then
                r, g, b = e1, e2, e3
            elseif (hasNofication) then
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

    if (not cfg.chatOutline) then
        chat:SetShadowOffset(1, -1)
    end

    if (cfg.disableFade) then
        chat:SetFading(false)
    end

    SkinTab(self)

    local font, fontsize, fontflags = chat:GetFont()
    chat:SetFont(font, fontsize, cfg.chatOutline and 'THINOUTLINE' or fontflags)
    chat:SetClampedToScreen(false)

    chat:SetClampRectInsets(0, 0, 0, 0)
    chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    chat:SetMinResize(150, 25)

    if (self ~= 'ChatFrame2') then
        chat.AddMessage = FCF_AddMessage
    end

    local buttonBottom = _G[self]['ScrollToBottomButton']
    if (cfg.enableBottomButton) then
        buttonBottom:Hide()
        buttonBottom:ClearAllPoints()
        buttonBottom:SetPoint('BOTTOMLEFT', chat, -1, -3)
        buttonBottom:HookScript('OnClick', function(self)
            self:Hide()
        end)
    else
        buttonBottom:SetAlpha(0)
        buttonBottom:EnableMouse(false)
    end

    for _, texture in pairs({
        'ButtonFrameBackground',
        'ButtonFrameTopLeftTexture',
        'ButtonFrameBottomLeftTexture',
        'ButtonFrameTopRightTexture',
        'ButtonFrameBottomRightTexture',
        'ButtonFrameLeftTexture',
        'ButtonFrameRightTexture',
        'ButtonFrameBottomTexture',
        'ButtonFrameTopTexture',
    }) do
        _G[self..texture]:SetTexture(nil)
    end

        -- Modify the editbox

    for k = 3, 8 do
        select(k, _G[self..'EditBox']:GetRegions()):SetTexture(nil)
    end

    _G[self..'EditBox']:SetAltArrowKeyMode(cfg.ignoreArrows)

    if (cfg.showInputBoxAbove) then
        local tabHeight = _G[self..'Tab']:GetHeight()
        _G[self..'EditBox']:ClearAllPoints()
        _G[self..'EditBox']:SetPoint('BOTTOMLEFT', chat, 'TOPLEFT', 0, tabHeight + 5)
        _G[self..'EditBox']:SetPoint('BOTTOMRIGHT', chat, 'TOPRIGHT', 0, tabHeight + 5)
    end
    _G[self..'EditBox']:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = {
            left = 3, right = 3, top = 2, bottom = 2
        },
    })

    _G[self..'EditBox']:SetBackdropColor(0, 0, 0, 0.5)
    _G[self..'EditBox']:CreateBeautyBorder(11)
    _G[self..'EditBox']:SetBeautyBorderPadding(-2, -1, -2, -1, -2, -1, -2, -1)

    if (cfg.enableBorderColoring) then
        _G[self..'EditBox']:SetBeautyBorderTexture('white')

        hooksecurefunc('ChatEdit_UpdateHeader', function(editBox)
            local type = editBox:GetAttribute('chatType')
            if (not type) then
                return
            end

            local info = ChatTypeInfo[type]
            _G[self..'EditBox']:SetBeautyBorderColor(info.r, info.g, info.b)
        end)
    end
end

local function SetChatStyle()
    for _, frame in pairs(CHAT_FRAMES) do
        local chat = _G[frame]
        if (chat and not chat.hasModification) then
            ModChat(chat:GetName())

            local convButton = _G[chat:GetName()..'ConversationButton']
            if (convButton) then
                convButton:SetAlpha(0)
                convButton:EnableMouse(false)
            end

            local chatMinimize = _G[chat:GetName()..'ButtonFrameMinimizeButton']
            if (chatMinimize) then
                chatMinimize:SetAlpha(0)
                chatMinimize:EnableMouse(0)
            end

            if (cfg.enableChatWindowBorder) then
                chat:CreateBeautyBorder(12)
                chat:SetBeautyBorderPadding(5, 5, 5, 5, 5, 8, 5, 8)

                if (chat == _G['ChatFrame2']) then
                    chat:CreateBeautyBorder(12)
                    chat:SetBeautyBorderPadding(5, 29, 5, 29, 5, 8, 5, 8)
                end
            end

            chat.hasModification = true
        end
    end
end
hooksecurefunc('FCF_OpenTemporaryWindow', SetChatStyle)
SetChatStyle()

    -- Chat menu, just a middle click on the chatframe 1 tab

hooksecurefunc('ChatFrameMenu_UpdateAnchorPoint', function()
    if (FCF_GetButtonSide(DEFAULT_CHAT_FRAME) == 'right') then
        ChatMenu:ClearAllPoints()
        ChatMenu:SetPoint('BOTTOMRIGHT', ChatFrame1Tab, 'TOPLEFT')
    else
        ChatMenu:ClearAllPoints()
        ChatMenu:SetPoint('BOTTOMLEFT', ChatFrame1Tab, 'TOPRIGHT')
    end
end)

ChatFrame1Tab:RegisterForClicks('AnyUp')
ChatFrame1Tab:HookScript('OnClick', function(self, button)
    if (button == 'MiddleButton' or button == 'Button4' or button == 'Button5') then
        if (ChatMenu:IsShown()) then
            ChatMenu:Hide()
        else
            ChatMenu:Show()
        end
    else
        ChatMenu:Hide()
    end
end)

    -- Modify the gm chatframe and add a sound notification on incoming whispers

local eventWatcher = CreateFrame('Frame')
eventWatcher:RegisterEvent('ADDON_LOADED')
eventWatcher:RegisterEvent('CHAT_MSG_WHISPER')
eventWatcher:SetScript('OnEvent', function(_, event)
    if (event == 'ADDON_LOADED' and arg1 == 'Blizzard_GMChatUI') then
        GMChatFrame:EnableMouseWheel(true)
        GMChatFrame:SetScript('OnMouseWheel', ChatFrame1:GetScript('OnMouseWheel'))
        GMChatFrame:SetHeight(200)

        GMChatFrameUpButton:SetAlpha(0)
        GMChatFrameUpButton:EnableMouse(false)

        GMChatFrameDownButton:SetAlpha(0)
        GMChatFrameDownButton:EnableMouse(false)

        GMChatFrameBottomButton:SetAlpha(0)
        GMChatFrameBottomButton:EnableMouse(false)
    end

    if (event == 'CHAT_MSG_WHISPER') then
        PlaySound(SOUNDKIT.TELL_MESSAGE)
    end
end)

local combatLog = {
    text = 'CombatLog',
    colorCode = '|cffFFD100',
    isNotRadio = true,

    func = function()
        if (not LoggingCombat()) then
            LoggingCombat(true)
            DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGENABLED, 1, 1, 0)
        else
            LoggingCombat(false)
            DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGDISABLED, 1, 1, 0)
        end
    end,

    checked = function()
        if (LoggingCombat()) then
            return true
        else
            return false
        end
    end
}

local chatLog = {
    text = 'ChatLog',
    colorCode = '|cffFFD100',
    isNotRadio = true,

    func = function()
        if (not LoggingChat()) then
            LoggingChat(true)
            DEFAULT_CHAT_FRAME:AddMessage(CHATLOGENABLED, 1, 1, 0)
        else
            LoggingChat(false)
            DEFAULT_CHAT_FRAME:AddMessage(CHATLOGDISABLED, 1, 1, 0)
        end
    end,

    checked = function()
        if (LoggingChat()) then
            return true
        else
            return false
        end
    end
}

local origFCF_Tab_OnClick = _G.FCF_Tab_OnClick
local function FCF_Tab_OnClickHook(chatTab, ...)
    origFCF_Tab_OnClick(chatTab, ...)

    combatLog.arg1 = chatTab
    UIDropDownMenu_AddButton(combatLog)

    chatLog.arg1 = chatTab
    UIDropDownMenu_AddButton(chatLog)
end
FCF_Tab_OnClick = FCF_Tab_OnClickHook
