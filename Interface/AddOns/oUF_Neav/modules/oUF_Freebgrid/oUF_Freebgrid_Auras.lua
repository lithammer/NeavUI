
-- THANKS & CREDITS GOES TO Freebaser (oUF Freebgrid)
-- http://www.wowinterface.com/downloads/info12264-oUF_Freebgrid.html

local _, ns = ...
local oUF = ns.oUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local _, class = UnitClass('player')
local buffcolor = { r = 0.0, g = 1.0, b = 1.0 }

    -- self explaining
    
local dispelPriority = {
    Magic = 5,
    Curse = 4,
    Poison = 3,
    Disease = 2,
}

    -- instance name and the instance ID, 
    -- find out the instance ID by typing this in the chat "  /run print(GetCurrentMapAreaID())  "
    -- Note: Just must be in this instance, when you run the script above
    
local L = {
    ['Baradin Hold'] = 752,
    ['Blackwing Descent'] = 754,
    ['The Bastion of Twilight'] = 758,
    ['Throne of the Four Winds'] = 773,
}

ns.auras = {
        -- Ascending aura timer
        -- Add spells to this list to have the aura time count up from 0
        -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
        [GetSpellInfo(92956)] = true, -- Wrack
    },
    
    debuffs = {
    
            -- General debuffs

        [GetSpellInfo(39171)] = 9, -- Mortal Strike
        [GetSpellInfo(76622)] = 9, -- Sunder Armor
        [GetSpellInfo(51372)] = 1, -- Daze
        [GetSpellInfo(5246)] = 5, -- Intimidating Shout
        -- [GetSpellInfo(6788)] = 16, -- Weakened Soul
        
        --[[
            -- Naxxramas
            
        [GetSpellInfo(27808)] = 9, -- Frost Blast, Kel'Thuzad

            -- Ulduar
            
        [GetSpellInfo(62717)] = 9, -- Slag Pot, Ignis
            
            -- ToC
            
        [GetSpellInfo(66869)] = 8, -- Burning Bile
        [GetSpellInfo(66823)] = 10, -- Paralizing Toxin
        [GetSpellInfo(67049)] = 9, -- Incinerate Flesh
            
            -- ICC
            
        [GetSpellInfo(69057)] = 9, -- Bone Spike Graveyard
        [GetSpellInfo(72448)] = 9, -- Rune of Blood
        [GetSpellInfo(72293)] = 10, -- Mark of the Fallen Champion, Deathbringer Saurfang

        [GetSpellInfo(71224)] = 9, -- Mutated Infection, Rotface
        [GetSpellInfo(72272)] = 9, -- Vile Gas, Festergut
        [GetSpellInfo(69279)] = 8, -- Gas Spore, Festergut

        [GetSpellInfo(70126)] = 9, -- Frost Beacon, Sindragosa

        [GetSpellInfo(70337)] = 9, -- Necrotic Plague, Lich King
        [GetSpellInfo(70541)] = 6, -- Infest, Lich King
        [GetSpellInfo(72754)] = 8, -- Defile, Lich King
        [GetSpellInfo(68980)] = 10, -- Harvest Soul, Lich King

            -- Suby Sanctum
            
        [GetSpellInfo(74562)] = 8, -- Fiery Combustion, Halion
        [GetSpellInfo(74792)] = 8, -- Soul Consumption, Halion
        --]]
    },

    buffs = {
        -- [GetSpellInfo(871)] = 15, -- Shield Wall
        [GetSpellInfo(61336)] = 15, -- Survival Instincts
    },

        -- Raid Debuffs
        
    instances = {
        --['Zone'] = {
        --	[Name or GetSpellInfo(#)] = PRIORITY,
        --},

        [L['Baradin Hold']] = {
            [GetSpellInfo(88954)] = 6, -- Consuming Darkness
        },
        
        [L['Blackwing Descent']] = {
            --Magmaw
            [GetSpellInfo(78941)] = 6, -- Parasitic Infection
            [GetSpellInfo(89773)] = 7, -- Mangle
            
                -- Omnitron Defense System
                
            [GetSpellInfo(79888)] = 6, -- Lightning Conductor
            [GetSpellInfo(79505)] = 8, -- Flamethrower
            [GetSpellInfo(80161)] = 7, -- Chemical Cloud
            [GetSpellInfo(79501)] = 8, -- Acquiring Target
            [GetSpellInfo(80011)] = 7, -- Soaked in Poison
            [GetSpellInfo(80094)] = 7, -- Fixate
            [GetSpellInfo(92048)] = 9, -- Shadow Infusion
            [GetSpellInfo(92053)] = 9, -- Shadow Conductor
            -- [GetSpellInfo(91858)] = 6, -- Overcharged Power Generator
            
                -- Maloriak
                
            [GetSpellInfo(92973)] = 8, -- Consuming Flames
            [GetSpellInfo(92978)] = 8, -- Flash Freeze
            [GetSpellInfo(92976)] = 7, -- Biting Chill
            [GetSpellInfo(91829)] = 7, -- Fixate
            [GetSpellInfo(92787)] = 9, -- Engulfing Darkness
            
                -- Atramedes
                
            [GetSpellInfo(78092)] = 7, -- Tracking
            [GetSpellInfo(78897)] = 8, -- Noisy
            [GetSpellInfo(78023)] = 7, -- Roaring Flame
            
                -- Chimaeron
                
            [GetSpellInfo(89084)] = 8, -- Low Health
            [GetSpellInfo(82881)] = 7, -- Break
            [GetSpellInfo(82890)] = 9, -- Mortality
            
                -- Nefarian
                
            [GetSpellInfo(94128)] = 7, -- Tail Lash
            -- [GetSpellInfo(94075)] = 8, -- Magma
            [GetSpellInfo(79339)] = 9, -- Explosive Cinders
            [GetSpellInfo(79318)] = 9, -- Dominion
        },

        [L['The Bastion of Twilight']] = {
        
                -- Halfus
                
            [GetSpellInfo(39171)] = 7, -- Malevolent Strikes
            [GetSpellInfo(86169)] = 8, -- Furious Roar
            
                -- Valiona & Theralion
            
            [GetSpellInfo(86788)] = 6, -- Blackout
            [GetSpellInfo(86622)] = 7, -- Engulfing Magic
            [GetSpellInfo(86202)] = 7, -- Twilight Shift
            
                -- Council
            
            [GetSpellInfo(82665)] = 7, -- Heart of Ice
            [GetSpellInfo(82660)] = 7, -- Burning Blood
            [GetSpellInfo(82762)] = 7, -- Waterlogged
            [GetSpellInfo(83099)] = 7, -- Lightning Rod
            [GetSpellInfo(82285)] = 7, -- Elemental Stasis
            [GetSpellInfo(92488)] = 8, -- Gravity Crush
            
                -- Cho'gall
                
            [GetSpellInfo(86028)] = 6, -- Cho's Blast
            [GetSpellInfo(86029)] = 6, -- Gall's Blast
            [GetSpellInfo(93189)] = 7, -- Corrupted Blood
            [GetSpellInfo(93133)] = 7, -- Debilitating Beam
            [GetSpellInfo(81836)] = 8, -- Corruption: Accelerated
            [GetSpellInfo(81831)] = 8, -- Corruption: Sickness
            [GetSpellInfo(82125)] = 8, -- Corruption: Malformation
            [GetSpellInfo(82170)] = 8, -- Corruption: Absolute
            
                -- Sinestra
                
            [GetSpellInfo(92956)] = 9, -- Wrack
        },

        [L['Throne of the Four Winds']] = {
        
                -- Conclave
                
            [GetSpellInfo(85576)] = 9, -- Withering Winds
            [GetSpellInfo(85573)] = 9, -- Deafening Winds
            [GetSpellInfo(93057)] = 7, -- Slicing Gale
            [GetSpellInfo(86481)] = 8, -- Hurricane
            [GetSpellInfo(93123)] = 7, -- Wind Chill
            [GetSpellInfo(93121)] = 8, -- Toxic Spores
            
                -- Al'Akir
                
            -- [GetSpellInfo(93281)] = 7, -- Acid Rain
            [GetSpellInfo(87873)] = 7, -- Static Shock
            [GetSpellInfo(88427)] = 7, -- Electrocute
            [GetSpellInfo(93294)] = 8, -- Lightning Rod
            [GetSpellInfo(93284)] = 9, -- Squall Line
        },
    },
}

local backdrop = {
    bgFile = 'Interface\\Buttons\\WHITE8x8', 
    tile = true, 
    tileSize = 16,
    edgeFile = 'Interface\\Buttons\\WHITE8x8', 
    edgeSize = 2,
    insets = {
        top = 2, 
        left = 2, 
        bottom = 2, 
        right = 2
    },
}

local BBackdrop = {
    bgFile = 'Interface\\Buttons\\WHITE8x8', 
    tile = true, 
    tileSize = 16,
    insets = {
        top = -1, 
        left = -1, 
        bottom = -1, 
        right = -1
    },
}

local function multicheck(check, ...)
    for i = 1, select('#', ...) do
        if (check == select(i, ...)) then 
            return true 
        end
    end
    
    return false
end

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if (s >= day) then
        return format('%dd', floor(s/day + 0.5))
    elseif (s >= hour) then
        return format('%dh', floor(s/hour + 0.5))
    elseif (s >= minute) then
        return format('%dm', floor(s/minute + 0.5))
    end

    return format('%d', fmod(s, minute))
end

local CreateAuraIcon = function(auras)
    if (not auras.button) then
        local button = CreateFrame('Button', nil, auras)
        button:EnableMouse(false)
        button:SetBackdrop(BBackdrop)
        button:SetBackdropColor(0, 0, 0, 1)
        button:SetBackdropBorderColor(0, 0, 0, 0)

        button:SetSize(auras.size, auras.size)

        local icon = button:CreateTexture(nil, 'OVERLAY')
        icon:SetAllPoints(button)
        icon:SetTexCoord(.1, .9, .1, .9)

        local overlay = CreateFrame('Frame', nil, button)
        overlay:SetAllPoints(button)
        overlay:SetBackdrop(backdrop)
        overlay:SetBackdropColor(0, 0, 0, 0)
        overlay:SetBackdropBorderColor(1, 1, 1, 1)
        overlay:SetFrameLevel(6)
        button.overlay = overlay

        local font, fontsize = GameFontNormalSmall:GetFont()
        local count = overlay:CreateFontString(nil, 'OVERLAY')
        count:SetFont(font, 10, 'THINOUTLINE')
        count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 1, 1)

        button:SetPoint('BOTTOMLEFT', auras, 'BOTTOMLEFT')

        local remaining = button:CreateFontString(nil, 'OVERLAY')
        remaining:SetPoint('CENTER', icon, 0.5, 0) 
        remaining:SetFont(font, 11, 'THINOUTLINE')
        remaining:SetTextColor(1, 0.82, 0)
        button.remaining = remaining

        button.parent = auras
        button.icon = icon
        button.count = count
        button.cd = cd
        button:Hide()

        return button
    end
