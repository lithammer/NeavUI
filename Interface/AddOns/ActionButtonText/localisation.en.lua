local _, addon = ... -- namespace

-- English/Default localisation

-- Config
addon.configtext = '<HTML><BODY>\
<H1>|cff00ff00What can the Configuratron! do?|r</H1>\
<H2>|cffffff00Select an existing ActionButtonText from the dropdown (above) to edit it|r</H2>\
<BR/><H2>|cffffff00Select "New ActionButtonText" from the dropdown to create one from scratch|r</H2>\
<BR/><BR/>\
<H1>|cff00ff00Can I edit the Presets?|r</H1>\
<H2>|cffffff00ActionButtonTexts which begin "PRESET" relate to presets on the /abt screen</H2>\
<BR/><H2>|cffffff00You can edit these to change font color/size etc. or just to see how they work|r</H2>\
<BR/><H2>|cffffff00Deselecing and Reselecting a Preset will reset any changes you have made|r</H2>\
</BODY></HTML>'

addon.hint1 = 'Add ActionButtonText to which button(s)'
addon.hint2 = 'What ActionButtonText to show about Spell(s)'
addon.hint3 = 'What ActionButtonText to show about Buff/Debuff(s)'
addon.hint4 = 'How ActionButtonText should look'

addon.err1 = '** Already Exists **'
addon.err2 = '** Cannot be blank **'

addon.con0 = 'Create/Edit ActionButtonText'
addon.con1 = 'Spell/Item/Macro Name'
addon.searchtt = 'Search Tooltip?'
addon.choose = 'Examples'

addon.showdmg = 'Show Hit/Miss?'
addon.ctoom = 'Show Casts until OOM?'
addon.con8 = 'Show CPs?'
addon.combovals = {'No','0 or more','1 or more'}
if addon.class == 'DEATHKNIGHT' then
	addon.edef = 'Show RP Deficit?'
	addon.edefvals = {'No','In Combat','Always'}
else
	addon.edef = 'Show Energy Deficit?'
	addon.edefvals = {'No','As Energy','As Ticks'}
end

addon.con2 = 'Buff Name'
addon.targetValues = {'PLAYER','TARGET','PET'}
addon.con4 = 'Debuff?'
addon.notmine = 'Anyones?'
addon.con5 = 'Hide Time?'
addon.con6 = 'Show Stacks?'

addon.con9 = 'Save Changes'
addon.con10 = 'Cancel Changes'
addon.spos = 'Position'
addon.sposvals = {'Bottom','Middle','Top'}
addon.fontsize = 'Font Size'
addon.fontstyle = 'Font Style'
addon.fontStyleValues = {
	[0] = 'NORMAL',
	[1] = 'OUTLINE',
	[2] = 'THICKOUTLINE'
}

addon.del1 = 'Delete this ActionButtonText'
addon.del2 = 'REALLY Delete it?'
addon.del3 = 'REALLY DELETE ???'

addon.tips = {
	['obicon1'] = 'ActionButtonText will appear where this matches the spell/macro/item name on the button\n|cff00ff00Tip: Can be a partial match e.g. "SEAL OF" or "SHOCK"|r\n\nAny text appearing before # is descriptive and will NOT included in the match\n|cff00ff00Tip: This allows more than one ActionButtonText for the same spell e.g. "DAMAGE#SEAL OF" and "MANA#SEAL OF"',
	['obisearchtt'] = 'If selected, the entire spell/item/macro tooltip will be matched rather than just the name',
	['obishowdmg'] = 'If selected, the last damage/heal or miss (block/parry,dodge) will be shown',
	['obictoom'] = 'If selected, the number of times the spell can be cast with current mana will be shown',
	['obicon8'] = 'If selected, Combo Points on current target will be shown',
	['obicon2'] = 'If this matches an active Buff, the remaining time will be shown\nIf blank, defaults to the spell/item/macro name on the button',
	['obicon4'] = 'If selected, Debuffs will be matched instead of Buffs',
	['obitarget'] = 'Which Unit should be checked for the Buff/Debuff',
	['obicon5'] = 'If selected, the remaining time for the Buff/Debuff will NOT be shown',
	['obicon6'] = 'If selected, Buff/Debuff stacks will be shown',
}
if addon.class == 'DEATHKNIGHT' then
	addon.tips['obiedef'] = 'If selected, Runic Power deficit will be shown'
