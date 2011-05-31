
    -- local stuff for faster usage
    
local ColorBorder = _G.ColorBorder
local CreateBorder = _G.CreateBorder
local SetBorderTexture = _G.SetBorderTexture
    
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

    -- load texture locally
    
local whiteTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'

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

local function ThreatUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if (self.elapsed >= 0.1) then
        if (self:IsVisible()) then
            ColorHealthBar(self)
            if (not self.oldGlow:IsShown()) then
                if (IsTarget(self)) then
                    self.Health:SetBorderTexture(whiteTexture)
                    
                    -- if (UnitIsEnemy('player', 'target')) then
                        self.Health:SetBorderColor(1, 1, 1)  	
                    -- else
                        -- self.Health:SetBorderColor(0, 1, 0)  	
                    -- end
                else
                    self.Health:SetBorderTexture(normalTexture)
                    self.Health:SetBorderColor(1, 1, 1)  
                end
            else			
                local r, g, b = self.oldGlow:GetVertexColor()
                self.Health:SetBorderTexture(whiteTexture)
                self.Health:SetBorderColor(r, g, b)			
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
        
	local oldName = self.oldName:GetText()
	local newName = (len(oldName) > 20) and gsub(oldName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or oldName

    self.Level:ClearAllPoints()
    self.Level:SetPoint('CENTER', self.Health, 'CENTER', 0, 10)
    self.Level:SetSize(134, 13)
    
    if (self.Level) then
        local level, elite = self.Level:GetText(), self.EliteIcon:IsShown()
        
        if (self.BossIcon:IsShown()) then
            self.Level:SetFont('Fonts\\ARIALN.ttf', 12)
        else
            self.Level:SetFont('Fonts\\ARIALN.ttf', 10)
        end
        
        if (self.BossIcon:IsShown()) then
            self.Level:SetText('?? |cffffffff'..newName)
            self.Level:SetTextColor(1, 0, 0)
            self.Level:Show()
        elseif (self.EliteIcon:IsVisible() and (not self.EliteIcon:GetTexture() == 'Interface\\Tooltips\\EliteNameplateIcon')) then
            self.Level:SetText('|cffffff00(r)|r'..level..' |cffffffff'..newName)
        else
            self.Level:SetText((elite and '|cffffff00+|r' or '')..level..' |cffffffff'..newName)
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
        self.Health:CreateBorder(7.33333)
        self.Health:SetBorderPadding(2.666666666665)
        
        for i = 1, 8 do 
            self.Health.beautyBorder[i]:SetDrawLayer('BORDER')
        end
    end
    
    self.Health:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    --[[
	self.NewName = self:CreateFontString(nil, 'OVERLAY')
	self.NewName:SetParent(self.Health)
	self.NewName:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
    self.NewName:SetShadowOffset(0, 0)
    self.NewName:SetPoint('CENTER', self.Health, 'CENTER', 0, 10)
    --]]
        
        -- create health value font string
        
	self.Health.Value = self:CreateFontString()
	self.Health.Value:SetPoint('CENTER', self.Health, 0, 0)
    self.Health.Value:SetFont('Fonts\\ARIALN.ttf', 9)
    self.Health.Value:SetShadowOffset(1, -1)
        
        -- the level text string, we abuse it as namestring too
        
	self.Level:SetFont('Fonts\\ARIALN.ttf', 10) --, 'THINOUTLINE')
	self.Level:SetShadowOffset(1, -1)
    
        -- create castbar borders
        
    if (not self.Castbar.beautyBorder) then
        self.Castbar:CreateBorder(8)
        self.Castbar:SetBorderPadding(3)
        
        for i = 1, 8 do 
            self.Castbar.beautyBorder[i]:SetDrawLayer('BORDER')
        end
    end
    
        -- castbar
        
    self.Castbar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    self.Castbar:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
    
    self.Castbar:ClearAllPoints()
    self.Castbar:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -9)
    self.Castbar:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT', 0, -20)
    
	self.Castbar:HookScript('OnShow', OnShow)
	self.Castbar:HookScript('OnValueChanged', OnValueChanged)
	self.Castbar:HookScript('OnEvent', OnEvent)
	self.Castbar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTIBLE')
	self.Castbar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTIBLE')
    
        -- castbar casttime font string
        
    self.Castbar.CastTime = self.Castbar:CreateFontString(nil, 'OVERLAY')
	self.Castbar.CastTime:SetPoint('RIGHT', self.Castbar, 'RIGHT', 5, 0)
	self.Castbar.CastTime:SetFont('Fonts\\ARIALN.ttf', 21)   -- , 'THINOUTLINE')
	self.Castbar.CastTime:SetTextColor(1, 1, 1)
    self.Castbar.CastTime:SetShadowOffset(1, -1)
    
        -- castbar castname font string
    
	self.Castbar.Name = self.Castbar:CreateFontString(nil, 'OVERLAY')
	self.Castbar.Name:SetPoint('LEFT', self.Castbar, 3, 0)
    self.Castbar.Name:SetPoint('RIGHT', self.Castbar.CastTime, 'LEFT', -6, 0)
	self.Castbar.Name:SetFont('Fonts\\ARIALN.ttf', 10)
	self.Castbar.Name:SetTextColor(1, 1, 1)
	self.Castbar.Name:SetShadowOffset(1, -1)
    self.Castbar.Name:SetJustifyH('LEFT')

        -- castbar spellicon and overlay
        
    self.Castbar.Icon:SetParent(self.Castbar)
	self.Castbar.Icon:ClearAllPoints()
	self.Castbar.Icon:SetPoint('BOTTOMLEFT', self.Castbar, 'BOTTOMRIGHT', 7, 3)
	self.Castbar.Icon:SetSize(24, 24)
    self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    self.Castbar.Icon:SetDrawLayer('BACKGROUND')
    
    self.Castbar.IconOverlay = self.Castbar:CreateTexture(nil, 'OVERLAY')
	self.Castbar.IconOverlay:SetPoint('TOPLEFT', self.Castbar.Icon, -1, 1)
	self.Castbar.IconOverlay:SetPoint('BOTTOMRIGHT', self.Castbar.Icon, 1, -1)
	self.Castbar.IconOverlay:SetTexture(whiteTexture)
    
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