end

    -- Want to see all magic/disease/curse or poison debuffs, even when you can't dispell it?
    -- I've prepared something below..

local dispelClass = {
    PRIEST = { 
        Disease = true,
        -- Magic = true,
        -- Poison = true, 
        -- Curse = true,
    },
    SHAMAN = { 
        Curse = true,
        -- Magic = true,
        -- Disease = true, 
        -- Poison = true, 
    },
    PALADIN = { 
        Poison = true, 
        Disease = true, 
        -- Magic = true,
        -- Disease = true, 
    },
    MAGE = { 
        Curse = true,
        -- Poison = true, 
        -- Disease = true, 
        -- Magic = true,
    },
    DRUID = { 
        Curse = true, 
        Poison = true,
        -- Magic = true,
        -- Disease = true, 
    },
    --[[
    WARRIOR = { 
        Curse = true, 
        Poison = true,
        Magic = true,
        Disease = true, 
    },
    DEATHKNIGHT = { 
        Curse = true, 
        Poison = true,
        Magic = true,
        Disease = true, 
    },
    HUNTER = {
        Curse = true, 
        Poison = true,
        Magic = true,
        Disease = true, 
    },
    WARLOCK = { 
        Curse = true, 
        Poison = true,
        Magic = true,
        Disease = true, 
    },   
    ROGUE = { 
        Curse = true, 
        Poison = true,
        Magic = true,
        Disease = true, 
    },
    --]]
}

