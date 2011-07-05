
local select = select
local tostring = tostring
local concat = table.concat

    -- first, we create the copy frame

local f = CreateFrame('Frame', nil, ChatFrame1)
f:SetHeight(220)
f:SetBackdropColor(0, 0, 0, 1)
f:SetPoint('BOTTOMLEFT', ChatFrame1EditBox, 'TOPLEFT', 3, 10)
f:SetPoint('BOTTOMRIGHT', ChatFrame1EditBox, 'TOPRIGHT', -3, 10)
f:SetFrameStrata('DIALOG')
f:CreateBeautyBorder(12)
f:SetBackdrop({
    bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
    edgeFile = '',
    tile = true, tileSize = 16, edgeSize = 16,
    insets = {left = 3, right = 3, top = 3, bottom = 3
}})
f:Hide()

f.Text = f:CreateFontString(nil, 'OVERLAY')
f.Text:SetFont('Fonts\\ARIALN.ttf', 18)
f.Text:SetPoint('TOPLEFT', f, 8, -8)
f.Text:SetTextColor(1, 1, 0)
f.Text:SetShadowOffset(1, -1)
f.Text:SetParent(f)
f.Text:SetJustifyH('LEFT')

f.EditBox = CreateFrame('EditBox', nil, f)
f.EditBox:SetMultiLine(true)
f.EditBox:SetMaxLetters(20000)
f.EditBox:SetWidth(450)
f.EditBox:SetHeight(270)
f.EditBox:SetScript('OnEscapePressed', function()
    f:Hide() 
end)

f.ScrollArea = CreateFrame('ScrollFrame', '$parentScrollBar', f, 'UIPanelScrollFrameTemplate')
f.ScrollArea:SetPoint('TOPLEFT', f, 'TOPLEFT', 8, -30)
f.ScrollArea:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -30, 8)
f.ScrollArea:SetScrollChild(f.EditBox)

f.CloseButton = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
f.CloseButton:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, -1)

    -- the functions where we get the text of our chatframe

local lines = {}

local function GetChatLines(...)
    local count = 1

    for i = select('#', ...), 1, -1 do
        local region = select(i, ...)
        if (region:GetObjectType() == 'FontString') then
            lines[count] = tostring(region:GetText())
            count = count + 1
        end
    end

    return count - 1
end

local function copyChat(self, chatTab)
    local chatFrame = _G['ChatFrame' .. chatTab:GetID()]
    local _, fontSize = chatFrame:GetFont()

    FCF_SetChatWindowFontSize(chatFrame, chatFrame, 0.01)
    local lineCount = GetChatLines(chatFrame:GetRegions())

    FCF_SetChatWindowFontSize(chatFrame, chatFrame, fontSize)

    if (lineCount > 0) then
        f:Show()
        f.Text:SetText(chatFrame:GetName())

        local f1, f2, f3 = ChatFrame1:GetFont()
        f.EditBox:SetFont(f1, f2, f3)

        local text = concat(lines, '\n', 1, lineCount)
        f.EditBox:SetText(text)
    end
end

    -- add a copychat-option to the dropdown menu of our chattabs

local info = {
    text = 'ChatCopy',
    colorCode = '|cffffffff',
    func = copyChat,
    notCheckable = true,
}

local origFCF_Tab_OnClick = _G.FCF_Tab_OnClick
local function FCF_Tab_OnClickHook(chatTab, ...)
    origFCF_Tab_OnClick(chatTab, ...)

    info.arg1 = chatTab
    UIDropDownMenu_AddButton(info)
end
FCF_Tab_OnClick = FCF_Tab_OnClickHook