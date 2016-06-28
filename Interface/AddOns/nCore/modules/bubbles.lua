local next = next
local select = select
local CreateFrame = CreateFrame

local frame = CreateFrame("Frame", nil, UIParent)
local total = 0
local numKids = 0
local bubbles = {}

local function styleBubble(frame)
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
		end
	end

	frame:CreateBeautyBorder(11)
	frame:SetBeautyBorderPadding(-3)
	frame:SetBackdrop({
		bgFile = 'Interface\\Buttons\\WHITE8x8',
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 0.5)
	frame:SetClampedToScreen(false)
	frame:SetFrameStrata("BACKGROUND")
	frame.text:SetFont('Fonts\\ARIALN.ttf', 12)
	frame.text:SetShadowOffset(1.25 * UIParent:GetScale(), -1.25 * UIParent:GetScale())
	
	tinsert(bubbles, frame)
end

frame:SetScript("OnUpdate", function(self, elapsed)
	total = total + elapsed

	if total > 0.1 then
		total = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids + 1, newNumKids do
				local frame = select(i, WorldFrame:GetChildren())
				local b = frame:GetBackdrop()
				if b and b.bgFile == [[Interface\Tooltips\ChatBubble-Background]] then
					styleBubble(frame)
				end
			end
			numKids = newNumKids
		end

		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()
			frame:SetBeautyBorderColor(r, g, b)
		end
	end
end)