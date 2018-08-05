
local _, nChat = ...
local cfg = nChat.Config

local concat = table.concat

local chatWidth, chatHeight = ChatFrame1:GetSize()
local container = CreateFrame("Frame", nil, UIParent)
container:SetSize(chatWidth, chatHeight)
container:SetFrameStrata("DIALOG")
container:CreateBeautyBorder(12)
container:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeSize = 16,
    tile = true, tileSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
container:SetBackdropColor(0, 0, 0)
container:Hide()

local title = container:CreateFontString(nil, "OVERLAY")
title:SetPoint("TOPLEFT", 8, -8)
title:SetFont(STANDARD_TEXT_FONT, 18)
title:SetTextColor(1, 1, 0)
title:SetShadowOffset(1, -1)
title:SetJustifyH("LEFT")

local closeButton = CreateFrame("Button", nil, container, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", 0, -1)

local copyBox = CreateFrame("EditBox", nil, container)
copyBox:SetSize(chatWidth - 38, chatHeight - 38) -- a ScrollFrame's child needs to have its size set explicitly
copyBox:SetMultiLine(true)
copyBox:SetAutoFocus(false)
copyBox:SetScript("OnEscapePressed", function()
    container:Hide()
end)

local scroll = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 8, -30)
scroll:SetPoint("BOTTOMRIGHT", -30, 8)
scroll:SetScrollChild(copyBox)

scroll.ScrollBar:SetScript("OnMinMaxChanged", function(self, _, max)
    -- need to use a timer here, because the values take time to update
    C_Timer.After(2, function() self:SetValue(max) end)
end)

local function GetChatLines(chat)
    local lines = {}
    for message = 1, chat:GetNumMessages() do
        lines[message] = chat:GetMessageInfo(message)
    end

    return lines
end

local function CopyChat(chat)
    ToggleFrame(container)

    if container:IsShown() then
        if cfg.showInputBoxAbove then
            local editBox = _G[chat:GetName().."EditBox"]
            container:SetPoint("BOTTOMLEFT", editBox, "TOPLEFT", 3, 10)
            container:SetPoint("BOTTOMRIGHT", editBox, "TOPRIGHT", -3, 10)
        else
            local tabHeight = _G[chat:GetName().."Tab"]:GetHeight()
            container:SetPoint("BOTTOMLEFT", chat, "TOPLEFT", 0, tabHeight + 10)
            container:SetPoint("BOTTOMRIGHT", chat, "TOPRIGHT", 0, tabHeight + 10)
        end

        local width, height = container:GetSize()
        copyBox:SetSize(width - 38, height - 38)
        scroll:UpdateScrollChildRect()

        title:SetText(chat.name)

        local f1, f2, f3 = chat:GetFont()
        copyBox:SetFont(f1, f2, f3)

        local lines = GetChatLines(chat)
        local text = concat(lines, "\n")
        copyBox:SetMaxLetters(#lines * 255 + #lines)
        copyBox:SetText(text)
    end
end

local function CreateCopyButton(self)
    self.Copy = CreateFrame("Button", nil, self)
    self.Copy:SetSize(20, 20)
    self.Copy:SetPoint("TOPRIGHT", self, -5, -5)

    self.Copy:SetNormalTexture("Interface\\AddOns\\nChat\\media\\textureCopyNormal")
    self.Copy:GetNormalTexture():SetSize(20, 20)

    self.Copy:SetHighlightTexture("Interface\\AddOns\\nChat\\media\\textureCopyHighlight")
    self.Copy:GetHighlightTexture():SetAllPoints(self.Copy:GetNormalTexture())

    local tab = _G[self:GetName().."Tab"]
    hooksecurefunc(tab, "SetAlpha", function()
        self.Copy:SetAlpha(tab:GetAlpha()*0.55)
    end)

    self.Copy:SetScript("OnMouseDown", function(self)
        self:GetNormalTexture():ClearAllPoints()
        self:GetNormalTexture():SetPoint("CENTER", 1, -1)
    end)

    self.Copy:SetScript("OnMouseUp", function()
        self.Copy:GetNormalTexture():ClearAllPoints()
        self.Copy:GetNormalTexture():SetPoint("CENTER")

        if self.Copy:IsMouseOver() then
            CopyChat(self)
        end
    end)
end

local function EnableCopyButton()
    for _, v in pairs(CHAT_FRAMES) do
        local chat = _G[v]
        if chat and not chat.Copy then
            CreateCopyButton(chat)
        end
    end
end
hooksecurefunc("FCF_OpenTemporaryWindow", EnableCopyButton)
EnableCopyButton()
