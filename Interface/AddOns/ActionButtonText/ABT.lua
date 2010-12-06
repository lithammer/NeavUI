local _, ABT_NS = ... -- namespace
local ABTFrame = CreateFrame("Frame")

ABT_NS.API = {}

-- ActionButtonText
--
-- Credit to Gagorian for his addon DrDamage 
-- His code for finding and adding text to actionbuttons (Blizzard AND addon-based) was ENORMOUSLY helpful
--
-- Credit to Mikk for MSBT - the MSBTOptions frame creation code is used as-is for the Configuratron
--
-- My thanks go to both authors for granting permission to use their code...

ABT_NS.lastbuttonupdate = 0

ABT_NS.updint = 0.9
ABT_NS.sdint = 5

ABT_NS.atkinfo = {}

ABT_NS.tipdb = {}

ABT_NS.btnprefix = ""
ABT_NS.btncooldown = ""
ABT_NS.btnid = 0
ABT_NS.relpos = {"BOTTOM","","TOP"}

ABT_NS.playername = UnitName("PLAYER")

ABT_NS.defaultBars = { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"}

ABT_NS.clearcasting = false

function ABT_NS.settext(button,id,text,fs,ol)
  local buttontxt = _G[button:GetName().."ob"..id] 
  if not buttontxt and text ~= "" then
    local aaa = CreateFrame("Frame")
    aaa:SetParent(button)
    
    local plevel = button:GetFrameLevel()
    local pstrata = button:GetFrameStrata()
    aaa:SetFrameStrata(pstrata)
    aaa:SetFrameLevel(plevel + 1)
   
    local ob = aaa:CreateFontString(button:GetName() .. "ob" .. id, "OVERLAY")
    --ob:SetPoint(ABT_NS.relpos[id], button, "CENTER") -- , 4-(2*id - 10))
    if (id == 1) then
        ob:SetPoint(ABT_NS.relpos[id].."LEFT", button, ABT_NS.relpos[id].."LEFT", -10, -(2*id))
        ob:SetPoint(ABT_NS.relpos[id].."RIGHT", button, ABT_NS.relpos[id].."RIGHT", 10 , -(2*id))
    else
        ob:SetPoint(ABT_NS.relpos[id].."LEFT", button, ABT_NS.relpos[id].."LEFT", -10, 18-(2*id))
        ob:SetPoint(ABT_NS.relpos[id].."RIGHT", button, ABT_NS.relpos[id].."RIGHT", 10 ,18-(2*id))
    end
        
  	-- ob:SetPoint(ABT_NS.relpos[id].."LEFT", button, ABT_NS.relpos[id].."LEFT", -10, 4-(2*id - 10))
   	-- ob:SetPoint(ABT_NS.relpos[id].."RIGHT", button, ABT_NS.relpos[id].."RIGHT", 10 ,4-(2*id - 10))
   	ob:SetJustifyH("CENTER")
    ob:Show()

    buttontxt = ob
  end
  if buttontxt then
   	-- buttontxt:SetFont(GameFontNormal:GetFont(), 12, ol or "OUTLINE")
    buttontxt:SetFont("Fonts\\ARIALN.ttf", fs or 16,"OUTLINE")
    buttontxt:SetText(text)
  end
end

function ABT_NS.cleartext(button)
  for id = 1,3 do
    local buttontxt = _G[button:GetName().."ob"..id] 
    if buttontxt then
      buttontxt:SetText("")
    end
  end
end

function ABT_NS.needslash(val,val2)
  if val and val ~= "" and val2 and val2 ~= "" then
    return val .. "/" .. val2
  elseif val and val ~= "" then    
    return val
  else
    return val2
  end
end


function ABT_NS.debuff(n,target)
  local name,_,_,stack,_,_,timeleft,ismine = UnitDebuff(target,n)
  return name,(timeleft or 0) - GetTime(),stack or 0,ismine
end

function ABT_NS.buff(n,target)
  local name,_,_,stack,_,_,timeleft,ismine = UnitBuff(target,n) 
  return name,(timeleft or 0) - GetTime(),stack or 0,ismine
end

