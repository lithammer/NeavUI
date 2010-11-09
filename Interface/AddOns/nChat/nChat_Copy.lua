local frame = CreateFrame("Frame", "nChatCopyFrame", UIParent)
frame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = {left = 3, right = 3, top = 5, bottom = 3
}})

frame:SetBackdropColor(0, 0, 0, 1)
frame:SetWidth(500)
frame:SetHeight(400)
frame:SetPoint("LEFT", UIParent, "LEFT", 3, 10)
frame:SetFrameStrata("DIALOG")
frame:Hide()

local scrollArea = CreateFrame("ScrollFrame", "nChatCopyFrameScroll", frame, "UIPanelScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

editBox = CreateFrame("EditBox", "nChatCopyBox", frame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(20000)
editBox:EnableMouse(true)
editBox:SetAutoFocus(true)
editBox:SetFontObject(ChatFontNormal)
editBox:SetWidth(450)
editBox:SetHeight(270)
editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

scrollArea:SetScrollChild(editBox)

local close = CreateFrame("Button", "nChatCopyClose", frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -1)

local lines = {}
local getLines = function(...)
	local count = 1

	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		
		if region:GetObjectType() == "FontString" then
			lines[count] = tostring(region:GetText())
			count = count + 1
		end
	end

	return count - 1
end

local copyChat = function(self, chatTab)
	local chatFrame = _G["ChatFrame" .. chatTab:GetID()]
	local _, fontSize = chatFrame:GetFont()
	
	FCF_SetChatWindowFontSize(chatFrame, chatFrame, 0.01)
	
	local lineCount = getLines(chatFrame:GetRegions())
	
	FCF_SetChatWindowFontSize(chatFrame, chatFrame, fontSize)

	if lineCount > 0 then
		local text = table.concat(lines, "\n", 1, lineCount)

		frame:Show()
		editBox:SetText(text)
	end
end

local info = {
	text = "Copy Chat Contents",
	func = copyChat,
	notCheckable = 1	
}

local origFCF_Tab_OnClick = _G.FCF_Tab_OnClick
local FCF_Tab_OnClickHook = function(chatTab, ...)
	origFCF_Tab_OnClick(chatTab, ...)

	info.arg1 = chatTab
	
	UIDropDownMenu_AddButton(info)
end

FCF_Tab_OnClick = FCF_Tab_OnClickHook