local _, nCore = ...

function nCore:Dressroom()
    if not nCoreDB.Dressroom then return end

    DressUpFrameCancelButton:SetText("Undress")
    DressUpFrameCancelButton:SetScript("OnClick", function()
        DressUpFrame.ModelScene:GetPlayerActor():Undress()
    end)
    DressUpFrameResetButton:SetText("Dress")
end
