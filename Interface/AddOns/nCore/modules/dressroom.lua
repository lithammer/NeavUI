local _, nCore = ...

function nCore:Dressroom()
    if not nCoreDB.Dressroom then return end

    DressUpFrameCancelButton:SetText("Naked")
    DressUpFrameCancelButton:SetScript("OnClick", function()
        -- Classic: Use DressUpModelFrame instead
        if DressUpModelFrame then
            DressUpModelFrame:Undress()
        else
            DressUpModel:Undress()
        end
    end)
    DressUpFrameResetButton:SetText("Clothed")
end