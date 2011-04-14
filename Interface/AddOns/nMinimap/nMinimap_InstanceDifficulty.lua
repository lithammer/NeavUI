
--  MiniMapInstanceDifficulty:SetAlpha(0)

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint('TOP', Minimap, 32, 8)

local w, h = MiniMapInstanceDifficultyTexture:GetSize()
MiniMapInstanceDifficultyTexture:SetSize(w*0.8, h*0.8)

--[[
local isHeroic = false
local function GetInstanceDifficulty2()
    local selectedRaidDifficulty
    local allowedRaidDifficulty

	local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
	if ((instanceType == 'party' or instanceType == 'raid') and not (difficulty == 1 and maxPlayers == 5 )) then		
		if (instanceType == 'party' and difficulty == 2) then
			isHeroic = true
		elseif (instanceType == 'raid') then
			if (isDynamicInstance) then
				selectedRaidDifficulty = difficulty;
				if (playerDifficulty == 1 ) then
					if (selectedRaidDifficulty <= 2) then
						selectedRaidDifficulty = selectedRaidDifficulty + 2
					end
					isHeroic = true
				end

				if (selectedRaidDifficulty == 1) then
					allowedRaidDifficulty = 3
				elseif (selectedRaidDifficulty == 2) then
					allowedRaidDifficulty = 4
				elseif (selectedRaidDifficulty == 3) then
					allowedRaidDifficulty = 1
				elseif (selectedRaidDifficulty == 4) then
					allowedRaidDifficulty = 2
				end
				allowedRaidDifficulty = 'RAID_DIFFICULTY'..allowedRaidDifficulty
			elseif (difficulty > 2) then
				isHeroic = true
			end
		end

		if (isHeroic) then
            f.texture1:SetTexture('Interface\\AddOns\\nMinimap\\media\\heroDown')
            f.text:SetTextColor(1, 0, 1)
		else
            f.texture1:SetTexture('Interface\\AddOns\\nMinimap\\media\\normalDown')
            f.text:SetTextColor(1, 1, 1)
		end
        
		f.MouseOver:Show()
        f.text:Hide()
        f.text:SetText(maxPlayers)
	else
		f.MouseOver:Hide()
        f.text:Hide()
        f.text:SetText(nil)
	end
end

f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
f:RegisterEvent('UPDATE_INSTANCE_INFO')
f:RegisterEvent('ZONE_CHANGED')
f:RegisterEvent('ZONE_CHANGED_INDOORS')
f:RegisterEvent('ZONE_CHANGED_NEW_AREA')
f:SetScript('OnEvent', function()
    GetInstanceDifficulty2()
end)
-- SetFrameLevel(Minimap:GetFrameLevel() + 1)

f.MouseOver = CreateFrame('Frame')
f.MouseOver:SetParent(Minimap)
f.MouseOver:EnableMouse(true)
f.MouseOver:SetPoint('TOPRIGHT', 15, 15)
f.MouseOver:SetPoint('BOTTOMLEFT', -0, -15)

f.text = f.MouseOver:CreateFontString(nil, 'OVERLAY')
f.text:SetFont('Interface\\AddOns\\nMinimap\\media\\fontVisitor.ttf', 19, 'OUTLINE')    -- Fonts\\ARIALN.ttf
f.text:SetPoint('BOTTOM', Minimap, 'TOP', 50, 2)

f.texture1 = f.MouseOver:CreateTexture(nil, 'BORDER')
f.texture1:SetHeight(50)
f.texture1:SetWidth(50)
f.texture1:SetPoint('BOTTOM', f.text, 'BOTTOM', -10, 0)
f.texture1:SetParent(f.MouseOver)

f.MouseOver:SetAllPoints(f.texture1)

f.MouseOver:SetScript('OnEnter', function()
    if (isHeroic) then
        f.texture1:SetTexture('Interface\\AddOns\\nMinimap\\media\\heroUp')
    else
        f.texture1:SetTexture('Interface\\AddOns\\nMinimap\\media\\normalUp')
    end
    UIFrameFadeIn(f.text, 0.15, f.text:GetAlpha(), 1)
end)

f.MouseOver:SetScript('OnLeave', function()
    if (isHeroic) then
        f.texture1:SetTexture('Interface\\AddOns\\nMinimap\\media\\heroDown')
    else
        f.texture1:SetTexture('Interface\\AddOns\\nMinimap\\media\\normalDown')
    end
    UIFrameFadeOut(f.text, 0.05, f.text:GetAlpha(), 0)
end)
--]]
