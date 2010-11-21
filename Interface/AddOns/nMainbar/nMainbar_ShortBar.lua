--[[

    nMainbar
    Copyright (c) 2008-2010, Anton "Neav" I. (Neav @ Alleria-EU)
    All rights reserved.

--]]

if (nMainbar.MainMenuBar.shortBar) then

MultiBarBottomRight:ClearAllPoints()
MultiBarBottomRight:SetPoint('BOTTOM', MultiBarBottomLeft, 'TOP', 0, 4)
MultiBarBottomRight.SetPoint = function() end

function ShapeshiftBar_Update() 
    ShapeshiftBar_UpdateState()
end

for _, frame in pairs({
    'MultiBarLeft',
    'MultiBarRight',
    --'MultiBarBottomLeft',
    --'MultiBarBottomRight',
    'ShapeshiftBarFrame',
    'PossessBarFrame',
        
    'MULTICASTACTIONBAR_YPOS',
    'MultiCastActionBarFrame',
        
    -- 'CONTAINER_OFFSET_Y',
    -- 'BATTLEFIELD_TAB_OFFSET_Y',

    'PETACTIONBAR_YPOS',
    -- 'PetActionBarFrame', -- (?)
}) do
    UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
end

for _, frame in pairs({        
    _G['PetActionBarFrame'],
    _G['ShapeshiftBarFrame'],
    _G['PossessBarFrame'],
    _G['MultiCastActionBarFrame'],
}) do
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
    frame:EnableMouse(false)
end

    -- -----------------------------------
    -- make the new totemmanager moveable
    -- -----------------------------------


local f = CreateFrame('Frame', 'MultiCastActionBarFrameAnchor')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetHeight(10)
f:SetWidth(10)
f:SetScript('OnEvent', function(self, event)
    MultiCastActionBarFrame:ClearAllPoints()   
    MultiCastActionBarFrame:SetPoint('CENTER', MultiCastActionBarFrameAnchor) 
    MultiCastActionBarFrame.SetPoint = function() end
    -- MultiCastActionBarFrame:UnregisterAllEvents()
    self:UnregisterAllEvents()
end)

for i = 1, 12 do
    for _, button in pairs({        
        _G['MultiCastActionButton'..i],
        
        _G['MultiCastSlotButton1'],
        _G['MultiCastSlotButton2'],
        _G['MultiCastSlotButton3'],
        _G['MultiCastSlotButton4'],
        
        _G['MultiCastRecallSpellButton'],
        _G['MultiCastSummonSpellButton'],
    }) do
        MultiCastActionBarFrameAnchor:ClearAllPoints()
        MultiCastActionBarFrameAnchor:SetPoint('CENTER', UIParent)  
            
        MultiCastActionBarFrameAnchor:SetMovable(true)
        MultiCastActionBarFrameAnchor:SetUserPlaced(true)
        
        button:RegisterForDrag('LeftButton')

        button:HookScript('OnDragStart', function()
            if (IsControlKeyDown()) then
                MultiCastActionBarFrameAnchor:StartMoving() 
            end
        end)

        button:HookScript('OnDragStop', function() 
            MultiCastActionBarFrameAnchor:StopMovingOrSizing()
        end)
    end
end

for i = 1, 12 do
    for _, button in pairs({        
        _G['MultiCastActionButton'..i],
        
        _G['MultiCastSlotButton1'],
        _G['MultiCastSlotButton2'],
        _G['MultiCastSlotButton3'],
        _G['MultiCastSlotButton4'],
        
        _G['MultiCastRecallSpellButton'],
        _G['MultiCastSummonSpellButton'],
        
        _G['MultiCastActionBarFrame'],
    }) do
        button:SetScale(nMainbar.totemManager.scale)
        button:SetAlpha(nMainbar.totemManager.alpha)
    end
end

MultiCastActionButton1:ClearAllPoints()   
MultiCastActionButton1:SetPoint('CENTER', MultiCastSlotButton1) 

MultiCastActionButton5:ClearAllPoints()   
MultiCastActionButton5:SetPoint('CENTER', MultiCastSlotButton1) 

MultiCastActionButton9:ClearAllPoints()   
MultiCastActionButton9:SetPoint('CENTER', MultiCastSlotButton1) 

hooksecurefunc('MultiCastFlyoutFrame_LoadSlotSpells', function(self, slot, ...)
	local numSpells = select('#', ...)
	if (numSpells == 0) then
		return false
	end

	numSpells = numSpells + 1
    
    for i = 2, numSpells do
        _G['MultiCastFlyoutButton'..i..'Icon']:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end)

MultiCastFlyoutFrame:SetScale(nMainbar.totemManager.scale * 1.1)

if (nMainbar.totemManager.hideRecallButton) then
    MultiCastRecallSpellButton:SetAlpha(0)
    MultiCastRecallSpellButton.SetAlpha = function() end
    MultiCastRecallSpellButton:EnableMouse(false)
    MultiCastRecallSpellButton.EnableMouse = function() end