else
	addon.tips['obiedef'] = 'If selected, Energy deficit will be shown'
end


-- Options
addon.opt1 = 'Click for Configuratron!'


-- Examples (NYI)
addon.examples = {
	['Heal Over Time#ENTER HOT SPELL NAME'] = {
	},
	['Damage Over Time#ENTER HOT SPELL NAME'] = {
		['Debuff'] = true,
		['TARGET'] = 2,
	},
}

-- Presets
local ABT_sealof = 'SEAL OF' -- text common to all Paladin Seal spells
local ABT_shock = 'SHOCK' -- text common to all Shaman 'Shock' spells
local ABT_bandage = 'BANDAGE' -- text common to every bandage item
local ABT_cpb = 'CP BUILDER#AWARDS' -- 'awards 1 combo point' in every CP building tooltip
local ABT_finishing = 'FINISHING' -- 'finishing move' in every finisher tooltip
local ABT_JUDGEMENT = 'JUDGEMENT' -- any of the 3 new judgement spells
addon.presets = {
	['WARRIOR'] = {
		[addon.battleshout] = {
			['DESC']='Show Remaining Time on ' .. addon.battleshout,
			['SPOS']=2,
			['FONTSIZE']=14,
		},
		[addon.rend] = {
			['DESC']='Show Remaining Time on Rend',
			['Debuff']=true, 
			['TARGET']=2, 
			['SPOS']=2,
			['FONTSIZE']=14,
			['FONTCOLR'] = 1,
			['FONTCOLG'] = 0,
		},
	},
	['PALADIN'] = {
		[ABT_JUDGEMENT] = {
			['DESC']='Show Remaining Time on Judgement',
			['Buff']=ABT_JUDGEMENT,
			['Debuff']=true, 
			['TARGET']=2, 
			['SPOS']=2,
			['FONTSIZE']=14,
		},
		[ABT_sealof] = {
			['DESC']='Show Remaining Time on all Seals',
			['SPOS']=2,
			['FONTSIZE']=14,
		},
	},
	['PRIEST'] = {
		[addon.swp] = {
			['DESC']='Show Remaining Time on ' .. addon.swp,
			['Debuff']=true, 
			['TARGET']=2, 
			['SPOS']=2,
			['FONTSIZE']=14,
			['FONTCOLR'] = 1,
			['FONTCOLG'] = 0,
		},
	},
	['DRUID'] = {
		[ABT_cpb] = {
			['DESC']='Show Energy Deficit on all attacks\nwhich award combo points',
			['SEARCHTT']=true,
			['EDEF']=2,
			['NoTime'] = true,
		},
		[addon.rake..'~'..addon.rip] = {
			['DESC']='Show Remaining Time on ' .. addon.rake .. ' and ' .. addon.rip,
			['Debuff']=true,
			['TARGET']=2, 
			['SPOS']=2,
			['FONTSIZE']=14,
		},
		[ABT_finishing] = {
			['DESC']='Show Combo Points on all Finishing Moves',
			['SEARCHTT']=true,
			['CP']=2,
			['NoTime'] = true,
		},
	},
	['ROGUE'] = {
		[addon.envenom] = {
			['DESC']='Show Combo Points/Deadly Poison stacks\non Envenom',
			['Buff']=addon.dp, 
			['Debuff']=true,
			['TARGET']=2, 
			['Stack']=true, 
			['NoTime']=true, 
			['CP']=1, 
		},
		[ABT_finishing] = {
			['DESC']='Show Combo Points on all Finishing Moves',
			['SEARCHTT']=true,
			['CP']=2,
			['NoTime'] = true,
		},
		[ABT_cpb] = {
			['DESC']='Show Energy Deficit on all attacks\nwhich award combo points',
			['SEARCHTT']=true,
			['EDEF']=2,
			['NoTime'] = true,
		},
	},
	['WARLOCK'] = {
		[addon.shadowbolt] = {
			['DESC']='Show ' .. addon.shadowtrance .. ' Remaining Time on ' .. addon.shadowbolt,
			['Buff']=addon.shadowtrance, 
			['SPOS']=2,
			['FONTSIZE']=14,
		},
	},
	['HUNTER'] = {
		[addon.huntersmark] = {
			['DESC']='Show Remaining Time on ' .. addon.huntersmark,
			['Debuff']=true,
			['TARGET']=2,
			['SPOS']=2,
			['FONTSIZE']=14,
		},
		[addon.mendpet] = {
			['DESC']='Show Remaining Time on ' .. addon.mendpet,
			['TARGET']=3,
			['SPOS']=2,
			['FONTSIZE']=14,
		},
	},
	['SHAMAN'] = {
		[ABT_shock] = {
			['DESC']='Show casts until OOM for all Shocks',
			['CTOOM']=0, 
		},
		[addon.lshield] = {
			['DESC']='Show remaining time/charges for ' .. addon.lshield,
			['Stack']=true, 
		},
	},
	['MAGE'] = {
		[addon.fblast] = {
			['DESC']='Show casts until OOM on ' .. addon.fblast,
			['CTOOM']=0, 
		},
	},
	['BloodElf'] = {
		[addon.manatap] = {
			['SEARCHTT']=true,
			['Buff']=addon.manatap, 
			['DESC']='Show Time Remaining/Stacks on Mana Tap/Arcane Torrent',
			['Stack']=true, 
		},
	},
	['DEATHKNIGHT'] = {
		['RPDEF#.*'] = {
			['DESC']='Show runic power deficit in-combat on all spells which use it',
			['EDEF']=1, 
			['NoTime']=true,
			['SPOS']=1,
			['FONTSIZE']=14,
			['FONTCOLB'] = 0.75,
			['FONTCOLG'] = 0.7,
		},
		['BP#' .. addon.plaguestrike .. '~' .. addon.spells_disease] = {
			['DESC']='Show ' .. addon.bloodplague .. ' Remaining Time \non Spells empowered by Diseases',
			['Debuff'] = true,
			['TARGET'] = 2,
			['Buff'] = 'BLOOD PLAGUE',
			['FONTCOLB'] = 0,
			['FONTCOLG'] = 0,
			['FONTCOLR'] = 1,
			['FONTSTYLE'] = 2,
		},
		['FF#' .. addon.icytouch .. '~' .. addon.howlingblast .. '~' .. addon.spells_disease] = {
			['DESC']='Show ' .. addon.frostfever .. ' Remaining Time \non Spells empowered by Diseases',
			['Debuff'] = true,
			['TARGET'] = 2,
			['Buff'] = 'FROST FEVER',
			['FONTCOLB'] = 0.75,
			['FONTCOLG'] = 0.7,
			['FONTSTYLE'] = 2,
		},
	},
	['ALL'] = {
		[ABT_bandage] = {
			['DESC']='Show Recently Bandaged debuff time on all Bandages',
			['Buff']=addon.rbandaged, 
			['Debuff']=true,
			['SPOS']=2,
			['FONTSIZE']=14,
			['FONTCOLR'] = 1,
			['FONTCOLG'] = 0,
		},
		['DMG#.*'] = {
			['DESC']='Show damage/heal/miss/block/parry on all buttons',
			['SHOWDMG']=1, 
			['NoTime']=true,
			['SPOS']=3,
			['FONTSIZE']=14,
		},
	},
}
