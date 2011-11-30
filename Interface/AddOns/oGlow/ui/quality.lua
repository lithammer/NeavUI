local _, ns = ...
local oGlow = ns.oGlow

local colorTable = ns.colorTable

local frame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = 'Filter: Quality'
frame.parent = 'oGlow'

frame:SetScript('OnShow', function(self)
	self:CreateOptions()
	self:SetScript('OnShow', nil)
end)

function frame:CreateOptions()
	local title = ns.createFontString(self, 'GameFontNormalLarge')
	title:SetPoint('TOPLEFT', 16, -16)
	title:SetText'oGlow: Filter: Quality'

	local thresLabel = ns.createFontString(self, 'GameFontNormalSmall')
	thresLabel:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -16)
	thresLabel:SetText('Quality Threshold')

	local thesDDown = CreateFrame('Button', 'oGlowOptFQualityThreshold', self, 'UIDropDownMenuTemplate')
	thesDDown:SetPoint('TOPLEFT', thresLabel, 'BOTTOMLEFT', -16, 0)

	do
		local DropDown_OnClick = function(self)
			oGlowDB.FilterSettings.quality = self.value - 1
			oGlow:CallOptionCallbacks()

			for pipe, active, name, desc in oGlow.IteratePipes() do
				if(active) then
					oGlow:UpdatePipe(pipe)
				end
			end
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local DropDown_OnEnter = function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
			GameTooltip:SetText('Controls the lowest item quality color that should be displayed.', nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local UpdateSelected = function(self)
			local filters = oGlowDB.FilterSettings
			local threshold = 1
			if(filters and filters.quality) then
				threshold = filters.quality
			end

			UIDropDownMenu_SetSelectedID(thesDDown, threshold + 2)
		end

		local DropDown_init = function(self)
			local info

			for i=0,7 do
				info = UIDropDownMenu_CreateInfo()
				info.text = ns.Hex(colorTable[i]) .._G['ITEM_QUALITY' .. i .. '_DESC']
				info.value = i
				info.func = DropDown_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		thesDDown:SetScript('OnEnter', DropDown_OnEnter)
		thesDDown:SetScript('OnLeave', DropDown_OnLeave)

		function frame:refresh()
			UIDropDownMenu_Initialize(thesDDown, DropDown_init)
			UpdateSelected()
		end
		self:refresh()
	end
end

InterfaceOptions_AddCategory(frame)
