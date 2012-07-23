local _, addon = ...
local ABT_configtooltip = CreateFrame('GameTooltip', 'ABT_configtooltip', UIParent, 'GameTooltipTemplate')

local _, playerClass = UnitClass('player')

local function ExampleUpdate()
	_G['obiexample']:SetDisabledTexture(GetActionTexture(1))

	local spell = _G['obicon1']:GetText()
	if spell then
		_, _, texture = GetSpellInfo(spell)

		if texture then
			_G['obiexample']:SetDisabledTexture(texture)
		end
	end

	if _G['obifontsize']:GetValue() > 0 then
		example = ''
		if _G['obicon5']:GetChecked() then
		else
			example = '9m'
		end

		if _G['obishowdmg']:GetValue() == 1 then
			example = addon.NeedSlash(example,'DDDD')
		end

		if _G['obicon6']:GetChecked() then
			example = addon.NeedSlash(example,'S')
		end

		if _G['obictoom']:GetValue() >= 0 then
			example = addon.NeedSlash(example,'CC')
		end

		if _G['obicon8']:GetValue() > 0 then
			example = addon.NeedSlash(example,'P')
		end

		if _G['obiedef']:GetValue() > 0 then
			example = addon.NeedSlash(example,'E')
		end

		addon.ClearText(_G['obiexample'])
		addon.SetText(_G['obiexample'],_G['obispos']:GetValue(),'|cff' .. string.format('%02x%02x%02x',(_G['obifontcolor'].fontr or 0) * 255,(_G['obifontcolor'].fontg or 0) * 255,(_G['obifontcolor'].fontb or 2) * 255) .. example .. '|r',_G['obifontsize']:GetValue(),addon.fontStyleValues[_G['obifontstyle']:GetValue()])
	end
end

local function Dropdown_OnShow(self)
	UIDropDownMenu_SetWidth(self, 180)
	UIDropDownMenu_JustifyText(self, 'LEFT')
	_G[self:GetName()..'Text']:SetText(' ')
	UIDropDownMenu_Initialize(self, self.Initialize)
end

local function BlankToNil(val)
	if not val or string.find(val,'^ *$') then -- string is either '' or all spaces
		return nil
	else
		return val
	end
end

local function FalseToNil(val)
	if val and val == 1 then
		return true
	else
		return nil
	end
end

local function NilIf(val,limit)
	if val == limit then
		return nil
	else
		return val
	end
end

local function NewSpellClick()
	_G['obicon0'].value = nil
	--_G['obipresets']:Show()
	_G['obicon1']:SetText('')
	_G['obisearchtt']:SetChecked(false)
	_G['obishowdmg']:SetValue(0)
	_G['obicon2']:SetText('')
	_G['obitarget']:SetValue(1)  		
	_G['obicon4']:SetChecked(false)
	_G['obinotmine']:SetChecked(false)
	_G['obicon5']:SetChecked(false)
	_G['obicon6']:SetChecked(false)
	_G['obicon8']:SetValue(0)
	_G['obicon9']:Disable()
	_G['obicon11']:Hide()
	_G['obiedef']:SetValue(0)
	_G['obictoom']:SetValue(-1)
	_G['obispos']:SetValue(1)
	_G['obifontsize']:SetValue(11)
	_G['obifontstyle']:SetValue(1)
	_G['obifontcolor'].fontr = 0
	_G['obifontcolor'].fontg = 1
	_G['obifontcolor'].fontb = 0
	_G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
	ExampleUpdate()
	_G['obicon0']:Hide()
	_G['obicon1']:Show()
end

