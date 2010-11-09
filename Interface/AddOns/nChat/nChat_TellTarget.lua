for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame"..i.."EditBox"]
	editBox:HookScript("OnTextChanged", function(self)
	   local text = self:GetText()
	   if text:len() < 5 then
		  if text:sub(1, 4) == "/tt " then
			 local unitname, realm
			 unitname, realm = UnitName("target")
			 if unitname then unitname = gsub(unitname, " ", "") end
			 if unitname and not UnitIsSameServer("player", "target") then
				unitname = unitname .. "-" .. gsub(realm, " ", "")
			 end
			 ChatFrame_SendTell((unitname or tukuilocal.chat_invalidtarget), ChatFrame1)
		  end
	   end
	end)
end


-- SlashCmdList['TELLTARGET'] = function(msg)   
	-- if (UnitExists('target') and UnitIsPlayer('target') and UnitIsFriend('player', 'target')) then
		-- SendChatMessage(msg, 'WHISPER', nil, UnitName('target'))
	-- end
-- end

-- SLASH_TELLTARGET1 = '/tt'