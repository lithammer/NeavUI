
local _, nMinimap = ...

nMinimap.Config = {
    scale = 1.1, -- Default: 1.1
    location = {"TOPRIGHT", UIParent, "TOPRIGHT", -26, -26}, -- Default: {"TOPRIGHT", UIParent, "TOPRIGHT", -26, -26}

    tab = {
        show = true,
        showAlways = true,

        showBelowMinimap = false,

        -- Number of addons shown in the memory section of the info tooltip. Set to "nil" to show all.
        numberOfAddons = nil,
    },

    mouseover = {
        zoneText = true,
        instanceDifficulty = false,
    },
}
