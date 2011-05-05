    
    --
    -- original by shNameplates - cealNameplates, heavy modified by Neal aka Neav
    --
    
    -- local stuff for faster usage
    
local SetCVar = _G.SetCVar
local ColorBorder = _G.ColorBorder
local CreateBorder = _G.CreateBorder
local SetBorderTexture = _G.SetBorderTexture

    -- import globals for faster usage
    
local modf = math.modf
local len = string.len
local sub = string.sub
local find = string.find
local gsub = string.gsub
local floor = math.floor
local upper = string.upper
local lower = string.lower
local format = string.format

local type = type
local select = select
local unpack = unpack
local tonumber = tonumber

    -- import functions for faster usage
    
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitIsPVP = UnitIsPVP
local UnitIsEnemy = UnitIsEnemy
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local overlayRegion = overlayRegion

    -- load texture paths locally
    
local whiteTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'

-- SetCVar('bloattest', 0)
-- SetCVar('bloatnameplates', 0) 
-- SetCVar('bloatthreat', 0)

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
    
	if (tname == self.oldname:GetText()) then
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

local function SetHealtText(self)
	local min, max = self.HealthBar:GetMinMaxValues()
	local currentValue = self.HealthBar:GetValue()
	local perc = (currentValue/max)*100	

    if (perc >= 100) then
        self.HealtValue:SetFormattedText('%s', FormatValue(currentValue))		
    elseif (perc < 100) then
        self.HealtValue:SetFormattedText('%s - %.1f%%', FormatValue(currentValue), perc)
    else
        self.HealtValue:SetText('')
    end
end

