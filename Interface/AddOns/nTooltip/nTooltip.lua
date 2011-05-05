
    -- import globals for faster usage
    
local _G = _G
local select = select

    -- import functions for faster usage
    
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitExists = UnitExists
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitFactionGroup = UnitFactionGroup
local UnitCreatureType = UnitCreatureType
local GetQuestDifficultyColor = GetQuestDifficultyColor

    -- font settings
    
GameTooltipHeaderText:SetFont('Fonts\\ARIALN.ttf', 17)
GameTooltipText:SetFont('Fonts\\ARIALN.ttf', 15)
GameTooltipTextSmall:SetFont('Fonts\\ARIALN.ttf', 15)
    
    -- healthbar settings
    
GameTooltipStatusBar:SetHeight(7)
GameTooltipStatusBar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    
    -- load texture paths locally
    
local whiteTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'
    
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
    
    self:HookScript('OnShow', function(self)
        self:SetBackdropColor(0, 0, 0, 0.70)
    end)
    
    self:CreateBorder(bsize)
end

hooksecurefunc('GameTooltip_ShowCompareItem', function(self)  
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
    
    -- tooltips like cookies!
    
for _, tooltip in pairs({
    GameTooltip,
    ItemRefTooltip,
   
    ShoppingTooltip1,
    ShoppingTooltip2,
    ShoppingTooltip3,   
    
    WorldMapTooltip,
 
    DropDownList1MenuBackdrop,
    DropDownList2MenuBackdrop,
    
    ConsolidatedBuffsTooltip,
    
    ChatMenu,
    EmoteMenu,
    LanguageMenu,
    VoiceMacroMenu,
}) do
    ApplyTooltipStyle(tooltip)
end

    -- itemquaility border, we use our beautycase functions
    
if (nTooltip.itemqualityBorderColor) then
    for _, tooltip in pairs({
        GameTooltip,
        ItemRefTooltip,
       
        ShoppingTooltip1,
        ShoppingTooltip2,
        ShoppingTooltip3,   
    }) do
        tooltip:HookScript('OnTooltipSetItem', function(self)
            local name, item = self:GetItem()
                
            if (item) then
                local quality = select(3, GetItemInfo(item))
                    
                if (quality) then
                    local r, g, b = GetItemQualityColor(quality)
                    self:SetBorderTexture(whiteTexture)
                    self:SetBorderColor(r, g, b)
                end
            end
        end)
        
        tooltip:HookScript('OnTooltipCleared', function(self)
            self:SetBorderTexture(normalTexture)
            self:SetBorderColor(1, 1, 1)
        end)
    end
end

    -- make sure we get a unit
    
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

local function GameTooltip_GetUnitPVPIcon(unit) 
    local factionGroup = UnitFactionGroup(unit)
    if (UnitIsPVPFreeForAll(unit)) then
        return 'Interface\\TargetingFrame\\UI-PVP-FFA'
    elseif (factionGroup and UnitIsPVP(unit)) then
        return 'Interface\\TargetingFrame\\UI-PVP-'..factionGroup
    else
        return ''
    end
end
        
    -- create some icons, they dont like cookies
    
GameTooltip.Icon = GameTooltip:CreateTexture('$parentRaidIcon', 'OVERLAY')
GameTooltip.Icon:SetPoint('TOPLEFT', GameTooltip, 10, -11)
GameTooltip.Icon:SetSize(14, 14)

if (nTooltip.showMouseoverTarget) then
    GameTooltip.TargetIcon = GameTooltip:CreateTexture('$parentRaidIcon', 'OVERLAY')
    GameTooltip.TargetIcon:SetSize(12, 12)
end

if (nTooltip.showPVPIcons) then
    GameTooltip.PVPIcon = GameTooltip:CreateTexture('$parentRaidIcon', 'OVERLAY')
    GameTooltip.PVPIcon:SetSize(45, 45)
end

    -- tooltip position
    
hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self)
	self:SetPoint(unpack(nTooltip.position))
end)

    -- set all to the defaults if tooltip hides
    
