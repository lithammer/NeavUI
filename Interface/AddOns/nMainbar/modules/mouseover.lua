
local _, nMainbar = ...
local cfg = nMainbar.Config

    -- mouseover function

local function EnableMouseOver(self, bar, min, max, alpha, hiddenAlpha)
    local minAlpha = hiddenAlpha or 0

    for i = min, max do
        local button = _G[self..i]

        local f = CreateFrame('Frame', bar, bar)
        f:SetFrameStrata('LOW')
        f:SetFrameLevel(1)
        f:EnableMouse()
        f:SetPoint('TOPLEFT', self..min, -5, 5)
        f:SetPoint('BOTTOMRIGHT', self..max, 5, 5)

        bar:SetAlpha(minAlpha)

        f:SetScript('OnEnter', function()
            bar:SetAlpha(alpha)
        end)

        f:SetScript('OnLeave', function() 
            if (not MouseIsOver(button)) then
                bar:SetAlpha(minAlpha)
            end
        end)

        button:HookScript('OnEnter', function()
            bar:SetAlpha(alpha)
        end)

        button:HookScript('OnLeave', function() 
            if (not MouseIsOver(bar)) then
                bar:SetAlpha(minAlpha)
            end
        end)
    end
end

if (cfg.multiBarLeft.mouseover) then
    EnableMouseOver('MultiBarLeftButton', MultiBarLeft, 1, 12, cfg.multiBarLeft.alpha, cfg.multiBarLeft.hiddenAlpha)
end

if (cfg.multiBarRight.mouseover) then
    EnableMouseOver('MultiBarRightButton', MultiBarRight, 1, 12, cfg.multiBarRight.alpha, cfg.multiBarRight.hiddenAlpha)
end

if (cfg.multiBarBottomLeft.mouseover) then
    EnableMouseOver('MultiBarBottomLeftButton', MultiBarBottomLeft, 1, 12, cfg.multiBarBottomLeft.alpha, cfg.multiBarBottomLeft.hiddenAlpha)
end

if (cfg.multiBarBottomRight.mouseover) then
    EnableMouseOver('MultiBarBottomRightButton', MultiBarBottomRight, 1, 12, cfg.multiBarBottomRight.alpha, cfg.multiBarBottomRight.hiddenAlpha)
end

if (cfg.petBar.mouseover) then
    EnableMouseOver('PetActionButton', PetActionBarFrame, 1, 10, cfg.petBar.alpha, cfg.petBar.hiddenAlpha)
end

if (cfg.stanceBar.mouseover) then
    EnableMouseOver('StanceButton', StanceBarFrame, 1, NUM_STANCE_SLOTS, cfg.stanceBar.alpha, cfg.stanceBar.hiddenAlpha)
end
