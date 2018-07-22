
-- Forked from rVignette by zork - 2014

local addon = CreateFrame("Frame")
addon.vignettes = {}

local function OnEvent(self, event, guid)
    if guid and not self.vignettes[guid] then
        local vignetteInfo = C_VignetteInfo.GetVignetteInfo(guid)
        if not vignetteInfo then
            return
        end

        local _, _, _, x1, x2, y1, y2 = GetAtlasInfo(vignetteInfo.atlasName)

        local str = '|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:'..(x1*256)..':'..(x2*256)..':'..(y1*256)..':'..(y2*256)..'|t'
        RaidNotice_AddMessage(RaidWarningFrame, str..vignetteInfo.name..' spotted!', ChatTypeInfo['RAID_WARNING'])
        print(str..vignetteInfo.name, 'spotted!')
        self.vignettes[guid] = true
    end
end

-- Listen for vignette event.
addon:RegisterEvent('VIGNETTE_MINIMAP_UPDATED')
addon:SetScript('OnEvent', OnEvent)