GameTooltip:HookScript('OnTooltipCleared', function(self)
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 2, -2)
    GameTooltipStatusBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -2, -2)
    
    if (GameTooltip.PVPIcon) then
        GameTooltip.PVPIcon:SetTexture(nil)
    end
    
    if (self.TargetIcon) then
        self.Icon:SetTexture(nil)
    end
    
    if (self.TargetIcon) then
        self.TargetIcon:SetTexture(nil)
    end
    
    if (nTooltip.reactionBorderColor) then
        self:SetBorderTexture(normalTexture)
        self:SetBorderColor(1, 1, 1)
    end
end)

    -- healthbar coloring funtion
    
local function HealthBarColor(unit)
    local r, g, b

    if (nTooltip.healthbar.customColor.apply and not nTooltip.healthbar.reactionColoring) then
        r, g, b = nTooltip.healthbar.customColor.r, nTooltip.healthbar.customColor.g, nTooltip.healthbar.customColor.b
    elseif (nTooltip.healthbar.reactionColoring) then
        r, g, b = UnitSelectionColor(unit)
    else
        r, g, b = 0, 1, 0
    end
    
    GameTooltipStatusBar:SetStatusBarColor(r, g, b)
    GameTooltipStatusBar:SetBackdropColor(r, g, b, 0.3)
end

    -- itemlvl (by Gsuz) - http://www.tukui.org/forums/topic.php?id=10151

local SlotName = {
        'Head',
        'Neck',
        'Shoulder',
        'Back',
        'Chest',
        'Wrist',
        'Hands',
        'Waist',
        'Legs',
        'Feet',
        'Finger0',
        'Finger1',
        'Trinket0',
        'Trinket1',
        'MainHand',
        'SecondaryHand',
        'Ranged',
        'Ammo'
    }

local function GetItemLVL(unit)
    local total, item = 0, 0
    for i, v in pairs(SlotName) do
        local slot = GetInventoryItemLink(unit, GetInventorySlotInfo(SlotName[i] .. 'Slot'))
        if (slot ~= nil) then
            item = item + 1
            total = total + select(4, GetItemInfo(slot))
        end
    end
        
    if (item > 0) then
        return floor(total / item)
    end
    
    return 0
end

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

