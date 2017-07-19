function DRB()
    DressUpFrameCancelButton:SetText('Naked');
    DressUpFrameCancelButton:SetScript('OnClick', function()
        DressUpModel:Undress()
    end)
    DressUpFrameResetButton:SetText('Clothed')
end
