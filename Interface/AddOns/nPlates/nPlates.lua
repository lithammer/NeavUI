    
    --
    -- original by shNameplates - cealNameplates, heavy modified by Neal aka Neav
    --
    
    -- local stuff for faster usage
    
local SetCVar = SetCVar

local modf = math.modf
local len = string.len
local sub = string.sub
local find = string.find
local gsub = string.gsub
local floor = math.floor
local upper = string.upper
local lower = string.lower

local type = type
local format = format
local select = select
local unpack = unpack
local tonumber = tonumber

local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitIsPVP = UnitIsPVP
local UnitIsEnemy = UnitIsEnemy
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local overlayRegion = overlayRegion

local whiteTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'

SetCVar('bloattest', 0)
SetCVar('bloatnameplates', 0) 
SetCVar('bloatthreat', 0)

local function IsValidFrame(frame)
	if (frame:GetName() and not find(frame:GetName(), '^NamePlate')) then
		return false
	end
    
	overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == 'Texture' and overlayRegion:GetTexture() == [=[Interface\Tooltips\Nameplate-Border]=] 
end

local function round(num, idp)
	return tonumber(format('%.' .. (idp or 0) .. 'f', num))
end

local function IsTarget(self) 
	local tname = UnitName('target')
	if (tname == self.name:GetText()) then
		return true
	else
		return false
	end
end

local function FormatValue(number)
	if (number >= 1e6) then
		return round(number/1e6, 1)..'m'
	elseif (number >= 1e3) then
		return round(number/1e3, 1)..'k'
	else
		return number
	end
end

local function showHealth(self)
	local min, max = self.healthBar:GetMinMaxValues()
	local currentValue = self.healthBar:GetValue()
	local perc = (currentValue/max)*100	

    if (perc >= 100) then
        self.hp:SetFormattedText('%s', FormatValue(currentValue))		
    elseif (perc < 100) then
        self.hp:SetFormattedText('%s - %.1f%%', FormatValue(currentValue), perc)
    else
        self.hp:SetText('')
    end
end

