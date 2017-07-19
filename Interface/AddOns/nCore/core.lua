
--INTERFACE_ACTION_BLOCKED = ''

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function(_, event, ...)
    if (event == 'PLAYER_LOGIN') then
        SetCVar('ScreenshotQuality', 10)
    end
end)

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

if ( AddonList ) then
    _G['ADDON_DEMAND_LOADED'] = "On Demand";
end

--[[
local sh = UIParent:CreateTexture(nil, 'BACKGROUND')
sh:SetAllPoints(UIParent)
sh:SetTexture(0, 0, 0)
sh:Hide()

hooksecurefunc(GameMenuFrame, 'Show', function()
    sh:SetAlpha(0)
    securecall('UIFrameFadeIn', sh, 0.235, sh:GetAlpha(), 0.5)
end)

hooksecurefunc(GameMenuFrame, 'Hide', function()
    securecall('UIFrameFadeOut', sh, 0.235, sh:GetAlpha(), 0)
end)
--]]
