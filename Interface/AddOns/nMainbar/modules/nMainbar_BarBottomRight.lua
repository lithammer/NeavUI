
MultiBarBottomRight:SetAlpha(nMainbar.multiBarBottomRight.alpha)

if (nMainbar.multiBarBottomRight.orderVertical) then
    for i = 2, 12 do
        button = _G['MultiBarBottomRightButton'..i]
        button:ClearAllPoints()
        button:SetPoint('TOP', _G['MultiBarBottomRightButton'..(i - 1)], 'BOTTOM', 0, -6)
    end

    MultiBarBottomRightButton1:HookScript('OnShow', function(self)
        self:ClearAllPoints()
        
        if (nMainbar.multiBarBottomRight.verticalPosition == 'RIGHT') then
            self:SetPoint('TOPRIGHT', MultiBarLeftButton1, 'TOPLEFT', -6, 0)
        else
            self:SetPoint('TOPLEFT', UIParent, 'LEFT', 6, (MultiBarBottomRight:GetWidth() / 2))
        end
    end)
end