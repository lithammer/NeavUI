local _, addon = ...

addon.API = {}

-- ActionButtonText
--
-- Credit to Gagorian for his addon DrDamage
-- His code for finding and adding text to actionbuttons (Blizzard AND addon-based) was ENORMOUSLY helpful
--
-- Credit to Mikk for MSBT - the MSBTOptions frame creation code is used as-is for the Configuratron
--
-- My thanks go to both authors for granting permission to use their code...

local format = string.format
local find = string.find
local upper = string.upper

local lastButtonUpdate = 0

local updateInterval = 0.9
local showDamageInterval = 5

local playerName = UnitName('player')

local attackInfo = {}
local tooltipDB = {}

local RelativePosition = {'BOTTOM','','TOP'}

local buttonPrefix = nil
local buttonCooldown = 'Cooldown'

local clearcasting = false

local defaultBars = {
	'ActionButton',
	'MultiBarBottomLeftButton',
	'MultiBarBottomRightButton',
	'MultiBarRightButton',
	'MultiBarLeftButton',
	'BonusActionButton'
}

function addon.SetText(button, id, text, fontSize, ol)
	local buttonText = _G[button:GetName()..'ob'..id]

	if not buttonText and text ~= '' then
		local f = CreateFrame('Frame')
		f:SetParent(button)

		local plevel = button:GetFrameLevel()
		local pstrata = button:GetFrameStrata()
		f:SetFrameStrata(pstrata)
		f:SetFrameLevel(plevel + 1)

		local ob = f:CreateFontString(button:GetName() .. 'ob' .. id, 'OVERLAY')
		if (id == 1) then
			ob:SetPoint(RelativePosition[id]..'LEFT', button, RelativePosition[id]..'LEFT', -10, -(2*id))
			ob:SetPoint(RelativePosition[id]..'RIGHT', button, RelativePosition[id]..'RIGHT', 10 , -(2*id))
		else
			ob:SetPoint(RelativePosition[id]..'LEFT', button, RelativePosition[id]..'LEFT', -10, 18-(2*id))
			ob:SetPoint(RelativePosition[id]..'RIGHT', button, RelativePosition[id]..'RIGHT', 10 ,18-(2*id))
		end

		ob:SetJustifyH('CENTER')
		ob:Show()

		buttonText = ob
	end

	if buttonText then
		buttonText:SetFont('Fonts\\ARIALN.ttf', fontSize or 16, 'OUTLINE')
		buttonText:SetText(text)
	end
end

function addon.NeedSlash(val, val2)
	if val and val ~= '' and val2 and val2 ~= '' then
		return val .. '/' .. val2
	elseif val and val ~= '' then
		return val
	else
		return val2
	end
end

local function Search(f1, f2)
	local _, _, pf2, rf2 = find(f2..'~', '^([^~]*)~(.*)$')

	while pf2 or rf2 do
		if pf2 and pf2 ~= '' then
			if find(f1, pf2) then
				return true
			end
		end

		_, _, pf2, rf2 = find(rf2, '^([^~]*)~(.*)$')
	end

	return false
end

local function Aura(unit, aura, func)
	local name, _, _, stack, _, _, timeLeft, caster = func(unit, aura)
	return name, (timeLeft or 0) - GetTime(), stack or 0, caster
end

local function CheckBuff(buffName, isDebuff, unit, notMine)
	local func = isDebuff and UnitDebuff or UnitBuff

	if UnitExists(unit) then
		local name, timeLeft, stack, caster = Aura(unit, buffName, func)

		if not name then
			return 0, 0
		end

		if caster == 'player' or notMine and name == buffName or Search(upper(name), upper(buffName)) then
			return timeLeft, stack
		end
	end

	return 0, 0
end

local function TimeToMinutes(time)
	local mins = ceil(time / 60)

	if mins > 1 then
		return mins..'m'
	else
		return floor(time)
	end
end

