
UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14

GameTooltipStatusBar:SetHeight(7)
GameTooltipStatusBar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})

local function ApplyTooltipStyle(self)
    local bgsize, bsize
    if (self == ConsolidatedBuffsTooltip) then
        bgsize = 1
        bsize = 8
    else
        bgsize = 3
        bsize = 12
    end
    
    self:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8', 
        insets = {
            left = bgsize, 
            right = bgsize, 
            top = bgsize, 
            bottom = bgsize
        }
    })
    
    self:HookScript('OnShow', function(tip)
        tip:SetBackdropColor(0, 0, 0, 0.70)
    end)
    
    CreateBorder(self, bsize)
end

hooksecurefunc("GameTooltip_ShowCompareItem", function(self)  
	if (not self) then
		self = GameTooltip
	end
    
    local shoppingTooltip1, shoppingTooltip2, shoppingTooltip3 = unpack(self.shoppingTooltips)
    
    if (not shoppingTooltip1.hasBorder) then
        ApplyTooltipStyle(shoppingTooltip1)
        shoppingTooltip1.hasBorder = true
    end
    
    if (not shoppingTooltip2.hasBorder) then
        ApplyTooltipStyle(shoppingTooltip2)
        shoppingTooltip2.hasBorder = true
    end
    
    if (not shoppingTooltip3.hasBorder) then
        ApplyTooltipStyle(shoppingTooltip3)
        shoppingTooltip3.hasBorder = true
    end
end)
    
for _, tooltip in pairs({
    GameTooltip,
    ItemRefTooltip,
    WorldMapTooltip,
        
    ShoppingTooltip1,
    ShoppingTooltip2,
    ShoppingTooltip3,   

    DropDownList1MenuBackdrop,
    DropDownList2MenuBackdrop,
    
    ConsolidatedBuffsTooltip,
    -- FrameStackTooltip,
    -- PaperDollStatTooltip,
    
    -- ChatMenu,
	-- EmoteMenu,
	-- LanguageMenu,
	-- DropDownList1,
}) do
    ApplyTooltipStyle(tooltip)
end

local function GameTooltip_GetUnit(self)
    if (GetMouseFocus() and not GetMouseFocus():GetAttribute('unit') and GetMouseFocus() ~= WorldFrame) then
        return select(2, self:GetUnit())
	elseif (GetMouseFocus() and GetMouseFocus():GetAttribute('unit')) then
		return GetMouseFocus():GetAttribute('unit')
    else
        return select(2, self:GetUnit())  
	end
end

local function GameTooltip_UnitCreatureType(unit)
    local creaturetype = UnitCreatureType(unit)
    if (creaturetype) then
        return creaturetype
    else
        return ''
    end
end

local function GameTooltip_UnitClassification(unit)
    local class = UnitClassification(unit)
    if (class == 'worldboss') then
        return '|cffFF0000'..BOSS..'|r '
    elseif (class == 'rareelite') then
        return '|cffFF66CCRare|r |cffFFFF00'..ELITE..'|r '
    elseif (class == 'rare') then 
        return '|cffFF66CCRare|r '
    elseif (class == 'elite') then
        return '|cffFFFF00'..ELITE..'|r '
    else
        return ''
    end
end

local function GameTooltip_UnitLevel(unit)
    local diff = GetQuestDifficultyColor(UnitLevel(unit))
    if (UnitLevel(unit) == -1) then
        return '|cffff0000??|r '
    elseif (UnitLevel(unit) == 0) then
        return '? '
    else
        return format('|cff%02x%02x%02x%s|r ', diff.r*255, diff.g*255, diff.b*255, UnitLevel(unit))    
    end
end

local function GameTooltip_UnitClass(unit)
    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    if (color) then
        return format(' |cff%02x%02x%02x%s|r', color.r*255, color.g*255, color.b*255, UnitClass(unit))
    end
end

local function GameTooltip_UnitType(unit) 
    if (UnitIsPlayer(unit)) then
        return GameTooltip_UnitLevel(unit)..UnitRace(unit)..GameTooltip_UnitClass(unit)
    else
        return GameTooltip_UnitLevel(unit)..GameTooltip_UnitClassification(unit)..GameTooltip_UnitCreatureType(unit)
    end
end

GameTooltip.Icon = GameTooltip:CreateTexture('$parentRaidIcon', 'OVERLAY')
GameTooltip.Icon:SetPoint('TOPLEFT', GameTooltip, 10, -10)
GameTooltip.Icon:SetWidth(16)
GameTooltip.Icon:SetHeight(16)

hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
	self:SetPoint('BOTTOMRIGHT', UIParent, -27.35, 27.35)
end)

GameTooltip:HookScript('OnTooltipCleared', function(self)
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 2, -2)
    GameTooltipStatusBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -2, -2)
    
    self.Icon:SetTexture(nil)
end)

