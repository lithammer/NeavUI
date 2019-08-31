local _, nMainbar = ...
local cfg = nMainbar.Config

    -- Experience Bar

-- Classic: ExpBarMixin doesn't exist
if ExpBarMixin then
    hooksecurefunc(ExpBarMixin, "OnLoad", function(self)
        self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
        self.OverlayFrame.Text:SetShadowOffset(0, 0)
    end)
end

    -- Azerite Bar

-- Classic: AzeriteBarMixin doesn't exist
if AzeriteBarMixin then
    hooksecurefunc(AzeriteBarMixin, "OnLoad", function(self)
        self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
        self.OverlayFrame.Text:SetShadowOffset(0, 0)
    end)
end

    -- Reputation Bar

-- Classic: ReputationBarMixin doesn't exist
if ReputationBarMixin then
    hooksecurefunc(ReputationBarMixin, "OnLoad", function(self)
        self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
        self.OverlayFrame.Text:SetShadowOffset(0, 0)

        self:SetScript("OnMouseDown", function(self, button)
            if not nMainbar:IsTaintable() and IsAltKeyDown() then
                ToggleCharacter("ReputationFrame")
            end
        end)
    end)
end

    -- Honor Bar

-- Classic: ReputationBarMixin doesn't exist
if HonorBarMixin then  
    hooksecurefunc(HonorBarMixin, "OnLoad", function(self)
        self.OverlayFrame.Text:SetFont(cfg.button.watchbarFont, cfg.button.watchbarFontsize, "OUTLINE")
        self.OverlayFrame.Text:SetShadowOffset(0, 0)

        self:SetScript("OnMouseDown", function(self, button)
            if not nMainbar:IsTaintable() and IsAltKeyDown() then
                ToggleTalentFrame(PVP_TALENTS_TAB)
            end
        end)
    end)
end

    -- Legion Artifact Bar

-- Classic: ReputationBarMixin doesn't exist
if ArtifactBarMixin then  
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
end