local function GetObi(spellName, spellTable)
	local fontSize = spellTable['FONTSIZE'] or 11
	local spellPosition = spellTable['SPOS'] or 1
	local fontStyle = spellTable['FONTSTYLE'] or 1
	local buffName = spellTable['Buff'] or spellName
	local debuff = spellTable['Debuff']
	local unit = addon.targetValues[spellTable['TARGET']] or 'PLAYER'
	local text = ''
	local name, rank, icon, cost, isfunnel, powertype

	local timeleft, charges = CheckBuff(buffName, debuff, unit, spellTable['NOTMINE'])

	if (spellTable['NoTime'] or false) == false then
		if timeleft and timeleft > 0 then
			text = addon.NeedSlash(text, TimeToMinutes(timeleft))
		end
	end

	if (spellTable['Stack'] or false) == true and charges > 0 then
		text = addon.NeedSlash(text,charges)
	end

	local cp = 0
	cp = GetComboPoints('player', 'target') --WOTLK
	if spellTable['CP'] and cp >= spellTable['CP']-1 and UnitPowerType('PLAYER') == 3 then -- uses energy
		text = addon.NeedSlash(text,cp)
	end

	if (spellTable['SHOWDMG'] or 0) == 1 and attackInfo[spellName] then
		local info, time, crit = attackInfo[spellName][1], attackInfo[spellName][2], attackInfo[spellName][3]

		if info and GetTime() - time < showDamageInterval then
			text = addon.NeedSlash(text, info)

			if crit then
				fontSize = fontSize + 2
			end
		end
	end

	local edef = spellTable['EDEF']
	if edef and (UnitPowerType('player') == 3 or UnitPowerType('player') == 6) then -- uses energy
		name, rank, icon, cost, isfunnel, powertype = GetSpellInfo(spellName)

		if cost and (powertype == 3 or powertype == 6) then
			if clearcasting then
				text = addon.NeedSlash(text, '00')
			elseif cost > 0 then
				def = UnitMana('player') - cost
				if def < 0 then
					if powertype == 3 then
						if edef == 2 then
							def = abs(floor(def / 20))
							text = addon.NeedSlash(text,def)
						else
							def = abs(def)
							text = addon.NeedSlash(text,def)
						end
					else
						if edef == 2 or UnitAffectingCombat('player') then
							def = abs(def)
							text = addon.NeedSlash(text,def)
						end
					end
				end
			end
		end
	end

	local ctoom = spellTable['CTOOM']
	if ctoom and UnitPowerType('player') == 0 then -- uses mana
		name, rank, icon, cost, isfunnel, powertype = GetSpellInfo(spellName)

		if cost and powertype == 0 then
			if clearcasting then
				text = '00'
			elseif cost > 0 then
				casts = floor(UnitMana('player') / cost)

				if ctoom == 0 or casts <= ctoom then
					text = addon.NeedSlash(text, casts)
				end
			end
		end
	end

	if text == '0' then text = ' ' end -- traps 0 CPs
	return text, fontSize, spellPosition, addon.fontStyleValues[fontStyle]
end

function addon.GetText(button,id)
	local buttonText = _G[button:GetName()..'ob'..id]

	if buttonText then
		return buttonText:GetText()
	else
		return ''
	end
end

local GetPagedActionButtonID = nil
local function Setup()
	GetPagedActionButtonID = function(button)
		return ActionButton_GetPagedID(button)
	end

	if IsAddOnLoaded('Bartender4') then
		buttonPrefix = 'BT4Button'
		GetPagedActionButtonID = function(button)
			return button.Secure:GetActionID()
		end
		updateInterval = 0.5 -- quicker due to the 'prowlbar' issue
	end
end

function addon:Combat()
	-- 4.2: timestamp 1, eventType 2, hideCaster 3, sourceGUID 4, sourceName 5, sourceFlags 6, sourceRaidFlags 7, destGUID 8, destName 9, destFlags 10, destRaidFlags 11, spellId 12, spellName 13, spellSchool 14
	if (arg5) and (arg5 == playerName) then
		if arg2 == 'SPELL_DAMAGE' or arg2 == 'SPELL_MISSED' or arg2 == 'SPELL_HEAL' then -- or arg2 == 'SPELL_PERIODIC_DAMAGE'
			if arg13 and arg15 then
				attackInfo[arg10] = {arg14, GetTime(), arg19}
				lastButtonUpdate = 0
			end
		end

		if arg2 == 'SWING_DAMAGE' or arg2 == 'SWING_MISSED' then
			if arg10 then
				attackInfo['Attack'] = {arg10, GetTime(), arg16}
				lastButtonUpdate = 0
			end
		end

		-- Actually has the spellname even tho it's most likely always 'Auto Shot' - identical to SPELL_ in fact
		if arg2 == 'RANGE_DAMAGE' or arg2 == 'RANGE_MISSED' then
			if arg12 and arg14 then
				attackInfo[arg10] = {arg14, GetTime(), arg19}
				lastButtonUpdate = 0
			end
		end
	end

	if (arg9) and (arg9 == playerName) then
		if arg13 == 'Clearcasting' then
			if arg2 == 'SPELL_AURA_APPLIED' then
				clearcasting = true
				lastButtonUpdate = 0
			else
				clearcasting = false
				lastButtonUpdate = 0
			end
		end
	end
end

function addon.ClearText(button)
	for id = 1, 3 do
		local buttonText = _G[button:GetName()..'ob'..id]

		if buttonText then
			buttonText:SetText('')
		end
	end
end

local function ButtonName(i)
	if buttonPrefix then
		return _G[buttonPrefix..i]
	else
		local barn = math.floor((i - 1) / 12)
		local btnn = i - (barn * 12)
		if btnn and barn and defaultBars[barn+1] then
			return _G[defaultBars[barn+1]..btnn]
		else
			return nil
		end
	end
end