-- function to short-display HP value on StatusBar
local function ShortValue(value)
	if value >= 1e7 then
		return ('%.1fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif value >= 1e6 then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif value >= 1e5 then
		return ('%.0fk'):format(value / 1e3)
	elseif value >= 1e3 then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

local PowerBarColor = PowerBarColor
GameTooltip:HookScript('OnTooltipSetUnit', function(self, ...)
    local unit = GameTooltip_GetUnit(self)

	if (UnitExists(unit) and UnitName(unit) ~= UNKNOWN) then
        local name, realm = UnitName(unit)
        if UnitPVPName(unit) then name = UnitPVPName(unit) end
        
        local unitTargetName = UnitName(unit .. 'target');
		local unitTargetClassColor = RAID_CLASS_COLORS[select(2,UnitClass(unit .. 'target'))] or { r = 1, g = 0, b = 1 };
		local unitTargetReactionColor = { r = select(1, UnitSelectionColor(unit .. 'target')), g = select(2, UnitSelectionColor(unit .. 'target')), b = select(3, UnitSelectionColor(unit .. 'target')) };

        GameTooltipTextLeft1:SetText(name)
        
        if (GetGuildInfo(unit)) then
            if (GetGuildInfo(unit) == GetGuildInfo('player') and IsInGuild('player')) then
               GameTooltipTextLeft2:SetText('|cffFF66CC'..GameTooltipTextLeft2:GetText()..'|r')
            end
        end

        for i = 2, GameTooltip:NumLines() do
            if (_G['GameTooltipTextLeft'..i]:GetText():find('^'..TOOLTIP_UNIT_LEVEL:gsub('%%s', '.+'))) then
                _G['GameTooltipTextLeft'..i]:SetText(GameTooltip_UnitType(unit))
            end
        end
        
        if ( UnitExists(unit .. 'target') ) then
			if ( UnitName('player') == unitTargetName ) then
				self:AddLine('|cffff00ff' .. string.upper(YOU) .. '|r', 1, 1, 1)
			else
				if UnitIsPlayer(unit .. 'target') then
					self:AddLine(format('|cff%02x%02x%02x%s|r', unitTargetClassColor.r*255, unitTargetClassColor.g*255, unitTargetClassColor.b*255, unitTargetName), 1, 1, 1)
				else
					self:AddLine(format('|cff%02x%02x%02x%s|r', unitTargetReactionColor.r*255, unitTargetReactionColor.g*255, unitTargetReactionColor.b*255, unitTargetName), 1, 1, 1)
				end
			end
		end

		for i = 3, GameTooltip:NumLines() do
			if (_G['GameTooltipTextLeft'..i]:GetText():find(PVP_ENABLED)) then
				_G['GameTooltipTextLeft'..i]:SetText(nil)
                if (UnitIsPVPFreeForAll(unit)) then
                    GameTooltipTextLeft1:SetText('|cffFF0000# |r'..GameTooltipTextLeft1:GetText())
                elseif (UnitIsPVP(unit)) then
                    GameTooltipTextLeft1:SetText('|cff00FF00# |r'..GameTooltipTextLeft1:GetText())
                end
			end
		end
        
        if (GetRaidTargetIndex(unit) and not UnitIsDead(unit)) then
           GameTooltipTextLeft1:SetText('   '..GameTooltipTextLeft1:GetText())
            self.Icon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcon_'..GetRaidTargetIndex(unit))
        end

        if (UnitIsAFK(unit)) then 
            self:AppendText(' |cffffffff[|r|cff00ff00AFK|r|cffffffff]|r')   
        elseif (UnitIsDND(unit)) then
            self:AppendText(' |cffffffff[|r|cff00ff00DND|r|cffffffff]|r')
        end

        if (realm and realm ~= '') then
            self:AppendText(' (*)')
        end
        
        if (UnitIsDead(unit) or UnitIsGhost(unit)) then
            GameTooltipStatusBar:SetBackdropColor(0.5, 0.5, 0.5, 0.35)
        else
            GameTooltipStatusBar:SetBackdropColor(27/255, 243/255, 27/255, 0.35)
        end

        self:AddLine(' ')
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint('LEFT', self:GetName()..'TextLeft'..self:NumLines(), 1, -3)
        GameTooltipStatusBar:SetPoint('RIGHT', self, -10, 0)
		
		--update HP value on status bar
		GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
			if not value then
				return
			end
			local min, max = self:GetMinMaxValues()
			
			if (value < min) or (value > max) then
				return
			end
			local _, unit = GameTooltip:GetUnit()
			
			-- fix target of target returning nil
			if (not unit) then
				local GMF = GetMouseFocus()
				unit = GMF and GMF:GetAttribute("unit")
			end

			if not self.text then
				self.text = self:CreateFontString(nil, 'LOW')
				self.text:SetPoint('CENTER', GameTooltipStatusBar, 0, 0)
				self.text:SetFont('Fonts\\ARIALN.ttf', 13, 'THINOUTLINE')
				self.text:Show()
				if unit then
					min, max = UnitHealth(unit), UnitHealthMax(unit)
					local hp = ShortValue(min).." / "..ShortValue(max)
					if UnitIsGhost(unit) then
						self.text:SetText('Ghost')
					elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
						self.text:SetText('Dead')
					else
						self.text:SetText(hp)
					end
				end
			else
				if unit then
					min, max = UnitHealth(unit), UnitHealthMax(unit)
					self.text:Show()
					local hp = ShortValue(min).." / "..ShortValue(max)
					if UnitIsGhost(unit) then
						self.text:SetText('Ghost')
					elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
						self.text:SetText('Dead')
					else
						self.text:SetText(hp)
					end
				else
					self.text:Hide()
				end
			end
		end)
		
    end
end)


