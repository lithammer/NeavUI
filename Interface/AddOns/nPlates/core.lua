
    -- local stuff for faster usage
    
local ColorBeautyBorder = _G.ColorBeautyBorder
local CreateBeautyBorder = _G.CreateBeautyBorder
local SetBeautyBorderTexture = _G.SetBeautyBorderTexture
  
local len = string.len
local find = string.find
local gsub = string.gsub

local select = select
local tonumber = tonumber

    -- import functions for faster usage
    
local UnitName = UnitName
-- local UnitIsEnemy = UnitIsEnemy
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local function RGBHex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

--[[

    local GetUnitAggroStatus
	do
		local shown 
		local red, green, blue
		function GetUnitAggroStatus( region)
			-- High = 1, 0, 0	-- Medium High = 1, .6, 0  -- Medium Low = 1, 1, .47
			shown = region:IsShown()
			if not shown then return "LOW", 0 end
			red, green, blue = region:GetVertexColor()
			if red > 0 then
				if green > 0 then
					if blue > 0 then return "MEDIUM", 1 end
					return "MEDIUM", 2
				end
				return "HIGH", 3
			end
		end
	end

    
    local function GetUnitCombatStatus(r, g, b) 
        return (r > .5 and g < .5) 
    end

    
    unit.isInCombat = GetUnitCombatStatus(regions.name:GetTextColor())
        
--]]


local function IsTarget(self) 
	local targetName = UnitName('target')
    
	if (targetName == self.oldName:GetText() and self:GetAlpha() >= 0.99) then
		return true
	else
		return false
	end
end

local function Round(num, idp)
	return tonumber(format('%.'..(idp or 0)..'f', num))
end

local function FormatValue(number)
	if (number >= 1e6) then
		return Round(number/1e6, 1)..'m'
	elseif (number >= 1e3) then
		return Round(number/1e3, 1)..'k'
	else
		return number
	end
end

local function UpdateHealtText(self)
	local min, max = self.Health:GetMinMaxValues()
	local currentValue = self.Health:GetValue()
	local perc = (currentValue/max)*100	

    if (perc >= 100 and currentValue ~= 1) then
        self.Health.Value:SetFormattedText('%s', FormatValue(currentValue))		
    elseif (perc < 100 and currentValue ~= 1) then
        self.Health.Value:SetFormattedText('%s - %.0f%%', FormatValue(currentValue), perc)
    else
        self.Health.Value:SetText('')
    end
end

local function ColorHealthBar(self)
    local r, g, b = self.Health:GetStatusBarColor()

    if (r + g == 0) then
        self.Health:SetStatusBarColor(0, 0.35, 1)
    end

    UpdateHealtText(self)
end

