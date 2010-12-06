local _, ABT_NS = ... -- namespace

-- English/Default localisation

-- Config
ABT_NS.configtext = "<HTML><BODY>\
<H1>|cff00ff00What can the Configuratron! do?|r</H1>\
<H2>|cffffff00Select an existing ActionButtonText from the dropdown (above) to edit it|r</H2>\
<BR/><H2>|cffffff00Select 'New ActionButtonText' from the dropdown to create one from scratch|r</H2>\
<BR/><BR/>\
<H1>|cff00ff00Can I edit the Presets?|r</H1>\
<H2>|cffffff00ActionButtonTexts which begin 'PRESET' relate to presets on the /abt screen</H2>\
<BR/><H2>|cffffff00You can edit these to change font color/size etc. or just to see how they work|r</H2>\
<BR/><H2>|cffffff00Deselecing and Reselecting a Preset will reset any changes you have made|r</H2>\
</BODY></HTML>"

ABT_NS.hint1 = "Add ActionButtonText to which button(s)"
ABT_NS.hint2 = "What ActionButtonText to show about Spell(s)"
ABT_NS.hint3 = "What ActionButtonText to show about Buff/Debuff(s)"
ABT_NS.hint4 = "How ActionButtonText should look"

ABT_NS.err1 = "** Already Exists **"
ABT_NS.err2 = "** Cannot be blank **"

ABT_NS.con0 = "Create/Edit ActionButtonText"
ABT_NS.con1 = "Spell/Item/Macro Name"
ABT_NS.searchtt = "Search Tooltip?"
ABT_NS.choose = "Examples"

ABT_NS.showdmg = "Show Hit/Miss?"
ABT_NS.ctoom = "Show Casts until OOM?"
ABT_NS.con8 = "Show CPs?"
ABT_NS.combovals = {"No","0 or more","1 or more"}
if ABT_NS.class == "DEATHKNIGHT" then
  ABT_NS.edef = "Show RP Deficit?"
  ABT_NS.edefvals = {"No","In Combat","Always"}
else
  ABT_NS.edef = "Show Energy Deficit?"
  ABT_NS.edefvals = {"No","As Energy","As Ticks"}
end

ABT_NS.con2 = "Buff Name"
ABT_NS.targetvals = {"PLAYER","TARGET","PET"}
ABT_NS.con4 = "Debuff?"
ABT_NS.notmine = "Anyones?"
ABT_NS.con5 = "Hide Time?"
ABT_NS.con6 = "Show Stacks?"

ABT_NS.con9 = "Save Changes"
ABT_NS.con10 = "Cancel Changes"
ABT_NS.spos = "Position"
ABT_NS.sposvals = {"Bottom","Middle","Top"}
ABT_NS.fontsize = "Font Size"
ABT_NS.fontstyle = "Font Style"
ABT_NS.fontstylevals = {[0]="NORMAL",[1]="OUTLINE",[2]="THICKOUTLINE"}

ABT_NS.del1 = "Delete this ActionButtonText"
ABT_NS.del2 = "REALLY Delete it?"
ABT_NS.del3 = "REALLY DELETE ???"

ABT_NS.tips = {
  ["obicon1"] = "ActionButtonText will appear where this matches the spell/macro/item name on the button\n|cff00ff00Tip: Can be a partial match e.g. 'SEAL OF' or 'SHOCK'|r\n\nAny text appearing before # is descriptive and will NOT included in the match\n|cff00ff00Tip: This allows more than one ActionButtonText for the same spell e.g. 'DAMAGE#SEAL OF' and 'MANA#SEAL OF'",
  ["obisearchtt"] = "If selected, the entire spell/item/macro tooltip will be matched rather than just the name",
  ["obishowdmg"] = "If selected, the last damage/heal or miss (block/parry,dodge) will be shown",
  ["obictoom"] = "If selected, the number of times the spell can be cast with current mana will be shown",
  ["obicon8"] = "If selected, Combo Points on current target will be shown",
  ["obicon2"] = "If this matches an active Buff, the remaining time will be shown\nIf blank, defaults to the spell/item/macro name on the button",
  ["obicon4"] = "If selected, Debuffs will be matched instead of Buffs",
  ["obitarget"] = "Which Unit should be checked for the Buff/Debuff",
  ["obicon5"] = "If selected, the remaining time for the Buff/Debuff will NOT be shown",
  ["obicon6"] = "If selected, Buff/Debuff stacks will be shown",
}
if ABT_NS.class == "DEATHKNIGHT" then
  ABT_NS.tips["obiedef"] = "If selected, Runic Power deficit will be shown"
