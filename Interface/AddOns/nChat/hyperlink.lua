
    -- Mouseover Itemlinks in the chat
    -- Code provided by the Tukui crew (Tukui.org)

if (not nChat.enableHyperlinkTooltip) then 
    return 
end

local _G = getfenv(0)
local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip

local linktypes = {
    item = true, 
    enchant = true, 
    spell = true, 
    quest = true, 
    unit = true, 
    talent = true, 
    achievement = true, 
    glyph = true
}

local function OnHyperlinkEnter(frame, link, ...)
    local linktype = link:match('^([^:]+)')
    if (linktype and linktypes[linktype]) then
        GameTooltip:SetOwner(ChatFrame1, 'ANCHOR_CURSOR', 0, 20)
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    else
        GameTooltip:Hide()
    end

    if (orig1[frame]) then 
        return orig1[frame](frame, link, ...) 
    end
end

local function OnHyperlinkLeave(frame, ...)
    GameTooltip:Hide()

    if (orig2[frame]) then 
        return orig2[frame](frame, ...) 
    end
end

for i = 1, NUM_CHAT_WINDOWS do
    local frame = _G['ChatFrame'..i]
    orig1[frame] = frame:GetScript('OnHyperlinkEnter')
    frame:SetScript('OnHyperlinkEnter', OnHyperlinkEnter)

    orig2[frame] = frame:GetScript('OnHyperlinkLeave')
    frame:SetScript('OnHyperlinkLeave', OnHyperlinkLeave)
end