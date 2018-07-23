
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.shortBar) then
    return
end

    -- disable the automatic frame position

do
    for _, frame in pairs({
        'MultiBarLeft',
        'MultiBarRight',
        'MultiBarBottomRight',

        --'StanceBarFrame',
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

        _G['KeyRingButton'],

        _G['MainMenuBarTexture'..i],
        _G['MainMenuMaxLevelBar'..i],
        _G['MainMenuXPBarTexture'..i],

        _G['ReputationWatchBarTexture'..i],
        _G['ReputationXPBarTexture'..i],

        _G['MainMenuBarPageNumber'],

        _G['SlidingActionBarTexture0'],
        _G['SlidingActionBarTexture1'],

        _G['StanceBarLeft'],
        _G['StanceBarMiddle'],
        _G['StanceBarRight'],

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

    -- reduce the size of some main menu bar objects

for _, object in pairs({
    _G['MainMenuBar'],
    _G['MainMenuExpBar'],
    _G['MainMenuBarMaxLevelBar'],
}) do
    object:SetWidth(512)
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

    -- the bottom right bar needs a better place, above the bottom left bar

MultiBarBottomRight:EnableMouse(false)

MultiBarBottomRightButton1:ClearAllPoints()
MultiBarBottomRightButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)

    -- reposit some objects

MainMenuBarTexture0:SetPoint('BOTTOM', MainMenuBarArtFrame, -128, 0)
MainMenuBarTexture1:SetPoint('BOTTOM', MainMenuBarArtFrame, 128, 0)

MainMenuMaxLevelBar0:SetPoint('BOTTOM', MainMenuBarMaxLevelBar, 'TOP', -128, 0)

MainMenuBarArtFrame.LeftEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, -289, 0)
MainMenuBarArtFrame.LeftEndCap.SetPoint = function() end

MainMenuBarArtFrame.RightEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, 289, 0)
MainMenuBarArtFrame.RightEndCap.SetPoint = function() end

    -- reposit the micromenu

CharacterMicroButton:ClearAllPoints()
CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)

hooksecurefunc('MoveMicroButtons', function(anchor, achorTo, relAnchor, x, y, isStacked)
    if (not isStacked) then
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
    end
end)

    -- a new place for the exit vehicle button

hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function()
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint('LEFT', MainMenuBar, 'RIGHT', 10, 75)
end)
