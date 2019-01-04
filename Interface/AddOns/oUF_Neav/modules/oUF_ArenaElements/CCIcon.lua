local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF not loaded")

local ccList = {

        -- Immunitys

    [45438] = true,    -- Ice Block
    [33786] = true,    -- Cyclone (PvP Talent)
    [642] = true,      -- Divine Shield
    [1022] = true,     -- Hand of Protection
    [204018] = true,   -- Blessing of Spellwarding (Talented verion of Blessing of Protection)
    [46924] = true,    -- Bladestorm
    [104773] = true,   -- Unending Resolve
    [18499] = true,    -- Berserker Rage
    [47585] = true,    -- Dispersion
    [196555] = true,   -- Netherwalk (Talent)

        -- Stuns

    [408] = true,      -- Kidney Shot
    [1833] = true,     -- Cheap Shot
    [46968] = true,    -- Shockwave
    [853] = true,      -- Hammer of Justice
    [5211] = true,     -- Mighty Bash
    [30283] = true,    -- Shadowfury
    [89766] = true,    -- Axe Toss
    [22570] = true,    -- Maim
    [47481] = true,    -- Gnaw
    [1776] = true,     -- Gouge
    [6770] = true,     -- Sap
    [88625] = true,    -- Holy Word: Chastise
    [91797] = true,    -- Monstrous Blow (Gnaw with DT)
    [179057] = true,   -- Chaos Nova
    [221562] = true,   -- Asphyxiate
    [199804] = true,   -- Between the Eyes
    [207165] = true,   -- Abomination[s Might
    [211794] = true,   -- Winter is Coming
    [211881] = true,   -- Fel Eruption

        -- CC

    [605] = true,      -- Mind Control
    [205364] = true,   -- Dominant Mind (Talented verion of Mind Control)
    [2094] = true,     -- Blind
    [118] = true,      -- Polymorph
    [51514] = true,    -- Hex
    [6789] = true,     -- Death Coil
    [5246] = true,     -- Intimidating Shout
    [8122] = true,     -- Psychic Scream
    [5484] = true,     -- Howl of Terror
    [5782] = true,     -- Fear
    [6358] = true,     -- Seduction
    [187650] = true,   -- Freezing Trap
    [20066] = true,    -- Repentance
    [339] = true,      -- Entangling Roots
    [31661] = true,    -- Dragon[s Breath
    [217832] = true,   -- Imprison
    [9484] = true,     -- Shackle Undead
    [115078] = true,   -- Paralysis

        -- Silences

    [47476] = true,    -- Strangulate
    [1330] = true,     -- Garrote - Silence
    [15487] = true,    -- Silence (priest)
    [19647] = true,    -- Spell Lock
    [183752] = true,   -- Consume Magic
    [202137] = true,   -- Sigil of Silence
}

local Update = function(self, event, unit)
    if not unit or unit ~= self.unit then return end

    local element = self.CCIcon

    for i = 1, 40 do
        local name, icon, _, _, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, i)

        if name then
            local results = ccList[spellId] -- ccFilter(spellId)

            if results then
                CooldownFrame_Set(element.cooldownFrame, expirationTime - duration, duration, duration > 0)
                element.Icon:SetTexture(icon)
                element:Show()
                return
            end
        end
    end
    element:Hide()

    if event == "PLAYER_ENTERING_WORLD" then
        CooldownFrame_Set(element.cooldownFrame, 1, 1, 1)
    end
end

local Enable = function(self)
    local element = self.CCIcon
    if element then
        self:RegisterEvent("UNIT_AURA", Update)
        self:RegisterEvent("PLAYER_ENTERING_WORLD", Update, true)

        if not element.cooldownFrame then
            element.cooldownFrame = CreateFrame("Cooldown", nil, element, "CooldownFrameTemplate")
            element.cooldownFrame:SetAllPoints(element)
            element.cooldownFrame:SetHideCountdownNumbers(false)
        end

        if not element.Icon then
            element.Icon = element:CreateTexture(nil, "BORDER")
            element.Icon:SetAllPoints(element)
            element.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            element.Icon:SetTexture([[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]])
        end
        element:Hide()
        return true
    end
end

local Disable = function(self)
    local element = self.CCIcon
    if element then
        self:UnregisterEvent("UNIT_AURA", Update)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
        element:Hide()
    end
end

oUF:AddElement("CCIcon", Update, Enable, Disable)