local checkTalents = CreateFrame('Frame')
checkTalents:RegisterEvent('PLAYER_ENTERING_WORLD')
checkTalents:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
checkTalents:RegisterEvent('CHARACTER_POINTS_CHANGED')
checkTalents:SetScript('OnEvent', function()
    if (multicheck(class, 'SHAMAN', 'PALADIN', 'DRUID', 'PRIEST')) then
        if (class == 'SHAMAN') then
            local _, _, _, _, rank = GetTalentInfo(3, 12)
            dispelClass[class].Magic = rank == 1 and true
        elseif (class == 'PALADIN') then
            local _, _, _, _,rank = GetTalentInfo(1, 14)
            dispelClass[class].Magic = rank == 1 and true
        elseif (class == 'DRUID') then
            local _, _, _, _,rank = GetTalentInfo(3, 17)
            dispelClass[class].Magic = rank == 1 and true
        elseif (class == 'PRIEST') then
            local tree = GetPrimaryTalentTree()
            dispelClass[class].Magic = (tree == 1 or tree == 2) and true
        end
    end

    if (event == 'PLAYER_ENTERING_WORLD') then
        self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    end
end)

local dispellist = dispelClass[class] or {}
local instDebuffs = {}

local delaytimer = 0
local zoneDelay = function(self, elapsed)
    delaytimer = delaytimer + elapsed

    if (delaytimer < 5) then 
        return 
    end

    if (IsInInstance()) then
        SetMapToCurrentZone()
        local zone = GetCurrentMapAreaID()

        if ns.auras.instances[zone] then
            instDebuffs = ns.auras.instances[zone]
        end
    else
        instDebuffs = {}
    end

    self:SetScript('OnUpdate', nil)
    delaytimer = 0
