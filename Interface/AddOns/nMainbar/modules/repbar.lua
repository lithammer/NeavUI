
local _, nMainbar = ...
local cfg = nMainbar.Config

    -- reputation bar mouseover text

ReputationWatchBar.OverlayFrame.Text:SetFont(cfg.repBar.font, cfg.repBar.fontsize, 'THINOUTLINE', "")
ReputationWatchBar.OverlayFrame.Text:SetShadowOffset(0, 0)

if (cfg.repBar.mouseover) then
    ReputationWatchBar.OverlayFrame.Text:SetAlpha(0)

    ReputationWatchBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', ReputationWatchBar.OverlayFrame.Text, 0.2, ReputationWatchBar.OverlayFrame.Text:GetAlpha(), 1)
    end)

    ReputationWatchBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', ReputationWatchBar.OverlayFrame.Text, 0.2, ReputationWatchBar.OverlayFrame.Text:GetAlpha(), 0)
    end)
else
    ReputationWatchBar.OverlayFrame.Text:Show()
    ReputationWatchBar.OverlayFrame.Text.Hide = function() end
end
