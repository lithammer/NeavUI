
local _, nMainbar = ...
local cfg = nMainbar.Config

MultiBarLeft:SetAlpha(cfg.multiBarLeft.alpha)
MultiBarLeft:SetScale(cfg.MainMenuBar.scale)

MultiBarLeft:SetParent(UIParent)

if (cfg.multiBarLeft.orderHorizontal and cfg.multiBarRight.orderHorizontal) then
    for i = 2, 12 do
        button = _G['MultiBarLeftButton'..i]
        button:ClearAllPoints()
        button:SetPoint('LEFT', _G['MultiBarLeftButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    MultiBarLeftButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()

        if (not cfg.MainMenuBar.shortBar) then
            self:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 6)
        else
            self:SetPoint('BOTTOMLEFT', MultiBarRightButton1, 'TOPLEFT', 0, 6)
        end
    end)
else
    MultiBarLeftButton1:ClearAllPoints() 
    MultiBarLeftButton1:SetPoint('TOPRIGHT', MultiBarRightButton1, 'TOPLEFT', -6, 0)
end