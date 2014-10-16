
local button = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

-- button:UnregisterAllEvents()
button:SetParent(UIParent)
button:ClearAllPoints()
button:SetPoint('TOPLEFT', UIParent, 3, -3)
button:SetSize(26, 26)
button:Hide()

button:HookScript('OnClick', function()
    local dropDown = DropDownList1
    local p1, p2, p3, p4, p5 = dropDown:GetPoint()
    dropDown:SetPoint(p1, p2, p3, p4 + 9, p5 - 5) 
end)

buttonHighlight = button:GetHighlightTexture()
buttonHighlight:ClearAllPoints()
buttonHighlight:SetPoint('CENTER', button)
buttonHighlight:SetParent(button)
buttonHighlight:SetSize(20, 20)
buttonHighlight:SetTexture(nil)


SlashCmdList['WORLDMARKERS'] = function()
	local instanceName, instanceType = GetInstanceInfo()
	local isLeader = UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')
	local isPvPZone = instanceType == 'arena' or instanceType == 'pvp' and instanceName == 'Wintergrasp' or instanceName == 'Tol Barad'

	if (UnitInParty('player') and (not isPvPZone) and isLeader) then
        ToggleFrame(button)
	else
		if (button:IsVisible()) then
			button:Hide()
		else
			PlaySound('igQuestFailed')
			UIErrorsFrame:AddMessage('You are not in a party and/or not eligible for marking', 1, 0, 0)
		end
	end
end

SLASH_WORLDMARKERS1 = '/wmarkers'
SLASH_WORLDMARKERS2 = '/worldmarkers'
SLASH_WORLDMARKERS3 = '/raidmarkers'
SLASH_WORLDMARKERS4 = '/rmarkers'

    -- InitiateRolePoll()

SlashCmdList['ROLECHECK'] = function()
    InitiateRolePoll()
end

ROLECHECK1 = '/rolecheck'
ROLECHECK2 = '/rcheck'

    -- DoReadyCheck()
