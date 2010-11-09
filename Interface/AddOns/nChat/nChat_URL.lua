-----------------------------------------------------------------------------
-- copy url
-----------------------------------------------------------------------------

local color = "BD0101"
local pattern = "[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]"

function string.color(text, color)
	return "|cff"..color..text.."|r"
end

function string.link(text, type, value, color)
	return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end

StaticPopupDialogs["LINKME"] = {
	text = "URL COPY",
	button2 = CANCEL,
	hasEditBox = true,
    	hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

local function f(url)
	return string.link("["..url.."]", "url", url, color)
end

local function hook(self, text, ...)
	self:f(text:gsub(pattern, f), ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	if ( i ~= 2 ) then
		local frame = _G["ChatFrame"..i]
		frame.f = frame.AddMessage
		frame.AddMessage = hook
	end
end

local f = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(self, link, text, button)
	local type, value = link:match("(%a+):(.+)")
	if ( type == "url" ) then
		local dialog = StaticPopup_Show("LINKME")
		local editbox = _G[dialog:GetName().."WideEditBox"]  
		editbox:SetText(value)
		editbox:SetFocus()
		editbox:HighlightText()
		local button = _G[dialog:GetName().."Button2"]
            
		button:ClearAllPoints()
           
		button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
	else
		f(self, link, text, button)
	end
end
