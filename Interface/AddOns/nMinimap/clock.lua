local unpack = unpack
local sort = table.sort
local sort_func = function( a,b ) return a.name < b.name end

local classColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
TimeManagerClockTicker:SetShadowOffset(0, 0)
TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
TimeManagerClockTicker:SetPoint("TOPRIGHT", TimeManagerClockButton, 0, 0)

TimeManagerClockButton:GetRegions():Hide()
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetWidth(40)
TimeManagerClockButton:SetHeight(18)
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, 0, 2)

TimeManagerAlarmFiredTexture:SetTexture(nil)

hooksecurefunc(TimeManagerAlarmFiredTexture, "Show", function()
    TimeManagerClockTicker:SetTextColor(1, 0, 1)
end)

hooksecurefunc(TimeManagerAlarmFiredTexture, "Hide", function()
    TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
end)

    -- Add lockouts to time tooltip.

local instanceLockouts = {}
local worldbossLockouts = {}

TimeManagerClockButton:SetScript("OnEnter" ,function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")

    -- Add default time info.
    GameTime_UpdateTooltip()
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(GAMETIME_TOOLTIP_TOGGLE_CLOCK)

    -- Raid Lockout Info
    local savedInstances = GetNumSavedInstances()
    if savedInstances > 0 then
        for index=1, savedInstances do
            local instanceName, _, _, _, locked, _, _, _, _, difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index)

            if locked then
                instanceLockouts[index] = { name = instanceName, difficulty = difficultyName, defeated = defeatedBosses, total = maxBosses }
            end
        end

        if next(instanceLockouts) ~= nil then
            sort(instanceLockouts, sort_func)

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(CALENDAR_FILTER_RAID_LOCKOUTS)

            for _, saved in ipairs(instanceLockouts) do
                local bossColor = saved.defeated == saved.total and { 0.0, 1.0, 0.0 } or { 1.0, 0.0, 0.0 }
                GameTooltip:AddDoubleLine(saved.name .. " |cffffffff" .. saved.difficulty .. "|r", saved.defeated .. "/" .. saved.total, 1.0, 0.82, 0.0, unpack(bossColor))
            end
        end

    end

    -- World Boss Lockout Info
    local savedWorldBosses = GetNumSavedWorldBosses()
    if savedWorldBosses > 0 then
        for index=1, savedWorldBosses do
            local instanceName, _, _ = GetSavedWorldBossInfo(index)
            worldbossLockouts[index] = { name = instanceName }
        end

        if next(worldbossLockouts) ~= nil then
            sort(worldbossLockouts, sort_func)

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(RAID_INFO_WORLD_BOSS)

            for _, boss in ipairs(worldbossLockouts) do
                GameTooltip:AddLine(boss.name, 1.0, 1.0, 1.0)
            end
        end
    end

    GameTooltip:Show()
end)

TimeManagerClockButton:SetScript("OnLeave", function(self)
    wipe(instanceLockouts)
    wipe(worldbossLockouts)
    GameTooltip:Hide()
end)
