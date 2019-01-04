--[[
# Element: Loot Specialization Indicator

Toggles the visibility of an indicator based on the player"s current loot specialization.

## Widget

LootSpecIndicator - A `Texture` used to display the loot specialization icon.

## Options

.border = A "Texture` used to make a border for the icon.
.alwaysShow = Forces the current specialization to be displayed even if the loot specialization matches the current specialization.

## Examples

    -- Position and size
    local LootLootSpecIndicator = self:CreateTexture(nil, "OVERLAY", nil, 2)
    LootLootSpecIndicator:SetSize(16, 16)
    LootLootSpecIndicator:SetPoint("LEFT", self)

    LootSpecIndicator.Border = self:CreateTexture(nil, "OVERLAY", nil, 3)
    LootSpecIndicator.Border:SetSize(42,42)
    LootSpecIndicator.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
    LootSpecIndicator.Border:SetPoint("TOPLEFT", LootSpecIndicator, -5, 5)

    -- Register it with oUF
    self.LootLootSpecIndicator = LootSpecIndicator
--]]

local _, ns = ...
local oUF = ns.oUF or oUF

local function Update(self, event)
    local element = self.LootSpecIndicator

    --[[ Callback: LootSpecIndicator:PreUpdate()
    Called before the element has been updated.

    * self - the LootSpecIndicator element
    --]]
    if element.PreUpdate then
        element:PreUpdate()
    end

    local NO_SPEC_FILTER = 0
    local specID = GetLootSpecialization()

    if specID and specID > NO_SPEC_FILTER then
        local _, _, _, texture, _, _ = GetSpecializationInfoByID(specID)
        element:SetTexture(texture)
        element:Show()
        if element.Border then element.Border:Show() end
    elseif specID and specID == NO_SPEC_FILTER and element.alwaysShow then
        local id, _, _, texture, _, _, _ = GetSpecializationInfo(GetSpecialization())
        specID = id
        element:SetTexture(texture)
        element:Show()
    else
        element:Hide()
        if element.Border then element.Border:Hide() end
    end

    --[[ Callback: LootSpecIndicator:PostUpdate(spec)
    Called after the element has been updated.

    * self - the LootSpecIndicator element
    * specID - the spec as returned by [GetLootSpecialization](http://wowprogramming.com/docs/api/GetLootSpecialization)
    --]]
    if element.PostUpdate then
        return element:PostUpdate(specID)
    end
end

local function Path(self, ...)
    --[[ Override: LootSpecIndicator.Override(self, event, ...)
    Used to completely override the internal update function.

    * self  - the parent object
    * event - the event triggering the update (string)
    * ...   - the arguments accompanying the event
    --]]
    return (self.LootSpecIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, "ForceUpdate")
end

local function Enable(self)
    local element = self.LootSpecIndicator
    if element then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        if self.unit == "player" then
            self:RegisterEvent("PLAYER_LOGIN", Path, true)
            self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED", Path, true)
            self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Path, true)
        end

        return true
    end
end

local function Disable(self)
    local element = self.LootSpecIndicator
    if element then
        element:Hide()

        self:UnregisterEvent("PLAYER_LOGIN", Path)
        self:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED", Path)
        self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Path)
    end
end

oUF:AddElement("LootSpecIndicator", Path, Enable, Disable)
