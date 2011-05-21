
    -- local stuff for faster usage
    
local ColorBorder = _G.ColorBorder
local CreateBorder = _G.CreateBorder
local SetBorderTexture = _G.SetBorderTexture

    -- import globals for faster usage
    
local len = string.len
local find = string.find
local gsub = string.gsub

local select = select
local tonumber = tonumber

    -- import functions for faster usage
    
local UnitName = UnitName
local UnitIsEnemy = UnitIsEnemy
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

    -- load texture paths locally
    
local whiteTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'

-- SetCVar('bloattest', 0)
-- SetCVar('bloatnameplates', 0) 
-- SetCVar('bloatthreat', 0)

local function IsTarget(self) 
	local tname = UnitName('target')
    
	if (tname == self.oldName:GetText() and self:GetAlpha() >= 0.99) then
		return true
	else
		return false
	end
end

local function round(num, idp)
	return tonumber(format('%.'..(idp or 0)..'f', num))
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

local function UpdateHealtText(self)
	local min, max = self.HealthBar:GetMinMaxValues()
	local currentValue = self.HealthBar:GetValue()
	local perc = (currentValue/max)*100	

    if (perc >= 100 and currentValue ~= 1) then
        self.HealtValue:SetFormattedText('%s', FormatValue(currentValue))		
    elseif (perc < 100 and currentValue ~= 1) then
        self.HealtValue:SetFormattedText('%s - %.0f%%', FormatValue(currentValue), perc)
    else
        self.HealtValue:SetText('')
    end
end

local function ColorHealthBar(self)
    local r, g, b = self.HealthBar:GetStatusBarColor()

    if (r + g == 0) then
        self.HealthBar:SetStatusBarColor(0, 0.35, 1)
    end

    -- self.HealthBar:SetBackdropColor(r * 0.175, g * 0.175, b * 0.175, 0.75)
    
    UpdateHealtText(self)
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
	if (self.elapsed >= 0.1) then
        ColorHealthBar(self)

		if (not self.oldGlow:IsShown()) then
			if (IsTarget(self)) then
                self.HealthBar:SetBorderTexture(whiteTexture)
                
                -- if (UnitIsEnemy('player', 'target')) then
                    self.HealthBar:SetBorderColor(1, 1, 0)  	
                -- else
                    -- self.HealthBar:SetBorderColor(0, 1, 0)  	
                -- end
			else
                self.HealthBar:SetBorderTexture(normalTexture)
				self.HealthBar:SetBorderColor(1, 1, 1)  
			end
		else			
			local r, g, b = self.oldGlow:GetVertexColor()
            self.HealthBar:SetBorderTexture(whiteTexture)
            self.HealthBar:SetBorderColor(r, g, b)			
		end
        
		self.elapsed = 0
	end
end