end

local getZone = CreateFrame('Frame')
getZone:RegisterEvent('PLAYER_ENTERING_WORLD')
getZone:RegisterEvent('ZONE_CHANGED_NEW_AREA')
getZone:SetScript('OnEvent', function(self, event)

        -- Delay just in case zone data hasn't loaded
        
    self:SetScript('OnUpdate', zoneDelay)

    if (event == 'PLAYER_ENTERING_WORLD') then
        self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    end
end)

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype = ...

    icon.asc = false
    icon.buff = false
    icon.priority = 0

    if (ns.auras.ascending[name]) then
        icon.asc = true
    end

    if (instDebuffs[name]) then
        icon.priority = instDebuffs[name]
        return true
    elseif (ns.auras.debuffs[name]) then
        icon.priority = ns.auras.debuffs[name]
        return true
    elseif (ns.auras.buffs[name]) then
        icon.priority = ns.auras.buffs[name]
        icon.buff = true
        return true
    elseif (dispellist[dtype]) then
        icon.priority = dispelPriority[dtype]
        return true
    end
end

local AuraTimerAsc = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if (self.elapsed < .2) then 
        return 
    end
    
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.remaining:SetText(nil)
    else
        local duration = self.duration - timeLeft
        self.remaining:SetText(FormatTime(duration))
    end
end

local AuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if (self.elapsed) < .2 then 
        return 
    end
    
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if (timeLeft <= 0) then
        self.remaining:SetText(nil)
    else
        self.remaining:SetText(FormatTime(timeLeft))
    end
end

local updateDebuff = function(icon, texture, count, dtype, duration, expires, buff)
    local color = buff and buffcolor or DebuffTypeColor[dtype] or DebuffTypeColor.none

    icon.overlay:SetBackdropBorderColor(color.r, color.g, color.b)

    icon.icon:SetTexture(texture)
    icon.count:SetText((count > 1 and count))

    icon.expires = expires
    icon.duration = duration

    if (icon.asc) then
        icon:SetScript('OnUpdate', AuraTimerAsc)
    else
        icon:SetScript('OnUpdate', AuraTimer)
    end
end

local Update = function(self, event, unit)
    if (self.unit ~= unit) then 
        return 
    end

    local cur
    local hide = true
    local auras = self.freebAuras
    local icon = auras.button

    local index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster = UnitDebuff(unit, index)
        if (not name) then 
            break 
        end
        
        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster)

        if (show) then
            if (not cur) then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires)
            else
                if (icon.priority > cur) then
                    updateDebuff(icon, texture, count, dtype, duration, expires)
                end
            end

            icon:Show()
            
            if (self.Name) then
                self.Name:Hide()
            end
            
            if (self.Health.Value) then
                self.Health.Value:Hide()
            end
            
            hide = false
        end

        index = index + 1
    end

    index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster = UnitBuff(unit, index)
        if (not name) then 
            break 
        end
        
        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster)

        if (show and icon.buff) then
            if (not cur) then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires, true)
            else
                if (icon.priority > cur) then
                    updateDebuff(icon, texture, count, dtype, duration, expires, true)
                end
            end

            icon:Show()
            
            if (self.Name) then
                self.Name:Hide()
            end
            
            if (self.Health.Value) then
                self.Health.Value:Hide()
            end
            
            hide = false
        end

        index = index + 1
    end

    if (hide) then
        icon:Hide()
        
        if (self.Name) then
            self.Name:Show()
        end
        
        if (self.Health.Value) then
            self.Health.Value:Show()
        end
    end
end

local Enable = function(self)
    local auras = self.freebAuras

    if (auras) then
        auras.button = CreateAuraIcon(auras)

        self:RegisterEvent('UNIT_AURA', Update)
        return true
    end
end

local Disable = function(self)
    local auras = self.freebAuras

    if (auras) then
        self:UnregisterEvent('UNIT_AURA', Update)
    end
end

oUF:AddElement('freebAuras', Update, Enable, Disable)