function ABT_NS.checkbuff(buffname, debuff, target, notmine)
  local fn
  local TL = 0
  local ST = 0
  if UnitExists(target) then
    if debuff then
      fn = ABT_NS.debuff
    else
      fn = ABT_NS.buff
    end
    local i = 1
    local testname, timeleft, stack, ismine = fn(1, target)
    while (testname) do
      -- if (ismine or notmine) and (ABT_NS.find(strupper(testname),strupper(buffname)) or testname == buffname) then
        if (ismine == "player" or notmine) and (ABT_NS.find(strupper(testname),strupper(buffname)) or testname == buffname) then
        if timeleft > TL then 
          TL = timeleft
          ST = stack 
        end
      end
    	i = i + 1
    	testname, timeleft, stack, ismine = fn(i, target)
    end
  end
  return TL,ST
end

function ABT_NS.find(f1,f2)
  local _,_,pf2,rf2 = strfind(f2.."~","^([^~]*)~(.*)$") 
  while pf2 or rf2 do
    if pf2 and pf2 ~= "" then
      if strfind(f1,pf2) then
        return true
      end
    end
     _,_,pf2,rf2 = strfind(rf2,"^([^~]*)~(.*)$")  
  end
  return false
end

function ABT_NS.getobi(spellname,spelltable,spellf)
	local msg = ""
	local fs,spos,fst = spelltable["FONTSIZE"] or 11,spelltable["SPOS"] or 1,spelltable["FONTSTYLE"] or 1
	local buffname = spelltable["Buff"] or spellname
	local debuff = spelltable["Debuff"]
	local target = ABT_NS.targetvals[spelltable["TARGET"]] or "PLAYER"
	local timeleft,charges,timeleft2,charges2 = 0,0,0,0
	local msg = ""
	local function timetomins(time)
	local mins = ceil(time/60)
	local name, rank, icon, cost, isfunnel, powertype
	
	if mins > 1 then
		return mins .. "m"
	else
		return floor(time)
	end
	
	end
	
	if ABT_NS.API[buffname..spellname] then
		msg = ABT_NS.needslash(msg,ABT_NS.API[buffname..spellname])
	else
		timeleft,charges = ABT_NS.checkbuff(buffname,debuff,target,spelltable["NOTMINE"])
	end
	
	if (spelltable["NoTime"] or false) == false then
		if timeleft and timeleft > 0 then
			msg = ABT_NS.needslash(msg,timetomins(timeleft))
		end
		--if timeleft2 and timeleft2 > 0 then
		--  msg = ABT_NS.needslash(msg,timetomins(timeleft2))
		--end
	end
	
	if (spelltable["Stack"] or false) == true and charges > 0 then
		msg = ABT_NS.needslash(msg,charges)
	end
	
	local cp = 0
	cp = GetComboPoints("PLAYER","TARGET") --WOTLK
	if spelltable["CP"] and cp >= spelltable["CP"]-1 and UnitPowerType("PLAYER") == 3 then -- uses energy
		msg = ABT_NS.needslash(msg,cp)
	end
	
	if (spelltable["SHOWDMG"] or 0) == 1 and ABT_NS.atkinfo[spellname] then
		local info,time,crit = ABT_NS.atkinfo[spellname][1],ABT_NS.atkinfo[spellname][2],ABT_NS.atkinfo[spellname][3]
		
		if info and GetTime() - time < ABT_NS.sdint then
			msg = ABT_NS.needslash(msg,info)
			
			if crit then
				fs = fs + 2
			end
		end
	end
	
	local edef = spelltable["EDEF"]
	if edef and (UnitPowerType("PLAYER") == 3 or UnitPowerType("PLAYER") == 6) then -- uses energy 
		name,rank,icon,cost,isfunnel,powertype = GetSpellInfo(spellname.."()")
		
		if cost and (powertype == 3 or powertype ==6) then
			if ABT_NS.clearcasting then
				msg = ABT_NS.needslash(msg,"00")
			elseif cost > 0 then
				def = UnitMana("PLAYER") - cost
				if def < 0 then
					if powertype == 3 then
						if edef == 2 then
							def = abs(floor(def / 20))
							msg = ABT_NS.needslash(msg,def)
						else
							def = abs(def)
							msg = ABT_NS.needslash(msg,def)
						end
					else
						if edef == 2 or UnitAffectingCombat("PLAYER") then
							def = abs(def)
							msg = ABT_NS.needslash(msg,def)
						end
					end
				end
			end
		end
	end
	
	local ctoom = spelltable["CTOOM"] 
	if ctoom and UnitPowerType("PLAYER") == 0 then -- uses mana
		name,rank,icon,cost,isfunnel,powertype = GetSpellInfo(spellname.."()")
		
		if cost and powertype == 0 then
			if ABT_NS.clearcasting then
				msg = "00"
			elseif cost > 0 then
				casts = floor(UnitMana("PLAYER") / cost)
				
				if ctoom == 0 or casts <= ctoom then
					msg = ABT_NS.needslash(msg,casts)
				end
			end
		end
	end
	
	if msg == "0" then msg = " " end -- traps 0 CPs
	return msg,fs,spos,ABT_NS.fontstylevals[fst]
