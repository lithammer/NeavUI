
hooksecurefunc('UIParent_ManageFramePositions', function()
    if (NUM_EXTENDED_UI_FRAMES) then
        for i = 1, NUM_EXTENDED_UI_FRAMES do
            local bar = _G['WorldStateCaptureBar'..i]

            if (bar and bar:IsVisible()) then
                bar:ClearAllPoints()
                bar:SetScale(0.9333334)

                if (i == 1) then
                    bar:SetPoint('TOP', Minimap, 'BOTTOM', 0, nMinimap.positionDrawerBelow and -30 or -10)
                else
                    bar:SetPoint('TOP', _G['WorldStateCaptureBar'..(i-1)], 'BOTTOM', 0, -15)
                end
            end
        end
    end
end)

WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetPoint('TOP', UIParent, 0, -15)

--[[
hooksecurefunc('WorldStateAlwaysUpFrame_Update', function()
    if (NUM_ALWAYS_UP_UI_FRAMES) then
        for i = 1, NUM_ALWAYS_UP_UI_FRAMES do
            local frame = _G['AlwaysUpFrame'..i]
            if (frame and frame:IsVisible()) then
                local text = _G['AlwaysUpFrame'..i..'Text']
                text:ClearAllPoints() 
                text:SetPoint('CENTER', frame)

                local icon = _G['AlwaysUpFrame'..i..'Icon']
                icon:ClearAllPoints() 
                icon:SetPoint('RIGHT', text, 'LEFT', 9, -9)
            end
        end
    end
end)
--]]