else
  ABT_NS.tips["obiedef"] = "If selected, Energy deficit will be shown"
end


-- Options
ABT_NS.opt1 = "Click for Configuratron!"


-- Examples (NYI)
ABT_NS.examples = {
  ["Heal Over Time#ENTER HOT SPELL NAME"] = {
  },
  ["Damage Over Time#ENTER HOT SPELL NAME"] = {
    ["Debuff"] = true,
    ["TARGET"] = 2,
  },
}

-- Presets
local ABT_sealof = "SEAL OF" -- text common to all Paladin Seal spells
local ABT_shock = "SHOCK" -- text common to all Shaman 'Shock' spells
local ABT_bandage = "BANDAGE" -- text common to every bandage item
local ABT_cpb = "CP BUILDER#AWARDS" -- 'awards 1 combo point' in every CP building tooltip
local ABT_finishing = "FINISHING" -- 'finishing move' in every finisher tooltip
local ABT_JUDGEMENT = "JUDGEMENT" -- any of the 3 new judgement spells
ABT_NS.presets = {
  ['WARRIOR'] = {
    [ABT_NS.battleshout] = {
  		["DESC"]="Show Remaining Time on " .. ABT_NS.battleshout,
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
  	[ABT_NS.rend] = {
  		["DESC"]="Show Remaining Time on Rend",
      ["Debuff"]=true, 
  		["TARGET"]=2, 
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  		["FONTCOLR"] = 1,
  		["FONTCOLG"] = 0,
  	},
	},
  ['PALADIN'] = {
  	[ABT_JUDGEMENT] = {
  		["DESC"]="Show Remaining Time on Judgement",
  		["Buff"]=ABT_JUDGEMENT,
      ["Debuff"]=true, 
  		["TARGET"]=2, 
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
  	[ABT_sealof] = {
  		["DESC"]="Show Remaining Time on all Seals",
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
	},
  ['PRIEST'] = {
  	[ABT_NS.swp] = {
  		["DESC"]="Show Remaining Time on " .. ABT_NS.swp,
      ["Debuff"]=true, 
  		["TARGET"]=2, 
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  		["FONTCOLR"] = 1,
  		["FONTCOLG"] = 0,
  	},
	},
  ['DRUID'] = {
  	[ABT_cpb] = {
  		["DESC"]="Show Energy Deficit on all attacks\nwhich award combo points",
  		["SEARCHTT"]=true,
  		["EDEF"]=2,
  		["NoTime"] = true,
  	},
  	[ABT_NS.rake.."~"..ABT_NS.rip] = {
  		["DESC"]="Show Remaining Time on " .. ABT_NS.rake .. " and " .. ABT_NS.rip,
  		["Debuff"]=true,
  		["TARGET"]=2, 
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
  	[ABT_finishing] = {
  		["DESC"]="Show Combo Points on all Finishing Moves",
  		["SEARCHTT"]=true,
  		["CP"]=2,
  		["NoTime"] = true,
  	},
	},
  ['ROGUE'] = {
  	[ABT_NS.envenom] = {
  		["DESC"]="Show Combo Points/Deadly Poison stacks\non Envenom",
  		["Buff"]=ABT_NS.dp, 
  		["Debuff"]=true,
  		["TARGET"]=2, 
  		["Stack"]=true, 
  		["NoTime"]=true, 
  		["CP"]=1, 
  	},
  	[ABT_finishing] = {
  		["DESC"]="Show Combo Points on all Finishing Moves",
  		["SEARCHTT"]=true,
  		["CP"]=2,
  		["NoTime"] = true,
  	},
  	[ABT_cpb] = {
  		["DESC"]="Show Energy Deficit on all attacks\nwhich award combo points",
  		["SEARCHTT"]=true,
  		["EDEF"]=2,
  		["NoTime"] = true,
  	},
	},
  ['WARLOCK'] = {
  	[ABT_NS.shadowbolt] = {
  		["DESC"]="Show " .. ABT_NS.shadowtrance .. " Remaining Time on " .. ABT_NS.shadowbolt,
  		["Buff"]=ABT_NS.shadowtrance, 
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
	},
  ['HUNTER'] = {
  	[ABT_NS.huntersmark] = {
  		["DESC"]="Show Remaining Time on " .. ABT_NS.huntersmark,
  		["Debuff"]=true,
  		["TARGET"]=2,
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
  	[ABT_NS.mendpet] = {
  		["DESC"]="Show Remaining Time on " .. ABT_NS.mendpet,
  		["TARGET"]=3,
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  	},
	},
  ['SHAMAN'] = {
  	[ABT_shock] = {
  	  ["DESC"]="Show casts until OOM for all Shocks",
  		["CTOOM"]=0, 
  	},
  	[ABT_NS.lshield] = {
  	  ["DESC"]="Show remaining time/charges for " .. ABT_NS.lshield,
  		["Stack"]=true, 
  	},
	},
  ['MAGE'] = {
  	[ABT_NS.fblast] = {
  	  ["DESC"]="Show casts until OOM on " .. ABT_NS.fblast,
  		["CTOOM"]=0, 
  	},
	},
  ['BloodElf'] = {
  	[ABT_NS.manatap] = {
  		["SEARCHTT"]=true,
  		["Buff"]=ABT_NS.manatap, 
  	  ["DESC"]="Show Time Remaining/Stacks on Mana Tap/Arcane Torrent",
  		["Stack"]=true, 
  	},
	},
  ['DEATHKNIGHT'] = {
  	["RPDEF#.*"] = {
  	  ["DESC"]="Show runic power deficit in-combat on all spells which use it",
  		["EDEF"]=1, 
  		["NoTime"]=true,
  		["SPOS"]=1,
  		["FONTSIZE"]=14,
  		["FONTCOLB"] = 0.75,
  		["FONTCOLG"] = 0.7,
  	},
  	["BP#" .. ABT_NS.plaguestrike .. "~" .. ABT_NS.spells_disease] = {
  	  ["DESC"]="Show " .. ABT_NS.bloodplague .. " Remaining Time \non Spells empowered by Diseases",
  		["Debuff"] = true,
  		["TARGET"] = 2,
  		["Buff"] = "BLOOD PLAGUE",
  		["FONTCOLB"] = 0,
  		["FONTCOLG"] = 0,
  		["FONTCOLR"] = 1,
  		["FONTSTYLE"] = 2,
  	},
  	["FF#" .. ABT_NS.icytouch .. "~" .. ABT_NS.howlingblast .. "~" .. ABT_NS.spells_disease] = {
  	  ["DESC"]="Show " .. ABT_NS.frostfever .. " Remaining Time \non Spells empowered by Diseases",
  		["Debuff"] = true,
  		["TARGET"] = 2,
  		["Buff"] = "FROST FEVER",
  		["FONTCOLB"] = 0.75,
  		["FONTCOLG"] = 0.7,
  		["FONTSTYLE"] = 2,
  	},
	},
  ['ALL'] = {
  	[ABT_bandage] = {
  	  ["DESC"]="Show Recently Bandaged debuff time on all Bandages",
  		["Buff"]=ABT_NS.rbandaged, 
  		["Debuff"]=true,
  		["SPOS"]=2,
  		["FONTSIZE"]=14,
  		["FONTCOLR"] = 1,
  		["FONTCOLG"] = 0,
  	},
  	["DMG#.*"] = {
  	  ["DESC"]="Show damage/heal/miss/block/parry on all buttons",
  		["SHOWDMG"]=1, 
  		["NoTime"]=true,
  		["SPOS"]=3,
  		["FONTSIZE"]=14,
  	},
	},
}
