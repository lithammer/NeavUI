local _, nCore = ...

function nCore:Dressroom()
    if not nCoreDB.Dressroom then return end

    DressUpFrameCancelButton:SetText("Naked")
    DressUpFrameCancelButton:SetScript("OnClick", function()
        DressUpModel:Undress()
    end)
    DressUpFrameResetButton:SetText("Clothed")
end
