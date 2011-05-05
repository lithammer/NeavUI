
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