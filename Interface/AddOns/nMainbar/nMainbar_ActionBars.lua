
local function GetNumShapeSlots()
    local _, class = UnitClass('Player')
    if (class == 'DEATHKNIGHT' or class == 'WARRIOR') then
        return 3
    elseif (class == 'ROGUE') then
        return 1
    else
        return 10
    end
end
    
    -- if you move the bar you get some problems, so what can we make? We move the buttons!
    
do
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint('TOPRIGHT', UIParent, 'RIGHT', -6, (MultiBarRight:GetHeight() / 2))

    MultiBarLeftButton1:ClearAllPoints() 
    MultiBarLeftButton1:SetPoint('TOPRIGHT', MultiBarRightButton1, 'TOPLEFT', -6, 0)
	
        -- to prevent scaling and visibility issues with the mouseover options
    
	MultiBarLeft:SetParent(UIParent)
end
    
    -- hide the stancebar
    
if (nMainbar.stanceBar.hide) then
    for i = 1, NUM_SHAPESHIFT_SLOTS do
        local button = _G['ShapeshiftButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end
        
        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

    -- mouseover function
    
local function EnableMouseOver(self, bar, min, max, alpha)
    local minAlpha = 0

    for i = min, max do
        local button = _G[self..i]
        
        local f = CreateFrame('Frame', bar, bar)
        f:RegisterEvent('PLAYER_LOGIN')
        f:SetFrameStrata('LOW')
        f:SetFrameLevel(1)
        f:EnableMouse()
        f:SetPoint('TOPLEFT', self..min, -5, 5)
        f:SetPoint('BOTTOMRIGHT', self..max, 5, 5)
        f:SetScript('OnEvent', function(self)
            bar:SetAlpha(minAlpha)
            self:UnregisterAllEvents()
        end)
        
        f:SetScript('OnEnter', function()
            bar:SetAlpha(alpha)
        end)
                    
        f:SetScript('OnLeave', function() 
            if (not MouseIsOver(button)) then
                bar:SetAlpha(minAlpha)
            end
        end)
    
        button:HookScript('OnEnter', function()
            bar:SetAlpha(alpha)
        end)
            
        button:HookScript('OnLeave', function() 
            if (not MouseIsOver(bar)) then
                bar:SetAlpha(minAlpha)
            end
        end)
    end
end
    
if (nMainbar.multiBarLeft.mouseover) then
    EnableMouseOver('MultiBarLeftButton', MultiBarLeft, 1, 12, nMainbar.multiBarLeft.alpha)
end

if (nMainbar.multiBarRight.mouseover) then
    EnableMouseOver('MultiBarRightButton', MultiBarRight, 1, 12, nMainbar.multiBarRight.alpha)
end

if (nMainbar.multiBarBottomLeft.mouseover) then
    EnableMouseOver('MultiBarBottomLeftButton', MultiBarBottomLeft, 1, 12, nMainbar.multiBarBottomLeft.alpha)
end

if (nMainbar.multiBarBottomRight.mouseover) then
    EnableMouseOver('MultiBarBottomRightButton', MultiBarBottomRight, 1, 12, nMainbar.multiBarBottomRight.alpha)
end

if (nMainbar.petbar.mouseover) then
    PetActionBarFrame:SetFrameStrata('HIGH')
    EnableMouseOver('PetActionButton', PetActionBarFrame, 1, 10, nMainbar.petbar.alpha)
end

if (nMainbar.stanceBar.mouseover) then
    ShapeshiftBarFrame:SetFrameStrata('HIGH')
    EnableMouseOver('ShapeshiftButton', ShapeshiftBarFrame, 1, GetNumShapeSlots(), nMainbar.stanceBar.alpha)
end

if (nMainbar.MainMenuBar.hideGryphons) then
    MainMenuBarLeftEndCap:SetAlpha(0)
    MainMenuBarRightEndCap:SetAlpha(0)
end
    
    -- alpha and scale settings
    
MultiBarLeft:SetAlpha(nMainbar.multiBarLeft.alpha)
MultiBarRight:SetAlpha(nMainbar.multiBarRight.alpha)

MultiBarBottomLeft:SetAlpha(nMainbar.multiBarBottomLeft.alpha)
MultiBarBottomRight:SetAlpha(nMainbar.multiBarBottomRight.alpha)
    
MainMenuBar:SetScale(nMainbar.MainMenuBar.scale)
MultiBarLeft:SetScale(nMainbar.MainMenuBar.scale)
MultiBarRight:SetScale(nMainbar.MainMenuBar.scale)

    -- scaling of the vehicle frame

VehicleMenuBar:SetScale(nMainbar.vehicle.scale)

    -- scaling of the shapeshiftbar
    
ShapeshiftBarFrame:SetScale(nMainbar.stanceBar.scale)

    -- scaling of the possessbar

PossessBarFrame:SetScale(nMainbar.possessbar.scale)

    -- scaling of the petbar
    
PetActionBarFrame:SetScale(nMainbar.petbar.scale)

    -- horizontal/vertical bars
 
if (nMainbar.petbar.vertical) then
	for i = 2, 10 do
		button = _G['PetActionButton'..i]
		button:ClearAllPoints()
		button:SetPoint('TOP', _G['PetActionButton'..(i - 1)], 'BOTTOM', 0, -8)
	end
end
   
if (nMainbar.multiBarRight.orderHorizontal) then
    for i = 2, 12 do
        button = _G['MultiBarRightButton'..i]
        button:ClearAllPoints()
        button:SetPoint('LEFT', _G['MultiBarRightButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    MultiBarRightButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        self:SetPoint('BOTTOMLEFT', MultiBarBottomRightButton1, 'TOPLEFT', 0, 6)
    end)
end

if (nMainbar.multiBarLeft.orderHorizontal and nMainbar.multiBarRight.orderHorizontal) then
    for i = 2, 12 do
        button = _G['MultiBarLeftButton'..i]
        button:ClearAllPoints()
        button:SetPoint('LEFT', _G['MultiBarLeftButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    MultiBarLeftButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        if (not nMainbar.MainMenuBar.shortBar) then
            self:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)
        else
            self:SetPoint('BOTTOMLEFT', MultiBarRightButton1, 'TOPLEFT', 0, 6)
        end
    end)
end

    -- slash command for the gm frame
    
SlashCmdList['GM'] = function()
    ToggleHelpFrame() 
end

SLASH_GM1 = '/gm'
SLASH_GM2 = '/ticket'

    -- reputation bar mouseover text
    
ReputationWatchStatusBarText:SetFont(nMainbar.repBar.font, nMainbar.repBar.fontsize, 'OUTLINE')
ReputationWatchStatusBarText:SetShadowOffset(0, 0)

if (nMainbar.repBar.mouseover) then
    ReputationWatchStatusBarText:SetAlpha(0)

    ReputationWatchBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 1)
    end)

    ReputationWatchBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 0) 
    end)
else
    ReputationWatchStatusBarText:Show()
    ReputationWatchStatusBarText.Hide = function() end
end

    -- experience bar mouseover text
    
MainMenuBarExpText:SetFont(nMainbar.expBar.font, nMainbar.expBar.fontsize, 'OUTLINE')
MainMenuBarExpText:SetShadowOffset(0, 0)

if (nMainbar.expBar.mouseover) then
    MainMenuBarExpText:SetAlpha(0)
else
    MainMenuBarExpText:Show()
    MainMenuBarExpText.Hide = function() end
end

MainMenuExpBar:HookScript('OnEnter', function()
    if (nMainbar.expBar.mouseover) then
        securecall('UIFrameFadeIn', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
    end
end)

MainMenuExpBar:HookScript('OnLeave', function()
    if (nMainbar.expBar.mouseover) then
        securecall('UIFrameFadeOut', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0) 
    end
end)