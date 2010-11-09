SlashCmdList['FRAMENAME'] = function()
    local name = GetMouseFocus():GetName()
    
    if (name) then
        DEFAULT_CHAT_FRAME:AddMessage('|cff00FF00   '..name)
    else
        DEFAULT_CHAT_FRAME:AddMessage('|cff00FF00This frame has no name!')
    end
end

SLASH_FRAMENAME1 = '/frame'

SlashCmdList['RELOADUI'] = function()
    ReloadUI()
end

SLASH_RELOADUI1 = '/rl'

WatchFrameTitle:SetAlpha(0)

local p1, p2, p3, p4, p5 = WatchFrameCollapseExpandButton:GetPoint()
WatchFrameCollapseExpandButton:ClearAllPoints()
WatchFrameCollapseExpandButton:SetPoint(p1, p2, p3, p4 - 15, p5)

local a, b, c, d, e = RaidFrameNotInRaidRaidBrowserButton:GetPoint() 
RaidFrameNotInRaidRaidBrowserButton:SetPoint(a, b, c, d, e - 25)

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("BOTTOMRIGHT", UIParent, 0, 0)

--[[
function UnitAura() 
    return "TestAura", nil, "Interface\\Icons\\Spell_Nature_RavenForm", 9, nil, 120, 120, 1, 0 
end
--]]