local function UpdateTime(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	local castName = UnitCastingInfo('target') or UnitChannelInfo('target')
    
	if (self.channeling) then
		self.CastTime:SetFormattedText('%.1fs', curValue)
	else
		self.CastTime:SetFormattedText('%.1fs', maxValue - curValue)
	end	
    
	self.Name:SetText(castName)
end

local function UpdateNameL(self)
	local oldName = self.oldName:GetText()
	-- local newName = (len(oldName) > 20) and gsub(oldName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or oldName
    local newName = oldName

    local level, elite = self.Level:GetText(), self.EliteIcon:IsShown()
        
    if (self.BossIcon:IsShown()) then
        self.Level:SetFont('Fonts\\ARIALN.ttf', 12)
    else
        self.Level:SetFont('Fonts\\ARIALN.ttf', 10)
    end
        
    local r, g, b = self.Name:GetTextColor()
    local nameColor = RGBHex(r, g, b)
        
    if (self.BossIcon:IsShown()) then
        self.Level:SetText('|cffff0000??|r '..nameColor..newName)
        self.Level:Show()
    elseif (self.EliteIcon:IsVisible() and (not self.EliteIcon:GetTexture() == 'Interface\\Tooltips\\EliteNameplateIcon')) then
        self.Level:SetText('|cffffff00(r)|r'..level..' '..nameColor..newName)
    else
        self.Level:SetText((elite and '|cffffff00+|r' or '')..level..' '..nameColor..newName)
    end	
end

local function ThreatUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if (self.elapsed >= 0.1) then
        if (self:IsVisible()) then
            ColorHealthBar(self)
            
            if (IsTarget(self)) then
                self.Health:SetBeautyBorderTexture('white')
            else
                self.Health:SetBeautyBorderTexture('default')
            end
            
            if (not self.oldGlow:IsShown()) then
                if (self.Health.bg:IsShown()) then
                    self.Health.bg:Hide()
                end
            else
                local r, g, b = self.oldGlow:GetVertexColor()
                self.Health.bg:SetBeautyBorderColor(r, g, b, 1)
                
                if (not self.Health.bg:IsShown()) then
                    self.Health.bg:Show()
                end
            end
        end
        
		self.elapsed = 0
	end
end

local function UpdatePlate(self)
    UpdateHealtText(self)
    ColorHealthBar(self)
    
    --[[
    self.EliteIcon:SetSize(25, 24)
    self.EliteIcon:SetTexture('Interface\\AddOns\\nPlates\\media\\eliteIcon')
    self.EliteIcon:ClearAllPoints()
    self.EliteIcon:SetPoint('LEFT', self.Health, -14.5, 2)
    self.EliteIcon:SetVertexColor(0.8, 0.8, 0.8)
    --]]
    
    self.Highlight:ClearAllPoints()
	self.Highlight:SetAllPoints(self.Health)	   
    
    if (self.Castbar:IsShown()) then     
        self.Castbar:Hide() 
    end
    
    local r, g, b = self.Health:GetStatusBarColor()
	self.Castbar.IconOverlay:SetVertexColor(r, g, b)
    
        -- shorter names

    self.Level:ClearAllPoints()
    self.Level:SetPoint('CENTER', self.Health, 'CENTER', 0, 9)
    self.Level:SetSize(110, 13)
    
    if (self.Level) then
        UpdateNameL(self)
    end
end

local function ColorCastBar(self, shield)		
	if (shield) then
        self:SetBeautyBorderTexture('white')
        self:SetBeautyBorderColor(1, 0, 1)  	
        self.CastTime:SetTextColor(1, 0, 1)
    else
        self:SetBeautyBorderTexture('default')
        self:SetBeautyBorderColor(1, 1, 1)  
        self.CastTime:SetTextColor(1, 1, 1)
	end
end

local function OnValueChanged(self, curValue)
	UpdateTime(self, curValue)
end

local function OnShow(self)
	self.channeling = UnitChannelInfo('target')

	ColorCastBar(self, self.Shield:IsShown())
end

local function OnEvent(self, event, unit)
	if (unit == 'target') then
		if (self:IsShown()) then
			ColorCastBar(self, event == 'UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
		end
	end
end

local function SkinPlate(self)
	if (self.RealDone) then
		return
	end

	self.Health, self.Castbar = self:GetChildren()
    _, self.Castbar.Overlay, self.Castbar.Shield, self.Castbar.Icon = self.Castbar:GetRegions()
    self.Glow, self.Overlay, self.Highlight, self.Name, self.Level, self.BossIcon, self.RaidIcon, self.EliteIcon = self:GetRegions()
	
        -- fake hide all unwanted texture
        
	self.Glow:SetTexCoord(0, 0, 0, 0)
	self.Overlay:SetTexCoord(0, 0, 0, 0)
    self.BossIcon:SetTexCoord(0, 0, 0, 0)
    self.EliteIcon:SetTexCoord(0, 0, 0, 0)

	self.Castbar.Shield:SetTexCoord(0, 0, 0, 0)
	self.Castbar.Overlay:SetTexCoord(0, 0, 0, 0)
	
        -- use these old frames for some functions
        
    self.oldName = self.Name
	self.oldGlow = self.Glow
    
        -- hide original name font string

	self.Name:Hide()

        -- create the healtbar border and background
    
    if (not self.Health.beautyBorder) then
        self.Health:CreateBeautyBorder(7.33333)
        self.Health:SetBeautyBorderPadding(2.6666667)
    end

    self.Health:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { 
            left = -2, 
            right = -2, 
            top = -2, 
            bottom = -2 
        }
    })
    self.Health:SetBackdropColor(0, 0, 0, 0.55)
    
    if (not self.Health.bg) then
        self.Health.bg = CreateFrame('Frame', nil, self.Health)
        self.Health.bg:SetPoint('TOP', self.Health, 0, 3)
        self.Health.bg:SetPoint('BOTTOM', self.Health, 0, -3)
        self.Health.bg:SetPoint('LEFT', self.Health, -3, 0)
        self.Health.bg:SetPoint('RIGHT', self.Health, 3, 0)
        self.Health.bg:Hide()

        self.Health.bg:CreateBeautyBorder(7.3333334)
        self.Health.bg:SetBeautyBorderPadding(2.3333334)
        self.Health.bg:SetBeautyBorderTexture('white')
    end

    --[[
	self.NewName = self:CreateFontString(nil, 'OVERLAY')
	self.NewName:SetParent(self.Health)
	self.NewName:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
    self.NewName:SetShadowOffset(0, 0)
    self.NewName:SetPoint('CENTER', self.Health, 'CENTER', 0, 10)
    --]]
        
        -- create health value font string
        
    if (not self.Health.Value) then    
        self.Health.Value = self:CreateFontString()
        self.Health.Value:SetPoint('CENTER', self.Health, 0, 0)
        self.Health.Value:SetFont('Fonts\\ARIALN.ttf', 9)
        self.Health.Value:SetShadowOffset(1, -1)
    end
    
        -- the level text string, we abuse it as namestring too
        
	self.Level:SetFont('Fonts\\ARIALN.ttf', 10) --, 'THINOUTLINE')
	self.Level:SetShadowOffset(1, -1)
    
        -- create castbar borders
        
    if (not self.Castbar.beautyBorder) then
        self.Castbar:CreateBeautyBorder(7.3333334)
        self.Castbar:SetBeautyBorderPadding(2.3333334)
    end
    
        -- castbar
        
    self.Castbar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    self.Castbar:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
    
    self.Castbar:ClearAllPoints()
    self.Castbar:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -9.3333334)
    self.Castbar:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT', 0, -20.6666667)
    
	self.Castbar:HookScript('OnShow', OnShow)
	self.Castbar:HookScript('OnValueChanged', OnValueChanged)
	self.Castbar:HookScript('OnEvent', OnEvent)
	self.Castbar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
	self.Castbar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
    
        -- castbar casttime font string
        
    if (not self.Castbar.CastTime) then   
        self.Castbar.CastTime = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.CastTime:SetPoint('RIGHT', self.Castbar, 1.6666667, 0)
        self.Castbar.CastTime:SetFont('Fonts\\ARIALN.ttf', 16)   -- , 'THINOUTLINE')
        self.Castbar.CastTime:SetTextColor(1, 1, 1)
        self.Castbar.CastTime:SetShadowOffset(1, -1)
    end
    
        -- castbar castname font string
    
    if (not self.Castbar.Name) then
        self.Castbar.Name = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Name:SetPoint('LEFT', self.Castbar, 1.5, 0)
        self.Castbar.Name:SetPoint('RIGHT', self.Castbar.CastTime, 'LEFT', -6, 0)
        self.Castbar.Name:SetFont('Fonts\\ARIALN.ttf', 10)
        self.Castbar.Name:SetTextColor(1, 1, 1)
        self.Castbar.Name:SetShadowOffset(1, -1)
        self.Castbar.Name:SetJustifyH('LEFT')
    end
    
        -- castbar spellicon and overlay
        
    self.Castbar.Icon:SetParent(self.Castbar)
	self.Castbar.Icon:ClearAllPoints()
	self.Castbar.Icon:SetPoint('BOTTOMLEFT', self.Castbar, 'BOTTOMRIGHT', 7, 3)
	self.Castbar.Icon:SetSize(24, 24)
    self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    self.Castbar.Icon:SetDrawLayer('BACKGROUND')
    
    if (not self.Castbar.IconOverlay) then
        self.Castbar.IconOverlay = self.Castbar:CreateTexture(nil, 'OVERLAY')
        self.Castbar.IconOverlay:SetPoint('TOPLEFT', self.Castbar.Icon, -1, 1)
        self.Castbar.IconOverlay:SetPoint('BOTTOMRIGHT', self.Castbar.Icon, 1, -1)
        self.Castbar.IconOverlay:SetTexture('Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite')
    end
    
        -- mouseover highlight
        
	self.Highlight:SetTexture(1, 1, 1, 0.2)

        -- raidicons

	self.RaidIcon:ClearAllPoints()
    self.RaidIcon:SetDrawLayer('OVERLAY')
	self.RaidIcon:SetPoint('CENTER', self.Health, 'TOP', 0, 12)
	self.RaidIcon:SetSize(16, 16)

        -- nameplates like cookies
        
	self:SetScript('OnShow', UpdatePlate)
	self:SetScript('OnHide', function(self)
        self.Highlight:Hide()
    end)
    
	self:SetScript('OnUpdate', ThreatUpdate)
	
        -- on update local
        
	self.elapsed = 0

        -- to prevent some problems 
        
	UpdatePlate(self)
    
    self.RealDone = true
end

    -- scan the worldframe for nameplates

local function IsNameplate(self)
    local region = self:GetRegions()
    return region and region:GetObjectType() == 'Texture' and region:GetTexture() == 'Interface\\TargetingFrame\\UI-TargetingFrame-Flash' 
end

local f = CreateFrame('Frame')

local total = -1
local namePlate, frames
f:SetScript('OnUpdate', function()
    frames = select('#', WorldFrame:GetChildren())

    if (frames ~= total) then
        for i = 1, frames do
            namePlate = select(i, WorldFrame:GetChildren())
    
            if (IsNameplate(namePlate)) then
                SkinPlate(namePlate)
            end
                
            total = frames
        end
    end
end)