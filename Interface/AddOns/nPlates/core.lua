
    -- Just some experimental config stuff

local enableTankMode = true
local noThreatColor = {0, 1, 0}

local showEliteBorder = true
local abbrevLongNames = false
local borderColor = {0.35, 0.35, 0.35}

    -- local stuff

local ColorBeautyBorder = _G.ColorBeautyBorder
local CreateBeautyBorder = _G.CreateBeautyBorder
local SetBeautyBorderTexture = _G.SetBeautyBorderTexture

local len = string.len
local find = string.find
local gsub = string.gsub

local ton = tonumber
local select = select
local tonumber = tonumber

local UnitName = UnitName
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local elitePlateTexture = 'Interface\\Tooltips\\EliteNameplateIcon'
local nameplateFlashTexture = 'Interface\\TargetingFrame\\UI-TargetingFrame-Flash'

    -- Some general functions

local function Round(num, idp)
    return ton(format('%.'..(idp or 0)..'f', num))
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

local function RGBHex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

    -- The plate functions

local function GetUnitReaction(r, g, b)
    if (g + b == 0) then
        return true
    end
    
    return false
end

local function GetUnitCombatStatus(r, g, b)
    if (r >= 0.98) then
        return true
    end
    
    return false
end

local function IsTarget(self) 
    local targetName = UnitName('target')
    if (targetName == self.Name:GetText() and self:GetAlpha() >= 0.99) then
        return true
    else
        return false
    end
end

local function UpdateThreatColor(self)
    local playerInfight = InCombatLockdown()
    local unitInfight = GetUnitCombatStatus(self.Name:GetTextColor())
    local lowThreat = unitInfight and playerInfight
    local isEnemy = GetUnitReaction(self.Health:GetStatusBarColor())

    if (lowThreat and not self.Glow:IsVisible() and isEnemy and enableTankMode) then
        self.NewGlow:Show()
        self.NewGlow:SetVertexColor(unpack(noThreatColor))
    elseif (self.Glow:IsVisible()) then
        self.NewGlow:Show()

        local r, g, b = self.Glow:GetVertexColor()
        self.NewGlow:SetVertexColor(r, g, b)
    else
        if (self.NewGlow:IsVisible()) then
            self.NewGlow:Hide()
        end
    end
end

local function UpdateHealthText(self)
    local min, max = self.Health:GetMinMaxValues()
    local currentValue = self.Health:GetValue()
    local perc = (currentValue/max)*100	

    if (perc >= 100 and currentValue ~= 1) then
        self.Health.Value:SetFormattedText('%s', FormatValue(currentValue))		
    elseif (perc < 100 and currentValue ~= 1) then
        self.Health.Value:SetFormattedText('%s - %.0f%%', FormatValue(currentValue), perc + 0.5)
    else
        self.Health.Value:SetText('')
    end
end