end

    -- -----------------------------------
    -- moveable bars
    -- -----------------------------------
    
for _, button in pairs({        
    _G['PossessButton1'],
    _G['PetActionButton1'],
    _G['ShapeshiftButton1'],
}) do
    button:ClearAllPoints()
    button:SetPoint('CENTER', UIParent)
    
    button:SetMovable(true)
    button:SetUserPlaced(true)
    button:RegisterForDrag('LeftButton')
    
    button:HookScript('OnDragStart', function(self)
        if (IsShiftKeyDown() and IsAltKeyDown()) then
            self:StartMoving() 
        end
    end)

    button:HookScript('OnDragStop', function(self) 
        self:StopMovingOrSizing()
    end)
end

for _, button in pairs({
    _G['ActionBarUpButton'],
    _G['ActionBarDownButton'],
    
    _G['MainMenuBarBackpackButton'],
    _G['KeyRingButton'],
    
    _G['CharacterBag0Slot'],
    _G['CharacterBag1Slot'],
    _G['CharacterBag2Slot'],
    _G['CharacterBag3Slot'],
}) do
    button:SetAlpha(0)
    button:EnableMouse(false)
end

local f = CreateFrame('Frame')
f:Hide()

for i = 2, 3 do
    for _, texture in pairs({
        _G['MainMenuBarTexture'..i],
        _G['MainMenuMaxLevelBar'..i],
        _G['MainMenuXPBarTexture'..i],
        
        _G['ReputationWatchBarTexture'..i],
        _G['ReputationXPBarTexture'..i],
        
        _G['MainMenuBarPageNumber'],

        _G['SlidingActionBarTexture0'],
        _G['SlidingActionBarTexture1'],
        
        _G['ShapeshiftBarLeft'],
        _G['ShapeshiftBarMiddle'],
        _G['ShapeshiftBarRight'],
        
        _G['PossessBackground1'],
        _G['PossessBackground2'],
    }) do
        -- texture:ClearAllPoints()
        -- texture:SetPoint('TOP', UIParent, 99999, 99999)
        texture:SetParent(f)
    end
end

for _, bar in pairs({
    _G['MainMenuBar'],
    _G['MainMenuExpBar'],
    _G['MainMenuBarMaxLevelBar'],

    _G['ReputationWatchStatusBar'],
    _G['ReputationWatchBar'],
}) do
    bar:SetWidth(512)
    -- bar:SetFrameStrata('BACKGROUND')
end

-- Fixes the issue with resizing exp bar when entering and exiting vehicles
-- as well as the positioning the dividers properly
hooksecurefunc('MainMenuExpBar_SetWidth', function(width)
	if not InCombatLockdown() then
		if width == EXP_DEFAULT_WIDTH then
			MainMenuXPBarTextureMid:SetWidth(512 - 28)
			MainMenuExpBar:SetWidth(512)
			width = 512
		end
		local divWidth = width/10
		local xpos = divWidth - 4.5
		for i=1,9 do
			local texture = _G["MainMenuXPBarDiv"..i]
			local xalign = floor(xpos)
			texture:SetPoint("LEFT", xalign, 1)
			xpos = xpos + divWidth
		end
	end
end)

-- Remove superfluous experience bar dividers
for i = 10, 19 do
    for _, frame in pairs({
        _G['MainMenuXPBarDiv'..i],
    }) do
        frame:Hide()
    end
end

MainMenuBarTexture0:SetPoint('BOTTOM', MainMenuBarArtFrame, -128, 0)
MainMenuBarTexture1:SetPoint('BOTTOM', MainMenuBarArtFrame, 128, 0)

MainMenuMaxLevelBar0:SetPoint('BOTTOM', MainMenuBarMaxLevelBar, 'TOP', -128, 0)

MainMenuBarLeftEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, -289, 0)
MainMenuBarLeftEndCap.SetPoint = function() end

MainMenuBarRightEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, 289, 0)
MainMenuBarRightEndCap.SetPoint = function() end

CharacterMicroButton:ClearAllPoints()
CharacterMicroButton:SetPoint('BOTTOMLEFT', 9000, 9000)

GuildMicroButton:ClearAllPoints()
GuildMicroButton:SetPoint('TOPLEFT', CharacterMicroButton, 'BOTTOMLEFT', 0, 20)

hooksecurefunc('VehicleMenuBar_MoveMicroButtons', function(self)
	if (not self) then
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
	elseif (self == 'Mechanical') then
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint('BOTTOMLEFT', VehicleMenuBar, 'BOTTOMRIGHT', -340, 41)
	elseif (self == 'Natural') then
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint('BOTTOMLEFT', VehicleMenuBar, 'BOTTOMRIGHT', -365, 41)
	end
end)

end

MainMenuBarVehicleLeaveButton:HookScript('OnEvent', function(self, event, ...)
	MainMenuBarVehicleLeaveButton:ClearAllPoints()
	MainMenuBarVehicleLeaveButton:SetPoint('LEFT', MainMenuBar, 'RIGHT', 10, 80)
end)