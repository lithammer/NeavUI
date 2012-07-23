local _, addon = ... -- namespace
local ABT_abouttext = '<HTML><BODY>\
<H1>|cff00ff00ActionButtonText (1.02)|r</H1>\
<H2>Created by &lt;Damage Inc&gt; of (EU)Draenor</H2>\
<P>EMail: damageinc@theedgeofthevoid.com</P>\
<BR/>\
<H1>|cffffff00Presets|r</H1>\
</BODY></HTML>'

function addon.prehash(name)
	if string.find(name,'#') then
		return name
	else
		return '#' .. name
	end
end

function addon.optclick(self)
	local to = 'PRESET' .. addon.prehash(self.spellname)

	if self:GetChecked() then
		if not ABT_SpellDB then
			ABT_SpellDB = {}
		end
		ABT_SpellDB[to] = {}
		for name,val in pairs(addon.presets[self.classname][self.spellname]) do
			ABT_SpellDB[to][name] = val
		end
	else
		ABT_SpellDB[to] = nil
	end
end

function addon.addopt(n,class,spellname,text)
	local optbtn = CreateFrame('CheckButton', 'obiopt'..n , _G['obiabout'], 'UICheckButtonTemplate')
	_G[optbtn:GetName() .. 'Text']:SetText(text)
	_G[optbtn:GetName() .. 'Text']:SetWidth(400)
	_G[optbtn:GetName() .. 'Text']:SetHeight(30)
	_G[optbtn:GetName() .. 'Text']:SetJustifyH('LEFT')
	optbtn:SetPoint('TOPLEFT', _G['obiabout'], 'BOTTOMLEFT', 0, -30 * (n - 1) + -40)
	optbtn.classname = class
	optbtn.spellname = spellname
	optbtn:SetScript('OnClick',addon.optclick)

	if ABT_SpellDB and ABT_SpellDB['PRESET'..addon.prehash(spellname)] then
		optbtn:SetChecked(true)
	end
end

function addon.optshow()
	local x = 1
	local optb = _G['obiopt'..x]

	while optb do
		if ABT_SpellDB and ABT_SpellDB['PRESET'..addon.prehash(optb.spellname)] then
			optb:SetChecked(true)
		else
			optb:SetChecked(false)
		end

		x = x + 1
		optb = _G['obiopt'..x]
	end
end

function addon.OptionsInit()
	local ABT_optionspanel = CreateFrame('Frame', 'OBIOptions', UIParent)
	ABT_optionspanel.name = 'ActionButtonText'
	ABT_optionspanel:SetScript('OnShow', addon.optshow)
	InterfaceOptions_AddCategory(ABT_optionspanel)

	local scroll0 = CreateFrame('ScrollFrame', 'obiscr0', ABT_optionspanel)
	scroll0:SetPoint('TOPLEFT', ABT_optionspanel, 'TOPLEFT', 15, -15)
	scroll0:SetPoint('TOPRIGHT', ABT_optionspanel, 'TOPRIGHT', -40, 15)
	scroll0:SetPoint('BOTTOM', ABT_optionspanel, 'BOTTOM', -5)
	local about = CreateFrame('SimpleHTML', 'obiabout', scroll0)
	about:SetFontObject('P', GameFontHighlightSmall)
	about:SetFontObject('H1', GameFontHighlightLarge)
	about:SetFontObject('H2', GameFontHighlight)
	about:SetWidth(360)
	about:SetHeight(40)
	about:SetText(ABT_abouttext)
	about:Show()
	scroll0:SetScrollChild(about)

	local x = 1
	for class in pairs(addon.presets) do
		if class == 'ALL' or class == select(2,UnitClass('PLAYER')) or class == select(2,UnitRace('PLAYER')) then 
			for spell in pairs(addon.presets[class]) do
				addon.addopt(x,class,spell,addon.presets[class][spell]['DESC'] or spell)
				x = x + 1
			end
		end
	end

	local savec = CreateFrame('Button','obiconfig', ABT_optionspanel, 'UIPanelButtonTemplate')
	savec:SetWidth(220)
	savec:SetHeight(20)
	savec:SetPoint('BOTTOMLEFT', ABT_optionspanel, 'BOTTOMLEFT', 20, 20)
	savec:SetText(addon.opt1)

	savec:SetScript('OnClick', function()
		InterfaceOptionsFrameCancel_OnClick()
		addon.configpanel:Show()
	end)

	savec:Show()
end