function addon.ConfigInit()
	addon.configpanel = CreateFrame('Frame', 'OBIConfig',UIParent)
	addon.configpanel:SetWidth(608)
	addon.configpanel:SetHeight(440)
	addon.configpanel:SetPoint('CENTER')

	local spelldd = CreateFrame('Frame', 'obicon0' , addon.configpanel, 'UIDropDownMenuTemplate')
	local text = spelldd:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', spelldd, 'TOPLEFT', 21, 0)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(addon.con0)
	spelldd:SetScript('OnShow', Dropdown_OnShow)
	spelldd:SetPoint('TOPLEFT', 25, -100)
	function spelldd.Initialize()
		local function Button_OnClick(self)
			UIDropDownMenu_SetSelectedValue(spelldd, self.value)
			spelldd.value = self.value
			--_G['obipresets']:Hide()
			_G['obicon1']:SetText(self.value or ' ')
			_G['obisearchtt']:SetChecked(ABT_SpellDB[self.value]['SEARCHTT'] or false)
			_G['obishowdmg']:SetValue(ABT_SpellDB[self.value]['SHOWDMG'] or 0)
			_G['obicon2']:SetText(ABT_SpellDB[self.value]['Buff'] or ' ')
			_G['obitarget']:SetValue(ABT_SpellDB[self.value]['TARGET'] or 1)
			_G['obicon4']:SetChecked(ABT_SpellDB[self.value]['Debuff'] or false)
			_G['obinotmine']:SetChecked(ABT_SpellDB[self.value]['NOTMINE'] or false)
			_G['obicon5']:SetChecked(ABT_SpellDB[self.value]['NoTime'] or false)
			_G['obicon6']:SetChecked(ABT_SpellDB[self.value]['Stack'] or false)
			_G['obicon8']:SetValue(ABT_SpellDB[self.value]['CP'] or 0)
			_G['obiedef']:SetValue(ABT_SpellDB[self.value]['EDEF'] or 0)
			_G['obictoom']:SetValue(ABT_SpellDB[self.value]['CTOOM'] or -1)
			_G['obicon11']:SetText(addon.del1)
			_G['obicon11']:Show()
			_G['obispos']:SetValue(ABT_SpellDB[self.value]['SPOS'] or 1)
			_G['obifontsize']:SetValue(ABT_SpellDB[self.value]['FONTSIZE'] or 11)
			_G['obifontstyle']:SetValue(ABT_SpellDB[self.value]['FONTSTYLE'] or 1)
			_G['obifontcolor'].fontr = ABT_SpellDB[self.value]['FONTCOLR'] or 0
			_G['obifontcolor'].fontg = ABT_SpellDB[self.value]['FONTCOLG'] or 1
			_G['obifontcolor'].fontb = ABT_SpellDB[self.value]['FONTCOLB'] or 0
			_G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
			ExampleUpdate()
			_G['obicon0']:Hide()
			_G['obicon1']:Show()
		end
		local items = {}
		if ABT_SpellDB then
			for spell in pairs(ABT_SpellDB) do
				items.text = spell
				items.func = Button_OnClick
				items.value = spell
				items.checked = false
				UIDropDownMenu_AddButton(items)
			end
		end
		items.text = 'New ActionButtonText'
		items.func = NewSpellClick
		items.value = 'New ActionButtonText'
		items.checked = false
		UIDropDownMenu_AddButton(items)
	end

	local about = CreateFrame('SimpleHTML','obiconfigtext',spelldd)
	about:SetFontObject('P' ,GameFontHighlightSmall)
	about:SetFontObject('H1',GameFontHighlightLarge)
	about:SetFontObject('H2',GameFontHighlight)
	about:SetPoint('TOPLEFT',spelldd,'BOTTOMLEFT',25,-15)
	about:SetPoint('TOPRIGHT',addon.configpanel,'TOPRIGHT',-40,15)
	about:SetPoint('BOTTOM',addon.configpanel,'BOTTOM',-5)
	about:SetWidth(500)
	about:SetHeight(40)
	about:SetText(addon.configtext)
	about:Show()

	local function SpellChange(self)
		self:SetText(strupper(self:GetText()))
		_G['obicon9']:Enable()
		self.error:SetText('')
		newtext = self:GetText()
		if newtext ~= _G['obicon0'].value then
			if ABT_SpellDB and ABT_SpellDB[newtext] then
				_G['obicon9']:Disable()
				self.error:SetText(addon.err1)
			else
			end  
		end
		if self:GetText() == '' then
			_G['obicon9']:Disable()
			self.error:SetText(addon.err2)
		end
		ExampleUpdate()
	end

	local function ShowTip(self)
		ABT_configtooltip:SetOwner(WorldFrame, 'ANCHOR_NONE') -- without this, tooltip can fail 'randomly'
		ABT_configtooltip:ClearLines()
		ABT_configtooltip:SetText(addon.tips[self:GetName()] or '')
		ABT_configtooltip:SetPoint('BOTTOMLEFT',self,'TOPLEFT',10,10)
		ABT_configtooltip:Show()
	end

	local function HideTip()
		ABT_configtooltip:Hide()
	end

	local spellnm = CreateFrame('Editbox', 'obicon1' , addon.configpanel,'InputBoxTemplate')
	spellnm:SetAutoFocus(nil)
	spellnm:SetWidth(180)
	spellnm:SetHeight(32)
	spellnm:SetFontObject('GameFontHighlightSmall')
	spellnm:SetPoint('TOPLEFT', spelldd, 'TOPLEFT', 21, -10)
	spellnm:SetScript('OnTextChanged',SpellChange)
	local text = spellnm:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', spellnm, 'TOPLEFT', 0, -5)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(addon.con1)
	local text2 = spellnm:CreateFontString(nil, 'BACKGROUND')
	text2:SetPoint('TOPLEFT', spellnm, 'BOTTOMLEFT', 0, 5)
	text2:SetFontObject('GameFontNormal')
	text2:SetTextColor(1,0,0)
	text2:SetText('')
	spellnm.error = text2
	spellnm:Hide()

	local text = spellnm:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', spellnm, 'TOPLEFT', -20, 30)
	text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
	text:SetTextColor(0,1,0) 
	text:SetText(addon.hint1)

	local searchtt = CreateFrame('CheckButton', 'obisearchtt' , spellnm ,'UICheckButtonTemplate')
	_G[searchtt:GetName() .. 'Text']:SetText(addon.searchtt)
	searchtt:SetPoint('TOPLEFT', spellnm, 'TOPRIGHT', 0,0)


	local presets = CreateFrame('Frame', 'obipresets' , spellnm, 'UIDropDownMenuTemplate')
	local text = presets:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', presets, 'TOPLEFT', 21, 0)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(addon.choose)
	presets:SetScript('OnShow', Dropdown_OnShow)
	presets:SetPoint('TOPLEFT', spellnm, 'TOPRIGHT',130,0)
	presets:Hide()

	function presets.Initialize()
		local function Button_OnClick(self)
			UIDropDownMenu_SetSelectedValue(presets, self.value)
			presets.value = self.value
			spell = self.value
			preset = addon.examples[spell]
			_G['obicon1']:SetText(spell)
			_G['obisearchtt']:SetChecked(preset['SEARCHTT'] or false)
			_G['obishowdmg']:SetValue(preset['SHOWDMG'] or 0)
			_G['obicon2']:SetText(preset['Buff'] or ' ')
			_G['obitarget']:SetValue(preset['TARGET'] or 1)
			_G['obicon4']:SetChecked(preset['Debuff'] or false)
			_G['obinotmine']:SetChecked(preset['NOTMINE'] or false)
			_G['obicon5']:SetChecked(preset['NoTime'] or false)
			_G['obicon6']:SetChecked(preset['Stack'] or false)
			_G['obicon8']:SetValue(preset['CP'] or 0)
			_G['obiedef']:SetValue(preset['EDEF'] or 0)
			_G['obictoom']:SetValue(preset['CTOOM'] or -1)
			_G['obicon11']:SetText(addon.del1)
			_G['obifontsize']:SetValue(preset['FONTSIZE'] or 11)
			_G['obifontstyle']:SetValue(preset['FONTSTYLE'] or 1)
			_G['obifontcolor'].fontr = preset['FONTCOLR'] or 0
			_G['obifontcolor'].fontg = preset['FONTCOLG'] or 1
			_G['obifontcolor'].fontb = preset['FONTCOLB'] or 0
			_G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
			ExampleUpdate()
		end
		local items = {}
		for spell in pairs(addon.examples) do
			_,_,items.text = string.find(spell,'(.*)#')
			items.func = Button_OnClick
			items.value = spell
			items.checked = false
			UIDropDownMenu_AddButton(items)
		end
	end

	local showdmg = CreateFrame('Slider','obishowdmg', spellnm,'OptionsSliderTemplate')
	showdmg:SetWidth(90)
	showdmg:SetMinMaxValues(0,1)
	showdmg:SetValueStep(1)
	_G[showdmg:GetName() .. 'Text']:SetText(addon.showdmg)
	_G[showdmg:GetName() .. 'Low']:SetText('No')
	_G[showdmg:GetName() .. 'High']:SetText('Yes')
	showdmg:SetPoint('TOPLEFT', spellnm, 'BOTTOMLEFT', 0, -50)
	showdmg:SetScript('OnValueChanged', function()
		ExampleUpdate()
	end)

	relto = showdmg

	local text = showdmg:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', showdmg, 'TOPLEFT', -20, 35)
	text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
	text:SetTextColor(0,1,0) 
	text:SetText(addon.hint2)

	local ctoom = CreateFrame('Slider','obictoom', spellnm,'OptionsSliderTemplate')
	ctoom:SetWidth(130)
	ctoom:SetMinMaxValues(-1,9)
	ctoom:SetValueStep(1)
	_G[ctoom:GetName() .. 'Text']:SetText(addon.ctoom)
	_G[ctoom:GetName() .. 'Low']:SetText('')
	_G[ctoom:GetName() .. 'High']:SetText('')
	ctoom:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
	ctoom:SetScript('OnValueChanged', function(self)
		val = self:GetValue()
		txt = ''
		if val == -1 then
			txt = 'No'
		elseif val == 0 then
			txt = 'Yes'
		else
			txt = 'when ' .. val .. ' or less'
		end
		self.valtext:SetText(txt)
		ExampleUpdate()
	end)

	local text = ctoom:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', ctoom, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	ctoom.valtext = text
	if string.find('WARRIOR:DEATHKNIGHT:ROGUE', playerClass) then
		ctoom:Hide()
	else
		relto = ctoom
	end 

	local function ComboChange(self)
		vals = addon.combovals
		if self:GetValue() then
			self.valtext:SetText(vals[self:GetValue()+1])
			ExampleUpdate()
		end
	end

	local combop = CreateFrame('Slider','obicon8', spellnm,'OptionsSliderTemplate')
	combop:SetWidth(90)
	combop:SetMinMaxValues(0,2)
	combop:SetValueStep(1)
	_G[combop:GetName() .. 'Text']:SetText(addon.con8)
	_G[combop:GetName() .. 'Low']:SetText('')
	_G[combop:GetName() .. 'High']:SetText('')
	combop:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
	combop:SetScript('OnValueChanged',ComboChange)
	local text = combop:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', combop, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	combop.valtext = text
	if not string.find('DRUID:ROGUE', playerClass) then
		combop:Hide()
	else
		relto = combop
	end 

	local edef = CreateFrame('Slider','obiedef', spellnm,'OptionsSliderTemplate')
	edef:SetWidth(110)
	edef:SetMinMaxValues(0,2)
	edef:SetValueStep(1)
	_G[edef:GetName() .. 'Text']:SetText(addon.edef)
	_G[edef:GetName() .. 'Low']:SetText('')
	_G[edef:GetName() .. 'High']:SetText('')
	edef:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
	edef:SetScript('OnValueChanged', function(self)
		vals = addon.edefvals
		if self:GetValue() then
			self.valtext:SetText(vals[self:GetValue()+1])
			ExampleUpdate()
		end
	end)

	local text = edef:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', edef, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	edef.valtext = text
	if not string.find('DEATHKNIGHT:DRUID:ROGUE', playerClass) then
		edef:Hide()
	end 


	local buffnm = CreateFrame('Editbox', 'obicon2' , spellnm,'InputBoxTemplate')
	buffnm:SetAutoFocus(nil)
	buffnm:SetWidth(200)
	buffnm:SetHeight(32)
	buffnm:SetFontObject('GameFontHighlightSmall')
	buffnm:SetPoint('TOPLEFT', showdmg, 'BOTTOMLEFT', 0, -55)
	buffnm:SetScript('OnTextChanged',function(self)
		self:SetText(strupper(self:GetText()))
	end)

	local text = buffnm:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', buffnm, 'TOPLEFT', 0, -5)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(addon.con2)

	local text = showdmg:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', buffnm, 'TOPLEFT', -20, 30)
	text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
	text:SetTextColor(0,1,0) 
	text:SetText(addon.hint3)

	local isdebuff = CreateFrame('CheckButton', 'obicon4' , spellnm,'UICheckButtonTemplate')
	_G[isdebuff:GetName() .. 'Text']:SetText(addon.con4)
	isdebuff:SetPoint('TOPLEFT', buffnm, 'TOPRIGHT', 0,0)

	local notmine = CreateFrame('CheckButton', 'obinotmine' , isdebuff,'UICheckButtonTemplate')
	_G[notmine:GetName() .. 'Text']:SetText(addon.notmine)
	notmine:SetPoint('LEFT', obicon4Text, 'RIGHT', 0,0)

	local target = CreateFrame('Slider','obitarget', spellnm,'OptionsSliderTemplate')
	target:SetWidth(80)
	target:SetMinMaxValues(1,3)
	target:SetValueStep(1)
	_G[target:GetName() .. 'Text']:SetText('')
	_G[target:GetName() .. 'Low']:SetText('')
	_G[target:GetName() .. 'High']:SetText('')
	target:SetPoint('TOPLEFT', notmine, 'TOPRIGHT', 60, 0)
	target:SetScript('OnValueChanged', function(self)
		vals = addon.targetValues
		if self:GetValue() then
			self.valtext:SetText(vals[self:GetValue()])
			ExampleUpdate()
		end
	end)

	local text = target:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', target, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	target.valtext = text

	local notime = CreateFrame('CheckButton', 'obicon5' , spellnm, 'UICheckButtonTemplate')
	_G[notime:GetName() .. 'Text']:SetText(addon.con5)
	notime:SetPoint('TOPLEFT', isdebuff, 'BOTTOMLEFT', 0, 10)
	notime:SetScript('OnClick', function(self)
		ExampleUpdate()
	end)

	local stack = CreateFrame('CheckButton', 'obicon6' , spellnm,'UICheckButtonTemplate')
	_G[stack:GetName() .. 'Text']:SetText(addon.con6)
	stack:SetPoint('TOPLEFT', notime, 'TOPRIGHT', 70 ,0)
	stack:SetScript('OnClick', function(self)
		ExampleUpdate()
	end)

	local spos = CreateFrame('Slider','obispos', spellnm,'OptionsSliderTemplate')
	spos:SetWidth(70)
	spos:SetMinMaxValues(1,3)
	spos:SetValueStep(1)
	_G[spos:GetName() .. 'Text']:SetText(addon.spos)
	_G[spos:GetName() .. 'Low']:SetText('')
	_G[spos:GetName() .. 'High']:SetText('')
	spos:SetPoint('TOPLEFT', buffnm, 'BOTTOMLEFT', 0, -60)
	spos:SetScript('OnValueChanged', function(self)
		vals = addon.sposvals
		if self:GetValue() then
			self.valtext:SetText(vals[self:GetValue()])
			ExampleUpdate()
		end
	end)

	local text = spos:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', spos, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	spos.valtext = text

	local text = spos:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', spos, 'TOPLEFT', -20, 35)
	text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
	text:SetTextColor(0,1,0) 
	text:SetText(addon.hint4)

	local fontsize = CreateFrame('Slider','obifontsize', spellnm,'OptionsSliderTemplate')
	fontsize:SetWidth(80)
	fontsize:SetMinMaxValues(8,26)
	fontsize:SetValueStep(1)
	_G[fontsize:GetName() .. 'Text']:SetText(addon.fontsize)
	_G[fontsize:GetName() .. 'Low']:SetText('8')
	_G[fontsize:GetName() .. 'High']:SetText('26')
	fontsize:SetPoint('TOPLEFT', spos, 'TOPRIGHT', 20, 0)
	fontsize:SetScript('OnValueChanged', function(self)
		self.valtext:SetText(self:GetValue())
		ExampleUpdate()
	end)

	local text = fontsize:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', fontsize, 'CENTER', 0, -20)
	text:SetFontObject('GameFontNormalSmall')
	fontsize.valtext = text

	local fontstyle = CreateFrame('Slider','obifontstyle', spellnm,'OptionsSliderTemplate')
	fontstyle:SetWidth(90)
	fontstyle:SetMinMaxValues(0,2)
	fontstyle:SetValueStep(1)
	_G[fontstyle:GetName() .. 'Text']:SetText(addon.fontstyle)
	_G[fontstyle:GetName() .. 'Low']:SetText('')
	_G[fontstyle:GetName() .. 'High']:SetText('')
	fontstyle:SetPoint('TOPLEFT', fontsize, 'TOPRIGHT', 20, 0)
	fontstyle:SetScript('OnValueChanged', function(self)
		vals = addon.fontStyleValues
		if self:GetValue() then
			self.valtext:SetText(vals[self:GetValue()])
			ExampleUpdate()
		end
	end)

	local text = fontstyle:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', fontstyle, 'CENTER', 0, -20)
	text:SetFontObject('GameFontNormalSmall')
	fontstyle.valtext = text

	local fontcolor = CreateFrame('Button','obifontcolor',spellnm)
	fontcolor:SetPoint('TOPLEFT', fontstyle, 'TOPRIGHT', 20, 0)
	fontcolor:SetWidth(20)
	fontcolor:SetHeight(20)
	--fontcolor:SetNormalTexture('Interface/ChatFrame/ChatFrameColorSwatch')
	local bg = fontcolor:CreateTexture(nil, 'BACKGROUND')
	bg:SetWidth(20)
	bg:SetHeight(20)
	bg:SetPoint('CENTER')
	fontcolor.bg = bg
	fontcolor:SetScript('OnClick', function(fontColor)
		ColorPickerFrame.func = function()
			r,g,b = ColorPickerFrame:GetColorRGB()
			fontcolor.fontr = r
			fontcolor.fontg = g
			fontcolor.fontb = b
			fontcolor.bg:SetTexture(r,g,b)
			ExampleUpdate()
		end

		ColorPickerFrame.cancelFunc = function()
			r,g,b = ColorPickerFrame.prevr,ColorPickerFrame.prevg,ColorPickerFrame.prevb
			fontcolor.fontr = r
			fontcolor.fontg = g
			fontcolor.fontb = b
			fontcolor.bg:SetTexture(r,g,b)
			ExampleUpdate()
		end

		ColorPickerFrame.prevr = fontcolor.fontr
		ColorPickerFrame.prevg = fontcolor.fontg
		ColorPickerFrame.prevb = fontcolor.fontb
		ColorPickerFrame:SetColorRGB(fontcolor.fontr,fontcolor.fontg,fontcolor.fontb)
		ColorPickerFrame.opacity = 1
		ColorPickerFrame:Show()
	end)


	local testbutton = CreateFrame('CheckButton','obiexample', spellnm, 'ActionBarButtonTemplate')
	testbutton:SetWidth(36)
	testbutton:SetHeight(36)
	testbutton:Disable()
	testbutton:SetPoint('TOPLEFT',fontcolor,50,10)

	local function CancelClick()
		_G['obicon1'].error:SetText('')
		_G['obicon1']:Hide()
		_G['obicon0']:Show()
	end

	local function SaveClick()
		-- actually save things in here
		to,from = _G['obicon1']:GetText() , _G['obicon0'].value
		if from ~= to then
			if not ABT_SpellDB then
				ABT_SpellDB = {}
			end
			ABT_SpellDB[to] = {}
			if from then
				for val in pairs(ABT_SpellDB[from]) do
					ABT_SpellDB[to][val] = ABT_SpellDB[from][val]
				end
				ABT_SpellDB[from] = nil
			end
			spelldd.Initialize()
		end

		ABT_SpellDB[to]['SEARCHTT'] = FalseToNil(_G['obisearchtt']:GetChecked())
		ABT_SpellDB[to]['SHOWDMG'] = NilIf(_G['obishowdmg']:GetValue(),0)
		ABT_SpellDB[to]['Buff'] = BlankToNil(_G['obicon2']:GetText())
		ABT_SpellDB[to]['TARGET'] = NilIf(_G['obitarget']:GetValue(),1)
		ABT_SpellDB[to]['Debuff'] = FalseToNil(_G['obicon4']:GetChecked())
		ABT_SpellDB[to]['NOTMINE'] = FalseToNil(_G['obinotmine']:GetChecked())
		ABT_SpellDB[to]['NoTime'] = FalseToNil(_G['obicon5']:GetChecked())
		ABT_SpellDB[to]['Stack'] = FalseToNil(_G['obicon6']:GetChecked())
		ABT_SpellDB[to]['SPOS'] = NilIf(_G['obispos']:GetValue(),1)
		ABT_SpellDB[to]['FONTSIZE'] = NilIf(_G['obifontsize']:GetValue(),11)
		ABT_SpellDB[to]['FONTSTYLE'] = NilIf(_G['obifontstyle']:GetValue(),1)
		ABT_SpellDB[to]['FONTCOLR'] = NilIf(_G['obifontcolor'].fontr,0)
		ABT_SpellDB[to]['FONTCOLG'] = NilIf(_G['obifontcolor'].fontg,1)
		ABT_SpellDB[to]['FONTCOLB'] = NilIf(_G['obifontcolor'].fontb,0)
		ABT_SpellDB[to]['CP'] = NilIf(_G['obicon8']:GetValue(),0)
		ABT_SpellDB[to]['EDEF'] = NilIf(_G['obiedef']:GetValue(),0)
		ABT_SpellDB[to]['CTOOM'] = NilIf(_G['obictoom']:GetValue(),-1)
		CancelClick()
	end

	local function DeleteClick(self)
		btntext = self:GetText()
		if btntext == addon.del1 then
			self:SetText(addon.del2)
		elseif btntext == addon.del2 then
			self:SetText(addon.del3)
		elseif btntext == addon.del3 then
			-- actually delete things in here
			ABT_SpellDB[_G['obicon0'].value] = nil
			CancelClick()
		end
	end

	local saveButton = CreateFrame('Button','obicon9', spellnm,'UIPanelButtonTemplate')
	saveButton:SetWidth(120)
	saveButton:SetHeight(20)
	saveButton:SetPoint('BOTTOMLEFT', addon.configpanel, 'BOTTOMLEFT', 30, 20)
	saveButton:SetText(addon.con9)
	saveButton:SetScript('OnClick', SaveClick)

	local cancelButton = CreateFrame('Button','obicon10', spellnm,'UIPanelButtonTemplate')
	cancelButton:SetWidth(120)
	cancelButton:SetHeight(20)
	cancelButton:SetPoint('TOPLEFT', saveButton, 'TOPRIGHT', 20, 0)
	cancelButton:SetText(addon.con10)
	cancelButton:SetScript('OnClick', CancelClick)

	local deleteButton = CreateFrame('Button','obicon11', spellnm,'UIPanelButtonTemplate')
	deleteButton:SetWidth(200)
	deleteButton:SetHeight(20)
	deleteButton:SetPoint('TOPLEFT', cancelButton, 'TOPRIGHT', 80, 0)
	deleteButton:SetScript('OnClick', DeleteClick)

	local widgets = {_G['obicon1'],_G['obicon1']:GetChildren()}
	for _,id in ipairs(widgets) do
		id:SetScript('OnEnter',ShowTip)
		id:SetScript('OnLeave',HideTip)
	end

	local titleRegion = addon.configpanel:CreateTitleRegion()
	titleRegion:SetWidth(525)
	titleRegion:SetHeight(20)
	titleRegion:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', 50, -10)

	local texture = addon.configpanel:CreateTexture(nil, 'BACKGROUND')
	texture:SetTexture('Interface\\FriendsFrame\\FriendsFrameScrollIcon')
	texture:SetWidth(64)
	texture:SetHeight(64) 
	texture:SetPoint('TOPLEFT', addon.configpanel, 'TOPLEFT', 8, 1)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft')
	texture:SetWidth(256)
	texture:SetHeight(256)
	texture:SetPoint('TOPLEFT')

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft')
	texture:SetWidth(128)
	texture:SetHeight(256)
	texture:SetPoint('TOPLEFT', addon.configpanel, 'TOPLEFT', 256, 0)
	texture:SetTexCoord(0.38, 0.88, 0, 1)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft')
	texture:SetWidth(128)
	texture:SetHeight(256)
	texture:SetPoint('TOPLEFT', addon.configpanel, 'TOPLEFT', 384, 0)
	texture:SetTexCoord(0.45, 0.95, 0, 1)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight')
	texture:SetWidth(100)
	texture:SetHeight(256)
	texture:SetPoint('TOPRIGHT')
	texture:SetTexCoord(0, 0.78125, 0, 1)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft')
	texture:SetWidth(256)
	texture:SetHeight(184)
	texture:SetPoint('BOTTOMLEFT')
	texture:SetTexCoord(0, 1, 0, 0.71875)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft')
	texture:SetWidth(128)
	texture:SetHeight(184)
	texture:SetPoint('BOTTOMLEFT', addon.configpanel, 'BOTTOMLEFT', 256, 0)
	texture:SetTexCoord(0.5, 1, 0, 0.71875)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft')
	texture:SetWidth(128)
	texture:SetHeight(184)
	texture:SetPoint('BOTTOMLEFT', addon.configpanel, 'BOTTOMLEFT', 384, 0)
	texture:SetTexCoord(0.5, 1, 0, 0.71875)

	texture = addon.configpanel:CreateTexture(nil, 'ARTWORK')
	texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight')
	texture:SetWidth(100)
	texture:SetHeight(184)
	texture:SetPoint('BOTTOMRIGHT')
	texture:SetTexCoord(0, 0.78125, 0, 0.71875)

	local fontString = addon.configpanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	fontString:SetText('ActionButtonText - Configuratron!')
	fontString:SetPoint('TOP', addon.configpanel, 'TOP', 0, -18)

	local frame = CreateFrame('Button', nil, addon.configpanel, 'UIPanelCloseButton')
	frame:SetPoint('TOPRIGHT', addon.configpanel, 'TOPRIGHT', -3, -8)

	table.insert(UISpecialFrames, addon.configpanel:GetName()) -- closes window on [ESCAPE]
	addon.configpanel:Hide()

end
