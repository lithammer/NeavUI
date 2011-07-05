
hooksecurefunc('UIParent_ManageFramePositions', function()
    if (NUM_EXTENDED_UI_FRAMES) then
        for i = 1, NUM_EXTENDED_UI_FRAMES do
            local bar = _G['WorldStateCaptureBar'..i]

            if (bar and bar:IsVisible()) then
                bar:ClearAllPoints()

                if (i == 1) then
                    bar:Point('TOP', Minimap, 'BOTTOM', 0, -25)
                else
                    bar:Point('TOPLEFT', _G['WorldStateCaptureBar'..(i-1)], 'TOPLEFT', 0, -25)
                end
            end
        end
    end
end)