local function UpdatePlate(self)
    UpdateHealtText(self)
    ColorHealthBar(self)
    
    self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.HealthBar)	   
    
    if (self.CastBar:IsShown()) then     
        self.CastBar:Hide() 
    end
    
    local r, g, b = self.HealthBar:GetStatusBarColor()
	self.CastBar.IconOverlay:SetVertexColor(r, g, b)
    
        -- shorter names
        
	local oldName = self.oldName:GetText()
	local newName = (len(oldName) > 20) and gsub(oldName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or oldName
    -- self.name:SetText(newName) 
    
    self.level:ClearAllPoints()
    self.level:SetPoint('CENTER', self.HealthBar, 'CENTER', 0, 10)
    self.level:SetSize(134, 13)
    
    if (self.level) then
        local level, elite = self.level:GetText(), self.elite:IsShown()
        
        if (self.boss:IsShown()) then
            self.level:SetFont('Fonts\\ARIALN.ttf', 12)
        else
            self.level:SetFont('Fonts\\ARIALN.ttf', 10)
        end
        
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

local function OnValueChanged(self, curValue)
	UpdateTime(self, curValue)
end

local function OnShow(self)
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

local function SkinPlate(frame)
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
        
        -- elite and bossicon, dont need them but use it for other funtions
        
	frame.elite = eliteIconRegion
	frame.boss = bossIconRegion
    
        -- use these old frames for some functions
        
    frame.oldName = nameTextRegion
	frame.oldGlow = glowRegion
    
        -- hide original name font string

	nameTextRegion:Hide()
    
        -- create the healtbar border and background
    
    if (not HealthBar.beautyBorder) then
        HealthBar:CreateBorder(7.33333)
        HealthBar:SetBorderPadding(2.666666666665)
        
        for i = 1, 8 do 
            HealthBar.beautyBorder[i]:SetDrawLayer('BORDER')
        end
    end
    
    frame.HealthBar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    frame.HealthBar:SetBackdropColor(0, 0, 0, 0.55)
    
    frame.HealthBar:SetScript('OnValueChanged',  function()
        ColorHealthBar(frame) 
    end)

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
    frame.HealtValue:SetFont('Fonts\\ARIALN.ttf', 9)
    frame.HealtValue:SetShadowOffset(1, -1)
        
        -- the level text string, we abuse it as namestring too
        
	levelTextRegion:SetFont('Fonts\\ARIALN.ttf', 10) --, 'THINOUTLINE')
	levelTextRegion:SetShadowOffset(1, -1)
    frame.level = levelTextRegion
    
        -- create castbar borders
        
    if (not CastBar.beautyBorder) then
        CastBar:CreateBorder(8)
        CastBar:SetBorderPadding(3)
        
        for i = 1, 8 do 
            CastBar.beautyBorder[i]:SetDrawLayer('BORDER')
        end
    end    
        
	CastBar.shieldedRegion = shieldedRegion
    
        -- castbar
        
    CastBar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    CastBar:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
    CastBar:ClearAllPoints()
    CastBar:SetPoint('TOPRIGHT', frame.HealthBar, 'BOTTOMRIGHT', 0, -9)
    CastBar:SetPoint('BOTTOMLEFT', frame.HealthBar, 'BOTTOMLEFT', 0, -20)
    
	CastBar:HookScript('OnShow', OnShow)
	CastBar:HookScript('OnValueChanged', OnValueChanged)
	CastBar:HookScript('OnEvent', OnEvent)
	CastBar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
	CastBar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
    
        -- castbar casttime font string
        
    CastBar.CastTime = CastBar:CreateFontString(nil, 'OVERLAY')
	CastBar.CastTime:SetPoint('RIGHT', CastBar, 'RIGHT', 5, 0)
	CastBar.CastTime:SetFont('Fonts\\ARIALN.ttf', 21)   -- , 'THINOUTLINE')
	CastBar.CastTime:SetTextColor(1, 1, 1)
    CastBar.CastTime:SetShadowOffset(1, -1)
    
        -- castbar castname font string
    
	CastBar.CastName = CastBar:CreateFontString(nil, 'OVERLAY')
	CastBar.CastName:SetPoint('LEFT', CastBar, 3, 0)
    CastBar.CastName:SetPoint('RIGHT', CastBar.CastTime, 'LEFT', -6, 0)
	CastBar.CastName:SetFont('Fonts\\ARIALN.ttf', 10)
	CastBar.CastName:SetTextColor(1, 1, 1)
	CastBar.CastName:SetShadowOffset(1, -1)
    CastBar.CastName:SetJustifyH('LEFT')

        -- castbar spellicon and overlay
        
	CastBar.SpellIcon = spellIconRegion
    CastBar.SpellIcon:SetParent(CastBar)
	CastBar.SpellIcon:ClearAllPoints()
	CastBar.SpellIcon:SetPoint('BOTTOMLEFT', CastBar, 'BOTTOMRIGHT', 7, 3)
	CastBar.SpellIcon:SetSize(24, 24)
    CastBar.SpellIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    CastBar.SpellIcon:SetDrawLayer('BACKGROUND')
    
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

        -- nameplates like cookies
        
	frame:SetScript('OnShow', UpdatePlate)
	frame:SetScript('OnHide', function(self)
        self.highlight:Hide()
    end)
    
	frame:SetScript('OnUpdate', ThreatUpdate)
	
        -- on update local
        
	frame.elapsed = 0

        -- to prevent some problems 
        
	UpdatePlate(frame)
    
    frame.done = true
end

    -- scan the worldframe for nameplates
    
local overlayRegion = overlayRegion

local function IsNameplate (frame)
    --[[
	if (frame:GetName() and not find(frame:GetName(), '^NamePlate')) then
		return false
	end
    
	overlayRegion = select(2, frame:GetRegions())
    return (overlayRegion and overlayRegion:GetObjectType() == 'Texture' and overlayRegion:GetTexture() == 'Interface\\Tooltips\\Nameplate-Border')
    --]]
    local region = frame:GetRegions()
    return region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" 
end

local f = CreateFrame('Frame')

-- local lastupdate = 0

local kvn = -1
local namePlate, frames

f:SetScript('OnUpdate', function(self, elapsed)
	-- lastupdate = lastupdate + elapsed
	-- if (lastupdate > 0.1) then
        frames = select('#', WorldFrame:GetChildren())

        if (frames ~= kvn) then
            for i = 1, frames do
                namePlate = select(i, WorldFrame:GetChildren())
    
                if (IsNameplate(namePlate)) then
                    SkinPlate(namePlate)
                end
                
                kvn = frames
            end
        end
        
		-- lastupdate = 0
	-- end
end)