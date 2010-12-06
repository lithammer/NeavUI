local gsub = _G.string.gsub
local find = _G.string.find

local urlStyle = "|cffffffff|Hurl:%1|h[%1]|h|r"
local urlPatterns = {
	"(http://%S+)", -- http://foo.com
	"(www%.%S+)", -- www.foo.com/whatever/index.php
	"(%d+%.%d+%.%d+%.%d+:?%d*)", -- 192.168.1.3, 192.3.4.5:43567
}

local messageTypes = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_RAID",
	"CHAT_MSG_SAY",
	"CHAT_MSG_WHISPER",
}

local urlFilter = function(self, event, text, ...)
	for _, pattern in ipairs(urlPatterns) do
		local result, matches = gsub(text, pattern, urlStyle)

		if matches > 0 then
			return false, result, ...
		end
	end
end

for _, event in ipairs(messageTypes) do
	ChatFrame_AddMessageEventFilter(event, urlFilter)
end

local origSetItemRef = _G.SetItemRef
local currentLink
local SetItemRefHook = function(link, text, button)
	if link:sub(0, 3) == "url" then
		currentLink = link:sub(5)
		StaticPopup_Show("UrlCopyDialog")
		return
	end
	
	return origSetItemRef(link, text, button)
end

SetItemRef = SetItemRefHook

StaticPopupDialogs["UrlCopyDialog"] = {
	text = "URL",
	button2 = CLOSE,
	hasEditBox = 1,
	editBoxWidth = 400,
	OnShow = function(frame)
		local editBox = _G[frame:GetName().."EditBox"]
		if editBox then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
		local button = _G[frame:GetName().."Button2"]
		if button then
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
		end
	end,
	EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	maxLetters = 1024, -- this otherwise gets cached from other dialogs which caps it at 10..20..30...
}