
SlashCmdList['TELLTARGET'] = function(msg)   
	if (UnitExists('target') and UnitIsPlayer('target') and UnitIsFriend('player', 'target')) then
		SendChatMessage(msg, 'WHISPER', nil, UnitName('target'))
	end
end

SLASH_TELLTARGET1 = '/tt'