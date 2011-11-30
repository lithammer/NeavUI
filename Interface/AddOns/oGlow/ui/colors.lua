local _, ns = ...
local oGlow = ns.oGlow

local colorTable = ns.colorTable

local frame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = 'Colors'
frame.parent = 'oGlow'

frame:SetScript('OnShow', function(self)
	self:CreateOptions()
	self:SetScript('OnShow', nil)
end)

function frame:CreateOptions()
	local title = ns.createFontString(self, 'GameFontNormalLarge')
	title:SetPoint('TOPLEFT', 16, -16)
	title:SetText'oGlow: Colors'

	local backdrop = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}

	local box = CreateFrame('Frame', nil, self)
	box:SetBackdrop(backdrop)
	box:SetBackdropColor(.1, .1, .1, .5)
	box:SetBackdropBorderColor(.3, .3, .3, 1)

	box:SetPoint('TOPLEFT', title, 0, -32)
	box:SetPoint'LEFT'
	box:SetPoint('RIGHT', -30, 0)

	local title = ns.createFontString(self)
	title:SetPoint('BOTTOMLEFT', box, 'TOPLEFT', 8, 0)
	title:SetText('Item colors')
	box.title = title

	local bTitle = ns.createFontString(self)
	bTitle:SetPoint('BOTTOMRIGHT', box, 'TOPRIGHT', -35 - 16 - 5, 0)
	bTitle:SetWidth(40)
	bTitle:SetText'Blue'
	bTitle:SetJustifyH'CENTER'
	box.bTitle = bTitle

	local gTitle = ns.createFontString(self)
	gTitle:SetPoint('RIGHT', bTitle, 'LEFT', -5, 0)
	gTitle:SetWidth(40)
	gTitle:SetText'Green'
	gTitle:SetJustifyH'CENTER'
	box.gTitle = gTitle

	local rTitle = ns.createFontString(self)
	rTitle:SetPoint('RIGHT', gTitle, 'LEFT', -5, 0)
	rTitle:SetWidth(40)
	rTitle:SetText'Red'
	rTitle:SetJustifyH'CENTER'
	box.rTitle = rTitle

	local Swatch_Update = function(self, update, r, g, b)
		local row = self:GetParent()
		self:GetNormalTexture():SetVertexColor(r, g, b)
		row.nameLabel:SetTextColor(r, g, b)

		row.swatch.r = r
		row.swatch.g = g
		row.swatch.b = b

		row.redLabel:SetNumber(math.floor(r * 255 + .5))
		row.greenLabel:SetNumber(math.floor(g * 255 + .5))
		row.blueLabel:SetNumber(math.floor(b * 255 + .5))

		if(update) then
			oGlow:RegisterColor(row.id, r, g, b)
		end
	end

	local Swatch_Ok = function()
		Swatch_Update(box.colorPicker, true, ColorPickerFrame:GetColorRGB())
	end

	local Swatch_Cancel = function()
		Swatch_Update(box.colorPicker, true, ColorPicker_GetPreviousValues())
	end

	local Label_Update = function(self)
		local row = self:GetParent()

		local r = row.redLabel:GetNumber() / 255
		local g = row.greenLabel:GetNumber() / 255
		local b = row.blueLabel:GetNumber() / 255

		Swatch_Update(row.swatch, true, r, g, b)
	end

	local Label_Validate = function(self)
		if(self:GetNumber() > 255) then
			return
		end

		return true
	end

	local Reset_OnClick = function(self)
		local row = self:GetParent()
		Swatch_Update(row.swatch, nil, oGlow:ResetColor(row.id))

		for pipe, active, name, desc in oGlow.IteratePipes() do
			if(active) then
				oGlow:UpdatePipe(pipe)
			end
		end
	end

	local Reset_OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(RESET)
	end

	local rows = {}
	for i=0, 7 do
		local row = CreateFrame('Button', nil, box)

		row:SetBackdrop(backdrop)
		row:SetBackdropBorderColor(.3, .3, .3)
		row:SetBackdropColor(.1, .1, .1, .5)

		if(i == 0) then
			row:SetPoint('TOP', 0, -8)
		else
			row:SetPoint('TOP', rows[i-1], 'BOTTOM')
		end
		row:SetPoint('LEFT', 6, 0)
		row:SetPoint('RIGHT', -25, 0)
		row:SetHeight(24)

		local swatch = ns.createColorSwatch(row)
		swatch:SetPoint('RIGHT', -10, 0)

		swatch.swatchFunc = Swatch_Ok
		swatch.cancelFunc = Swatch_Cancel

		row.swatch = swatch

		local blueLabel = ns.createEditBox(row)
		blueLabel:SetPoint('RIGHT', swatch, 'LEFT', -5, 0)
		blueLabel:SetJustifyH'CENTER'

		blueLabel:SetNumeric(true)
		blueLabel.update = Label_Update
		blueLabel.validate = Label_Validate

		row.blueLabel = blueLabel

		local greenLabel = ns.createEditBox(row)
		greenLabel:SetPoint('RIGHT', blueLabel, 'LEFT', -5, 0)
		greenLabel:SetJustifyH'CENTER'

		greenLabel:SetNumeric(true)
		greenLabel.update = Label_Update
		greenLabel.validate = Label_Validate

		row.greenLabel = greenLabel

		local redLabel = ns.createEditBox(row)
		redLabel:SetPoint('RIGHT', greenLabel, 'LEFT', -5, 0)
		redLabel:SetJustifyH'CENTER'

		redLabel:SetNumeric(true)
		redLabel.update = Label_Update
		redLabel.validate = Label_Validate

		row.redLabel = redLabel

		local nameLabel= ns.createFontString(row)
		nameLabel:SetPoint('LEFT', 10, 0)
		nameLabel:SetPoint('TOP', 0, -4)
		nameLabel:SetPoint'BOTTOM'
		nameLabel:SetJustifyH'LEFT'
		row.nameLabel = nameLabel

		local reset = CreateFrame("Button", nil, row)
		reset:SetSize(16, 16)
		reset:SetPoint('LEFT', row, 'RIGHT')

		reset:SetNormalTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Up]]
		reset:SetPushedTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Down]]
		reset:SetHighlightTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]]

		reset:SetScript("OnClick", Reset_OnClick)
		reset:SetScript("OnEnter", Reset_OnEnter)
		reset:SetScript("OnLeave", GameTooltip_Hide)
		row.reset = reset

		row.id = i
		rows[i] = row
	end
	box.rows = rows
	box:SetHeight(8 * 24 + 16)

	function frame:refresh()
		for i=0, 7 do
			local r, g, b = unpack(colorTable[i])
			local row = rows[i]
			row.nameLabel:SetText(_G['ITEM_QUALITY' .. i .. '_DESC'])
			Swatch_Update(row.swatch, false, r, g, b)
		end
	end
	self:refresh()
end

InterfaceOptions_AddCategory(frame)
