--[[

    nMainbar
    Copyright (c) 2008-2010, Anton "Neav" I. (Neav @ Alleria-EU)
    All rights reserved.

--]]

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
end

if (nMainbar.stanceBar.hide) then
    for i = 1, NUM_SHAPESHIFT_SLOTS do
        local button = _G['ShapeshiftButton'..i]
        button:SetAlpha(0)
        button.SetAlpha = function() end
        
        button:EnableMouse(false)
        button.EnableMouse = function() end
    end
end

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

if (nMainbar.petbar.vertical) then
	for i = 2, 10 do
		button = _G["PetActionButton"..i]
		button:ClearAllPoints()
		button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -8)
	end
end

if (nMainbar.stanceBar.mouseover) then
    ShapeshiftBarFrame:SetFrameStrata('HIGH')
    EnableMouseOver('ShapeshiftButton', ShapeshiftBarFrame, 1, GetNumShapeSlots(), nMainbar.stanceBar.alpha)
end