local function UpdateHealthColor(self)
    local r, g, b = self.Health:GetStatusBarColor()
    if (r + g == 0) then
        self.Health:SetStatusBarColor(0, 0.35, 1)
    end
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
    local newName = self.Name:GetText()
    if (abbrevLongNames) then
        newName = (len(newName) > 20) and gsub(newName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or newName
    end

    local level, elite = self.Level:GetText(), self.EliteIcon:IsVisible()

    if (self.BossIcon:IsVisible()) then
        self.Level:SetFont('Fonts\\ARIALN.ttf', 12)
    else
        self.Level:SetFont('Fonts\\ARIALN.ttf', 10)
    end

    local nameColor = RGBHex(1, 1, 1)

    if (self.BossIcon:IsVisible()) then
        self.Level:SetText('|cffff0000??|r '..nameColor..newName)
        self.Level:Show()
    elseif (self.EliteIcon:IsVisible() and (not self.EliteIcon:GetTexture() == elitePlateTexture)) then
        self.Level:SetText('|cffffff00(r)|r'..level..' '..nameColor..newName)
    else
        self.Level:SetText((elite and '|cffffff00+|r' or '')..level..' '..nameColor..newName)
    end	
end

local function UpdateTargetBorder(self)
    if (IsTarget(self)) then
        -- self.Health:SetBeautyBorderTexture('white')
        self.Health:SetBeautyShadowColor(1, 1, 1)
    else
        -- self.Health:SetBeautyBorderTexture('default')
        self.Health:SetBeautyShadowColor(0, 0, 0)
    end
end

local function ThreatUpdate(self, elapsed)
    self.elapsed = self.elapsed + elapsed
    if (self.elapsed >= 0.1) then
        if (self:IsVisible()) then
            UpdateHealthColor(self)
            UpdateThreatColor(self)
            UpdateTargetBorder(self)
        end

        self.elapsed = 0
    end
end

local function UpdateEliteTexture(self)
    local r, g, b = unpack(borderColor)
    if (self.BossIcon:IsVisible() or self.EliteIcon:IsVisible()) then
        self.Health.beautyBorder[2]:SetVertexColor(1, 1, 0)
        self.Health.beautyBorder[4]:SetVertexColor(1, 1, 0)
        self.Health.beautyBorder[8]:SetVertexColor(1, 1, 0)
        self.Health.beautyBorder[5]:SetGradientAlpha('HORIZONTAL', r, g, b, 1, 1, 1, 0, 1)
        self.Health.beautyBorder[6]:SetGradientAlpha('HORIZONTAL', r, g, b, 1, 1, 1, 0, 1)
    else
        self.Health.beautyBorder[2]:SetVertexColor(r, g, b)
        self.Health.beautyBorder[4]:SetVertexColor(r, g, b)
        self.Health.beautyBorder[8]:SetVertexColor(r, g, b)
        self.Health.beautyBorder[5]:SetVertexColor(r, g, b)
        self.Health.beautyBorder[6]:SetVertexColor(r, g, b)
    end
end

local function UpdatePlate(self)
    if (self.Level) then
        UpdateNameL(self)
    end

    if (showEliteBorder) then
        UpdateEliteTexture(self)
    end

    UpdateHealthText(self)
    UpdateHealthColor(self)
    UpdateThreatColor(self)

    self.Highlight:ClearAllPoints()
    self.Highlight:SetAllPoints(self.Health)

    if (self.Castbar:IsVisible()) then     
        self.Castbar:Hide() 
    end

    local r, g, b = self.Health:GetStatusBarColor()
    self.Castbar.IconOverlay:SetVertexColor(r, g, b)

        -- shorter names

    self.Level:ClearAllPoints()
    self.Level:SetPoint('CENTER', self.Health, 'CENTER', 0, 9)
    self.Level:SetSize(110, 13)
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
    ColorCastBar(self, self.Shield:IsVisible())
end

local function OnEvent(self, event, unit)
    if (unit == 'target') then
        if (self:IsVisible()) then
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

        -- hide all unwanted texture

    self.Glow:SetTexCoord(0, 0, 0, 0)
    self.Overlay:SetTexCoord(0, 0, 0, 0)
    self.BossIcon:SetTexCoord(0, 0, 0, 0)
    self.EliteIcon:SetTexCoord(0, 0, 0, 0)

    self.Castbar.Shield:SetTexCoord(0, 0, 0, 0)
    self.Castbar.Overlay:SetTexCoord(0, 0, 0, 0)

        -- hide original name font string

    self.Name:Hide()

        -- create the healtbar border and background

    if (not self.Health.beautyBorder) then
        local r, g, b = unpack(borderColor)
        self.Health:CreateBeautyBorder(7.33333)
        self.Health:SetBeautyBorderPadding(2.6666667)
        self.Health:SetBeautyBorderColor(r, g, b)
        self.Health:SetBeautyBorderTexture('white')
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

    self.Health:SetScript('OnValueChanged', function()
        UpdateHealthText(self)
    end)

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

    if (not self.NewGlow) then
        self.NewGlow = self.Health:CreateTexture(nil, 'BACKGROUND')
        self.NewGlow:SetTexture('Interface\\AddOns\\nPlates\\media\\threatTexture')
        self.NewGlow:SetPoint('TOPRIGHT', self.Health, 21, 18)
        self.NewGlow:SetPoint('BOTTOMLEFT', self.Health, -21, -18)
        self.NewGlow:SetParent(self.Health)
        self.NewGlow:Hide()
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
    return region and region:GetObjectType() == 'Texture' and region:GetTexture() == nameplateFlashTexture
end

local total = -1
local namePlate, frames
local f = CreateFrame('Frame')
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