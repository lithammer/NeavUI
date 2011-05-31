
if (not nMainbar.MainMenuBar.shortBar) then
    return
end

    -- disable the automatic frame position

do
    for _, frame in pairs({
        'MultiBarLeft',
        'MultiBarRight',
        'MultiBarBottomRight',

        'ShapeshiftBarFrame',
        'PossessBarFrame',
            
        'MULTICASTACTIONBAR_YPOS',
        'MultiCastActionBarFrame',

        'PETACTIONBAR_YPOS',
    }) do
        UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
    end
end

    -- hide unwanted objects
    
for i = 2, 3 do
    for _, object in pairs({
        _G['ActionBarUpButton'],
        _G['ActionBarDownButton'],
        
        _G['MainMenuBarBackpackButton'],
        _G['KeyRingButton'],
        
        _G['CharacterBag0Slot'],
        _G['CharacterBag1Slot'],
        _G['CharacterBag2Slot'],
        _G['CharacterBag3Slot'],
        
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
        if (object:IsObjectType('Frame') or object:IsObjectType('Button')) then
            object:UnregisterAllEvents()
            object:SetScript('OnEnter', nil)
            object:SetScript('OnLeave', nil)
            object:SetScript('OnClick', nil)
        end
        
        hooksecurefunc(object, 'Show', function(self)
            self:Hide()
        end)
        
        object:Hide()
    end
end

	-- remove divider

for i = 1, 19, 2 do
    for _, object in pairs({
        _G['MainMenuXPBarDiv'..i],
    }) do
        hooksecurefunc(object, 'Show', function(self)
            self:Hide()
        end)
        
        object:Hide()
    end
end

securecall('MainMenuExpBar_SetWidth', 512)

    -- reduce the size of some main menu bar objects
    
for _, object in pairs({
    _G['MainMenuBar'],
    _G['MainMenuExpBar'],
    _G['MainMenuBarMaxLevelBar'],
    
    _G['ReputationWatchBar'],
    _G['ReputationWatchStatusBar'],
}) do
    object:SetWidth(512)
end

	-- fix the exp bar size when exiting vehicle
	
MainMenuExpBar:HookScript('OnSizeChanged', function(self, width, height)
	if (math.floor(width) == EXP_DEFAULT_WIDTH) then
		securecall('MainMenuExpBar_SetWidth', 512)
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
	end
end)

    -- the bottom right bar needs a better place, above the bottom left bar

MultiBarBottomRight:EnableMouse(false)

MultiBarBottomRightButton1:ClearAllPoints()
MultiBarBottomRightButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)

    -- reposit some objects
    
MainMenuBarTexture0:SetPoint('BOTTOM', MainMenuBarArtFrame, -128, 0)
MainMenuBarTexture1:SetPoint('BOTTOM', MainMenuBarArtFrame, 128, 0)

MainMenuMaxLevelBar0:SetPoint('BOTTOM', MainMenuBarMaxLevelBar, 'TOP', -128, 0)

MainMenuBarLeftEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, -289, 0)
MainMenuBarLeftEndCap.SetPoint = function() end

MainMenuBarRightEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, 289, 0)
MainMenuBarRightEndCap.SetPoint = function() end

    -- reposit the micromenu
    
GuildMicroButton:ClearAllPoints()
GuildMicroButton:SetPoint('TOPLEFT', CharacterMicroButton, 'BOTTOMLEFT', 0, 20)

CharacterMicroButton:ClearAllPoints()
CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
        
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

    -- a new place for the exit vehicle button
    
MainMenuBarVehicleLeaveButton:HookScript('OnShow', function()
	MainMenuBarVehicleLeaveButton:ClearAllPoints()
	MainMenuBarVehicleLeaveButton:SetPoint('LEFT', MainMenuBar, 'RIGHT', 10, 75)
end)
