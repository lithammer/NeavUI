local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.useShortBar) then
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
        -- Classic textures are index differently
        -- _G['MainMenuXPBarTexture'..i],

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

-- Classic: textures are index differently so hide the ones we don't care about
MainMenuXPBarTexture0:Hide()
MainMenuXPBarTexture3:Hide()

    -- reduce the size of some main menu bar objects

for _, object in pairs({
    _G['MainMenuBar'],
    _G['MainMenuExpBar'],
    _G['MainMenuBarMaxLevelBar'],
}) do
    object:SetWidth(512)
end

ReputationWatchBar:SetWidth(512)
ReputationWatchBar.StatusBar:SetWidth(512)

ReputationWatchBar.StatusBar.WatchBarTexture0:SetWidth(256)
ReputationWatchBar.StatusBar.WatchBarTexture1:SetWidth(256)
ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture(nil)
ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture(nil)

-- Classic doesn't have this
if ArtifactWatchBar then
    ArtifactWatchBar:SetWidth(512)
    ArtifactWatchBar.StatusBar:SetWidth(512)
    ArtifactWatchBar.StatusBar.WatchBarTexture0:SetWidth(256)
    ArtifactWatchBar.StatusBar.WatchBarTexture1:SetWidth(256)
    ArtifactWatchBar.StatusBar.WatchBarTexture2:SetTexture(nil)
    ArtifactWatchBar.StatusBar.WatchBarTexture3:SetTexture(nil)
end

-- Classic doesn't have this
if HonorWatchBar then
    HonorWatchBar:SetWidth(512)
    HonorWatchBar.StatusBar:SetWidth(512)
    HonorWatchBar.StatusBar.WatchBarTexture0:SetWidth(256)
    HonorWatchBar.StatusBar.WatchBarTexture1:SetWidth(256)
    HonorWatchBar.StatusBar.WatchBarTexture2:SetTexture(nil)
    HonorWatchBar.StatusBar.WatchBarTexture3:SetTexture(nil)
end

-- Only shown when tracker is in place of MainMenuExpBar.
ReputationWatchBar.StatusBar.XPBarTexture0:SetWidth(256)
ReputationWatchBar.StatusBar.XPBarTexture1:SetWidth(256)
ReputationWatchBar.StatusBar.XPBarTexture2:SetTexture(nil)
ReputationWatchBar.StatusBar.XPBarTexture3:SetTexture(nil)

-- Classic doesn't have this
if ArtifactWatchBar then
    ArtifactWatchBar.StatusBar.XPBarTexture0:SetWidth(256)
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetWidth(256)
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetTexture(nil)
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetTexture(nil)
end

-- Classic doesn't have this
if HonorWatchBar then
    HonorWatchBar.StatusBar.XPBarTexture0:SetWidth(256)
    HonorWatchBar.StatusBar.XPBarTexture1:SetWidth(256)
    HonorWatchBar.StatusBar.XPBarTexture2:SetTexture(nil)
    HonorWatchBar.StatusBar.XPBarTexture3:SetTexture(nil)
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

if _G['MainMenuXPBarDiv2'] then
    hooksecurefunc(_G['MainMenuXPBarDiv2'], 'Show', function(self)
        local divWidth = MainMenuExpBar:GetWidth() / 10
        local xpos = divWidth - 4.5

        for i = 2, 19, 2 do
            local texture = _G['MainMenuXPBarDiv'..i]
            local xalign = floor(xpos)
            texture:SetPoint('LEFT', xalign, 1)
            xpos = xpos + divWidth
        end
    end)

    _G['MainMenuXPBarDiv2']:Show()
end

    -- fix the exp bar size when exiting vehicle

-- XXX: Not need anymore?
--MainMenuExpBar:HookScript('OnSizeChanged', function(self, width, height)
--    if (math.floor(width) == EXP_DEFAULT_WIDTH) then
--        securecall(MainMenuExpBar_SetWidth, 512)
--        CharacterMicroButton:ClearAllPoints()
--        CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
--    end
--end)

    -- the bottom right bar needs a better place, above the bottom left bar

MultiBarBottomRight:EnableMouse(false)

MultiBarBottomRightButton1:ClearAllPoints()
MultiBarBottomRightButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)

    -- reposition some objects

MainMenuBarTexture0:SetPoint('BOTTOM', MainMenuBarArtFrame, -128, 0)
MainMenuBarTexture1:SetPoint('BOTTOM', MainMenuBarArtFrame, 128, 0)
MainMenuMaxLevelBar0:SetPoint('BOTTOM', MainMenuBarMaxLevelBar, 'TOP', -128, 0)

MainMenuBarLeftEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, -289, 0)
MainMenuBarLeftEndCap.SetPoint = function() end

MainMenuBarRightEndCap:SetPoint('BOTTOM', MainMenuBarArtFrame, 289, 0)
MainMenuBarRightEndCap.SetPoint = function() end

--     -- reposit the micromenu

-- CharacterMicroButton:ClearAllPoints()
-- CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)

-- hooksecurefunc('MoveMicroButtons', function(anchor, achorTo, relAnchor, x, y, isStacked)
--     if (not isStacked) then
--         CharacterMicroButton:ClearAllPoints()
--         CharacterMicroButton:SetPoint('BOTTOMLEFT', UIParent, 9000, 9000)
--     end
-- end)

    -- a new place for the exit vehicle button

hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function()
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint('LEFT', MainMenuBar, 'RIGHT', 10, 75)
end)
