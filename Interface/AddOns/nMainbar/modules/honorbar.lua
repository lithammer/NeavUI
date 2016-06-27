
local _, nMainbar = ...
local cfg = nMainbar.Config

    -- Honor Bar Mouseover Text

HonorWatchBar.OverlayFrame.Text:SetFont(cfg.honorBar.font, cfg.honorBar.fontsize, 'THINOUTLINE', "")
HonorWatchBar.OverlayFrame.Text:SetShadowOffset(0, 0)

if (cfg.honorBar.mouseover) then
    HonorWatchBar.OverlayFrame.Text:SetAlpha(0)

    HonorWatchBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', HonorWatchBar.OverlayFrame.Text, 0.2, HonorWatchBar.OverlayFrame.Text:GetAlpha(), 1)
    end)

    HonorWatchBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', HonorWatchBar.OverlayFrame.Text, 0.2, HonorWatchBar.OverlayFrame.Text:GetAlpha(), 0)
    end)
else
    HonorWatchBar.OverlayFrame.Text:Show()
    HonorWatchBar.OverlayFrame.Text.Hide = function() end
end
