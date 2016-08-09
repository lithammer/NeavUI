-- Sets manabar color for default unit frames.
local function CustomManaColor(manaBar)
	local powerType = UnitPowerType(manaBar.unit);

    if ( powerType == 0 ) then
        manaBar:SetStatusBarColor(0,0.55,1)
    end
end
hooksecurefunc('UnitFrameManaBar_UpdateType',CustomManaColor)

CUSTOM_FACTION_BAR_COLORS = {
    [1] = {r = 1, g = 0, b = 0},
    [2] = {r = 1, g = 0, b = 0},
    [3] = {r = 1, g = 1, b = 0},
    [4] = {r = 1, g = 1, b = 0},
    [5] = {r = 0, g = 1, b = 0},
    [6] = {r = 0, g = 1, b = 0},
    [7] = {r = 0, g = 1, b = 0},
    [8] = {r = 0, g = 1, b = 0},
}

function GameTooltip_UnitColor(unit)

    local r, g, b

    if (UnitIsDead(unit) or UnitIsGhost(unit) or UnitIsTapDenied(unit)) then
        r = 0.5
        g = 0.5
        b = 0.5
    elseif (UnitIsPlayer(unit)) then
        if (UnitIsFriend(unit, 'player')) then
            local _, class = UnitClass(unit)
            if ( class ) then
                r = RAID_CLASS_COLORS[class].r
                g = RAID_CLASS_COLORS[class].g
                b = RAID_CLASS_COLORS[class].b
            else
                r = 0.60
                g = 0.60
                b = 0.60
            end
        elseif (not UnitIsFriend(unit, 'player')) then
            r = 1
            g = 0
            b = 0
        end
    elseif (UnitPlayerControlled(unit)) then
        if (UnitCanAttack(unit, 'player')) then
            if (not UnitCanAttack('player', unit)) then
                r = 157/255
                g = 197/255
                b = 255/255
            else
                r = 1
                g = 0
                b = 0
            end
        elseif (UnitCanAttack('player', unit)) then
            r = 1
            g = 1
            b = 0
        elseif (UnitIsPVP(unit)) then
            r = 0
            g = 1
            b = 0
        else
            r = 157/255
            g = 197/255
            b = 255/255
        end
    else
        local reaction = UnitReaction(unit, 'player')

        if (reaction) then
            r = CUSTOM_FACTION_BAR_COLORS[reaction].r
            g = CUSTOM_FACTION_BAR_COLORS[reaction].g
            b = CUSTOM_FACTION_BAR_COLORS[reaction].b
        else
            r = 157/255
            g = 197/255
            b = 255/255
        end
    end

    return r, g, b
end

UnitSelectionColor = GameTooltip_UnitColor
