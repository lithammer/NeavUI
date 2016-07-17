local isLegion = select(4, GetBuildInfo()) >= 70000
if not isLegion then return end 

    -- Create SmallOrder Frame

local SmallOrder = CreateFrame("Frame", "SmallOrder", UIParent)
SmallOrder:SetPoint("TOP", WorldFrame, "TOP", 0,5)
SmallOrder:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",})
SmallOrder:SetBackdropColor(0, 0, 0, 1)
SmallOrder:SetWidth(256)
SmallOrder:SetHeight(30)
SmallOrder:EnableMouse(true)

    -- Add !Beautycase Border

if IsAddOnLoaded('!Beautycase') then
    SmallOrder:CreateBeautyBorder(8)
end

    -- Create Order Resource Text

local amountDisplay = SmallOrder:CreateFontString(nil, 'OVERLAY')
amountDisplay:SetFont('Fonts\\ARIALN.ttf', 13)
amountDisplay:SetPoint('LEFT', SmallOrder, 'LEFT', 7, 0)

    -- Create Troop Text

local followerDisplay = SmallOrder:CreateFontString(nil, 'OVERLAY')
followerDisplay:SetFont('Fonts\\ARIALN.ttf', 13)
followerDisplay:SetPoint('RIGHT', SmallOrder, 'RIGHT', -7, 0)

    -- Invisible Frame (Used for Troops Tooltip)

local TroopsOverlay = CreateFrame("Frame", "TroopsOverlay", UIParent)
TroopsOverlay:SetHeight(30)
TroopsOverlay:SetWidth(SmallOrder:GetWidth()/3)
TroopsOverlay:SetPoint('RIGHT', SmallOrder, 'RIGHT', 0, 0)
TroopsOverlay:EnableMouse(true)
TroopsOverlay:SetFrameStrata("HIGH")

local function onEvent(self, event)
    
        -- Checks Location

    if (C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)) then
        SmallOrder:Show()
        TroopsOverlay:Show()
    else
        SmallOrder:Hide()
        TroopsOverlay:Hide()
        return
    end

        -- Hide Default Bar

    if OrderHallCommandBar then
        OrderHallCommandBar:Hide()
        OrderHallCommandBar:UnregisterAllEvents()
        OrderHallCommandBar.Show = function() end
    end
    OrderHall_CheckCommandBar = function () end
    
        -- Change Order Resources Text

    local name, amount = GetCurrencyInfo(1220)
    amountDisplay:SetText(name..": "..amount)

        -- Count and display number of troops.
    
    local followerInfo = C_Garrison.GetFollowers() or {}

    local followerTotal = 0

    for i, follower in ipairs(followerInfo) do
      if follower.isCollected then
        if follower.isTroop then
            followerTotal = followerTotal + 1
        end
      end
    end

    followerDisplay:SetText("Troops: "..followerTotal)
end

    -- Gets Follower Info and Outputs it in Tooltip when TroopsOverlay is clicked.
        
TroopsOverlay:SetScript('OnEnter', function(self)

    local followerInfo = C_Garrison.GetFollowers() or {}
    
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("Troops", 0, 1, 0)
    
    for i, follower in ipairs(followerInfo) do
      if follower.isCollected then
        if follower.isTroop then
            GameTooltip:AddLine(follower.name .. " - Durability: " .. follower.durability .. "/" .. follower.maxDurability)
        end
      end
    end
    
    GameTooltip:Show()
end)

    -- Hides Tooltip

TroopsOverlay:SetScript('OnLeave', function()
    GameTooltip:Hide()
end)

SmallOrder:SetScript("OnEvent", onEvent)
SmallOrder:RegisterEvent('ADDON_LOADED')
SmallOrder:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
SmallOrder:RegisterEvent("DISPLAY_SIZE_CHANGED")
SmallOrder:RegisterEvent("UI_SCALE_CHANGED")
SmallOrder:RegisterEvent("GARRISON_TALENT_COMPLETE")
SmallOrder:RegisterEvent("GARRISON_TALENT_UPDATE")
SmallOrder:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
SmallOrder:RegisterEvent("GARRISON_FOLLOWER_ADDED")
SmallOrder:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
SmallOrder:RegisterEvent("GARRISON_UPDATE")
SmallOrder:RegisterUnitEvent("UNIT_AURA", "player")