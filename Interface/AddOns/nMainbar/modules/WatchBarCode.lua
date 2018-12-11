local _, nMainbar = ...
local cfg = nMainbar.Config

    -- Experience Bar

hooksecurefunc(ExpBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)
end)

    -- Azerite Bar

hooksecurefunc(AzeriteBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)
end)

    -- Reputation Bar

hooksecurefunc(ReputationBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)

    self:SetScript("OnMouseDown", function(self, button)
        if not nMainbar:IsTaintable() and IsAltKeyDown() then
            ToggleCharacter("ReputationFrame")
        end
    end)
end)

    -- Honor Bar

hooksecurefunc(HonorBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)

    self:SetScript("OnMouseDown", function(self, button)
        if not nMainbar:IsTaintable() and IsAltKeyDown() then
            ToggleTalentFrame(PVP_TALENTS_TAB)
        end
    end)
end)

    -- Legion Artifact Bar

hooksecurefunc(ArtifactBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)

    self:SetScript("OnMouseDown", function(self, button)
        if not nMainbar:IsTaintable() and IsAltKeyDown() then
            if not ArtifactFrame or not ArtifactFrame:IsShown() then
                ShowUIPanel(SocketInventoryItem(16))
            elseif ArtifactFrame and ArtifactFrame:IsShown() then
                HideUIPanel(ArtifactFrame)
            end
        end
    end)
end)
