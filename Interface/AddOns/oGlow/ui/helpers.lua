local _, ns = ...
local oGlow = ns.oGlow

ns.createFontString = function(parent, template)
	local label = parent:CreateFontString(nil, nil, template or 'GameFontHighlight')
	label:SetJustifyH'LEFT'

	return label
end

ns.Hex = function(r, g, b)
	if(type(r) == "table") then
		if(r.r) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

do
	local OnEscapePressed = function(self)
		self:SetText(self.oldText)
		self:ClearFocus()

		self:update()
	end

	local OnEnterPressed = function(self)
		local text = self:GetText()
		self:ClearFocus()

		self:update()
	end

	local OnEditFocusGained = function(self)
		self.oldText = self:GetText()

		self:SetText(self.oldText)
		self.newText = nil
	end

	local OnEditFocusLost = function(self)
		self.newText = nil
		self.oldText = nil
	end

	local OnTextChanged = function(self, userInput)
		if(userInput) then
			self.newText = self:GetText()
			self:update()
		end
	end

	local OnChar = function(self, key)
		local text = self:GetText()
		if(self.validate and not self:validate(text)) then
			local pos = self:GetCursorPosition() - 1
			self:SetText(self.newText or self.oldText)
			self:SetCursorPosition(pos)
		end

		self.newText = self:GetText()
	end

	ns.createEditBox = function(self)
		local editbox = CreateFrame('EditBox', nil, self)

		editbox:SetWidth(40)
		editbox:SetMaxLetters(5)
		editbox:SetAutoFocus(false)
		editbox:SetFontObject(GameFontHighlight)

		editbox:SetPoint('TOP', 0, -4)
		editbox:SetPoint('BOTTOM', 0, 0)

		local background = editbox:CreateTexture(nil, 'BACKGROUND')
		background:SetPoint('TOP', 0, -1)
		background:SetPoint'LEFT'
		background:SetPoint'RIGHT'
		background:SetPoint('BOTTOM', 0, 4)

		background:SetTexture(1, 1, 1, .05)

		editbox:SetScript('OnEscapePressed', OnEscapePressed)
		editbox:SetScript('OnEnterPressed', OnEnterPressed)
		editbox:SetScript('OnEditFocusGained', OnEditFocusGained)
		editbox:SetScript('OnEditFocusLost', OnEditFocusLost)
		editbox:SetScript('OnTextChanged', OnTextChanged)
		editbox:SetScript('OnChar', OnChar)

		return editbox
	end
end

do
	local OnClick = function(self, button, down)
		self:GetParent():GetParent().colorPicker = self
		OpenColorPicker(self)
	end

	ns.createColorSwatch = function(self)
		local swatch = CreateFrame('Button', nil, self)
		swatch:SetSize(16, 16)

		local background = swatch:CreateTexture(nil, 'BACKGROUND')
		background:SetSize(14, 14)
		background:SetPoint'CENTER'
		background:SetTexture(.3, .3, .3)

		swatch:SetNormalTexture[[Interface\ChatFrame\ChatFrameColorSwatch]]

		swatch:SetScript('OnClick', OnClick)

		return swatch
	end
end
