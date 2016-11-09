
local _, nMainbar = ...
local cfg = nMainbar.Config

    -- Artifact Bar Mouseover Text

ArtifactWatchBar.OverlayFrame.Text:SetFont(cfg.artifactBar.font, cfg.artifactBar.fontsize, 'THINOUTLINE', "")
ArtifactWatchBar.OverlayFrame.Text:SetShadowOffset(0, 0)

if (cfg.artifactBar.mouseover) then
    ArtifactWatchBar.OverlayFrame.Text:SetAlpha(0)

    ArtifactWatchBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', ArtifactWatchBar.OverlayFrame.Text, 0.2, ArtifactWatchBar.OverlayFrame.Text:GetAlpha(), 1)
    end)

    ArtifactWatchBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', ArtifactWatchBar.OverlayFrame.Text, 0.2, ArtifactWatchBar.OverlayFrame.Text:GetAlpha(), 0)
    end)
    
    ArtifactWatchBar:SetScript('OnMouseDown', function(self)
        if not ArtifactFrame or not ArtifactFrame:IsShown() then
            ShowUIPanel(SocketInventoryItem(16))
        elseif ArtifactFrame and ArtifactFrame:IsShown() then
            HideUIPanel(ArtifactFrame)
        end
    end)
else
    ArtifactWatchBar.OverlayFrame.Text:Show()
    ArtifactWatchBar.OverlayFrame.Text.Hide = function() end
end
