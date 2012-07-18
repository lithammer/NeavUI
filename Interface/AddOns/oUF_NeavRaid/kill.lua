
InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

--[[
function CompactUnitFrame_UpdateVisible() end
function CompactUnitFrame_UpdateAll() end

function CompactRaidFrameContainer_OnLoad() end
function CompactUnitFrame_SetUnit() end

function CompactRaidFrameManager_OnEvent() end
function CompactRaidFrameManager_SetBorderShown() end
function CompactRaidFrameManager_SetSetting() end
function CompactRaidFrameManager_SetManaged() end

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
--]]

function CompactUnitFrame_UpdateVisible() end
function CompactUnitFrame_UpdateAll() end
function CompactRaidFrameContainer_OnLoad() end

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
