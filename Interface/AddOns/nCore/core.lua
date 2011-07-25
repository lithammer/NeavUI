
INTERFACE_ACTION_BLOCKED = ''

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

function AuraTest()
    function UnitAura() 
        return 'TestAura', nil, 'Interface\\Icons\\Spell_Nature_RavenForm', 9, nil, 120, 120, 1, 0 
    end
end






local grid
local boxSize = 32

function Grid_Show()
	if not grid then
        Grid_Create()
	elseif grid.boxSize ~= boxSize then
        grid:Hide()
        Grid_Create()
    else
		grid:Show()
	end
end

function Grid_Hide()
	if grid then
		grid:Hide()
	end
end

local isAligning = false
SLASH_TOGGLEGRID1 = "/align"
SlashCmdList["TOGGLEGRID"] = function(arg)
    if isAligning then
        Grid_Hide()
        isAligning = false
    else
        boxSize = (math.ceil((tonumber(arg) or boxSize) / 32) * 32)
    if boxSize > 256 then boxSize = 256 end    
        Grid_Show()
        isAligning = true
    end
end

function Grid_Create() 
	grid = CreateFrame('Frame', nil, UIParent) 
	grid.boxSize = boxSize 
	grid:SetAllPoints(UIParent) 

	local size = 2 
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio

	local wStep = width / boxSize
	local hStep = height / boxSize

	for i = 0, boxSize do 
		local tx = grid:CreateTexture(nil, 'BACKGROUND') 
		if i == boxSize / 2 then 
			tx:SetTexture(1, 0, 0, 0.5) 
		else 
			tx:SetTexture(0, 0, 0, 0.5) 
		end 
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", i*wStep - (size/2), 0) 
		tx:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', i*wStep + (size/2), 0) 
	end 
	height = GetScreenHeight()
	
	do
		local tx = grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(1, 0, 0, 0.5)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2 + size/2))
	end
	
	for i = 1, math.floor((height/2)/hStep) do
		local tx = grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 0, 0, 0.5)
		
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2+i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2+i*hStep + size/2))
		
		tx = grid:CreateTexture(nil, 'BACKGROUND') 
		tx:SetTexture(0, 0, 0, 0.5)
		
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height/2-i*hStep) + (size/2))
		tx:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -(height/2-i*hStep + size/2))
		
	end
	
end