local function UpdateTime(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	local castname = UnitCastingInfo('target') or UnitChannelInfo('target')
    
	if (self.channeling) then
		self.CastTime:SetFormattedText('%.1fs', curValue)
	else
		self.CastTime:SetFormattedText('%.1fs', maxValue - curValue)
	end	
    
	self.CastName:SetText(castname)
end

local function ThreatUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if (self.elapsed >= 0.15) then
        SetHealtText(self)
        
		if (not self.oldglow:IsShown()) then
			if (IsTarget(self)) then
                self.HealthBar:SetBorderTexture(whiteTexture)
				self.HealthBar:SetBorderColor(1, 1, 0)  		
			else
                self.HealthBar:SetBorderTexture(normalTexture)
				self.HealthBar:SetBorderColor(1, 1, 1)  
			end
		else			
			local r, g, b = self.oldglow:GetVertexColor()
            self.HealthBar:SetBorderTexture(whiteTexture)
            self.HealthBar:SetBorderColor(r, g, b)			
		end
        
		self.elapsed = 0
	end
end

local function ColorHealthBar(self)
    local r, g, b = self:GetStatusBarColor()
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
        
    self:SetStatusBarColor(newr, newg, newb)
    self:SetBackdropColor(newr * 0.2, newg * 0.2, newb * 0.2, 0.5)
end

local function UpdatePlate(self)
    SetHealtText(self)
    ColorHealthBar(self.HealthBar)

	if (self.CastBar:IsShown()) then 
        self.CastBar:Hide() 
    end
    
    local r, g, b = self.HealthBar:GetStatusBarColor()
	self.CastBar.IconOverlay:SetVertexColor(r, g, b)

	self.HealthBar:ClearAllPoints()
	self.HealthBar:SetPoint('CENTER', self.HealthBar:GetParent())
	self.HealthBar:SetSize(115, 11)
	self.HealthBar:SetAlpha(1)
    
	self.CastBar:ClearAllPoints()
	self.CastBar:SetPoint('TOP', self.HealthBar, 'BOTTOM', 0, -8)	
	self.CastBar:SetSize(115, 11)
    
	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.HealthBar)
        
        -- shorter names
        
	local oldName = self.oldname:GetText()
	local newName = (len(oldName) > 20) and gsub(oldName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or oldName
    -- self.name:SetText(newName) 
    
    self.level:ClearAllPoints()
    self.level:SetPoint('CENTER', self.HealthBar, 'CENTER', 0, 10)
    self.level:SetSize(134, 13)
    
	local level, elite = tonumber(self.level:GetText()), self.elite:IsShown()
	if (self.boss:IsShown()) then
		self.level:SetText('?? |cffffffff'..newName)
		self.level:SetTextColor(1, 0, 0)
		self.level:Show()
	elseif (self.elite:IsVisible() and (not self.elite:GetTexture() == 'Interface\\Tooltips\\EliteNameplateIcon')) then
		self.level:SetText('(r)'..level..' |cffffffff'..newName)
	else
		self.level:SetText((elite and '+' or '')..level..' |cffffffff'..newName)
	end	
end

local function FixCastbar(self)
	self.castbarOverlay:Hide()	
	self:SetHeight(11)
	self:ClearAllPoints()
	self:SetPoint('TOP', self.HealthBar, 'BOTTOM', 0, -8)	
end

local function ColorCastBar(self, shield)		
	if (shield) then
        self:SetBorderTexture(whiteTexture)
        self:SetBorderColor(1, 0, 1)  	
        self.CastTime:SetTextColor(1, 0, 1)
    else
        self:SetBorderTexture(normalTexture)
        self:SetBorderColor(1, 1, 1)  
        self.CastTime:SetTextColor(1, 1, 1)
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
	self.channeling = UnitChannelInfo('target')
	self.IconOverlay:Show()	
    
    FixCastbar(self)	
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
	frame.HealthBar, frame.CastBar = frame:GetChildren()
    
	local HealthBar, CastBar = frame.HealthBar, frame.CastBar
    local _, castbarOverlay, shieldedRegion, spellIconRegion = CastBar:GetRegions()
	local glowRegion, overlayRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, eliteIconRegion = frame:GetRegions()
	
        -- fake hide all unwanted texture
        
	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	eliteIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)
    
        -- hide original name font string
        
	nameTextRegion:Hide()
    
        -- create the healtbar border and background
    
    if (not HealthBar.hasBorder) then
        HealthBar:CreateBorder(8)
        HealthBar:SetBorderPadding(3)
        
        for i = 1, 8 do 
            HealthBar.beautyBorder[i]:SetDrawLayer('BORDER')
        end
    
        HealthBar.hasBorder = true
    end
    
    frame.HealthBar:SetScript('OnValueChanged', ColorHealthBar)
    HealthBar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })

    --[[
	frame.name = frame:CreateFontString(nil, 'OVERLAY')
	frame.name:SetParent(HealthBar)
	frame.name:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
    frame.name:SetShadowOffset(0, 0)
    frame.name:SetPoint('CENTER', HealthBar, 'CENTER', 0, 10)
    --]]
        
        -- create health value font string
        
	frame.HealtValue = frame:CreateFontString()
	frame.HealtValue:SetPoint('CENTER', HealthBar, 0, 0)
    frame.HealtValue:SetFont('Fonts\\ARIALN.ttf', 9.5)--, 'THINOUTLINE')
    frame.HealtValue:SetShadowOffset(1, -1)
        
        -- the level text string, we abuse it as namestring too
        
	levelTextRegion:SetFont('Fonts\\ARIALN.ttf', 10)--, 'THINOUTLINE')
    levelTextRegion:SetDrawLayer('ARTWORK')
	levelTextRegion:SetShadowOffset(1, -1)
    frame.level = levelTextRegion
    
        -- create castbar borders
        
    if (not CastBar.hasBorder) then
        CastBar:CreateBorder(8)
        CastBar:SetBorderPadding(3)
        
        for i = 1, 8 do 
            CastBar.beautyBorder[i]:SetDrawLayer('BORDER')
        end
    
        CastBar.hasBorder = true
    end    
        
	CastBar.castbarOverlay = castbarOverlay
	CastBar.HealthBar = HealthBar
	CastBar.shieldedRegion = shieldedRegion
    
        -- castbar
        
    CastBar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    CastBar:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
    
	CastBar:HookScript('OnShow', OnShow)
	CastBar:HookScript('OnSizeChanged', OnSizeChanged)
	CastBar:HookScript('OnValueChanged', OnValueChanged)
	CastBar:HookScript('OnEvent', OnEvent)
	CastBar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
	CastBar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
    
        -- castbar time font string
        
    CastBar.CastTime = CastBar:CreateFontString(nil, 'OVERLAY')
	CastBar.CastTime:SetPoint('RIGHT', CastBar, 'RIGHT', 5, 0)
	CastBar.CastTime:SetFont('Fonts\\ARIALN.ttf', 21)   -- , 'THINOUTLINE')
	CastBar.CastTime:SetTextColor(1, 1, 1)
    CastBar.CastTime:SetShadowOffset(1, -1)
    
        -- castbar name font string
    
	CastBar.CastName = CastBar:CreateFontString(nil, 'OVERLAY')
	CastBar.CastName:SetPoint('LEFT', CastBar, 3, 0)
    CastBar.CastName:SetPoint('RIGHT', CastBar.CastTime, 'LEFT', -6, 0)
	CastBar.CastName:SetFont('Fonts\\ARIALN.ttf', 10)
	CastBar.CastName:SetTextColor(1, 1, 1)
	CastBar.CastName:SetShadowOffset(1, -1)
    CastBar.CastName:SetJustifyH('LEFT')

        -- castbar spellicon
        
	CastBar.SpellIcon = spellIconRegion
    CastBar.SpellIcon:SetParent(CastBar)
	CastBar.SpellIcon:ClearAllPoints()
	CastBar.SpellIcon:SetPoint('BOTTOMLEFT', CastBar, 'BOTTOMRIGHT', 7, 3)
	CastBar.SpellIcon:SetSize(24, 24)
    CastBar.SpellIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    CastBar.IconOverlay = CastBar:CreateTexture(nil, 'OVERLAY')
	CastBar.IconOverlay:SetPoint('TOPLEFT', CastBar.SpellIcon, -1, 1)
	CastBar.IconOverlay:SetPoint('BOTTOMRIGHT', CastBar.SpellIcon, 1, -1)
	CastBar.IconOverlay:SetTexture(whiteTexture)
    
        -- mouseover highlight
        
	highlightRegion:SetTexture('Interface\\Buttons\\WHITE8x8')
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25, 0.8)
	frame.highlight = highlightRegion

        -- raidicons

	raidIconRegion:ClearAllPoints()
    raidIconRegion:SetDrawLayer('OVERLAY')
	raidIconRegion:SetPoint('CENTER', HealthBar, 'TOP', 0, 12)
	raidIconRegion:SetSize(16, 16)
    
        -- use these old frames for some functions
        
    frame.oldname = nameTextRegion
	frame.oldglow = glowRegion
    
        -- elite and bossicon, dont need them but use it for other funtions
        
	frame.elite = eliteIconRegion
	frame.boss = bossIconRegion
		
        -- nameplates like cookies
        
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

    -- scan the worldframe for nameplates
    
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