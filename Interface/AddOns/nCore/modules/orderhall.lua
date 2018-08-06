local _, nCore = ...

-- nOrderHall: Hides default Blizzard order hall ui bar and replaces it with a custom version.

    -- Toggle Display Bar

local function ToggleBar(self)
    if C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) and not self:IsVisible() then
        self:Show()
    else
        if self:IsVisible() then
            self:Hide()
        end
    end
end

    -- Change Order Resources Text

local function SetCurrency()
    local name, amount = GetCurrencyInfo(1220)
    nOrderHall_Resources:SetText(name..": |cffFFFFFF"..amount)
end

    -- Count and display number of troops.

local function SetTroops()
    local followerInfo = C_Garrison.GetFollowers() or {}

    local followerTotal = 0

    for i, follower in ipairs(followerInfo) do
      if follower.isCollected then
        if follower.isTroop then
            followerTotal = followerTotal + 1
        end
      end
    end

    nOrderHall_Troops:SetText(FOLLOWERLIST_LABEL_TROOPS..": |cffFFFFFF"..followerTotal)
end

function nOrderHall_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    self:RegisterEvent("GARRISON_UPDATE")
    self:RegisterEvent("GARRISON_FOLLOWER_ADDED")
    self:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
end

function nOrderHall_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if OrderHallCommandBar then
            OrderHallCommandBar:Hide()
            OrderHallCommandBar:UnregisterAllEvents()
            OrderHallCommandBar.Show = function() end
        end
        OrderHall_CheckCommandBar = function () end

        ToggleBar(self)
    elseif event == "GARRISON_UPDATE" then
        ToggleBar(self)

        if self:IsVisible() then
            SetCurrency()
            SetTroops()
        end
    elseif event == "CURRENCY_DISPLAY_UPDATE" then
        if self:IsVisible() then
            SetCurrency()
        end
    elseif event == "GARRISON_FOLLOWER_ADDED" or event == "GARRISON_FOLLOWER_REMOVED" then
        if self:IsVisible() then
            SetTroops()
        end
    end
end

    -- Gets follower info and outputs it in tooltip.

function nOrderHall_OnEnter(self)
    local followerInfo = C_Garrison.GetFollowers() or {}

    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:ClearLines()
    GameTooltip:AddDoubleLine(FOLLOWERLIST_LABEL_TROOPS, DURABILITY)

    local sort_func = function( a,b ) return a.name < b.name end
    table.sort( followerInfo, sort_func )

    for i, follower in ipairs(followerInfo) do
        if follower.isCollected then
            if follower.isTroop then
                GameTooltip:AddDoubleLine(follower.name, follower.durability .. "/" .. follower.maxDurability, 1,1,1, 1,1,1)
            end
        end
    end

    GameTooltip:Show()
end

    -- Hides Tooltip

function nOrderHall_OnLeave(self)
    GameTooltip:Hide()
end