end

function ABT_NS.btnname(i)
	if ABT_NS.btnprefix ~= "" then
		return _G[ABT_NS.btnprefix..i]
	else
		local barn = math.floor((i-1)/12)
		local btnn = i-(barn*12)
		if btnn and barn and ABT_NS.defaultBars[barn+1] then
			return _G[ABT_NS.defaultBars[barn+1]..btnn]
		else
			return nil
		end
	end
end

function ABT_NS.gettext(button,id)
	local buttontxt = _G[button:GetName().."ob"..id]
	
	if buttontxt then
		return buttontxt:GetText()
	else
		return ""
	end 
end

function ABT_NS.getdefs()
  ABT_NS.btnid = function(button) return ActionButton_GetPagedID(button) end
  ABT_NS.btncooldown = "Cooldown"
	if IsAddOnLoaded("Bartender3") then
		ABT_NS.btnprefix = "BT3Button"
		ABT_NS.btnid = function( button, index )
					if Bartender3.actionbuttons[index] and Bartender3.actionbuttons[index].state == "used" then
						return Bartender3.actionbuttons[index].object:PagedID()
					end
		end
		ABT_NS.updint = .5 -- quicker due to the 'prowlbar' issue
	elseif IsAddOnLoaded("Bartender4") then
		ABT_NS.btnprefix = "BT4Button"
		ABT_NS.btnid = function( button ) return button.Secure:GetActionID() end 
		ABT_NS.updint = .5 -- quicker due to the 'prowlbar' issue
	elseif IsAddOnLoaded( "Bongos2" ) then
		ABT_NS.btnprefix = "BongosActionButton"
		ABT_NS.btnid = function(button) return button:GetPagedID() end
	elseif IsAddOnLoaded( "Bongos" ) then
		ABT_NS.btnprefix = "Bongos3ActionButton"
		ABT_NS.btnid = function(button) return button:GetPagedID() end
	elseif IsAddOnLoaded( "CogsBar" ) then
		ABT_NS.btnprefix = "CogsBarButton"
	elseif IsAddOnLoaded("Dominos") then
		-- nothing needed 
	elseif IsAddOnLoaded("TrinityBars") then
		ABT_NS.btnprefix = "TrinityActionButton"
		ABT_NS.btncooldown = "IconFrameCooldown"
		ABT_NS.btnid = function( button ) return SecureButton_GetModifiedAttribute(button,"action",SecureStateChild_GetEffectiveButton(button)) end
	elseif IsAddOnLoaded("TrinityBars2") then
		ABT_NS.btnprefix = "TrinityActionButton"
		ABT_NS.btncooldown = "IconFrameCooldown"
		ABT_NS.btnid = 
    function( button )
      if button.config.type == "action" then
        return button.config.action 
      elseif button.config.type == "macro" then
        return button.config.macro 
      elseif button.config.type == "spell" then 
        return button.config.spell..button.config.spellranktext,"TRINITYSPELL" 
      elseif button.config.type == "item" and button.config.itemlink and button.config.itemlink ~= "" then
        _,_,itemid = strfind(button.config.itemlink,"item:(%d+):")
        return button.config.itemlink,"TRINITYITEM",itemid
      end
    end
	elseif IsAddOnLoaded("idActionbar") then
		ABT_NS.btnprefix = "idActionbarButton"
  end
