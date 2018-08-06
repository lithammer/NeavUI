local _, nCore = ...

-- Forked from rVignette by zork - 2014

function nCore:VignetteAlert()
    if not nCoreDB.VignetteAlert then return end

    local addon = CreateFrame("Frame")

    local function OnEvent(self, event, id)
        if event == "VIGNETTE_MINIMAP_UPDATED" then
            if not id then return end

            self.vignettes = self.vignettes or {}
            if self.vignettes[id] then return end

            local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
            if not vignetteInfo then return end

            local _, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(vignetteInfo.atlasName)

            local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(txLeft*256)..":"..(txRight*256)..":"..(txTop*256)..":"..(txBottom*256).."|t"

            if vignetteInfo.name ~= "Garrison Cache" and vignetteInfo.name ~= "Full Garrison Cache" and vignetteInfo.name ~= nil then
                RaidNotice_AddMessage(RaidWarningFrame, str.." "..vignetteInfo.name.." spotted!", ChatTypeInfo["RAID_WARNING"])
                print(str.." "..vignetteInfo.name,"spotted!")
                self.vignettes[id] = true
            end
        end
    end

    -- Listen for vignette event.
    addon:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
    addon:SetScript("OnEvent", OnEvent)
end
