
local _, nTooltip = ...
local cfg = nTooltip.Config

if (not cfg.disableFade) then
    return
end

-- GameTooltip.FadeOut = GameTooltip.Hide
GameTooltip.UpdateTime = 0
GameTooltip:HookScript('OnUpdate', function(self, elapsed)
    self.UpdateTime = self.UpdateTime + elapsed
    if (self.UpdateTime > TOOLTIP_UPDATE_TIME) then
        self.UpdateTime = 0
        if (GetMouseFocus() == WorldFrame and (not UnitExists('mouseover'))) then
            self:Hide()
        end
       end
end)