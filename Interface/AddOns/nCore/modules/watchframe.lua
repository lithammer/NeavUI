
local watchFrame = _G['WatchFrame']
watchFrame:SetHeight(400)
watchFrame:ClearAllPoints()
watchFrame.ClearAllPoints = function() end
watchFrame:SetPoint('TOPRIGHT', UIParent, -100, -250)
watchFrame:SetClampedToScreen(true)
watchFrame:SetMovable(true)
watchFrame:SetUserPlaced(true)
watchFrame.SetPoint = function() end
watchFrame:SetScale(1.01)

local watchHead = _G['WatchFrameHeader']
watchHead:EnableMouse(true)
watchHead:RegisterForDrag('LeftButton')
watchHead:SetHitRectInsets(-15, 0, -5, -5)
watchHead:SetScript('OnDragStart', function(self) 
    if (IsShiftKeyDown()) then
        self:GetParent():StartMoving()
    end
end)

watchHead:SetScript('OnDragStop', function(self) 
    self:GetParent():StopMovingOrSizing()
end)

watchHead:SetScript('OnEnter', function()
    if (not InCombatLockdown()) then
		GameTooltip:SetOwner(watchHead, 'ANCHOR_TOPLEFT', 0, 10)
		GameTooltip:ClearLines()
		GameTooltip:AddLine('Shift + left-click to Drag')
        GameTooltip:Show()
    end
end)

watchHead:SetScript('OnLeave', function()
    GameTooltip:Hide()
end)

local classColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

local watchHeadTitle = _G['WatchFrameTitle']
watchHeadTitle:SetFont('Fonts\\ARIALN.ttf', 15)
watchHeadTitle:SetTextColor(classColor.r, classColor.g, classColor.b)
