SlashCmdList['WORLDMARKERS'] = function()
	local instanceName, instanceType = GetInstanceInfo()
	local isLeader = IsRealPartyLeader() or IsRealRaidLeader() or IsRaidOfficer()
	local isPvPZone = instanceType == 'arena' or instanceType == 'pvp' and instanceName == 'Wintergrasp' or instanceName == 'Tol Barad'

	if (UnitInParty('player') and not isPvPZone and isLeader) then
		if (CompactRaidFrameManager:IsVisible()) then
			CompactRaidFrameManager:Hide()
		else
			CompactRaidFrameManager:Show()
		end
	else
		if (CompactRaidFrameManager:IsVisible()) then
			CompactRaidFrameManager:Hide()
		else
			PlaySound('igQuestFailed')
			UIErrorsFrame:AddMessage("You're not in a party and/or not eligible for marking", 1, 0, 0)
		end
	end
end
SLASH_WORLDMARKERS1 = '/wm'
SLASH_WORLDMARKERS2 = '/worlmarkers'
SLASH_WORLDMARKERS3 = '/raidmarkers'
SLASH_WORLDMARKERS4 = '/rm'