
oUF_Neav = {
    show = {
        castbars = true,
        pvpicons = true,
        party = true,
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
            style = 'NORMAL', -- 'NORMAL', 'RARE' or 'ELITE'
            
            showHealthPercent = false,
            showPowerPercent = false,
            druidManaFrequentUpdates = false,
            
            showStatusFlash = false, -- cause an error during a warsong gulch bg :-/
            showCombatFeedback = true,
            
            position = {'TOPLEFT', UIParent, 34, -30},
        },

        pet = {
            mouseoverText = true,
            
            scale = 1.193,
            
            auraSize = 22,
            
            showHealthPercent = false,
            showPowerPercent = false,
            
            position = {43, -20},
        },

        target = {
            mouseoverText = false,
            
            scale = 1.193,
            
            auraSize = 22,
            numBuffs = 20,
            numDebuffs = 20,
            
            showComboPoints = true,
            showComboPointsAsNumber = true,
            numComboPointsColor = {0.9, 0, 0},      -- textcolor of the combopoints if showComboPointsAsNumber is true
            
            showHealthPercent = true,
            showHealthAndPercent = true,   -- overrides showHealthPercent
            showPowerPercent = false,
            
            showCombatFeedback = true,
            
			colorPlayerDebuffsOnly = true,
            
            position = {'TOPLEFT', UIParent, 270, -30},
        },

        targettarget = {
            scale = 1.193,
        },

        focus = {
            mouseoverText = false,
            
            scale = 1.193,
            
            auraSize = 22,
            numDebuffs = 6,
            
            showHealthPercent = false,
            showHealthAndPercent = false,   -- overrides showHealthPercent
            showPowerPercent = false,
            
            showCombatFeedback = true,
                        
            enableFocusToggleKeybind = true,
            focusToggleKey = 'type4', -- type1, type2 (mousebutton 1 or 2, 3, 4, 5 etc. works too)
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
            show = true,    
            showSolo = true,
        
            width = 42,
            height = 40,
            scale = 1.1, 
            iconSize = 20,
            
            numGroups = 8,

            position = {'LEFT', UIParent, 'CENTER', 350, -30},
            
            showThreatText = false,
            showRolePrefix = false,
            
            showTargetBorder = true,
            targetBorderColor = {1, 1, 1},

            smoothUpdatesForAllClasses = true, -- Set to true to enable smooth updates for healing classes
            
            indicatorSize = 7,
            horizontalHealthBars = false,
            
            manabar = {
                show = true,
                horizontalOrientation = false,
            },

       },
        
        boss = {
            showCastbar = false,
            scale = 1.0,

            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -80, -300},
        },
        
        arena = {
            show = true,
            showCastbar = true,
            
            scale = 1.0,
            
            auraSize = 22,
            
            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -80, -300},
        },
    },

    castbar = {
        player = {
            width = 220,
            height = 19,
            
            showLatency = true, 
            safezone = true,
            safezoneColor = {1, 0, 1},
            
            classcolor = true,
            color = {1, 0.7, 0},
            
            position = {'BOTTOM', UIParent, 0, 141},
        },
        
        pet = {
            width = 220,
            height = 19,
            color = {0, 0.65, 1},
            position = {'BOTTOM', UIParent, 0, 390},
        },
        
        target = {
            width = 220,
            height = 19,
            color = {0.9, 0.1, 0.1},
            interruptColor = {1, 0, 1},
            position = {'BOTTOM', UIParent, 0, 332},
        },
        
        focus = {
            width = 176,
            height = 19,
            color = {0, 0.65, 1},
            interruptColor = {1, 0, 1},
        },
        
        boss = {
            color = {1, 0, 0},
        },
        
        arena = {
            iconSize = 22,
            color = {1, 0, 0},
        },
    },
}