local function UpdateTime(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	local castname = UnitCastingInfo('target') or UnitChannelInfo('target')
    
	if (self.channeling) then
		self.time:SetFormattedText('%.1fs', curValue)
	else
		self.time:SetFormattedText('%.1fs', maxValue - curValue)
	end	
    
	self.cname:SetText(castname)
end

local function ThreatUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if (self.elapsed >= 0.15) then
        showHealth(self)
        
		if (not self.oldglow:IsShown()) then
			if (IsTarget(self)) then
                self.healthBar:SetBorderTexture(whiteTexture)
				self.healthBar:SetBorderColor(1, 1, 0)  		
			else
                self.healthBar:SetBorderTexture(normalTexture)
				self.healthBar:SetBorderColor(1, 1, 1)  
			end
		else			
			local r, g, b = self.oldglow:GetVertexColor()
            self.healthBar:SetBorderTexture(whiteTexture)
            self.healthBar:SetBorderColor(r, g, b)			
		end
        
		self.elapsed = 0
	end
end

local function UpdatePlate(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb

	if (g + b == 0) then
		-- Hostile unit
		newr, newg, newb = 0.9, 0.2, 0
	elseif (r + b == 0) then
		-- Friendly unit
		newr, newg, newb = 0.2, 1, 0
	elseif (r + g == 0) then
		-- Friendly player
		newr, newg, newb = 0, 0.35, 1
	elseif (2 - (r + g) < 0.05 and b == 0) then
		-- Neutral unit
		newr, newg, newb = 1, 1, 0
	else
		-- Hostile player - class colored.
		newr, newg, newb = r, g, b
	end
    
    self.healthBar:SetStatusBarColor(newr, newg, newb)
    
	self.r, self.g, self.b = newr, newg, newb
	
	if (self.castBar:IsShown()) then 
        self.castBar:Hide() 
    end
	
	showHealth(self)
	
	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint('CENTER', self.healthBar:GetParent(), 0, 8)
	self.healthBar:SetSize(130, 14)
	
	self.healthBar:SetBackdropColor(self.r * 0.3, self.g * 0.3, self.b * 0.3, 0.7)
    
	self.castBar:ClearAllPoints()
	self.castBar:SetPoint('TOP', self.healthBar, 'BOTTOM', 0, -7)	
	self.castBar:SetSize(130, 14)
    
	self.castBar.IconOverlay:SetVertexColor(self.r, self.g, self.b)
    
	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)
    
    self.level:ClearAllPoints()
    self.level:SetPoint('TOPLEFT', self.healthBar, 1, 8)
        
    self.name:ClearAllPoints()
    self.name:SetPoint('LEFT', self.level, 'RIGHT', 1, 0)
    
        -- shorter names
        
	local oldName = self.oldname:GetText()
	local newName = (len(oldName) > 20) and gsub(oldName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or oldName
    self.name:SetText(newName) 
    
	local level, elite = tonumber(self.level:GetText()), self.elite:IsShown()
	if (self.boss:IsShown()) then
		self.level:SetText('?? ')
		self.level:SetTextColor(1, 0, 0)
		self.level:Show()
	elseif (self.elite:IsVisible() and (not self.elite:GetTexture() == 'Interface\\Tooltips\\EliteNameplateIcon')) then
		self.level:SetText('(r)'..level)
	else
		self.level:SetText((elite and '+' or '')..level)
	end	
end

local function FixCastbar(self)
	self.castbarOverlay:Hide()	
	self:SetHeight(14)
	self:ClearAllPoints()
	self:SetPoint('TOP', self.healthBar, 'BOTTOM', 0, -7)	
end

local function ColorCastBar(self, shield)		
	if (shield) then
        self:SetBorderTexture(whiteTexture)
        self:SetBorderColor(1, 0, 1)  	
        self.time:SetTextColor(1, 0, 1)
    else
        self:SetBorderTexture(normalTexture)
        self:SetBorderColor(1, 1, 1)  
        self.time:SetTextColor(1, 1, 1)
	end
end

local function OnSizeChanged(self)
	self.needFix = true
end

local function OnValueChanged(self, curValue)
	UpdateTime(self, curValue)
    
	if (self.needFix) then
		FixCastbar(self)
		self.needFix = nil
	end
end

local function OnShow(self)
	FixCastbar(self)		
    
	self.channeling = UnitChannelInfo('target')
	self.IconOverlay:Show()	
    
	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local function OnEvent(self, event, unit)
	if (unit == 'target') then
		if (self:IsShown()) then
			ColorCastBar(self, event == 'UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
		end
	end
end

local function CreatePlate(frame)
	if (frame.done) then
		return
	end

	frame.nameplate = true
	frame.healthBar, frame.castBar = frame:GetChildren()
    
	local healthBar, castBar = frame.healthBar, frame.castBar
    local _, castbarOverlay, shieldedRegion, spellIconRegion = castBar:GetRegions()
	local glowRegion, overlayRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
	
	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)
	
    if (not healthBar.hasBorder) then
        healthBar:CreateBorder(9)
        healthBar:SetBorderPadding(2)
        healthBar.hasBorder = true
    end
    
    healthBar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    
    --[[
    for i = 1, 8 do 
        healthBar.Border[i]:SetDrawLayer('ARTWORK')
    end
    --]]
    
    frame.oldname = nameTextRegion
	nameTextRegion:Hide()
    
	local newNameRegion = frame:CreateFontString(nil, 'OVERLAY')
	newNameRegion:SetParent(healthBar)
	newNameRegion:SetPoint('TOPLEFT', healthBar, 18, 8)
	newNameRegion:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
    newNameRegion:SetShadowOffset(0, 0)
	frame.name = newNameRegion
    
	local hpRegion = frame:CreateFontString()
	hpRegion:SetPoint('RIGHT', healthBar, -1, 0)
    hpRegion:SetFont('Fonts\\ARIALN.ttf', 10, 'THINOUTLINE')
    hpRegion:SetShadowOffset(0, 0)
	frame.hp = hpRegion
	
	levelTextRegion:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
    levelTextRegion:SetPoint('TOPLEFT', healthBar, 0, 8)
	levelTextRegion:SetShadowOffset(0, 0)
    frame.level = levelTextRegion
    
    if (not castBar.hasBorder) then
        castBar:CreateBorder(9)
        castBar:SetBorderPadding(2)
        castBar.hasBorder = true
    end    
        
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
    
    castBar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    castBar:SetBackdropColor(0.3, 0.3, 0.3, 0.75)
    
	castBar:HookScript('OnShow', OnShow)
	castBar:HookScript('OnSizeChanged', OnSizeChanged)
	castBar:HookScript('OnValueChanged', OnValueChanged)
	castBar:HookScript('OnEvent', OnEvent)
	castBar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
	castBar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
    
    castBar.time = castBar:CreateFontString(nil, 'OVERLAY')
	castBar.time:SetPoint('RIGHT', castBar, 'RIGHT', -1, 0)
	castBar.time:SetFont('Fonts\\ARIALN.ttf', 19, 'THINOUTLINE')
	castBar.time:SetTextColor(1, 1, 1)
    castBar.time:SetShadowOffset(0, 0)
    
        -- fontstring for castnames
    
	castBar.cname = castBar:CreateFontString(nil, 'OVERLAY')
	castBar.cname:SetPoint('LEFT', castBar, 3, 0)
    castBar.cname:SetPoint('RIGHT', castBar.time, 'LEFT', -6, 0)
	castBar.cname:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
	castBar.cname:SetTextColor(1, 1, 1)
	castBar.cname:SetShadowOffset(0, 0)
    castBar.cname:SetJustifyH('LEFT')

	castBar.spellicon = spellIconRegion
    castBar.spellicon:SetParent(castBar)
	castBar.spellicon:ClearAllPoints()
	castBar.spellicon:SetPoint('BOTTOMLEFT', castBar, 'BOTTOMRIGHT', 7, 3)
	castBar.spellicon:SetSize(24, 24)
    castBar.spellicon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    castBar.IconOverlay = castBar:CreateTexture(nil, 'BACKGROUND')
	castBar.IconOverlay:SetPoint('TOPLEFT', castBar.spellicon, -1.5, 1.5)
	castBar.IconOverlay:SetPoint('BOTTOMRIGHT', castBar.spellicon, 1.5, -1.5)
	castBar.IconOverlay:SetTexture('Interface\\Buttons\\WHITE8x8')
    
	highlightRegion:SetTexture('Interface\\Buttons\\WHITE8x8')
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25, 0.8)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint('CENTER', healthBar, 0, 25)
	raidIconRegion:SetSize(24, 24)

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion
		
	frame:SetScript('OnShow', UpdatePlate)
	frame:SetScript('OnHide', function(self)
        self.highlight:Hide()
    end)
    
	frame:SetScript('OnUpdate', ThreatUpdate)
	
	frame.done = true
	frame.elapsed = 0

        -- to prevent some problems 
        
	UpdatePlate(frame)
end

local i = 0
local numKids = 0 
local frame = frame 
local lastupdate = 0
local WorldFrame = WorldFrame

local f = CreateFrame('Frame')

f:SetScript('OnUpdate', function(self, elapsed)
	lastupdate = lastupdate + elapsed
	if (lastupdate > 0.25) then
		local newNumKids = WorldFrame:GetNumChildren()
				
		if (numKids ~= newNumKids) then		
			for i = numKids + 1, newNumKids do
				frame = select(i, WorldFrame:GetChildren())
				
				if (IsValidFrame(frame)) then
					CreatePlate(frame)
				end
			end	
            
			numKids = newNumKids			
		end	
		
		lastupdate = 0
	end
end)