GameTooltip:HookScript('OnTooltipSetUnit', function(self, ...)
    local unit = GameTooltip_GetUnit(self)
            
	if (UnitExists(unit) and UnitName(unit) ~= UNKNOWN) then
        local name, realm = UnitName(unit)
        
            -- hide player titles
            
        if (nTooltip.showPlayerTitles) then
            if (UnitPVPName(unit)) then 
                name = UnitPVPName(unit) 
            end
        end
        
        GameTooltipTextLeft1:SetText(name)
        
            -- color guildnames
            
        if (GetGuildInfo(unit)) then
            if (GetGuildInfo(unit) == GetGuildInfo('player') and IsInGuild('player')) then
               GameTooltipTextLeft2:SetText('|cffFF66CC'..GameTooltipTextLeft2:GetText()..'|r')
            end
        end
            
            -- tooltip level text
            
        for i = 2, GameTooltip:NumLines() do
            if (_G['GameTooltipTextLeft'..i]:GetText():find('^'..TOOLTIP_UNIT_LEVEL:gsub('%%s', '.+'))) then
                _G['GameTooltipTextLeft'..i]:SetText(GameTooltip_UnitType(unit))
            end
        end
        
            -- mouse over target with raidicon support
            
        if (nTooltip.showMouseoverTarget) then
            local unitTargetName = UnitName(unit .. 'target');
            local unitTargetClassColor = RAID_CLASS_COLORS[select(2, UnitClass(unit .. 'target'))] or { r = 1, g = 0, b = 1 }
            local unitTargetReactionColor = { 
                r = select(1, UnitSelectionColor(unit .. 'target')), 
                g = select(2, UnitSelectionColor(unit .. 'target')), 
                b = select(3, UnitSelectionColor(unit .. 'target')) 
            }
        
            if (UnitExists(unit..'target')) then
                if (UnitName('player') == unitTargetName) then
                    self:AddLine(format('  |cffff00ff%s|r', string.upper(YOU)), 1, 1, 1)
                else
                    if (UnitIsPlayer(unit .. 'target')) then
                        if (GetRaidTargetIndex(unit .. 'target') and not UnitIsDead(unit .. 'target')) then
                            self:AddLine(format('     |cff%02x%02x%02x%s|r', unitTargetClassColor.r*255, unitTargetClassColor.g*255, unitTargetClassColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)
                            for i = 3, GameTooltip:NumLines() do
                                if (_G['GameTooltipTextLeft'..i]:GetText():find(unitTargetName)) then
                                        
                                    self.TargetIcon:SetPoint('LEFT', _G['GameTooltipTextLeft'..i], 10, 0)
                                    self.TargetIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcon_'..GetRaidTargetIndex(unit .. 'target'))      
                                end
                            end
                       else
                            self:AddLine(format('  |cff%02x%02x%02x%s|r', unitTargetClassColor.r*255, unitTargetClassColor.g*255, unitTargetClassColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)
                        end
                    else
                        if (GetRaidTargetIndex(unit .. 'target') and not UnitIsDead(unit .. 'target')) then
                            self:AddLine(format('     |cff%02x%02x%02x%s|r', unitTargetReactionColor.r*255, unitTargetReactionColor.g*255, unitTargetReactionColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)                 
                            for i = 3, GameTooltip:NumLines() do
                                if (_G['GameTooltipTextLeft'..i]:GetText():find(unitTargetName)) then
                                    self.TargetIcon:SetPoint('LEFT', _G['GameTooltipTextLeft'..i], 10, 0)
                                    self.TargetIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcon_'..GetRaidTargetIndex(unit .. 'target'))         
                                end
                            end 
                       else
                            self:AddLine(format('  |cff%02x%02x%02x%s|r', unitTargetReactionColor.r*255, unitTargetReactionColor.g*255, unitTargetReactionColor.b*255, unitTargetName:sub(1, 40)), 1, 1, 1)
                        end
                    end
                end
            end
        end

            -- raid icon
            
        if (GetRaidTargetIndex(unit) and not UnitIsDead(unit)) then
            GameTooltipTextLeft1:SetText('   '..GameTooltipTextLeft1:GetText())
            self.Icon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcon_'..GetRaidTargetIndex(unit))
        end
                
            -- pvp flag prefix 
            
		for i = 3, GameTooltip:NumLines() do
			if (_G['GameTooltipTextLeft'..i]:GetText():find(PVP_ENABLED)) then
				_G['GameTooltipTextLeft'..i]:SetText(nil)
                if (nTooltip.showPVPIcons) then
                    if (GetRaidTargetIndex(unit) and not UnitIsDead(unit)) then
                        GameTooltipTextLeft1:SetText('    '..GameTooltipTextLeft1:GetText())
                        GameTooltip.PVPIcon:ClearAllPoints()
                        GameTooltip.PVPIcon:SetPoint('TOPLEFT', GameTooltip, 24, -4)
                    else
                        GameTooltipTextLeft1:SetText('   '..GameTooltipTextLeft1:GetText())
                        GameTooltip.PVPIcon:ClearAllPoints()
                        GameTooltip.PVPIcon:SetPoint('TOPLEFT', GameTooltip, 2, -4)
                    end
                    GameTooltip.PVPIcon:SetTexture(GameTooltip_GetUnitPVPIcon(unit))
                else
                    if (UnitIsPVPFreeForAll(unit)) then
                        GameTooltipTextLeft1:SetText('|cffFF0000# |r'..GameTooltipTextLeft1:GetText())
                    elseif (UnitIsPVP(unit)) then
                        GameTooltipTextLeft1:SetText('|cff00FF00# |r'..GameTooltipTextLeft1:GetText())
                    end
                end
			end
		end
        
            -- afk and dnd prefix

        if (UnitIsAFK(unit)) then 
            self:AppendText(' |cffffffff[|r|cff00ff00AFK|r|cffffffff]|r')   
        elseif (UnitIsDND(unit)) then
            self:AppendText(' |cffffffff[|r|cff00ff00DND|r|cffffffff]|r')
        end

            -- player realm names
            
        if (realm and realm ~= '') then
            if (nTooltip.abbrevRealmNames)   then
                self:AppendText(' (*)')
            else
                self:AppendText(' - '..realm)
            end
        end

            -- move the healthbar inside the tooltip
            
        self:AddLine(' ')
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint('LEFT', self:GetName()..'TextLeft'..self:NumLines(), 1, -3)
        GameTooltipStatusBar:SetPoint('RIGHT', self, -10, 0)
        
            -- show player item lvl
            
        if (nTooltip.showItemLevel) then
            if (unit and CanInspect(unit)) then
                if (not ((InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown()))) then
                    NotifyInspect(unit)
                    GameTooltip:AddLine('Item Level: ' .. GetItemLVL(unit));
                    ClearInspectPlayer(unit)
                end
            end
        end
        
            -- border coloring
            
        if (nTooltip.reactionBorderColor) then
            local r, g, b = UnitSelectionColor(unit)
            
            self:SetBorderTexture(whiteTexture)
            self:SetBorderColor(r, g, b)
        end
        
            -- dead or ghost recoloring
            
        if (UnitIsDead(unit) or UnitIsGhost(unit)) then
            GameTooltipStatusBar:SetBackdropColor(0.5, 0.5, 0.5, 0.3)
        else
            if (not nTooltip.healthbar.customColor.apply and not nTooltip.healthbar.reactionColoring) then
                GameTooltipStatusBar:SetBackdropColor(27/255, 243/255, 27/255, 0.3)
            else
                HealthBarColor(unit)
            end
        end

            -- tooltip HP bar & value
            
        if (not GameTooltipStatusBar.hasHealthText and nTooltip.healthbar.showHealthValue or nTooltip.healthbar.customColor.apply or nTooltip.healthbar.reactionColoring) then
            GameTooltipStatusBar:SetScript('OnValueChanged', function(self, value)
                if (not value) then
                    return
                end
                
                local min, max = self:GetMinMaxValues()
                
                if (value < min) or (value > max) then
                    return
                end
                
                local _, unit = GameTooltip:GetUnit()

                if (not unit) then
                    unit = GetMouseFocus() and GetMouseFocus():GetAttribute('unit')
                end
                
                    -- custom healthbar coloring
                    
                HealthBarColor(unit)
                
                if (not GameTooltipStatusBar.hasHealthText and nTooltip.healthbar.showHealthValue) then
                    if (not self.text) then
                        self.text = self:CreateFontString(nil, 'MEDIUM')
                        
                        if (nTooltip.healthbar.textPos == 'TOP') then
                            self.text:SetPoint('RIGHT', GameTooltipStatusBar, 'TOPRIGHT', -10, 1)
                            self.text:SetPoint('LEFT', GameTooltipStatusBar, 'TOPLEFT', 10, 1)
                        elseif (nTooltip.healthbar.textPos == 'BOTTOM') then
                            self.text:SetPoint('RIGHT', GameTooltipStatusBar, 'BOTTOMRIGHT', -10, 1)
                            self.text:SetPoint('LEFT', GameTooltipStatusBar, 'BOTTOMLEFT', 10, 1)
                        else
                            self.text:SetPoint('RIGHT', GameTooltipStatusBar, 'RIGHT', -10, 1)
                            self.text:SetPoint('LEFT', GameTooltipStatusBar, 'LEFT', 10, 1)
                        end
                        
                        if (nTooltip.healthbar.showOutline) then
                            self.text:SetFont(nTooltip.healthbar.font, nTooltip.healthbar.fontSize, 'THINOUTLINE')
                            self.text:SetShadowOffset(0, 0)
                        else
                            self.text:SetFont(nTooltip.healthbar.font, nTooltip.healthbar.fontSize)
                            self.text:SetShadowOffset(1, -1)
                        end
                        
                        self.text:Show()
                    end
                    
                    if (unit and self.text) then
                        min = UnitHealth(unit)
                        max = UnitHealthMax(unit)
                        local hp = ShortValue(min)..' / '..ShortValue(max)
                            
                        if (UnitIsGhost(unit)) then
                            self.text:SetText('Ghost')
                        elseif (min == 0 or UnitIsDead(unit) or UnitIsGhost(unit)) then
                            self.text:SetText('Dead')
                        else
                            self.text:SetText(hp)
                        end
                    end
                    
                    self.hasHealthText = true
                end
            end)
        end
    end
end)

    -- disable fade
    
if (nTooltip.disableFade) then
    GameTooltip.UpdateTime = 0
    GameTooltip:HookScript('OnUpdate', function(self, elapsed)
        self.UpdateTime = self.UpdateTime + elapsed
        if (self.UpdateTime > TOOLTIP_UPDATE_TIME) then
            self.UpdateTime = 0
            if (GetMouseFocus() == WorldFrame and (not UnitExists('mouseover'))) then
                self:Hide()
            end
        end
    end)
end

