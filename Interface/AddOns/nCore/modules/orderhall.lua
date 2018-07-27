-- Small Order: Hides default Blizzard order hall ui bar and replaces it with a custom version.

    -- Create SmallOrder Frame

local SmallOrder = CreateFrame("Frame", "SmallOrder", UIParent)
SmallOrder:SetPoint("TOP", WorldFrame, "TOP", 0,5)
SmallOrder:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",})
SmallOrder:SetBackdropColor(0, 0, 0, 1)
SmallOrder:SetWidth(256)
SmallOrder:SetHeight(30)
SmallOrder:EnableMouse(true)

    -- Add !Beautycase Border

if IsAddOnLoaded("!Beautycase") then
    SmallOrder:CreateBeautyBorder(8)
end

    -- Create Order Resource Text

local amountDisplay = SmallOrder:CreateFontString(nil, "OVERLAY")
amountDisplay:SetFont("Fonts\\ARIALN.ttf", 13)
amountDisplay:SetPoint("LEFT", SmallOrder, "LEFT", 7, 0)

    -- Create Troop Text

local followerDisplay = SmallOrder:CreateFontString(nil, "OVERLAY")
followerDisplay:SetFont("Fonts\\ARIALN.ttf", 13)
followerDisplay:SetPoint("RIGHT", SmallOrder, "RIGHT", -7, 0)

    -- Invisible Frame (Used for Troops Tooltip)

local TroopsOverlay = CreateFrame("Frame", "TroopsOverlay", UIParent)
TroopsOverlay:SetHeight(30)
TroopsOverlay:SetWidth(SmallOrder:GetWidth()/3)
TroopsOverlay:SetPoint("RIGHT", SmallOrder, "RIGHT", 0, 0)
TroopsOverlay:EnableMouse(true)
TroopsOverlay:SetFrameStrata("HIGH")

    -- Toggle Display Bar

local function ToggleBar()
    if ( C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) and not SmallOrder:IsVisible() ) then
        -- Show SmallOrder
        SmallOrder:Show()
        TroopsOverlay:Show()
    else
        -- Hide SmallOrder
        if ( SmallOrder:IsVisible() ) then
            SmallOrder:Hide()
            TroopsOverlay:Hide()
        end
    end
end

    -- Change Order Resources Text

local function SetCurrency()
    local name, amount = GetCurrencyInfo(1220)
    amountDisplay:SetText(name..": "..amount)
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

    followerDisplay:SetText(FOLLOWERLIST_LABEL_TROOPS..": "..followerTotal)
end

local function onEvent(self, event, ...)

    if ( event == "PLAYER_ENTERING_WORLD" ) then

        -- Hide Default Bar
        if ( OrderHallCommandBar ) then
            OrderHallCommandBar:Hide()
            OrderHallCommandBar:UnregisterAllEvents()
            OrderHallCommandBar.Show = function() end
        end
        OrderHall_CheckCommandBar = function () end

        ToggleBar()

    elseif ( event == "GARRISON_UPDATE" ) then

        ToggleBar()

        if ( C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) ) then
            -- Update Display
            SetCurrency()
            SetTroops()
        end

    elseif ( event == "CURRENCY_DISPLAY_UPDATE" ) then
        if ( not C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) ) then return end

        -- Update Currency Display
        SetCurrency()

    elseif ( event == "GARRISON_FOLLOWER_ADDED" or event == "GARRISON_FOLLOWER_REMOVED" ) then
        if ( not C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) ) then return end

        -- Update Troop Count
        SetTroops()
    end
end

    -- Gets follower info and outputs it in tooltip on TroopsOverlay mouseover.

TroopsOverlay:SetScript("OnEnter", function(self)

    local followerInfo = C_Garrison.GetFollowers() or {}

    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddDoubleLine(FOLLOWERLIST_LABEL_TROOPS, DURABILITY, 0, 1, 0, 0, 1, 0)

    local sort_func = function( a,b ) return a.name < b.name end
    table.sort( followerInfo, sort_func )

    for i, follower in ipairs(followerInfo) do
        if follower.isCollected then
            if follower.isTroop then
                GameTooltip:AddDoubleLine(follower.name, follower.durability .. "/" .. follower.maxDurability)
            end
        end
    end

    GameTooltip:Show()
end)

    -- Hides Tooltip

TroopsOverlay:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

SmallOrder:SetScript("OnEvent", onEvent)
SmallOrder:RegisterEvent("PLAYER_ENTERING_WORLD")
SmallOrder:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
SmallOrder:RegisterEvent("GARRISON_UPDATE")
SmallOrder:RegisterEvent("GARRISON_FOLLOWER_ADDED")
SmallOrder:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