function addon:UpdateText()
	for x = 1, 120 do
		local button = ButtonName(x)

		if button and button:IsVisible() then
			self.ClearText(button)

			local action = GetPagedActionButtonID(button, x)
			if action and action ~= '()' then
				local type, id = GetActionInfo(action)

				if type then
					local spellname = nil
					local spellid = nil

					if type == 'spell' and id ~= 0 then
						spellid = id
						spellname = GetSpellInfo(id)
					elseif type == 'macro' then
						ABT_ToolTipScan:SetOwner(WorldFrame, 'ANCHOR_NONE') -- without this, tooltip can fail 'randomly'
						ABT_ToolTipScan:ClearLines()
						ABT_ToolTipScan:SetAction(action)
						spellid = ABT_ToolTipScanTextLeft1:GetText()
						spellname = spellid
					elseif type == 'item' then
						spellid = GetItemInfo(id)
						spellname = spellid
					end

					if spellname then
						if ABT_SpellDB then
							for spell in pairs(ABT_SpellDB) do
								local text = ''
								local spellf, fontSize, spellPosition, fontStyle

								if find(spell, '#') then
								   _, _, spellf = find(spell, '#(.*)')
								else
								  spellf = spell
								end

								local scanTooltip = ABT_SpellDB[spell]['SEARCHTT'] or false

								if scanTooltip then
									if not tooltipDB[spellid] then
										ABT_ToolTipScan:SetOwner(WorldFrame, 'ANCHOR_NONE') -- without this, tooltip can fail 'randomly'
										ABT_ToolTipScan:ClearLines()

										if action then
										  ABT_ToolTipScan:SetAction(action)
										end

										local tiptext = ''
										for i = 1, ABT_ToolTipScan:NumLines() do
											tiptext = tiptext .. upper(_G['ABT_ToolTipScanTextLeft'..i]:GetText() or '')
											tiptext = tiptext .. upper(_G['ABT_ToolTipScanTextRight'..i]:GetText() or '')
										end

										tooltipDB[spellid] = upper(tiptext)
									end

									if tooltipDB[spellid] and Search(tooltipDB[spellid], spellf) then
										text, fontSize, spellPosition, fontStyle = GetObi(spellname, ABT_SpellDB[spell])
									end
								else
									if Search(upper(spellname), spellf) then
										text, fontSize, spellPosition, fontStyle = GetObi(spellname, ABT_SpellDB[spell])
									end
								end

								if text ~= '' then
									self.SetText(button, spellPosition, self.NeedSlash(self.GetText(button, spellPosition),'|cff'..format('%02x%02x%02x', (ABT_SpellDB[spell]['FONTCOLR'] or 0) * 255, (ABT_SpellDB[spell]['FONTCOLG'] or 1) * 255, (ABT_SpellDB[spell]['FONTCOLB'] or 0) * 255) .. text .. '|r'), fontSize, fontStyle)
								end
							end -- loop
						end -- spelldb
					end
				end -- type
			end -- action
		end -- button
	end -- 120 buttons
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('ACTIONBAR_PAGE_CHANGED')
f:RegisterEvent('ACTIONBAR_SLOT_CHANGED')
f:RegisterEvent('ACTIONBAR_HIDEGRID')
f:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
f:RegisterEvent('PLAYER_TARGET_CHANGED')
f:RegisterEvent('PLAYER_AURAS_CHANGED')
f:RegisterEvent('UPDATE_MACROS')
f:RegisterEvent('UNIT_ENERGY')
f:RegisterEvent('RUNE_POWER_UPDATE')
f:RegisterEvent('UNIT_RUNIC_POWER')
f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
f:RegisterEvent('SPELLS_CHANGED')

f:SetScript('OnEvent', function(self, event, arg1)
	if event == 'PLAYER_ENTERING_WORLD' then
		local tt = CreateFrame('GameTooltip', 'ABT_ToolTipScan', UIParent, 'GameTooltipTemplate')

		addon.ConfigInit()
		addon.OptionsInit()
		Setup()

		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	elseif event == 'UNIT_ENERGY' then
		lastButtonUpdate = 0
	elseif (event == 'COMBAT_LOG_EVENT_UNFILTERED') then
		addon:Combat()
	elseif (event == 'SPELLS_CHANGED') then
		tooltipDB = {} -- Reset tooltip database
	else
		-- we can't update here because bar mods haven't refreshed yet
		-- so we defer the update until the next ON_UPDATE event
		lastButtonUpdate = 0
	end
end)

f:SetScript('OnUpdate', function(self, elapsed)
	if GetTime() - lastButtonUpdate > updateInterval then
		addon:UpdateText()
		lastButtonUpdate = GetTime()
	end
end)

SLASH_ABT1 = '/abt'
SlashCmdList['ABT'] = function(opts)
	if UnitAffectingCombat('player') then
		DEFAULT_CHAT_FRAME:AddMessage('Error: /abt is disabled in combat',1,0,0)
	elseif find(upper((opts or '')), 'CONFIG') then
		addon.configpanel:Show()
	elseif find(upper((opts or '')), 'ADD') then
		addon.configpanel:Show()
		addon.newspell_click()
	else
		InterfaceOptionsFrame_OpenToCategory('ActionButtonText')
	end
end
