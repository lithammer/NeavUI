--[[****************************************************************************
  * oUF_SpellRange by Saiket                                                   *
  * oUF_SpellRange.lua - Improved range element for oUF.                       *
  *                                                                            *
  * Elements handled: .SpellRange                                              *
  * Settings: (Either Update method or both alpha properties are required)     *
  *   - .SpellRange.Update( Frame, InRange ) - Callback fired when a unit      *
  *       either enters or leaves range. Overrides default alpha changing.     *
  *   OR                                                                       *
  *   - .SpellRange.insideAlpha - Frame alpha value for units in range.        *
  *   - .SpellRange.outsideAlpha - Frame alpha for units out of range.         *
  * Note that SpellRange will automatically disable Range elements of frames.  *
  ****************************************************************************]]


assert(oUF, 'Unable to locate oUF.')

local UpdateRate = 0.1

local UpdateFrame
local Objects = {}
local ObjectRanges = {}

-- Array of possible spell IDs in order of priority, and the name of the highest known priority spell

local HelpName
local HarmName

local _, playerClass = UnitClass('player')

-- Optional lists of low level baseline skills with greater than 28 yard range.
-- First known spell in the appropriate class list gets used.
-- Note: Spells probably shouldn't have minimum ranges!

local HelpIDs = ({
    --DEATHKNIGHT = {
        --47541,                  -- Death Coil (40yd) - Starter
        --61999,                  -- Raise Ally (40yd) - Lvl 72
    --},
    DRUID = { 8921 },           -- Revive (40yd) - Lvl 14
    -- HUNTER = {},
    -- MAGE = { },
    MONK = { 116694 },          -- Effuse (40yd) - Lvl 8
    PALADIN = { 19750 },        -- Flash of Light (40yd) - Lvl 9
    PRIEST = { 2006 },          -- Resurrection (40yd) - Lvl 14
    -- ROGUE = {},
    SHAMAN = { 8004,188070 },   -- Healing Surge (40yd) - Lvl 7
    WARLOCK = { 20707 },        -- Soulstone (40yd) - Lvl 18
    -- WARRIOR = {},
})[playerClass]

local HarmIDs = ({
    DEATHKNIGHT = { 47541 },    -- Dark Command (30yd) - Starter
    DEMONHUNTER = { 204157 },   -- Throw Glaive
    DRUID = { 5176 },           -- Moonfire (40yd) - Lvl 10
    HUNTER = {
        75,                     -- Auto Shot (40yd) - Starter
        193265                  -- Hatchet Toss (30yd) - Lvl 19
    },
    MAGE = { 116,133,44425 },   -- Frostbolt, Fireball, Arcane Barrage (40yd)
    MONK = { 115546 },          -- Provoke (40yd) - Lvl 13
    PALADIN = { 62124 },        -- Hand of Reckoning (30yd) - Lvl 13
    PRIEST = {
        589,                    -- Shadow Word: Pain (40yd) - Lvl 4
        585                     -- Smite (40yd) - Starter
    },
    -- ROGUE = {},
    SHAMAN = {                  -- Lightning Bolt (40yd)
        403,
        187837,
        188196
    },
    WARLOCK = {                 -- Shadow Bolt (40yd)
        686,
        196657,
    },
    WARRIOR = { 355 },          -- Taunt (30yd) - Lvl 14
})[playerClass]
local IsInRange
do
    local UnitIsConnected = UnitIsConnected
    local UnitCanAssist = UnitCanAssist
    local UnitCanAttack = UnitCanAttack
    local UnitIsUnit = UnitIsUnit
    local UnitPlayerOrPetInRaid = UnitPlayerOrPetInRaid
    local UnitIsDead = UnitIsDead
    local UnitOnTaxi = UnitOnTaxi
    local UnitInRange = UnitInRange
    local IsSpellInRange = IsSpellInRange
    local CheckInteractDistance = CheckInteractDistance

	-- Uses an appropriate range check for the given unit.
	-- Actual range depends on reaction, known spells, and status of the unit.
	-- @param unit  Unit to check range for.
	-- @return True if in casting range
    function IsInRange(unit)
        if (UnitIsConnected(unit)) then
            if (UnitCanAssist('player', unit)) then
                if (HelpName and not UnitIsDead(unit)) then
                    return IsSpellInRange(HelpName, unit) == 1 and true or false
                elseif (UnitOnTaxi('player')) then  -- UnitInRange always returns nil while on flightpaths
                    return false
                elseif (UnitIsUnit(unit, 'player') or UnitIsUnit(unit, 'pet') or UnitPlayerOrPetInParty(unit) or UnitPlayerOrPetInRaid(unit)) then
                    local inRange, checkedRange = UnitInRange(unit)
                    if (checkedRange and not inRange) then
                        return false
                    else
                        return true
                    end
                end
            elseif (HarmName and not UnitIsDead(unit) and UnitCanAttack('player', unit)) then
                return IsSpellInRange(HarmName, unit) == 1 and true or false
            end

                -- Fallback when spell not found or class uses none

            return CheckInteractDistance(unit, 4) and true or false -- Follow distance (28 yd range)
        end
    end
