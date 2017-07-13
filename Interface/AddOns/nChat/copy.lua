
local _, nChat = ...
local cfg = nChat.Config

local select = select
local tostring = tostring
local concat = table.concat

    -- First, we create the copy frame

local f = CreateFrame('Frame', nil, UIParent)
f:SetHeight(220)
f:SetBackdropColor(0, 0, 0, 1)
f:SetFrameStrata('DIALOG')
f:CreateBeautyBorder(12)
f:SetBackdrop({
    bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
    edgeFile = '',
    tile = true, tileSize = 16, edgeSize = 16,
    insets = {left = 3, right = 3, top = 3, bottom = 3
}})
f:Hide()

f.t = f:CreateFontString(nil, 'OVERLAY')
f.t:SetFont('Fonts\\ARIALN.ttf', 18)
f.t:SetPoint('TOPLEFT', f, 8, -8)
f.t:SetTextColor(1, 1, 0)
f.t:SetShadowOffset(1, -1)
f.t:SetJustifyH('LEFT')

f.b = CreateFrame('EditBox', nil, f)
f.b:SetMultiLine(true)
f.b:SetMaxLetters(20000)
f.b:SetSize(450, 270)
f.b:SetScript('OnEscapePressed', function()
    f:Hide()
end)

f.s = CreateFrame('ScrollFrame', '$parentScrollBar', f, 'UIPanelScrollFrameTemplate')
f.s:SetPoint('TOPLEFT', f, 'TOPLEFT', 8, -30)
f.s:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -30, 8)
f.s:SetScrollChild(f.b)

f.c = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
f.c:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, -1)

local lines = {}
local function GetChatLines(self)
    table.wipe(lines) -- in case the chat was cleared
    for message = 1, self:GetNumMessages() do
        lines[message] = self:GetMessageInfo(message)
    end

    return #lines
end

local function copyChat(self)
    ToggleFrame(f)

    if (f:IsShown()) then
        local lineCount = GetChatLines(self)
        if (cfg.showInputBoxAbove) then
            local editBox = _G[self:GetName()..'EditBox']
            f:SetPoint('BOTTOMLEFT', editBox, 'TOPLEFT', 3, 10)
            f:SetPoint('BOTTOMRIGHT', editBox, 'TOPRIGHT', -3, 10)
        else
            local tabHeight = _G[self:GetName()..'Tab']:GetHeight()
            f:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, tabHeight + 10)
            f:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, tabHeight + 10)
        end

        f.t:SetText(self:GetName())

        local f1, f2, f3 = self:GetFont()
        f.b:SetFont(f1, f2, f3)

        local text = concat(lines, '\n', 1, lineCount)
        f.b:SetText(text)
    end
end

local function CreateCopyButton(self)
    self.Copy = CreateFrame('Button', nil, self)
    self.Copy:SetSize(20, 20)
    self.Copy:SetPoint('TOPRIGHT', self, -5, -5)

    self.Copy:SetNormalTexture('Interface\\AddOns\\nChat\\media\\textureCopyNormal')
    self.Copy:GetNormalTexture():SetSize(20, 20)

    self.Copy:SetHighlightTexture('Interface\\AddOns\\nChat\\media\\textureCopyHighlight')
    self.Copy:GetHighlightTexture():SetAllPoints(self.Copy:GetNormalTexture())

    local tab = _G[self:GetName()..'Tab']
    hooksecurefunc(tab, 'SetAlpha', function()
        self.Copy:SetAlpha(tab:GetAlpha()*0.55)
    end)

    self.Copy:SetScript('OnMouseDown', function(self)
        self:GetNormalTexture():ClearAllPoints()
        self:GetNormalTexture():SetPoint('CENTER', 1, -1)
    end)

    self.Copy:SetScript('OnMouseUp', function()
        self.Copy:GetNormalTexture():ClearAllPoints()
        self.Copy:GetNormalTexture():SetPoint('CENTER')

        if (self.Copy:IsMouseOver()) then
            copyChat(self)
        end
    end)
end

local function EnableCopyButton()
    for _, v in pairs(CHAT_FRAMES) do
        local chat = _G[v]
        if (chat and not chat.Copy) then
            CreateCopyButton(chat)
        end
    end
end
hooksecurefunc('FCF_OpenTemporaryWindow', EnableCopyButton)
EnableCopyButton()
