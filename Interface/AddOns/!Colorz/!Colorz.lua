
    -- Sets manabar color for default unit frames.

local function CustomManaColor(manaBar)
    local powerType = UnitPowerType(manaBar.unit)

    if powerType == 0 then
        manaBar:SetStatusBarColor(0.0, 0.55, 1.0)
    end
end
hooksecurefunc("UnitFrameManaBar_UpdateType", CustomManaColor)

    -- Set faction colors for Repuation Frame and tracking bar.

TOOLTIP_FACTION_COLORS = {
    [1] = {r = 1, g = 0, b = 0},
    [2] = {r = 1, g = 0, b = 0},
    [3] = {r = 1, g = 1, b = 0},
    [4] = {r = 1, g = 1, b = 0},
    [5] = {r = 0, g = 1, b = 0},
    [6] = {r = 0, g = 1, b = 0},
    [7] = {r = 0, g = 1, b = 0},
    [8] = {r = 0, g = 1, b = 0},
}

CUSTOM_FACTION_BAR_COLORS = {
    [1] = {r = 0.63, g = 0, b = 0},
    [2] = {r = 0.63, g = 0, b = 0},
    [3] = {r = 0.63, g = 0, b = 0},
    [4] = {r = 0.82, g = 0.67, b = 0},
    [5] = {r = 0.32, g = 0.67, b = 0},
    [6] = {r = 0.32, g = 0.67, b = 0},
    [7] = {r = 0.32, g = 0.67, b = 0},
    [8] = {r = 0, g = 0.75, b = 0.44},
}

hooksecurefunc("ReputationFrame_Update", function(showLFGPulse)
    local numFactions = GetNumFactions()
    local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

    for i=1, NUM_FACTIONS_DISPLAYED, 1 do
        local factionIndex = factionOffset + i
        local factionBar = _G["ReputationBar"..i.."ReputationBar"]

        if factionIndex <= numFactions then
            local name, description, standingID = GetFactionInfo(factionIndex)

            local colorIndex = standingID

            local friendID = GetFriendshipReputation(factionID)

            if friendID ~= nil then
                colorIndex = 5                              -- always color friendships green
            end

            local color = CUSTOM_FACTION_BAR_COLORS[colorIndex]
            factionBar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end
end)

hooksecurefunc(ReputationBarMixin, "Update", function(self)
    local name, reaction, minBar, maxBar, value, factionID = GetWatchedFactionInfo();
    local colorIndex = reaction;
    local friendshipID = GetFriendshipReputation(factionID);

    if friendshipID then
        colorIndex = 5;     -- always color friendships green
    end

    local color = CUSTOM_FACTION_BAR_COLORS[colorIndex];
    self:SetBarColor(color.r, color.g, color.b, 1);
end)

    -- Override the default GameTooltip_UnitColor function.

function GameTooltip_UnitColor(unit)

    local r, g, b

    if UnitIsDead(unit) or UnitIsGhost(unit) or UnitIsTapDenied(unit) then
        r = 0.5
        g = 0.5
        b = 0.5
    elseif UnitIsPlayer(unit) then
        if UnitIsFriend(unit, "player") then
            local _, class = UnitClass(unit)
            if class then
                r = RAID_CLASS_COLORS[class].r
                g = RAID_CLASS_COLORS[class].g
                b = RAID_CLASS_COLORS[class].b
            else
                r = 0.60
                g = 0.60
                b = 0.60
            end
        elseif not UnitIsFriend(unit, "player") then
            r = 1
            g = 0
            b = 0
        end
    elseif UnitPlayerControlled(unit) then
        if UnitCanAttack(unit, "player") then
            if not UnitCanAttack("player", unit) then
                r = 157/255
                g = 197/255
                b = 255/255
            else
                r = 1
                g = 0
                b = 0
            end
        elseif UnitCanAttack("player", unit) then
            r = 1
            g = 1
            b = 0
        elseif UnitIsPVP(unit) then
            r = 0
            g = 1
            b = 0
        else
            r = 157/255
            g = 197/255
            b = 255/255
        end
    else
        local reaction = UnitReaction(unit, "player")

        if reaction then
            r = TOOLTIP_FACTION_COLORS[reaction].r
            g = TOOLTIP_FACTION_COLORS[reaction].g
            b = TOOLTIP_FACTION_COLORS[reaction].b
        else
            r = 157/255
            g = 197/255
            b = 255/255
        end
    end

    return r, g, b
end

    -- Override the name background on default unit frames.

hooksecurefunc("TargetFrame_CheckFaction", function(self)
    if UnitPlayerControlled(self.unit) then
        self.nameBackground:SetVertexColor(GameTooltip_UnitColor(self.unit))
    end
end)
