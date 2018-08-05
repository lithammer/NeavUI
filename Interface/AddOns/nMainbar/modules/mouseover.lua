local _, nMainbar = ...
local cfg = nMainbar.Config

    -- Mouseover Function

local function EnableMouseOver(self, bar, min, max, alpha, hiddenAlpha)
    local minAlpha = hiddenAlpha or 0

    for i = min, max do
        local button = _G[self..i]

        local mouseOverFrame = CreateFrame("Frame", bar, bar)
        mouseOverFrame:SetFrameStrata("LOW")
        mouseOverFrame:SetFrameLevel(1)
        mouseOverFrame:EnableMouse()
        mouseOverFrame:SetPoint("TOPLEFT", self..min, -5, 5)
        mouseOverFrame:SetPoint("BOTTOMRIGHT", self..max, 5, 5)

        hooksecurefunc(bar, "SetAlpha", function(self, alpha)
            if button.cooldown then
                button.cooldown:SetSwipeColor(0, 0, 0, alpha)
                button.cooldown:SetDrawSwipe(alpha > 0)
                button.cooldown:SetDrawEdge(alpha > 0)
                button.cooldown:SetDrawBling(alpha > 0)
            end
        end)

        mouseOverFrame:SetScript("OnShow", function()
            if not MouseIsOver(button) then
                bar:SetAlpha(minAlpha)
            end
        end)

        mouseOverFrame:SetScript("OnEnter", function()
            bar:SetAlpha(alpha)
        end)

        mouseOverFrame:SetScript("OnLeave", function()
            if not MouseIsOver(button) then
                bar:SetAlpha(minAlpha)
            end
        end)

        button:HookScript("OnShow", function()
            C_Timer.After(0.5, function()
                if not MouseIsOver(mouseOverFrame) then
                    bar:SetAlpha(minAlpha)
                end
            end)
        end)

        button:HookScript("OnEnter", function()
            bar:SetAlpha(alpha)
        end)

        button:HookScript("OnLeave", function()
            if not MouseIsOver(mouseOverFrame) then
                bar:SetAlpha(minAlpha)
            end
        end)

        bar:SetAlpha(minAlpha)
    end
end

	-- Set Mouseovers

C_Timer.After(0.001, function()
    if cfg.multiBarRight.mouseover then
        if MultiBarLeft then
            EnableMouseOver("MultiBarLeftButton", MultiBarLeft, 1, 12, cfg.multiBarRight.alpha, cfg.multiBarRight.hiddenAlpha)
        end
        if MultiBarRight then
            EnableMouseOver("MultiBarRightButton", MultiBarRight, 1, 12, cfg.multiBarRight.alpha, cfg.multiBarRight.hiddenAlpha)
        end
    end

    if cfg.multiBarBottomLeft.mouseover then
        EnableMouseOver("MultiBarBottomLeftButton", MultiBarBottomLeft, 1, 12, cfg.multiBarBottomLeft.alpha, cfg.multiBarBottomLeft.hiddenAlpha)
    end

    if cfg.multiBarBottomRight.mouseover then
        EnableMouseOver("FakeMultiBarBottomRight1Button", FakeMultiBarBottomRight1, 1, 12, cfg.multiBarBottomRight.alpha, cfg.multiBarBottomRight.hiddenAlpha)
    end

    if cfg.petBar.mouseover then
        EnableMouseOver("PetActionButton", PetActionBarFrame, 1, 10, cfg.petBar.alpha, cfg.petBar.hiddenAlpha)
    end

    if cfg.stanceBar.mouseover then
        EnableMouseOver("StanceButton", StanceBarFrame, 1, NUM_STANCE_SLOTS, cfg.stanceBar.alpha, cfg.stanceBar.hiddenAlpha)
    end
end)
