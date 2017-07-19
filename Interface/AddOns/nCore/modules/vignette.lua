
-- Forked from rVignette by zork - 2014

local addon = CreateFrame("Frame")
addon.vignettes = {}

local function OnEvent(self,event,id)
    if id and not self.vignettes[id] then
        local x, y, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
        local x1, x2, y1, y2 = GetObjectIconTextureCoords(icon)

        local str = '|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:'..(x1*256)..':'..(x2*256)..':'..(y1*256)..':'..(y2*256)..'|t'

        if name ~= 'Garrison Cache' and name ~= 'Full Garrison Cache' and name ~= nil then
            RaidNotice_AddMessage(RaidWarningFrame, str..(name or 'Unknown')..' spotted!', ChatTypeInfo['RAID_WARNING'])
            print(str..name, 'spotted!')
            self.vignettes[id] = true
        end
    end
end

-- Listen for vignette event.
addon:RegisterEvent('VIGNETTE_ADDED')
addon:SetScript('OnEvent', OnEvent)
