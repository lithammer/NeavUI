
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick

function MerchantItemButton_OnModifiedClick(self, ...)
	if (IsAltKeyDown()) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
		local _, _, _, quantity = GetMerchantItemInfo(self:GetID())
        
		if (maxStack and maxStack > 1) then
			BuyMerchantItem(self:GetID(), floor(maxStack / quantity))
		end
	end
    
	savedMerchantItemButton_OnModifiedClick(self, ...)
end