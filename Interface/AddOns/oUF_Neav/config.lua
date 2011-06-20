
local _, ns = ...

ns.config = {
    show = {
        castbars = true,
        pvpicons = true,
        classPortraits = false,
        ThreeDPortraits = false,                                                             -- 3DPortraits; Overrides classPortraits
    },

    media = {
        border = 'Interface\\AddOns\\oUF_Neav\\media\\borderTexture',                       -- Buffborder Texture
        statusbar = 'Interface\\AddOns\\oUF_Neav\\media\\statusbarTexture',                 -- Statusbar texture
    },  

    font = {
        normal = 'Interface\\AddOns\\oUF_Neav\\media\\fontSmall.ttf',                       -- General font for all other  
        normalSize = 13,
        
        normalBig = 'Interface\\AddOns\\oUF_Neav\\media\\fontThick.ttf',                    -- Name font
        normalBigSize = 14,
    },
    
    units = {
        ['player'] = {
            mouseoverText = false,
            
            scale = 1.193,
            style = 'NORMAL',                                                               -- 'NORMAL' 'RARE' 'ELITE' 'CUSTOM'
            customTexture = 'Interface\\AddOns\\oUF_Neav\\media\\customFrameTexture',       -- Custom texture if style = 'CUSTOM'
            
            showHealthPercent = false,
            showPowerPercent = false,
            
            druidManaFrequentUpdates = false,
            
            showVengeance = false,                                                          -- Attention: vengeance and swingtimer will overlap eachother, 
            showSwingTimer = false,                                                         -- Change the pos in the oUF_Neav file if you want both
            showStatusFlash = true,
            showCombatFeedback = true,
            
            position = {'TOPLEFT', UIParent, 34, -30},
            
            castbar = {
                show = true, 
                            
                width = 220,
                height = 19,
                scale = 0.93,
                
                showLatency = true, 
                showSafezone = true,
                safezoneColor = {1, 0, 1},
                
                classcolor = true,
                color = {1, 0.7, 0},
                
                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },
                
                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 141},
            },
        },

        ['pet'] = {
            mouseoverText = true,
            
            scale = 1.193,
            
            auraSize = 22,
            
            showHealthPercent = false,
            showPowerPercent = false,
            
            position = {43, -20},
            
            castbar = {
                show = true, 
                        
                width = 220,
                height = 19,
                scale = 0.93,
                
                color = {0, 0.65, 1},
                            
                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },
                
                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 390},
                
                ignoreSpells = true,                                                        -- Hides castbar for spells listed in "ignoreList"
                ignoreList = {
                    3110,	-- firebolt (imp)
                    31707,	-- waterbolt (water elemental)
                },
            },
        },

        ['target'] = {
            mouseoverText = false,
            
            scale = 1.193,

            numBuffs = 20,
            numDebuffs = 20,
            
            showComboPoints = true,
            showComboPointsAsNumber = false,
            numComboPointsColor = {0.9, 0, 0},                                              -- Textcolor of the combopoints if showComboPointsAsNumber = true
            
            showHealthPercent = true,
            showHealthAndPercent = true,                                                    -- Overrides showHealthPercent
            showPowerPercent = false,
            
            showCombatFeedback = true,
            
            showUnitTypeTab = false,                                                         -- Shows a tab with the unit race or creature type
            
			colorPlayerDebuffsOnly = true,
            
            position = {'TOPLEFT', UIParent, 270, -30},
            
            castbar = {
                show = true, 
                
                width = 220,
                height = 19,
                scale = 0.93,
                
                color = {0.9, 0.1, 0.1},
                interruptColor = {1, 0, 1},
                            
                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = false,
                },
                
                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 332},
            },
        },
        
        ['targettarget'] = {
            scale = 1.193,
        },
        
        ['focus'] = {
            mouseoverText = false,
            
            scale = 1.193,

            numDebuffs = 6,
            
            showHealthPercent = false,
            showHealthAndPercent = true,                                                   -- Overrides showHealthPercent
            showPowerPercent = false,
            
            showCombatFeedback = true,
                        
            enableFocusToggleKeybind = true,
            focusToggleKey = 'type4',                                                       -- type1, type2 (mousebutton 1 or 2, 3, 4, 5 etc. works too)
            
            castbar = {
                show = true, 
                
                width = 176,
                height = 19,
                scale = 0.93,
                
                color = {0, 0.65, 1},
                interruptColor = {1, 0, 1},     
                
                icon = {
                    show = false,
                    position = 'LEFT',   -- 'LEFT' or 'RIGHT'
                    positionOutside = true,
                },
            },
        },
        
        ['focustarget'] = {
            scale = 1.193,
        },
        
        ['party'] = {
            show = false,
            hideInRaid = true,
            mouseoverText = true,
            
            scale = 1.11,
            
            position = {'TOPLEFT', UIParent, 25, -200},
        },

        ['boss'] = {
            scale = 1,

            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -50, -250},
            
            castbar = {
                color = {1, 0, 0},
        
                icon = {
                    size = 22,
                    show = false,                       
                    position = 'LEFT'   -- 'LEFT' or 'RIGHT' 
                },
            },
        },
        
        ['arena'] = {
            show = true,
            scale = 1,
            
            auraSize = 22,
            
            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -80, -300},
            
            castbar = {
                icon = {
                    size = 22,
                },
                
                color = {1, 0, 0},
            },
        },
    },
}