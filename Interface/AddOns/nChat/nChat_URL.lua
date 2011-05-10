
if (not nChat.enableURLCopy) then
    return
end

local _G = _G
local gsub = string.gsub
local find = string.find

local urlStyle = '|cffff00ff|Hurl:%1|h%1|h|r'
local urlPatterns = {
	'(http://%S+)',                 -- http://xxx.com
	'(www%.%S+)',                   -- www.xxx.com/site/index.php
	'(%d+%.%d+%.%d+%.%d+:?%d*)',    -- 192.168.1.1 and 192.168.1.1:1110
}

local messageTypes = {
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_GUILD',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_RAID',
	'CHAT_MSG_SAY',
	'CHAT_MSG_WHISPER',
}

local function urlFilter(self, event, text, ...)
	for _, pattern in ipairs(urlPatterns) do
		local result, matches = gsub(text, pattern, urlStyle)

		if (matches > 0) then
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
	if link:sub(0, 3) == 'url' then
		currentLink = link:sub(5)
		StaticPopup_Show('UrlCopyDialog')
		return
	end
	
	return origSetItemRef(link, text, button)
end

SetItemRef = SetItemRefHook

StaticPopupDialogs['UrlCopyDialog'] = {
	text = 'URL',
	button2 = CLOSE,
	hasEditBox = 1,
	editBoxWidth = 250,
    
	OnShow = function(frame)
		local editBox = _G[frame:GetName()..'EditBox']
		if (editBox) then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
        
		local button = _G[frame:GetName()..'Button2']
		if (button) then
			button:ClearAllPoints()
			button:SetWidth(100)
			button:SetPoint('CENTER', editBox, 'CENTER', 0, -30)
		end
	end,
    
	EditBoxOnEscapePressed = function(frame) 
        frame:GetParent():Hide() 
    end,
    
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	maxLetters = 1024,
}