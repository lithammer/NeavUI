
oUF_Neav = {
    show = {
        castbars = true,
        party = true,
        pvpicons = true,
    },

    media = {
        border = 'Interface\\AddOns\\oUF_Neav\\media\\borderTexture',
        statusbar = 'Interface\\AddOns\\oUF_Neav\\media\\statusbarTexture',
        font = 'Interface\\AddOns\\oUF_Neav\\media\\fontSmall.ttf',
        fontThick = 'Interface\\AddOns\\oUF_Neav\\media\\fontThick.ttf',
    },

    font = {
        fontSmall = 14,
        fontSmallOutline = false,
        fontBig = 14,
        fontBigOutline = false,
    },

    units = {
        player = {
            mouseoverText = false,
            scale = 1.193,
            position = {'TOPLEFT', UIParent, 34, -30},
            showHealthPercent = false,
            showPowerPercent = false,
        },

        pet = {
            mouseoverText = true,
            scale = 1.193,
            auraSize = 22,
            position = {43, -20},
            showHealthPercent = false,
            showPowerPercent = false,
        },

        target = {
            mouseoverText = false,
            auraSize = 22,
            showComboPoints = true,
            showComboPointsAsNumber = false,
            numComboPointsColor = {0.9, 0, 0},      -- textcolor of the combopoints if showComboPointsAsNumber is true
            scale = 1.193,
            position = {'TOPLEFT', UIParent, 270, -30},
            showHealthPercent = true,
            showHealthAndPercent = true,   -- overrides showHealthPercent
            showPowerPercent = false,
        },

        targettarget = {
            scale = 1.193,
        },

        focus = {
            mouseoverText = false,
            auraSize = 22,
            scale = 1.193,
            showHealthPercent = false,
            showHealthAndPercent = false,   -- overrides showHealthPercent
            showPowerPercent = false,
        },
        
        focustarget = {
            scale = 1.193,
        },
        
        party = {
            mouseoverText = true,
            scale = 1.11,
            auraSize = 22,  
            hideInRaid = true,
            position = {'TOPLEFT', UIParent, 25, -200},
        },

        raid = {
            width = 42,
            height = 40,
            scale = 1.2, 
            iconSize = 20,
            indicatorSize = 9,
            showSolo = true,
            numGroups = 5,
            position = {'LEFT', UIParent, 'CENTER', 447, 0},
            showTargetBorder = true,
            targetBorderColor = {1, 1, 1},
			horizontalHealthBars = false,
        },
    },

    castbar = {
        player = {
            position = {'BOTTOM', UIParent, 0, 141},
            width = 220,
            height = 19,
            classcolor = true,
            safezone = true,
            showLatency = true, 
            color = {1, 0.7, 0},
        },
        pet = {
            --position = {'BOTTOM', UIParent, 0, 390},
            position = {'BOTTOM', UIParent, 0, 9000},
            width = 220,
            height = 19,
            color = {0, 0.65, 1},
        },
        target = {
            position = {'BOTTOM', UIParent, 0, 332},
            width = 220,
            height = 19,
            color = {0.9, 0.1, 0.1},
            interruptColor = {1, 0, 1},
            showInterruptHighlight = true,
        },
        focus = {
            width = 176,
            height = 19,
            color = {0, 0.65, 1},
            interruptColor = {1, 0, 1},
            showInterruptHighlight = true,
        },
    },
}
