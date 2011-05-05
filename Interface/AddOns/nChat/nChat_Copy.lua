
local frame = CreateFrame('Frame', 'nChat_Copy', UIParent)
-- frame:SetWidth(350)
frame:SetHeight(220)
frame:SetBackdropColor(0, 0, 0, 1)
frame:SetPoint('BOTTOMLEFT', ChatFrame1EditBox, 'TOPLEFT', 3, 10)
frame:SetPoint('BOTTOMRIGHT', ChatFrame1EditBox, 'TOPRIGHT', -3, 10)
frame:SetFrameStrata('DIALOG')
frame:Hide()
frame:SetBackdrop({
	bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
	edgeFile = '',
	tile = true, tileSize = 16, edgeSize = 16,
	insets = {left = 3, right = 3, top = 3, bottom = 3
}})

frame:CreateBorder(12)

editBox = CreateFrame('EditBox', '$parentTextBox', frame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(20000)
editBox:EnableMouse(true)
editBox:SetAutoFocus(true)
editBox:SetFontObject(ChatFontNormal)
editBox:SetWidth(450)
editBox:SetHeight(270)
editBox:SetScript('OnEscapePressed', function() 
    frame:Hide() 
end)

local scrollArea = CreateFrame('ScrollFrame', '$parentScrollFrame', frame, 'UIPanelScrollFrameTemplate')
scrollArea:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, -30)
scrollArea:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -30, 8)
scrollArea:SetScrollChild(editBox)

local close = CreateFrame('Button', '$parentCloseButton', frame, 'UIPanelCloseButton')
close:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 0, -1)

local lines = {}
local function getLines(...)
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
	local lineCount = getLines(chatFrame:GetRegions())
	
	FCF_SetChatWindowFontSize(chatFrame, chatFrame, fontSize)

	if (lineCount > 0) then
		local text = table.concat(lines, '\n', 1, lineCount)
		frame:Show()
		editBox:SetText(text)
	end
end

local info = {
	text = '|cffff00ffCopyChat|r',
	func = copyChat,
	notCheckable = 1	
}

local origFCF_Tab_OnClick = _G.FCF_Tab_OnClick
local function FCF_Tab_OnClickHook(chatTab, ...)
	origFCF_Tab_OnClick(chatTab, ...)
	info.arg1 = chatTab
	UIDropDownMenu_AddButton(info)
end
FCF_Tab_OnClick = FCF_Tab_OnClickHook