end

-- Support for Trinity 2.0 'post-hack'
if TrinityBars2 and TrinityBars2.spellIndex then 
 TRspellIndex = TrinityBars2.spellIndex
else
 TRspellIndex = spellIndex
end

function ABT_NS.init()

  _,ABT_NS.class = UnitClass("PLAYER")

  local tt = CreateFrame("GameTooltip","ABT_ToolTipScan",UIParent,"GameTooltipTemplate")

  ABT_NS.configinit()
  ABT_NS.optionsinit()
  ABT_NS.getdefs()
  
  ABTFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function ABT_NS.combat()
  if (arg4) and (arg4 == ABT_NS.playername) then
    if arg2 == "SPELL_DAMAGE" or arg2 == "SPELL_MISSED" or arg2 == "SPELL_HEAL" then -- or arg2 == "SPELL_PERIODIC_DAMAGE" 
      if arg10 and arg12 then
        ABT_NS.atkinfo[arg10] = {arg12,GetTime(),arg17}
        ABT_NS.lastbuttonupdate = 0
      end
    end
    if arg2 == "SWING_DAMAGE" or arg2 == "SWING_MISSED" then
      if arg9 then
        ABT_NS.atkinfo["Attack"] = {arg9,GetTime(),arg14}
        ABT_NS.lastbuttonupdate = 0
      end
    end
    -- Actually has the spellname even tho it's most likely always "Auto Shot" - identical to SPELL_ in fact
    if arg2 == "RANGE_DAMAGE" or arg2 == "RANGE_MISSED" then
      if arg10 and arg12 then
        ABT_NS.atkinfo[arg10] = {arg12,GetTime(),arg17}
        ABT_NS.lastbuttonupdate = 0
      end
    end
  end
  if (arg7) and (arg7 == ABT_NS.playername) then
    if arg10 == "Clearcasting" then
      if arg2 == "SPELL_AURA_APPLIED" then
        ABT_NS.clearcasting = true
        ABT_NS.lastbuttonupdate = 0
      else
        ABT_NS.clearcasting = false
        ABT_NS.lastbuttonupdate = 0
      end
     end
  end
end

function ABT_NS.resetdb()
  ABT_NS.tipdb = {}
end

function ABT_NS.event(self, event, arg1)
  if event == "PLAYER_ENTERING_WORLD" then
   ABT_NS.init()
  elseif event == "UNIT_ENERGY" then
   ABT_NS.lastbuttonupdate = 0
  elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then 
   ABT_NS.combat(); 
  elseif (event == "SPELLS_CHANGED") then 
   ABT_NS.resetdb()
  else
   -- we can't update here because bar mods haven't refreshed yet
   -- so we defer the update until the next ON_UPDATE event
   ABT_NS.lastbuttonupdate = 0
  end; 
end

