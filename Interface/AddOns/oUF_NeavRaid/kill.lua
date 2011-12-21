
--[[
for _, object in pairs({
    CompactPartyFrame,
    CompactRaidFrameManager,
    CompactRaidFrameContainer,
}) do
    object:UnregisterAllEvents()

    hooksecurefunc(object, 'Show', function(self)
        self:Hide()
    end)
end
--]]

InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

CompactRaidFrameManager:UnregisterAllEvents()
CompactUnitFrame_UpateVisible = function() end
CompactUnitFrame_UpdateAll = function() end

local function KillRaidFrame()
    CompactRaidFrameManager:UnregisterAllEvents()
    if (not InCombatLockdown()) then 
        CompactRaidFrameManager:Hide() 
    end

    local shown = CompactRaidFrameManager_GetSetting('IsShown')
    if (shown and shown ~= '0') then
        CompactRaidFrameManager_SetSetting('IsShown', '0')
    end
end

hooksecurefunc('CompactRaidFrameManager_UpdateShown', function()
    KillRaidFrame()
end)

KillRaidFrame()