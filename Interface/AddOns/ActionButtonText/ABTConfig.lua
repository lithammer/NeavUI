local ABT_configtooltip = CreateFrame("GameTooltip","ABT_configtooltip",UIParent,"GameTooltipTemplate")

function ABT_NS.configinit()
	ABT_NS.configpanel = CreateFrame("Frame", "OBIConfig",UIParent);
	ABT_NS.configpanel:SetWidth(608)
	ABT_NS.configpanel:SetHeight(440)
	ABT_NS.configpanel:SetPoint("CENTER")

	local function example_update()
		_G['obiexample']:SetDisabledTexture(GetActionTexture(1))
		spell = _G['obicon1']:GetText()
		if spell then
			   _,_,texture = GetSpellInfo(spell)
		  if texture then
			  _G['obiexample']:SetDisabledTexture(texture)
			end
		end
		if _G['obifontsize']:GetValue() > 0 then
		example = ""
		if _G['obicon5']:GetChecked() then
		else
		  example = "9m"
		end
		if _G['obishowdmg']:GetValue() == 1 then
		  example = ABT_NS.needslash(example,"DDDD")
		end     
		if _G['obicon6']:GetChecked() then
		  example = ABT_NS.needslash(example,"S")
		end     
		if _G['obictoom']:GetValue() >= 0 then
		  example = ABT_NS.needslash(example,"CC")
		end
		if _G['obicon8']:GetValue() > 0 then
		  example = ABT_NS.needslash(example,"P")
		end
		if _G['obiedef']:GetValue() > 0 then
		  example = ABT_NS.needslash(example,"E")
		end
		ABT_NS.cleartext(_G['obiexample'])
		ABT_NS.settext(_G['obiexample'],_G['obispos']:GetValue(),"|cff" .. string.format("%02x%02x%02x",(_G['obifontcolor'].fontr or 0) * 255,(_G['obifontcolor'].fontg or 0) * 255,(_G['obifontcolor'].fontb or 2) * 255) .. example .. "|r",_G['obifontsize']:GetValue(),ABT_NS.fontstylevals[_G['obifontstyle']:GetValue()])
		end
	end

	local function Dropdown_OnShow(self)
		UIDropDownMenu_SetWidth(self, 180)
 		UIDropDownMenu_JustifyText(self, "LEFT")
		getglobal(self:GetName() .. 'Text'):SetText(" ")
		UIDropDownMenu_Initialize(self, self.Initialize)
	end

	local spelldd = CreateFrame('Frame', "obicon0" , ABT_NS.configpanel, 'UIDropDownMenuTemplate')
	local text = spelldd:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', spelldd, 'TOPLEFT', 21, 0)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(ABT_NS.con0)
	spelldd:SetScript('OnShow', Dropdown_OnShow)
	spelldd:SetPoint('TOPLEFT', 25, -100)

	ABT_NS.newspell_click = function()
		_G['obicon0'].value = nil
		--_G['obipresets']:Show()
		_G["obicon1"]:SetText("")
		_G["obisearchtt"]:SetChecked(false)
		_G["obishowdmg"]:SetValue(0)
		_G["obicon2"]:SetText("")
		_G['obitarget']:SetValue(1)  		
		_G["obicon4"]:SetChecked(false)
		_G["obinotmine"]:SetChecked(false)
		_G["obicon5"]:SetChecked(false)
		_G["obicon6"]:SetChecked(false)
		_G["obicon8"]:SetValue(0)
		_G["obicon9"]:Disable()
		_G["obicon11"]:Hide()
		_G['obiedef']:SetValue(0)
		_G['obictoom']:SetValue(-1)
		_G['obispos']:SetValue(1)
		_G['obifontsize']:SetValue(11)
		_G['obifontstyle']:SetValue(1)
		_G['obifontcolor'].fontr = 0
		_G['obifontcolor'].fontg = 1
		_G['obifontcolor'].fontb = 0
		_G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
		example_update()
		_G["obicon0"]:Hide()
		_G["obicon1"]:Show()
	end
	function spelldd.Initialize()
		local function Button_OnClick(self)
			UIDropDownMenu_SetSelectedValue(spelldd, self.value)
			spelldd.value = self.value
			--_G['obipresets']:Hide()
			_G["obicon1"]:SetText(self.value or " ")
			_G["obisearchtt"]:SetChecked(ABT_spelldb[self.value]["SEARCHTT"] or false)
			_G['obishowdmg']:SetValue(ABT_spelldb[self.value]["SHOWDMG"] or 0)
			_G["obicon2"]:SetText(ABT_spelldb[self.value]["Buff"] or " ")
			_G["obitarget"]:SetValue(ABT_spelldb[self.value]["TARGET"] or 1)
			_G["obicon4"]:SetChecked(ABT_spelldb[self.value]["Debuff"] or false)
			_G["obinotmine"]:SetChecked(ABT_spelldb[self.value]["NOTMINE"] or false)
			_G["obicon5"]:SetChecked(ABT_spelldb[self.value]["NoTime"] or false)
			_G["obicon6"]:SetChecked(ABT_spelldb[self.value]["Stack"] or false)
			_G["obicon8"]:SetValue(ABT_spelldb[self.value]["CP"] or 0)
			_G['obiedef']:SetValue(ABT_spelldb[self.value]["EDEF"] or 0)
			_G['obictoom']:SetValue(ABT_spelldb[self.value]["CTOOM"] or -1)
			_G["obicon11"]:SetText(ABT_NS.del1)
			_G["obicon11"]:Show()
			_G["obispos"]:SetValue(ABT_spelldb[self.value]["SPOS"] or 1)
			_G["obifontsize"]:SetValue(ABT_spelldb[self.value]["FONTSIZE"] or 11)
			_G["obifontstyle"]:SetValue(ABT_spelldb[self.value]["FONTSTYLE"] or 1)
			_G['obifontcolor'].fontr = ABT_spelldb[self.value]["FONTCOLR"] or 0
			_G['obifontcolor'].fontg = ABT_spelldb[self.value]["FONTCOLG"] or 1
			_G['obifontcolor'].fontb = ABT_spelldb[self.value]["FONTCOLB"] or 0
			_G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
			example_update()
			_G["obicon0"]:Hide()
			_G["obicon1"]:Show()
		end
	  local items = {}
	  if ABT_spelldb then
  	for spell in pairs(ABT_spelldb) do
  		items.text = spell
  		items.func = Button_OnClick
  		items.value = spell
  		items.checked = false
  		UIDropDownMenu_AddButton(items)
  	end
  	end
		items.text = "New ActionButtonText"
 		items.func = ABT_NS.newspell_click
 		items.value = "New ActionButtonText"
 		items.checked = false
  	UIDropDownMenu_AddButton(items)
  end

  local about = CreateFrame('SimpleHTML',"obiconfigtext",spelldd)
  about:SetFontObject('P' ,GameFontHighlightSmall)
  about:SetFontObject('H1',GameFontHighlightLarge)
  about:SetFontObject('H2',GameFontHighlight)
  about:SetPoint("TOPLEFT",spelldd,"BOTTOMLEFT",25,-15)
  about:SetPoint("TOPRIGHT",ABT_NS.configpanel,"TOPRIGHT",-40,15)
  about:SetPoint("BOTTOM",ABT_NS.configpanel,"BOTTOM",-5)
  about:SetWidth(500)
  about:SetHeight(40)
  about:SetText(ABT_NS.configtext)
  about:Show()

	local function spell_change(self)
	  self:SetText(strupper(self:GetText()))
    _G["obicon9"]:Enable()
    self.error:SetText("")
	  newtext = self:GetText()
	  if newtext ~= _G['obicon0'].value then
      if ABT_spelldb and ABT_spelldb[newtext] then
        _G["obicon9"]:Disable()
        self.error:SetText(ABT_NS.err1)
      else
      end  
	  end
	  if self:GetText() == "" then
      _G["obicon9"]:Disable()
      self.error:SetText(ABT_NS.err2)
    end
    example_update()
	end
	
	local function ShowTip(self)
    ABT_configtooltip:SetOwner(WorldFrame, "ANCHOR_NONE") -- without this, tooltip can fail 'randomly'
    ABT_configtooltip:ClearLines()
	  ABT_configtooltip:SetText(ABT_NS.tips[self:GetName()] or "")
	  ABT_configtooltip:SetPoint("BOTTOMLEFT",self,"TOPLEFT",10,10)
	  ABT_configtooltip:Show()
	end
	
  local function HideTip()
    ABT_configtooltip:Hide()
  end

	local spellnm = CreateFrame('Editbox', "obicon1" , ABT_NS.configpanel,"InputBoxTemplate")
	spellnm:SetAutoFocus(nil)
  spellnm:SetWidth(180)
  spellnm:SetHeight(32)
  spellnm:SetFontObject('GameFontHighlightSmall')
	spellnm:SetPoint('TOPLEFT', spelldd, 'TOPLEFT', 21, -10)
	spellnm:SetScript('OnTextChanged',spell_change)
	local text = spellnm:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', spellnm, 'TOPLEFT', 0, -5)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(ABT_NS.con1)
	local text2 = spellnm:CreateFontString(nil, 'BACKGROUND')
	text2:SetPoint('TOPLEFT', spellnm, 'BOTTOMLEFT', 0, 5)
	text2:SetFontObject('GameFontNormal')
	text2:SetTextColor(1,0,0)
	text2:SetText("")
	spellnm.error = text2
  spellnm:Hide()

	local text = spellnm:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', spellnm, 'TOPLEFT', -20, 30)
  text:SetFont(GameFontNormal:GetFont(),16, "OUTLINE")
  text:SetTextColor(0,1,0) 
	text:SetText(ABT_NS.hint1)

	local searchtt = CreateFrame('CheckButton', "obisearchtt" , spellnm ,"UICheckButtonTemplate")
	_G[searchtt:GetName() .. 'Text']:SetText(ABT_NS.searchtt)
	searchtt:SetPoint('TOPLEFT', spellnm, 'TOPRIGHT', 0,0)


  local presets = CreateFrame('Frame', "obipresets" , spellnm, 'UIDropDownMenuTemplate')
	local text = presets:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', presets, 'TOPLEFT', 21, 0)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(ABT_NS.choose)
	presets:SetScript('OnShow', Dropdown_OnShow)
	presets:SetPoint('TOPLEFT', spellnm, "TOPRIGHT",130,0)
	presets:Hide()

	function presets.Initialize()
		local function Button_OnClick(self)
			UIDropDownMenu_SetSelectedValue(presets, self.value)
			presets.value = self.value
			spell = self.value
			preset = ABT_NS.examples[spell]
			_G["obicon1"]:SetText(spell)
			_G["obisearchtt"]:SetChecked(preset["SEARCHTT"] or false)
			_G["obishowdmg"]:SetValue(preset["SHOWDMG"] or 0)
			_G["obicon2"]:SetText(preset["Buff"] or " ")
			_G["obitarget"]:SetValue(preset["TARGET"] or 1)
			_G["obicon4"]:SetChecked(preset["Debuff"] or false)
			_G["obinotmine"]:SetChecked(preset["NOTMINE"] or false)
			_G["obicon5"]:SetChecked(preset["NoTime"] or false)
			_G["obicon6"]:SetChecked(preset["Stack"] or false)
			_G["obicon8"]:SetValue(preset["CP"] or 0)
			_G['obiedef']:SetValue(preset["EDEF"] or 0)
			_G['obictoom']:SetValue(preset["CTOOM"] or -1)
			_G["obicon11"]:SetText(ABT_NS.del1)
			_G["obifontsize"]:SetValue(preset["FONTSIZE"] or 11)
			_G["obifontstyle"]:SetValue(preset["FONTSTYLE"] or 1)
			_G['obifontcolor'].fontr = preset["FONTCOLR"] or 0
			_G['obifontcolor'].fontg = preset["FONTCOLG"] or 1
			_G['obifontcolor'].fontb = preset["FONTCOLB"] or 0
			_G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
			example_update()
		end
	  local items = {}
    for spell in pairs(ABT_NS.examples) do
      _,_,items.text = strfind(spell,"(.*)#")
  		items.func = Button_OnClick
  		items.value = spell
     	items.checked = false
   	  UIDropDownMenu_AddButton(items)
  	 end
  end

  local function showdmg_change(self)
    example_update()
  end

  local showdmg = CreateFrame('Slider',"obishowdmg", spellnm,"OptionsSliderTemplate")
  showdmg:SetWidth(90)
  showdmg:SetMinMaxValues(0,1)
  showdmg:SetValueStep(1)
	_G[showdmg:GetName() .. 'Text']:SetText(ABT_NS.showdmg)
	_G[showdmg:GetName() .. 'Low']:SetText("No")
	_G[showdmg:GetName() .. 'High']:SetText("Yes")
	showdmg:SetPoint('TOPLEFT', spellnm, 'BOTTOMLEFT', 0, -50)
	showdmg:SetScript('OnValueChanged',showdmg_change)
	
	relto = showdmg

	local text = showdmg:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', showdmg, 'TOPLEFT', -20, 35)
  text:SetFont(GameFontNormal:GetFont(),16, "OUTLINE")
  text:SetTextColor(0,1,0) 
	text:SetText(ABT_NS.hint2)

  local function ctoom_change(self)
    val = self:GetValue()
    txt = ""
    if val == -1 then
      txt = "No"
    elseif val == 0 then
      txt = "Yes"
    else
      txt = "when " .. val .. " or less"
    end
    self.valtext:SetText(txt)
    example_update()
  end

  local ctoom = CreateFrame('Slider',"obictoom", spellnm,"OptionsSliderTemplate")
  ctoom:SetWidth(130)
  ctoom:SetMinMaxValues(-1,9)
  ctoom:SetValueStep(1)
	_G[ctoom:GetName() .. 'Text']:SetText(ABT_NS.ctoom)
	_G[ctoom:GetName() .. 'Low']:SetText("")
	_G[ctoom:GetName() .. 'High']:SetText("")
	ctoom:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
	ctoom:SetScript('OnValueChanged',ctoom_change)
	local text = ctoom:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', ctoom, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	ctoom.valtext = text
	if strfind("WARRIOR:DEATHKNIGHT:ROGUE",ABT_NS.class) then
    ctoom:Hide()
  else
    relto = ctoom
  end 

  local function combo_change(self)
    vals = ABT_NS.combovals
    if self:GetValue() then
    self.valtext:SetText(vals[self:GetValue()+1])
    example_update()
    end
  end

  local combop = CreateFrame('Slider',"obicon8", spellnm,"OptionsSliderTemplate")
  combop:SetWidth(90)
  combop:SetMinMaxValues(0,2)
  combop:SetValueStep(1)
	_G[combop:GetName() .. 'Text']:SetText(ABT_NS.con8)
	_G[combop:GetName() .. 'Low']:SetText("")
	_G[combop:GetName() .. 'High']:SetText("")
	combop:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
	combop:SetScript('OnValueChanged',combo_change)
	local text = combop:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', combop, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	combop.valtext = text
	if not strfind("DRUID:ROGUE",ABT_NS.class) then
    combop:Hide()
  else
    relto = combop
  end 

  local function edef_change(self)
    vals = ABT_NS.edefvals
    if self:GetValue() then
    self.valtext:SetText(vals[self:GetValue()+1])
    example_update()
    end
  end

  local edef = CreateFrame('Slider',"obiedef", spellnm,"OptionsSliderTemplate")
  edef:SetWidth(110)
  edef:SetMinMaxValues(0,2)
  edef:SetValueStep(1)
	_G[edef:GetName() .. 'Text']:SetText(ABT_NS.edef)
	_G[edef:GetName() .. 'Low']:SetText("")
	_G[edef:GetName() .. 'High']:SetText("")
	edef:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
	edef:SetScript('OnValueChanged',edef_change)
	local text = edef:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', edef, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	edef.valtext = text
	if not strfind("DEATHKNIGHT:DRUID:ROGUE",ABT_NS.class) then
    edef:Hide()
  end 


	local buffnm = CreateFrame('Editbox', "obicon2" , spellnm,"InputBoxTemplate")
	buffnm:SetAutoFocus(nil)
  buffnm:SetWidth(200)
  buffnm:SetHeight(32)
  buffnm:SetFontObject('GameFontHighlightSmall')
	buffnm:SetPoint('TOPLEFT', showdmg, 'BOTTOMLEFT', 0, -55)
	buffnm:SetScript('OnTextChanged',function(self) self:SetText(strupper(self:GetText())) end)
	local text = buffnm:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', buffnm, 'TOPLEFT', 0, -5)
	text:SetFontObject('GameFontNormalSmall')
	text:SetText(ABT_NS.con2)

	local text = showdmg:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', buffnm, 'TOPLEFT', -20, 30)
  text:SetFont(GameFontNormal:GetFont(),16, "OUTLINE")
  text:SetTextColor(0,1,0) 
	text:SetText(ABT_NS.hint3)

	local isdebuff = CreateFrame('CheckButton', "obicon4" , spellnm,"UICheckButtonTemplate")
	_G[isdebuff:GetName() .. 'Text']:SetText(ABT_NS.con4)
	isdebuff:SetPoint('TOPLEFT', buffnm, 'TOPRIGHT', 0,0)

	local notmine = CreateFrame('CheckButton', "obinotmine" , isdebuff,"UICheckButtonTemplate")
	_G[notmine:GetName() .. 'Text']:SetText(ABT_NS.notmine)
	notmine:SetPoint('LEFT', obicon4Text, 'RIGHT', 0,0)

  local function target_change(self)
    vals = ABT_NS.targetvals
    if self:GetValue() then
    self.valtext:SetText(vals[self:GetValue()])
    example_update()
    end
  end

  local target = CreateFrame('Slider',"obitarget", spellnm,"OptionsSliderTemplate")
  target:SetWidth(80)
  target:SetMinMaxValues(1,3)
  target:SetValueStep(1)
	_G[target:GetName() .. 'Text']:SetText("")
	_G[target:GetName() .. 'Low']:SetText("")
	_G[target:GetName() .. 'High']:SetText("")
	target:SetPoint('TOPLEFT', notmine, 'TOPRIGHT', 60, 0)
	target:SetScript('OnValueChanged',target_change)
	local text = target:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', target, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	target.valtext = text
	
	local notime = CreateFrame('CheckButton', "obicon5" , spellnm, "UICheckButtonTemplate")
	_G[notime:GetName() .. 'Text']:SetText(ABT_NS.con5)
	notime:SetPoint('TOPLEFT', isdebuff, 'BOTTOMLEFT', 0, 10)
	notime:SetScript("OnClick", function(self) example_update() end)

	local stack = CreateFrame('CheckButton', "obicon6" , spellnm,"UICheckButtonTemplate")
	_G[stack:GetName() .. 'Text']:SetText(ABT_NS.con6)
	stack:SetPoint('TOPLEFT', notime, 'TOPRIGHT', 70 ,0)
	stack:SetScript("OnClick", function(self) example_update() end)

  local function spos_change(self)
    vals = ABT_NS.sposvals
    if self:GetValue() then
    self.valtext:SetText(vals[self:GetValue()])
    example_update()
    end
  end

  local spos = CreateFrame('Slider',"obispos", spellnm,"OptionsSliderTemplate")
  spos:SetWidth(70)
  spos:SetMinMaxValues(1,3)
  spos:SetValueStep(1)
	_G[spos:GetName() .. 'Text']:SetText(ABT_NS.spos)
	_G[spos:GetName() .. 'Low']:SetText("")
	_G[spos:GetName() .. 'High']:SetText("")
	spos:SetPoint('TOPLEFT', buffnm, 'BOTTOMLEFT', 0, -60)
	spos:SetScript('OnValueChanged',spos_change)
	local text = spos:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', spos, 'CENTER', 0, -10)
	text:SetFontObject('GameFontNormalSmall')
	spos.valtext = text

	local text = spos:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('TOPLEFT', spos, 'TOPLEFT', -20, 35)
  text:SetFont(GameFontNormal:GetFont(),16, "OUTLINE")
  text:SetTextColor(0,1,0) 
	text:SetText(ABT_NS.hint4)

  local function fontsize_change(self)
    self.valtext:SetText(self:GetValue())
    example_update()
  end

  local fontsize = CreateFrame('Slider',"obifontsize", spellnm,"OptionsSliderTemplate")
  fontsize:SetWidth(80)
  fontsize:SetMinMaxValues(8,26)
  fontsize:SetValueStep(1)
	_G[fontsize:GetName() .. 'Text']:SetText(ABT_NS.fontsize)
	_G[fontsize:GetName() .. 'Low']:SetText("8")
	_G[fontsize:GetName() .. 'High']:SetText("26")
	fontsize:SetPoint('TOPLEFT', spos, 'TOPRIGHT', 20, 0)
	fontsize:SetScript('OnValueChanged',fontsize_change)
	local text = fontsize:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', fontsize, 'CENTER', 0, -20)
	text:SetFontObject('GameFontNormalSmall')
	fontsize.valtext = text

  local function fontstyle_change(self)
    vals = ABT_NS.fontstylevals
    if self:GetValue() then
      self.valtext:SetText(vals[self:GetValue()])
    example_update()
    end
  end

  local fontstyle = CreateFrame('Slider',"obifontstyle", spellnm,"OptionsSliderTemplate")
  fontstyle:SetWidth(90)
  fontstyle:SetMinMaxValues(0,2)
  fontstyle:SetValueStep(1)
	_G[fontstyle:GetName() .. 'Text']:SetText(ABT_NS.fontstyle)
	_G[fontstyle:GetName() .. 'Low']:SetText("")
	_G[fontstyle:GetName() .. 'High']:SetText("")
	fontstyle:SetPoint('TOPLEFT', fontsize, 'TOPRIGHT', 20, 0)
	fontstyle:SetScript('OnValueChanged',fontstyle_change)
	local text = fontstyle:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', fontstyle, 'CENTER', 0, -20)
	text:SetFontObject('GameFontNormalSmall')
	fontstyle.valtext = text
  
	local function getcolor(fontcolor)
	  local function okfunc()
	    r,g,b = ColorPickerFrame:GetColorRGB()
	    fontcolor.fontr = r
	    fontcolor.fontg = g
	    fontcolor.fontb = b
	    fontcolor.bg:SetTexture(r,g,b)
	    example_update()
	  end
	  local function cancelfunc()
	    r,g,b = ColorPickerFrame.prevr,ColorPickerFrame.prevg,ColorPickerFrame.prevb
	    fontcolor.fontr = r
	    fontcolor.fontg = g
	    fontcolor.fontb = b
	    fontcolor.bg:SetTexture(r,g,b)
	    example_update()
    end	  
	  ColorPickerFrame.func = okfunc
	  ColorPickerFrame.cancelFunc = cancelfunc
	  ColorPickerFrame.prevr = fontcolor.fontr
	  ColorPickerFrame.prevg = fontcolor.fontg
	  ColorPickerFrame.prevb = fontcolor.fontb
	  ColorPickerFrame:SetColorRGB(fontcolor.fontr,fontcolor.fontg,fontcolor.fontb)
	  ColorPickerFrame.opacity = 1
	  ColorPickerFrame:Show()
	end

	local fontcolor = CreateFrame('Button','obifontcolor',spellnm)
	fontcolor:SetPoint('TOPLEFT', fontstyle, "TOPRIGHT", 20, 0)
	fontcolor:SetWidth(20)
	fontcolor:SetHeight(20)
	--fontcolor:SetNormalTexture('Interface/ChatFrame/ChatFrameColorSwatch')
  local bg = fontcolor:CreateTexture(nil, 'BACKGROUND')
	bg:SetWidth(20); bg:SetHeight(20)
	bg:SetPoint('CENTER')
	fontcolor.bg = bg
	fontcolor:SetScript('OnClick', getcolor)

  local testbutton = CreateFrame('CheckButton',"obiexample", spellnm, "ActionBarButtonTemplate")
  testbutton:SetWidth(36)
  testbutton:SetHeight(36)
  testbutton:Disable()
  testbutton:SetPoint("TOPLEFT",fontcolor,50,10);
  
	local function cancel_click()
	  _G['obicon1'].error:SetText("")
	  _G['obicon1']:Hide()
	  _G['obicon0']:Show()
  end

	local function save_click()
	  -- actually save things in here
	  to,from = _G['obicon1']:GetText() , _G['obicon0'].value
	  if from ~= to then
	    if not ABT_spelldb then
	      ABT_spelldb = {}
	    end
      ABT_spelldb[to] = {}
      if from then
        for val in pairs(ABT_spelldb[from]) do
          ABT_spelldb[to][val] = ABT_spelldb[from][val]
        end
        ABT_spelldb[from] = nil
      end
      spelldd.Initialize()
    end
    local function blanktonil(val)
      if not val or strfind(val,"^ *$") then -- string is either "" or all spaces
        return nil
      else
        return val
      end
    end
    local function falsetonil(val)
      if val and val == 1 then
        return true
      else
        return nil
      end
    end
    
    local function nilif(val,limit)
      if val == limit then
        return nil
      else
        return val
      end
    end
    
    ABT_spelldb[to]["SEARCHTT"] = falsetonil(_G['obisearchtt']:GetChecked())
    ABT_spelldb[to]["SHOWDMG"] = nilif(_G['obishowdmg']:GetValue(),0)
    ABT_spelldb[to]["Buff"] = blanktonil(_G['obicon2']:GetText())
    ABT_spelldb[to]["TARGET"] = nilif(_G['obitarget']:GetValue(),1)
    ABT_spelldb[to]["Debuff"] = falsetonil(_G['obicon4']:GetChecked())
    ABT_spelldb[to]["NOTMINE"] = falsetonil(_G['obinotmine']:GetChecked())
    ABT_spelldb[to]["NoTime"] = falsetonil(_G['obicon5']:GetChecked())
    ABT_spelldb[to]["Stack"] = falsetonil(_G['obicon6']:GetChecked())
    ABT_spelldb[to]["SPOS"] = nilif(_G['obispos']:GetValue(),1)
    ABT_spelldb[to]["FONTSIZE"] = nilif(_G['obifontsize']:GetValue(),11)
    ABT_spelldb[to]["FONTSTYLE"] = nilif(_G['obifontstyle']:GetValue(),1)
    ABT_spelldb[to]["FONTCOLR"] = nilif(_G['obifontcolor'].fontr,0)
    ABT_spelldb[to]["FONTCOLG"] = nilif(_G['obifontcolor'].fontg,1)
    ABT_spelldb[to]["FONTCOLB"] = nilif(_G['obifontcolor'].fontb,0)
    ABT_spelldb[to]["CP"] = nilif(_G['obicon8']:GetValue(),0)
    ABT_spelldb[to]["EDEF"] = nilif(_G['obiedef']:GetValue(),0)
    ABT_spelldb[to]["CTOOM"] = nilif(_G['obictoom']:GetValue(),-1)
	  cancel_click()
	end

	local function delete_click(self)
	  btntext = self:GetText()
	  if btntext == ABT_NS.del1 then
	    self:SetText(ABT_NS.del2)
	  elseif btntext == ABT_NS.del2 then
	    self:SetText(ABT_NS.del3)
	  elseif btntext == ABT_NS.del3 then
	    -- actually delete things in here
	    ABT_spelldb[_G['obicon0'].value] = nil
	    cancel_click()
	  end
	end

  local savec = CreateFrame('Button',"obicon9", spellnm,"UIPanelButtonTemplate")
  savec:SetWidth(120)
  savec:SetHeight(20)
	savec:SetPoint('BOTTOMLEFT', ABT_NS.configpanel, 'BOTTOMLEFT', 30, 20)
	savec:SetText(ABT_NS.con9)
	savec:SetScript("OnClick", save_click)

  local cancelc = CreateFrame('Button',"obicon10", spellnm,"UIPanelButtonTemplate")
  cancelc:SetWidth(120)
  cancelc:SetHeight(20)
	cancelc:SetPoint('TOPLEFT', savec, 'TOPRIGHT', 20, 0)
	cancelc:SetText(ABT_NS.con10)
	cancelc:SetScript("OnClick", cancel_click)

  local deleteb = CreateFrame('Button',"obicon11", spellnm,"UIPanelButtonTemplate")
  deleteb:SetWidth(200)
  deleteb:SetHeight(20)
	deleteb:SetPoint('TOPLEFT', cancelc, 'TOPRIGHT', 80, 0)
	deleteb:SetScript("OnClick", delete_click)

  local widgets = {_G['obicon1'],_G['obicon1']:GetChildren()}
  for _,id in ipairs(widgets) do
    id:SetScript('OnEnter',ShowTip)
	  id:SetScript('OnLeave',HideTip)
	end

  local titleRegion = ABT_NS.configpanel:CreateTitleRegion();
  titleRegion:SetWidth(525);
  titleRegion:SetHeight(20);
  titleRegion:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 50, -10);
  
  local texture = ABT_NS.configpanel:CreateTexture(nil, "BACKGROUND");
  texture:SetTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon");
  texture:SetWidth(64);
  texture:SetHeight(64); 
  texture:SetPoint("TOPLEFT", ABT_NS.configpanel, "TOPLEFT", 8, 1);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
  texture:SetWidth(256);
  texture:SetHeight(256);
  texture:SetPoint("TOPLEFT");
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
  texture:SetWidth(128);
  texture:SetHeight(256);
  texture:SetPoint("TOPLEFT", ABT_NS.configpanel, "TOPLEFT", 256, 0);
  texture:SetTexCoord(0.38, 0.88, 0, 1);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
  texture:SetWidth(128);
  texture:SetHeight(256);
  texture:SetPoint("TOPLEFT", ABT_NS.configpanel, "TOPLEFT", 384, 0);
  texture:SetTexCoord(0.45, 0.95, 0, 1);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
  texture:SetWidth(100);
  texture:SetHeight(256);
  texture:SetPoint("TOPRIGHT");
  texture:SetTexCoord(0, 0.78125, 0, 1);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft");
  texture:SetWidth(256);
  texture:SetHeight(184);
  texture:SetPoint("BOTTOMLEFT");
  texture:SetTexCoord(0, 1, 0, 0.71875);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft");
  texture:SetWidth(128);
  texture:SetHeight(184);
  texture:SetPoint("BOTTOMLEFT", ABT_NS.configpanel, "BOTTOMLEFT", 256, 0);
  texture:SetTexCoord(0.5, 1, 0, 0.71875);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft");
  texture:SetWidth(128);
  texture:SetHeight(184);
  texture:SetPoint("BOTTOMLEFT", ABT_NS.configpanel, "BOTTOMLEFT", 384, 0);
  texture:SetTexCoord(0.5, 1, 0, 0.71875);
  
  texture = ABT_NS.configpanel:CreateTexture(nil, "ARTWORK");
  texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight");
  texture:SetWidth(100);
  texture:SetHeight(184);
  texture:SetPoint("BOTTOMRIGHT");
  texture:SetTexCoord(0, 0.78125, 0, 0.71875);
  
  local fontString = ABT_NS.configpanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
  fontString:SetText("ActionButtonText - Configuratron!");
  fontString:SetPoint("TOP", ABT_NS.configpanel, "TOP", 0, -18);
  
  local frame = CreateFrame("Button", nil, ABT_NS.configpanel, "UIPanelCloseButton");
  frame:SetPoint("TOPRIGHT", ABT_NS.configpanel, "TOPRIGHT", -3, -8);

  table.insert(UISpecialFrames, ABT_NS.configpanel:GetName()) -- closes window on [ESCAPE]
	ABT_NS.configpanel:Hide()
	
end
