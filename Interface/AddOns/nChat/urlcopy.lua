
local find = string.find
local gsub = string.gsub

local found = false

local function ColorURL(text, url)
    found = true
    return ' |H'..'url'..':'..tostring(url)..'|h'..'|cff0099FF'..tostring(url)..'|h|r '
end

local function ScanURL(frame, text, ...)
    found = false

    if (find(text:upper(), '%pTINTERFACE%p+')) then
        found = true
    end

        -- 192.168.2.1:1234
    if (not found) then
        text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)', ColorURL)
    end
        -- 192.168.2.1
    if (not found) then
        text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)', ColorURL)
    end
        -- www.url.com:3333
    if (not found) then
        text = gsub(text, '(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)', ColorURL)
    end
        -- http://www.google.com
    if (not found) then
        text = gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", ColorURL)
    end
        -- www.google.com
    if (not found) then
        text = gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", ColorURL)
    end
        -- url@domain.com
    if (not found) then
        text = gsub(text, '(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)', ColorURL)
    end

    frame.add(frame, text,...)
end

local function EnableURLCopy()
    for _, v in pairs(CHAT_FRAMES) do
        local chat = _G[v]
        if (chat and not chat.hasURLCopy and (chat ~= 'ChatFrame2')) then
            chat.add = chat.AddMessage
            chat.AddMessage = ScanURL
            chat.hasURLCopy = true
        end
    end
end
hooksecurefunc('FCF_OpenTemporaryWindow', EnableURLCopy)

local orig = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(frame, link, text, button)
    local type, value = link:match('(%a+):(.+)')
    if (type == 'url') then
        local editBox = _G[frame:GetName()..'EditBox']
        if (editBox) then
            editBox:Show()
            editBox:SetText(value)
            editBox:SetFocus()
            editBox:HighlightText()
        end
    else
        orig(self, link, text, button)
    end
end

EnableURLCopy()
