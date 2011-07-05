
    -- just a new color

local NEW_ITEM_VENDOR_STACK_BUY = ITEM_VENDOR_STACK_BUY
ITEM_VENDOR_STACK_BUY = '|cffa9ff00'..NEW_ITEM_VENDOR_STACK_BUY..'|r'

    -- alt-click to buy a stack

local origMerchantItemButton_OnModifiedClick = _G.MerchantItemButton_OnModifiedClick
local function MerchantItemButton_OnModifiedClickHook(self, ...)
    origMerchantItemButton_OnModifiedClick(self, ...)

    if (IsAltKeyDown()) then
        local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
        local _, _, _, quantity = GetMerchantItemInfo(self:GetID())

        if (maxStack and maxStack > 1) then
            BuyMerchantItem(self:GetID(), floor(maxStack / quantity))
        end
    end
end
MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClickHook

    -- Google translate ftw...NOT

local function GetAltClickString()
    if (GetLocale() == 'enUS') then
        return '<Alt-click, to buy an stack>'
    elseif (GetLocale() == 'frFR') then
        return '<Alt-clic, d acheter une pile>'
    elseif (GetLocale() == 'esES') then
        return '<Alt-clic, para comprar una pila>'
    elseif (GetLocale() == 'deDE') then
        return '<Alt-klicken, um einen ganzen Stapel zu kaufen>'
    else
        return '<Alt-click, to buy an stack>'
    end
end

    -- add a hint to the tooltip

local function IsMerchantButtonOver()
    return GetMouseFocus():GetName() and GetMouseFocus():GetName():find('MerchantItem%d')
end

GameTooltip:HookScript('OnTooltipSetItem', function(self)
    if (MerchantFrame:IsShown() and IsMerchantButtonOver()) then 
        for i = 2, GameTooltip:NumLines() do
            if (_G['GameTooltipTextLeft'..i]:GetText():find('<[sS]hift')) then
                GameTooltip:AddLine('|cff00ffcc'..GetAltClickString()..'|r')
            end
        end
    end
end)