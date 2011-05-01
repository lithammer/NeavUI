
local watch = _G['WatchFrame']
watch:SetHeight(400)
watch:ClearAllPoints()	
watch.ClearAllPoints = function() end
watch:SetPoint('TOPRIGHT', UIParent, -100, -250)
watch:SetClampedToScreen(true)
watch:SetMovable(1)
watch:SetUserPlaced(true)
watch.SetPoint = function() end
watch:SetScale(1.01)

local watchHead = _G['WatchFrameHeader']
watchHead:EnableMouse(true)
watchHead:RegisterForDrag('LeftButton')
watchHead:SetHitRectInsets(-15, -15, -5, -5)
watchHead:SetScript('OnDragStart', function(self) 
    if (IsShiftKeyDown()) then
        self:GetParent():StartMoving()
    end
end)

watchHead:SetScript('OnDragStop', function(self) 
    self:GetParent():StopMovingOrSizing()
end)

local classColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

local watchHeadTitle = _G['WatchFrameTitle']
watchHeadTitle:SetFont('Fonts\\ARIALN.ttf', 15)
watchHeadTitle:SetTextColor(classColor.r, classColor.g, classColor.b)