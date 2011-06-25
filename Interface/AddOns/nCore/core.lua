local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
f:SetScript('OnEvent', function(_, event, ...)
    if (event == 'PLAYER_LOGIN') then
        SetCVar('ScreenshotQuality', 10)
    end

	if (event == 'ACTIVE_TALENT_GROUP_CHANGED') then
		LoadAddOn('Blizzard_GlyphUI')
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

function ma2()
    function UnitAura() 
        return 'TestAura', nil, 'Interface\\Icons\\Spell_Nature_RavenForm', 9, nil, 120, 120, 1, 0 
    end
end