end

-- Rechecks range for a unit frame, and fires callbacks when the unit passes in or out of range
local function UpdateRange(self)
    local InRange = IsInRange(self.unit)
    if (ObjectRanges[self] ~= InRange) then -- Range state changed
        ObjectRanges[self] = InRange

        local SpellRange = self.SpellRange
        if (SpellRange.Update) then
            SpellRange.Update(self, InRange)
        else
            self:SetAlpha(SpellRange[InRange and 'insideAlpha' or 'outsideAlpha'])
        end
    end
end


local OnUpdate;
do
    local NextUpdate = 0

	-- Updates the range display for all visible oUF unit frames on an interval
    function OnUpdate(self, Elapsed)
        NextUpdate = NextUpdate - Elapsed
        if (NextUpdate <= 0) then
            NextUpdate = UpdateRate

            for Object in pairs(Objects) do
                if (Object:IsVisible()) then
                    UpdateRange(Object)
                end
            end
        end
    end
end

local OnSpellsChanged
do
    local IsSpellKnown = IsSpellKnown
    local GetSpellInfo = GetSpellInfo

	-- @return Highest priority spell name available, or nil if none
    local function GetSpellName(IDs)
        if (IDs) then
            for _, ID in ipairs(IDs) do
                if (IsSpellKnown(ID)) then
                    return GetSpellInfo(ID)
                end
            end
        end
    end

	-- Checks known spells for the highest priority spell name to use
    function OnSpellsChanged()
        HelpName, HarmName = GetSpellName(HelpIDs), GetSpellName(HarmIDs)
    end
end


-- Called by oUF when the unit frame's unit changes or otherwise needs a complete update.
-- @param Event  Reason for the update.  Can be a real event, nil, or a string defined by oUF.
local function Update (self, Event, UnitID)
    if (Event ~= 'OnTargetUpdate') then -- OnTargetUpdate is fired on a timer for *target units that don't have real events
        ObjectRanges[self] = nil -- Force update to fire
        UpdateRange(self) -- Update range immediately
    end
end

-- Forces range to be recalculated for this element's frame immediately.
local function ForceUpdate(self)
    return Update(self.__owner, 'ForceUpdate', self.__owner.unit)
end

-- Called by oUF for new unit frames to setup range checking.
-- @return True if the range element was actually enabled.
local function Enable(self, UnitID)
    local SpellRange = self.SpellRange
    if (SpellRange) then
        assert(type( SpellRange ) == 'table', 'oUF layout addon using invalid SpellRange element.')
        assert(type(SpellRange.Update) == 'function' or (tonumber(SpellRange.insideAlpha) and tonumber(SpellRange.outsideAlpha)), 'oUF layout addon omitted required SpellRange properties.')

        if (self.Range) then -- Disable default range checking
            self:DisableElement('Range')
            self.Range = nil -- Prevent range element from enabling, since enable order isn't stable
        end

        SpellRange.__owner = self
        SpellRange.ForceUpdate = ForceUpdate
        if (not UpdateFrame) then
            UpdateFrame = CreateFrame('Frame')
            UpdateFrame:SetScript('OnUpdate', OnUpdate)
            UpdateFrame:SetScript('OnEvent', OnSpellsChanged)
        end
        if (not next(Objects)) then -- First object
            UpdateFrame:Show()
            UpdateFrame:RegisterEvent('SPELLS_CHANGED')
            OnSpellsChanged() -- Recheck spells immediately
        end

        Objects[self] = true
        return true
    end
end

--- Called by oUF to disable range checking on a unit frame.
local function Disable(self)
    Objects[self] = nil
    ObjectRanges[self] = nil

    if (not next(Objects))then -- Last object
        UpdateFrame:Hide()
        UpdateFrame:UnregisterEvent('SPELLS_CHANGED')
    end
end

oUF:AddElement('SpellRange', Update, Enable, Disable)
