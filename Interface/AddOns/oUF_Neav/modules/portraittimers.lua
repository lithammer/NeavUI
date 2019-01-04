
local _, ns = ...
local oUF = ns.oUF or oUF

ns.PortraitTimerDB = {

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
    [207165] = true,   -- Abomination's Might
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
    [31661] = true,    -- Dragon's Breath
    [217832] = true,   -- Imprison
    [9484] = true,     -- Shackle Undead
    [115078] = true,   -- Paralysis

        -- CC immune

    [53271] = true,    -- Master's Call
    [1044] = true,     -- Hand of Freedom
    [31224] = true,    -- Cloak of Shadows
    [51271] = true,    -- Pillar of Frost

        -- Dmg reductions

    [48707] = true,    -- Anti-Magic Shell
    [33206] = true,    -- Pain Suppression
    [47585] = true,    -- Dispersion
    [871] = true,      -- Shield Wall
    [48792] = true,    -- Icebound Fortitude
    [498] = true,      -- Divine Protection
    [22812] = true,    -- Barkskin
    [61336] = true,    -- Survival Instincts
    [5277] = true,     -- Evasion
    [186265] = true,   -- Aspect of the Turtle
    [198589] = true,   -- Blur
    [203720] = true,   -- Demon Spikes
    [218256] = true,   -- Empower Wards

        -- Silences

    [47476] = true,    -- Strangulate
    [1330] = true,     -- Garrote - Silence
    [15487] = true,    -- Silence (priest)
    [19647] = true,    -- Spell Lock
    [183752] = true,   -- Consume Magic
    [202137] = true,   -- Sigil of Silence

        -- Dmg buffs

    [31884] = true,    -- Avenging Wrath
    [211048] = true,   -- Chaos Blades

        -- Helpful buffs

    [6940] = true,     -- Hand of Sacrifice
    [23920] = true,    -- Spell Reflection (warrior)
    [68992] = true,    -- Darkflight (Worgen racial)
    [2983] = true,     -- Sprint
    [47788] = true,    -- Guardian Spirit
    [1850] = true,     -- Dash
    [121557] = true,   -- Feather
}

local Update = function(self, event, unit)
    if self.unit ~= unit or self.IsTargetFrame then
        return
    end

    local element = self.PortraitTimer
    local name, texture, _, _, duration, expirationTime, _, _, _, spellId
    local results

    for i = 1, 40 do
        name, texture, _, _, duration, expirationTime, _, _, _, spellId = UnitBuff(unit, i)

        if name then
            results = ns.PortraitTimerDB[spellId]

            if results then
                element.Icon:SetTexture(texture)
                CooldownFrame_Set(element.cooldownFrame, expirationTime - duration, duration, duration > 0)
                element:Show()

                if self.CombatFeedbackText then
                    self.CombatFeedbackText.maxAlpha = 0
                end
                return
            end
        end
    end

    for i = 1, 40 do
        name, texture, _, _, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, i)

        if name then
            results = ns.PortraitTimerDB[spellId]

            if results then
                element.Icon:SetTexture(texture)
                CooldownFrame_Set(element.cooldownFrame, expirationTime - duration, duration, duration > 0)
                element:Show()

                if self.CombatFeedbackText then
                    self.CombatFeedbackText.maxAlpha = 0
                end
                return
            end
        end
    end

    element:Hide()
    if self.CombatFeedbackText then
        self.CombatFeedbackText.maxAlpha = 1
    end

    if event == "PLAYER_ENTERING_WORLD" then
        CooldownFrame_Set(element.cooldownFrame, 1, 1, 1)
    end
end

local Enable = function(self)
    local element = self.PortraitTimer

    if element then
        self:RegisterEvent("UNIT_AURA", Update)
        self:RegisterEvent("PLAYER_ENTERING_WORLD", Update, true)

        if not element.Icon then
            local mask = element:CreateMaskTexture()
            mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            mask:SetAllPoints(element)

            element.Icon = element:CreateTexture(nil, "BACKGROUND")
            element.Icon:SetAllPoints(element)
            element.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            element.Icon:AddMaskTexture(mask)
        end

        if not element.cooldownFrame then
            element.cooldownFrame = CreateFrame("Cooldown", nil, element, "CooldownFrameTemplate")
            element.cooldownFrame:SetAllPoints(element)
            element.cooldownFrame:SetHideCountdownNumbers(false)
            element.cooldownFrame:SetDrawSwipe(false)
        end

        element:Hide()

        return true
    end
end

local Disable = function(self)
    local element = self.PortraitTimer
    if element then
        self:UnregisterEvent("UNIT_AURA", Update)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
    end
end

oUF:AddElement("PortraitTimer", Update, Enable, Disable)