function ABT_NS.updtext()
  for x=1,120 do
    local button = ABT_NS.btnname(x)
    if button and button:IsVisible() then
      ABT_NS.cleartext(button)
      local ac,ty,id = ABT_NS.btnid(button,x)
      if ac and ac ~= "()" then
        if not ty then
          ty,id = GetActionInfo(ac)
        end
        --DEFAULT_CHAT_FRAME:AddMessage((ac or "NOAC") .. (ty or "NOTY") .. (id or "NOID"))
        if ty then
          local spellname = ""
		  local spellid
          if ty == "TRINITYSPELL" and TRspellIndex and TRspellIndex[strlower(ac)] then
            id = TRspellIndex[strlower(ac)][1]
            spellid = id
            spellname = GetSpellBookItemName(id,BOOKTYPE_SPELL)
          elseif ty == "spell" and id ~= 0 then
            spellid = id
            spellname = GetSpellInfo(id)
          elseif ty == "macro" then
            ABT_ToolTipScan:SetOwner(WorldFrame, "ANCHOR_NONE") -- without this, tooltip can fail 'randomly'
            ABT_ToolTipScan:ClearLines()
            ABT_ToolTipScan:SetAction(ac)
          	spellid = ABT_ToolTipScanTextLeft1:GetText()
          	spellname = spellid
          elseif ty == "item" or ty == "TRINITYITEM" then
          	spellid = GetItemInfo(id)
          	spellname = spellid
          end
          if spellname and spellname ~= "" then
            if ABT_spelldb then
              for spell in pairs(ABT_spelldb) do
                local msg = ""
                local spellf,fs,spos,fst
                if strfind(spell,"#") then
                   _,_,spellf = strfind(spell,"#(.*)")
                else
                  spellf = spell
                end 
                local scantt = ABT_spelldb[spell]["SEARCHTT"] or false
                local scanwp = ABT_spelldb[spell]["SEARCHWP"] or false
                if scantt then
                  if not ABT_NS.tipdb[spellid] then
                    ABT_ToolTipScan:SetOwner(WorldFrame, "ANCHOR_NONE") -- without this, tooltip can fail 'randomly'
                    ABT_ToolTipScan:ClearLines()
                    if ty == "TRINITYSPELL" then
                      ABT_ToolTipScan:SetSpell(spellid,BOOKTYPE_SPELL)
                    elseif ty == "TRINITYITEM" then
                      ABT_ToolTipScan:SetHyperlink(ac)
                    elseif ac then
                      ABT_ToolTipScan:SetAction(ac)
                    end
                    local tiptext = ""
                    for i=1,ABT_ToolTipScan:NumLines() do
                      tiptext = tiptext .. strupper(_G['ABT_ToolTipScanTextLeft'..i]:GetText() or "")
                      tiptext = tiptext .. strupper(_G['ABT_ToolTipScanTextRight'..i]:GetText() or "")
                    end
                    ABT_NS.tipdb[spellid] = strupper(tiptext)
                  end
                  if ABT_NS.tipdb[spellid] and ABT_NS.find(ABT_NS.tipdb[spellid],spellf) then
                    msg,fs,spos,fst = ABT_NS.getobi(spellname,ABT_spelldb[spell],spellf)
                  end
                else
                  if ABT_NS.find(strupper(spellname),spellf) then
                    msg,fs,spos,fst = ABT_NS.getobi(spellname,ABT_spelldb[spell],spellf)
                  end
                end
                if msg ~= "" then
                  ABT_NS.settext(button,spos,ABT_NS.needslash(ABT_NS.gettext(button,spos),"|cff" .. string.format("%02x%02x%02x", (ABT_spelldb[spell]["FONTCOLR"] or 0) * 255, (ABT_spelldb[spell]["FONTCOLG"] or 1) * 255, (ABT_spelldb[spell]["FONTCOLB"] or 0) * 255) .. msg .. "|r"),fs,fst)
                end
              end -- loop
            end -- spelldb
          end
        end -- ty
      end -- ac
    end -- button
  end -- 120 buttons
end

function ABT_NS.update()
  if GetTime() - ABT_NS.lastbuttonupdate > ABT_NS.updint then
    ABT_NS.updtext()
    ABT_NS.lastbuttonupdate = GetTime()
	end
end

ABTFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ABTFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
ABTFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ABTFrame:RegisterEvent("ACTIONBAR_HIDEGRID")
ABTFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
ABTFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ABTFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
ABTFrame:RegisterEvent("UPDATE_MACROS")
ABTFrame:RegisterEvent("UNIT_ENERGY")
ABTFrame:RegisterEvent("RUNE_POWER_UPDATE")
ABTFrame:RegisterEvent("UNIT_RUNIC_POWER")
ABTFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
ABTFrame:RegisterEvent("SPELLS_CHANGED");
ABTFrame:SetScript("OnEvent", ABT_NS.event)
ABTFrame:SetScript("OnUpdate", ABT_NS.update)

function ABT_NS.slash(opts)
  if UnitAffectingCombat("PLAYER") then
    DEFAULT_CHAT_FRAME:AddMessage("Error: /abt is disabled in combat",1,0,0)
  elseif strfind(strupper((opts or "")),"CONFIG") then
    ABT_NS.configpanel:Show()
  elseif strfind(strupper((opts or "")),"ADD") then
    ABT_NS.configpanel:Show()
    ABT_NS.newspell_click()
  else
    InterfaceOptionsFrame_OpenToCategory("ActionButtonText")
  end
end

SLASH_ABT1 = "/abt";
SlashCmdList["ABT"] = ABT_NS.slash;