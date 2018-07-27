local _, nMainbar = ...
local cfg = nMainbar.Config

local function SetTextPoint(self)
    if StatusTrackingBarManager:GetNumberVisibleBars() == 2 then
        self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 5.3)
    else
        self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 3)
    end
end

local function IsInCombat()
    return InCombatLockdown() or UnitAffectingCombat("player") or UnitAffectingCombat("pet")
end

    -- Experience Bar

hooksecurefunc(ExpBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.statusTrackingBar.font, cfg.statusTrackingBar.fontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)
end)

hooksecurefunc(ExpBarMixin, "OnShow", function(self)
    self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 3)
end)

    -- Azerite Bar

hooksecurefunc(AzeriteBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.statusTrackingBar.font, cfg.statusTrackingBar.fontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)
end)

hooksecurefunc(AzeriteBarMixin, "OnShow", function(self)
    --SetTextPoint(self)
    self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 5.3)
end)

    -- Reputation Bar

hooksecurefunc(ReputationBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.statusTrackingBar.font, cfg.statusTrackingBar.fontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)

    self:SetScript("OnMouseDown", function(self, button)
        if not IsInCombat() then
            ToggleCharacter("ReputationFrame")
        end
    end)
end)

hooksecurefunc(ReputationBarMixin, "OnShow", function(self)
    if UnitLevel("player") < MAX_PLAYER_LEVEL and StatusTrackingBarManager:GetNumberVisibleBars() == 2 then
        self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 5.3)
    else
        self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 3)
    end
end)

    -- Honor Bar

hooksecurefunc(HonorBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.statusTrackingBar.font, cfg.statusTrackingBar.fontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)

    self:SetScript("OnMouseDown", function(self, button)
        if not IsInCombat() then
            ToggleTalentFrame(PVP_TALENTS_TAB)
        end
    end)
end)

hooksecurefunc(HonorBarMixin, "OnShow", function(self)
    SetTextPoint(self)
end)

    -- Legion Artifact Bar

hooksecurefunc(ArtifactBarMixin, "OnLoad", function(self)
    self.OverlayFrame.Text:SetFont(cfg.statusTrackingBar.font, cfg.statusTrackingBar.fontsize, "OUTLINE")
    self.OverlayFrame.Text:SetShadowOffset(0, 0)

    self:SetScript("OnMouseDown", function(self, button)
        if not IsInCombat() then
            if not ArtifactFrame or not ArtifactFrame:IsShown() then
                ShowUIPanel(SocketInventoryItem(16))
            elseif ArtifactFrame and ArtifactFrame:IsShown() then
                HideUIPanel(ArtifactFrame)
            end
        end
    end)
end)

hooksecurefunc(ArtifactBarMixin, "OnShow", function(self)
    self.OverlayFrame.Text:SetPoint("CENTER", self.OverlayFrame, 0, 3)
end)
