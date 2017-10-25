
local _, nMainbar = ...
local cfg = nMainbar.Config

MultiBarRight:SetAlpha(cfg.multiBarRight.alpha)
MultiBarRight:SetScale(cfg.multiBarRight.scale)

MultiBarRight:SetParent(UIParent)

if (cfg.multiBarRight.orderHorizontal) then
    for i = 2, 12 do
        button = _G['MultiBarRightButton'..i]
        button:ClearAllPoints()
        button:SetPoint('LEFT', _G['MultiBarRightButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    MultiBarRightButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        self:SetPoint('BOTTOMLEFT', MultiBarBottomRightButton1, 'TOPLEFT', 0, 6)
    end)
else
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint('TOPRIGHT', UIParent, 'RIGHT', -6, (MultiBarRight:GetHeight() / 2))
end
