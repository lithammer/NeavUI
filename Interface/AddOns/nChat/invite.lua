
local sub = string.sub
local match = string.match

local origSetItemRef = SetItemRef
function SetItemRef(link, text, button)
    local linkType = sub(link, 1, 6)
    if (IsAltKeyDown() and linkType == 'player') then
        local name = match(link, 'player:([^:]+)')
        InviteUnit(name)
        return nil
    end

    return origSetItemRef(link,text,button)
end