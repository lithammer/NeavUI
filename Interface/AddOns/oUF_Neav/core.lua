
local _, ns = ...
local config = ns.Config

local playerClass = select(2, UnitClass('player'))
local tarTexPath = 'Interface\\TargetingFrame\\'

UnitPopupMenus['MOVE_PLAYER_FRAME'] = { 
    'UNLOCK_PLAYER_FRAME', 
    'LOCK_PLAYER_FRAME', 
    'RESET_PLAYER_FRAME_POSITION'
}

UnitPopupMenus['MOVE_TARGET_FRAME'] = { 
    'UNLOCK_TARGET_FRAME', 
    'LOCK_TARGET_FRAME', 
    'RESET_TARGET_FRAME_POSITION'
}

UnitPopupMenus['FOCUS'] = { 
    'LOCK_FOCUS_FRAME', 
    'UNLOCK_FOCUS_FRAME', 
    'RAID_TARGET_ICON', 
    'CANCEL' 
}

local __pa = CreateFrame('Frame', 'oUF_Neav_Player_Anchor', UIParent)
__pa:SetSize(1, 1)
__pa:SetPoint(unpack(config.units.player.position))
__pa:SetMovable(true)
__pa:SetUserPlaced(true)
__pa:SetClampedToScreen(true)

local __ta = CreateFrame('Frame', 'oUF_Neav_Target_Anchor', UIParent)
__ta:SetSize(1, 1)
__ta:SetPoint(unpack(config.units.target.position))
__ta:SetMovable(true)
__ta:SetUserPlaced(true)
__ta:SetClampedToScreen(true)

local __fa = CreateFrame('Frame', 'oUF_Neav_Focus_Anchor', UIParent)
__fa:SetSize(1, 1)
__fa:SetPoint('LEFT', 30, 0)
__fa:SetMovable(true)
__fa:SetUserPlaced(true)
__fa:SetClampedToScreen(true)

PLAYER_FRAME_UNLOCKED = false
function PlayerFrame_SetLocked(locked)
    PLAYER_FRAME_UNLOCKED = not locked
    if (locked) then
        if (oUF_Neav_Player) then
            oUF_Neav_Player:RegisterForDrag() 
        end
    else
        if (oUF_Neav_Player) then
            oUF_Neav_Player:RegisterForDrag('LeftButton') 
        end
    end
end

function PlayerFrame_ResetUserPlacedPosition()
    if (oUF_Neav_Player) then
        __pa:ClearAllPoints()
        __pa:SetPoint(unpack(config.units.player.position))
        PlayerFrame_SetLocked(true)
    end
end

TARGET_FRAME_UNLOCKED = false
function TargetFrame_SetLocked(locked)
    TARGET_FRAME_UNLOCKED = not locked
    if (locked) then
        if (oUF_Neav_Target) then
            oUF_Neav_Target:RegisterForDrag() 
        end
    else
        if (oUF_Neav_Target) then
            oUF_Neav_Target:RegisterForDrag('LeftButton') 
        end
    end
end

function TargetFrame_ResetUserPlacedPosition()
    if (oUF_Neav_Target) then
        __ta:ClearAllPoints()
        __ta:SetPoint(unpack(config.units.target.position))
        TargetFrame_SetLocked(true)
    end
end

local function CreateFocusButton(self)
    self.FTarget = CreateFrame('BUTTON', nil, self, 'SecureActionButtonTemplate')
    self.FTarget:EnableMouse(true)
    self.FTarget:RegisterForClicks('AnyUp')
    self.FTarget:SetAttribute('type', 'macro')
    self.FTarget:SetAttribute('macrotext', '/focus')
    self.FTarget:SetSize(self.TabMiddle:GetWidth() + 30, self.TabMiddle:GetHeight() + 2)
    self.FTarget:SetPoint('TOPLEFT', self, (self.TabMiddle:GetWidth()/5), 17)
    
    self.FTarget:SetScript('OnMouseDown', function()
        self.TabText:SetPoint('BOTTOM', self.TabMiddle, -1, 1)
    end)

    self.FTarget:SetScript('OnMouseUp', function()
        self.TabText:SetPoint('BOTTOM', self.TabMiddle, 0, 2)
    end)

    self.FTarget:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', self.TabMiddle, 0.25, self.TabMiddle:GetAlpha(), 0)
        securecall('UIFrameFadeOut', self.TabLeft, 0.25, self.TabLeft:GetAlpha(), 0)
        securecall('UIFrameFadeOut', self.TabRight, 0.25, self.TabRight:GetAlpha(), 0)
        securecall('UIFrameFadeOut', self.TabText, 0.15, self.TabText:GetAlpha(), 0)
    end)

    self.FTarget:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', self.TabMiddle, 0.25, self.TabMiddle:GetAlpha(), 0.5)
        securecall('UIFrameFadeIn', self.TabLeft, 0.25, self.TabLeft:GetAlpha(), 0.5)
        securecall('UIFrameFadeIn', self.TabRight, 0.25, self.TabRight:GetAlpha(), 0.5)
        securecall('UIFrameFadeIn', self.TabText, 0.15, self.TabText:GetAlpha(), 1)
    end)

    self:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', self.TabMiddle, 0.25, self.TabMiddle:GetAlpha(), 0)
        securecall('UIFrameFadeOut', self.TabLeft, 0.25, self.TabLeft:GetAlpha(), 0)
        securecall('UIFrameFadeOut', self.TabRight, 0.25, self.TabRight:GetAlpha(), 0)
        securecall('UIFrameFadeOut', self.TabText, 0.25, self.TabText:GetAlpha(), 0)
    end)

    self:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', self.TabMiddle, 0.25, self.TabMiddle:GetAlpha(), 0.5)
        securecall('UIFrameFadeIn', self.TabLeft, 0.25, self.TabLeft:GetAlpha(), 0.5)
        securecall('UIFrameFadeIn', self.TabRight, 0.25, self.TabRight:GetAlpha(), 0.5)
        securecall('UIFrameFadeIn', self.TabText, 0.25, self.TabText:GetAlpha(), 0.5)
    end)
    return self
end

local function CreateDropDown(self)
    local dropdown = _G[string.format('%sFrameDropDown', string.gsub(self.unit, '(.)', string.upper, 1))]

    if (dropdown) then
        ToggleDropDownMenu(1, nil, dropdown, 'cursor')
    elseif (self.unit:match('party')) then
        ToggleDropDownMenu(1, nil, _G[format('PartyMemberFrame%dDropDown', self.id)], 'cursor')
    else
        FriendsDropDown.unit = self.unit
        FriendsDropDown.id = self.id
        FriendsDropDown.initialize = RaidFrameDropDown_Initialize
        ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
    end
end

local function PlayerToVehicleTexture(self, event, unit)
    self.ThreatGlow:Hide()
    self.Level:Hide()
    
    self.LFDRole:SetAlpha(0)
    
    self.Texture:SetHeight(121)
    self.Texture:SetWidth(240)
    self.Texture:SetPoint('CENTER', self, 0, -8)
    self.Texture:SetTexCoord(0, 1, 0, 1)

    self.Health:SetHeight(9)
    
    if (UnitVehicleSkin('player') == 'Natural') then
        self.Health:SetWidth(103)
        self.Health:SetPoint('TOPLEFT', self.Texture, 100, -54)

        self.Texture:SetTexture('Interface\\Vehicles\\UI-Vehicle-Frame-Organic')
    else
        self.Health:SetWidth(100)
        self.Health:SetPoint('TOPLEFT', self.Texture, 103, -54)

        self.Texture:SetTexture('Interface\\Vehicles\\UI-Vehicle-Frame')
    end

    self.Name.Bg:Hide()

    self.Name:SetWidth(100)
    self.Name:SetPoint('CENTER', self.Texture, 30, 23)

    if (self.Portrait.Bg) then
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 52, -19)
        self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 23, -12)
    else
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 23, -12)
    end

    if (self.PvP) then
        self.PvP:SetPoint('TOPLEFT', self.Texture, 3, -28)
    end

    self.Leader:SetPoint('TOPLEFT', self.Texture, 23, -14)
    self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 74, -14)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -5)

    self.TabMiddle:SetPoint('BOTTOM', self.Name, 'TOP', 0, 10)
end

local function VehicleToPlayerTexture(self, event, unit)
    self.Level:Show()
    self.ThreatGlow:Show()

    self.LFDRole:SetAlpha(1)

    self.Texture:SetHeight(100)
    self.Texture:SetWidth(232)
    self.Texture:SetPoint('CENTER', self, -20, -7)
    self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
    
    if (config.units.player.style == 'NORMAL') then
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame')
    elseif (config.units.player.style == 'RARE') then
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame-Rare')
    elseif (config.units.player.style == 'ELITE') then
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame-Elite')
    elseif (config.units.player.style == 'CUSTOM') then
        self.Texture:SetTexture(config.units.player.customTexture)
    end

    self.Health:SetHeight(12)
    self.Health:SetWidth(119)
    self.Health:SetPoint('TOPLEFT', self.Texture, 107, -41)

    self.Name.Bg:Show()

    self.Name:SetWidth(110)
    self.Name:SetPoint('CENTER', self.Texture, 50, 19)

    if (self.Portrait.Bg) then
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 49, -19)
        self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 42, -12)
    else
        self.Portrait:SetPoint('TOPLEFT', self.Texture, 42, -12)
    end

    if (self.PvP) then
        self.PvP:SetPoint('TOPLEFT', self.Texture, 18, -20)
    end

    self.Leader:SetPoint('TOPLEFT', self.Portrait, 3, 2)
    self.MasterLooter:SetPoint('TOPRIGHT', self.Portrait, -3, 3)
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)

    self.TabMiddle:SetPoint('BOTTOM', self.Name.Bg, 'TOP', -1, 0)
end

local function SetTabAlpha(self, alpha)
    self.TabMiddle:SetAlpha(alpha)
    self.TabLeft:SetAlpha(alpha)
    self.TabRight:SetAlpha(alpha)
    self.TabText:SetAlpha(alpha)
end

local function CreateUnitTabTexture(self, text)
    self.TabMiddle = self:CreateTexture(nil, 'BACKGROUND')
    self.TabMiddle:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
    self.TabMiddle:SetAlpha(0.5)
    self.TabMiddle:SetSize(24, 18)
    self.TabMiddle:SetTexCoord(0.1875, 0.53125, 0, 1)

    self.TabLeft = self:CreateTexture(nil, 'BACKGROUND')
    self.TabLeft:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
    self.TabLeft:SetPoint('LEFT', self.TabMiddle, 'RIGHT')
    self.TabLeft:SetAlpha(0.5)
    self.TabLeft:SetSize(24, 18)
    self.TabLeft:SetTexCoord(0.53125, 0.71875, 0, 1)

    self.TabRight = self:CreateTexture(nil, 'BACKGROUND')
    self.TabRight:SetTexture('Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator')
    self.TabRight:SetPoint('RIGHT', self.TabMiddle, 'LEFT')
    self.TabRight:SetAlpha(0.5)
    self.TabRight:SetSize(24, 18)
    self.TabRight:SetTexCoord(0, 0.1875, 0, 1)

    self.TabText = self:CreateFontString(nil, 'OVERLAY')
    self.TabText:SetFont(config.font.normal, config.font.normalSize - 1)
    self.TabText:SetShadowOffset(1, -1)
    self.TabText:SetPoint('BOTTOM', self.TabMiddle, 0, 2)
    self.TabText:SetAlpha(0.5)
    self.TabText:SetText(text or '')
end

local function UpdateFlashStatus(self)
    if (UnitHasVehicleUI('player') or UnitIsDeadOrGhost('player')) then
        ns.StopFlash(self.StatusFlash)
        return
    end

    if (UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.1, 0.1, 1)

        if (not ns.IsFlashing(self.StatusFlash)) then
            ns.StartFlash(self.StatusFlash, 0.5, 0.5, 0.1, 0.1)
        end
    elseif (IsResting() and not UnitAffectingCombat('player')) then
        self.StatusFlash:SetVertexColor(1, 0.88, 0.25, 1)

        if (not ns.IsFlashing(self.StatusFlash)) then
            ns.StartFlash(self.StatusFlash, 0.5, 0.5, 0.1, 0.1)
        end
    else
        ns.StopFlash(self.StatusFlash)
    end
end

local function CheckVehicleStatus(self, event, unit)
    if (UnitHasVehicleUI('player')) then
        PlayerToVehicleTexture(self, event, unit)
    else
        VehicleToPlayerTexture(self, event, unit)
    end

    if (self.StatusFlash) then
        UpdateFlashStatus(self)
    end
end

local function UpdatePortraitColor(self, unit, min, max)
    if (not UnitIsConnected(unit)) then
        self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
    elseif (UnitIsDead(unit)) then
        self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
    elseif (UnitIsGhost(unit)) then
        self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
    elseif (min/max * 100 < 25) then
        if (UnitIsPlayer(unit)) then
            if (unit ~= 'player') then
                self.Portrait:SetVertexColor(1, 0, 0, 0.7)
            end
        end
    else
        self.Portrait:SetVertexColor(1, 1, 1, 1)
    end
end

    -- Update target and focus texture

local texPath = tarTexPath..'UI-TargetingFrame'
local texTable = {
    ['elite'] = texPath..'-Elite',
    ['rareelite'] = texPath..'-Rare-Elite',
    ['rare'] = texPath..'-Rare',
    ['worldboss'] = texPath..'-Elite',
    ['normal'] = texPath,
}

local function UpdateClassPortraits(self, unit)
    local _, unitClass = UnitClass(unit)
    if (unitClass and UnitIsPlayer(unit)) then
        self:SetTexture(tarTexPath..'UI-Classes-Circles')
        self:SetTexCoord(unpack(CLASS_ICON_TCOORDS[unitClass]))
    else
        self:SetTexCoord(0, 1, 0, 1)
    end
end

local function UpdateFrame(self, _, unit)
    if (self.unit ~= unit) then 
        return
    end

    if (unit == 'target' or unit == 'focus') then
        self.Texture:SetTexture(texTable[UnitClassification(unit)] or texTable['normal'])
    end
end

local function EnableMouseOver(self)
    self.Health.Value:Hide()

    if (self.Power and self.Power.Value) then
        self.Power.Value:Hide()
    end

    if (self.DruidMana and self.DruidMana.Value) then
        self.DruidMana.Value:Hide()
    end

    self:HookScript('OnEnter', function(self)
        self.Health.Value:Show()

        if (self.Power and self.Power.Value) then
            self.Power.Value:Show()
        end

        if (self.DruidMana and self.DruidMana.Value) then
            self.DruidMana.Value:Show()
        end

        UnitFrame_OnEnter(self)
    end)

    self:HookScript('OnLeave', function(self)
        self.Health.Value:Hide()

        if (self.Power and self.Power.Value) then
            self.Power.Value:Hide()
        end

        if (self.DruidMana and self.DruidMana.Value) then
            self.DruidMana.Value:Hide()
        end
        UnitFrame_OnLeave(self)
    end)
end

local function UpdateHealth(Health, unit, cur, max)
    local self = Health:GetParent()
    if (not self.Portrait.Bg) then
        UpdatePortraitColor(self, unit, cur, max)
    end
    
    if (self.Portrait.Bg) then
        self.Portrait.Bg:SetVertexColor(UnitSelectionColor(unit))
    end
    
    if (unit == 'target' or unit == 'focus') then
        if (self.Name.Bg) then
            self.Name.Bg:SetVertexColor(UnitSelectionColor(unit))
        end
    end

    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Health:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        Health:SetStatusBarColor(0, 1, 0)
    end

    Health.Value:SetText(ns.GetHealthText(unit, cur, max))
end

local function UpdatePower(Power, unit, cur, max)
    if (UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
        Power:SetValue(0)
    end

    Power.Value:SetText(ns.GetPowerText(unit, cur, max))
end

local function CreateUnitLayout(self, unit)
    self.IsMainFrame = ns.MultiCheck(unit, 'player', 'target', 'focus')
    self.IsTargetFrame = ns.MultiCheck(unit, 'targettarget', 'focustarget')
    self.IsPartyFrame = unit:match('party')

    if (self.IsTargetFrame) then
        self:SetFrameLevel(30)
    end

    self:RegisterForClicks('AnyUp')
    self:EnableMouse(true)

    self.menu = CreateDropDown
    self:SetAttribute('*type2', 'menu')

    if (config.units.focus.enableFocusToggleKeybind) then
        if (unit == 'focus') then
            self:SetAttribute(config.units.focus.focusToggleKey, 'macro')
            self:SetAttribute('macrotext', '/clearfocus')
        else
            self:SetAttribute(config.units.focus.focusToggleKey, 'focus')
        end
    end

    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)

        -- Create the castbars

    if (config.show.castbars) then
        ns.CreateCastbars(self, unit)
    end

        -- Texture

    self.Texture = self:CreateTexture(nil, 'BORDER')

    if (self.IsTargetFrame) then
        self.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\customTargetTargetTexture_2')
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('CENTER', self, 16, -10)
    elseif (unit == 'pet') then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture(tarTexPath..'UI-SmallTargetingFrame')
        self.Texture.SetTexture = function() end
    elseif (unit == 'target' or unit == 'focus') then
        self.Texture:SetSize(230, 100)
        self.Texture:SetPoint('CENTER', self, 20, -7)
        self.Texture:SetTexture(tarTexPath..'UI-TargetingFrame')
        self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    elseif (self.IsPartyFrame) then
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint('TOPLEFT', self, 0, -2)
        self.Texture:SetTexture(tarTexPath..'UI-PartyFrame')
    end

        -- Healthbar

    self.Health = CreateFrame('StatusBar', nil, self)
    self.Health:SetStatusBarTexture(config.media.statusbar)
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)

    if (unit == 'player') then
        self.Health:SetSize(119, 12)
    elseif (unit == 'pet') then
        self.Health:SetSize(69, 8)
        self.Health:SetPoint('TOPLEFT', self.Texture, 46, -22)
    elseif (unit == 'target' or unit == 'focus') then
        self.Health:SetSize(119, 12)
        self.Health:SetPoint('TOPRIGHT', self.Texture, -105, -41)
    elseif (self.IsTargetFrame) then
        self.Health:SetSize(46, 9)
        self.Health:SetPoint('CENTER', self, 18, 4)
    elseif (self.IsPartyFrame) then   
        self.Health:SetPoint('TOPLEFT', self.Texture, 47, -12)
        self.Health:SetSize(70, 7) 
    end

    self.Health:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health.PostUpdate = UpdateHealth
    self.Health.frequentUpdates = true
    self.Health.Smooth = true

        -- Health text

    self.Health.Value = self:CreateFontString(nil, 'OVERLAY')

    if (self.IsTargetFrame) then
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize - 2)
        self.Health.Value:SetPoint('CENTER', self.Health, 'BOTTOM', -4, 1)
    else
        self.Health.Value:SetFont(config.font.normal, config.font.normalSize)
        self.Health.Value:SetPoint('CENTER', self.Health, 1, 1)
    end

    self.Health.Value:SetShadowOffset(1, -1)

        -- Powerbar

    self.Power = CreateFrame('StatusBar', nil, self)
    self.Power:SetStatusBarTexture(config.media.statusbar)
    self.Power:SetFrameLevel(self:GetFrameLevel() - 1)

    if (self.IsTargetFrame) then
        self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', -8, 0)
        self.Power:SetHeight(self.Health:GetHeight() - 2)
    else
        self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, 0)
        self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, 0)
        self.Power:SetHeight(self.Health:GetHeight() - 1)
    end

    self.Power:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
    self.Power:SetBackdropColor(0, 0, 0, 0.55)

    self.Power.frequentUpdates = true
    self.Power.Smooth = true

    self.Power.colorPower = true

        -- Power text

    if (not self.IsTargetFrame) then
        self.Power.Value = self:CreateFontString(nil, 'OVERLAY')
        self.Power.Value:SetFont(config.font.normal, config.font.normalSize)
        self.Power.Value:SetShadowOffset(1, -1)
        self.Power.Value:SetPoint('CENTER', self.Power, 0, 1)

        self.Power.PostUpdate = UpdatePower
    end

        -- Name

    self.Name = self:CreateFontString(nil, 'OVERLAY')
    self.Name:SetFont(config.font.normalBig, config.font.normalBigSize)
    self.Name:SetShadowOffset(1, -1)
    self.Name:SetJustifyH('CENTER')
    self.Name:SetHeight(10)

    if (unit == 'pet') then
        self.Name:SetWidth(110)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 5)
    elseif (unit == 'target' or unit == 'focus') then
        self.Name:SetWidth(110)
        self.Name:SetPoint('CENTER', self, 'CENTER', -30, 12)
    elseif (self.IsTargetFrame) then
        self.Name:SetWidth(65)
        self.Name:SetJustifyH('LEFT')
        self.Name:SetPoint('TOPLEFT', self, 'CENTER', -4, -11)
    elseif (self.IsPartyFrame) then    
        self.Name:SetJustifyH('CENTER')
        self.Name:SetHeight(10)
        self.Name:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
    end

    self:Tag(self.Name, '[name]')

        -- Level

    if (self.IsMainFrame) then
        self.Level = self:CreateFontString(nil, 'ARTWORK')
        self.Level:SetFont('Interface\\AddOns\\oUF_Neav\\media\\fontNumber.ttf', 17, 'THINOUTLINE')
        self.Level:SetShadowOffset(0, 0)
        self.Level:SetPoint('CENTER', self.Texture, (unit == 'player' and -63) or 63, -16)
        self:Tag(self.Level, '[level]')
    end

        -- Portrait

    if (config.show.threeDPortraits) then    
        self.Portrait = CreateFrame('PlayerModel', nil, self)
        self.Portrait:SetFrameStrata('BACKGROUND')

        self.Portrait.Bg = self.Health:CreateTexture(nil, 'BACKGROUND')
        self.Portrait.Bg:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\portraitBackground')
        self.Portrait.Bg:SetParent(self.Portrait)

        if (unit == 'player') then
            self.Portrait:SetSize(50, 50)
            self.Portrait.Bg:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)

            self.Portrait.Bg:SetSize(37, 37)
            self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 7, -6)
        elseif (unit == 'target' or unit == 'focus') then
            self.Portrait:SetSize(50, 50)
            self.Portrait:SetPoint('TOPRIGHT', self.Texture, -50, -19)

            self.Portrait.Bg:SetSize(64, 64)
            self.Portrait.Bg:SetPoint('TOPRIGHT', self.Texture, -42, -12)
        elseif (self.IsTargetFrame) then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('LEFT', self, 'CENTER', -38, -1)

            self.Portrait.Bg:SetSize(40, 40)
            self.Portrait.Bg:SetPoint('LEFT', self, 'CENTER', -43, 0)
        elseif (self.IsPartyFrame) then
            self.Portrait:SetSize(30, 30)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 9, -8)

            self.Portrait.Bg:SetSize(37, 37)
            self.Portrait.Bg:SetPoint('TOPLEFT', self.Texture, 7, -6)
        end
    else
        self.Portrait = self.Health:CreateTexture('$parentPortrait', 'BACKGROUND')

        if (unit == 'player') then
            self.Portrait:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.Portrait:SetSize(37, 37)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
        elseif (unit == 'target' or unit == 'focus') then
            self.Portrait:SetSize(64, 64)
            self.Portrait:SetPoint('TOPRIGHT', self.Texture, -42, -12)
        elseif (self.IsTargetFrame) then
            self.Portrait:SetSize(40, 40)
            self.Portrait:SetPoint('LEFT', self, 'CENTER', -43, 0)
        elseif (self.IsPartyFrame) then
            self.Portrait:SetSize(37, 37)
            self.Portrait:SetPoint('TOPLEFT', self.Texture, 7, -6)
        end

        if (config.show.classPortraits) then
            self.Portrait.PostUpdate = UpdateClassPortraits
        end
    end

        -- Portrait timer

    if (config.show.portraitTimer) then
        self.PortraitTimer = CreateFrame('Frame', nil, self.Health)

        self.PortraitTimer.Icon = self.PortraitTimer:CreateTexture(nil, 'BACKGROUND')
        self.PortraitTimer.Icon:SetAllPoints(self.Portrait.Bg or self.Portrait)

        self.PortraitTimer.Remaining = self.PortraitTimer:CreateFontString(nil, 'OVERLAY')
        self.PortraitTimer.Remaining:SetPoint('CENTER', self.PortraitTimer.Icon) 
        self.PortraitTimer.Remaining:SetFont(config.font.normal, (self.Portrait:GetWidth()/3.5), 'THINOUTLINE')
        self.PortraitTimer.Remaining:SetTextColor(1, 1, 1)
    end

        -- Pvp icons

    if (config.show.pvpicons) then
        self.PvP = self:CreateTexture(nil, 'OVERLAY')

        if (unit == 'player') then
            self.PvP:SetSize(64, 64)
        elseif (unit == 'pet') then
            self.PvP:SetSize(50, 50)
            self.PvP:SetPoint('CENTER', self.Portrait, 'LEFT', 7, -7)
        elseif (unit == 'target' or unit == 'focus') then
            self.PvP:SetSize(64, 64)
            self.PvP:SetPoint('TOPRIGHT', self.Texture, 3, -20)
        elseif (self.IsPartyFrame) then
            self.PvP:SetSize(40, 40)
            self.PvP:SetPoint('TOPLEFT', self.Texture, -9, -10)
        end
    end

        -- Masterlooter icon

    self.MasterLooter = self:CreateTexture(nil, 'OVERLAY')
    self.MasterLooter:SetSize(16, 16)

    if (unit == 'target' or unit == 'focus') then
        self.MasterLooter:SetPoint('TOPLEFT', self.Portrait, 3, 3)
    elseif (self.IsTargetFrame) then
        self.MasterLooter:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 3, -3)
    elseif (self.IsPartyFrame) then  
        self.MasterLooter:SetSize(14, 14)
        self.MasterLooter:SetPoint('TOPLEFT', self.Texture, 29, 0)
    end

        -- Groupleader icon

    self.Leader = self:CreateTexture(nil, 'OVERLAY')
    self.Leader:SetSize(16, 16)

    if (unit == 'target' or unit == 'focus') then
        self.Leader:SetPoint('TOPRIGHT', self.Portrait, -3, 2)
    elseif (self.IsTargetFrame) then
        self.Leader:SetPoint('TOPLEFT', self.Portrait, -3, 4)
    elseif (self.IsPartyFrame) then
        self.Leader:SetSize(14, 14)
        self.Leader:SetPoint('CENTER', self.Portrait, 'TOPLEFT', 1, -1)
    end

        -- Raidicons

    self.RaidIcon = self:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetPoint('CENTER', self.Portrait, 'TOP', 0, -1)
    self.RaidIcon:SetTexture(tarTexPath..'UI-RaidTargetingIcons')
    local s1 = self.Portrait.Bg and self.Portrait.Bg:GetSize()/3 or self.Portrait:GetSize()/3
    self.RaidIcon:SetSize(s1, s1)

        -- Phase icon
    
    if (not IsTargetFrame) then
        self.PhaseIcon = self:CreateTexture(nil, 'OVERLAY')
        self.PhaseIcon:SetPoint('CENTER', self.Portrait, 'BOTTOM')
        
        if (self.IsMainFrame) then
            self.PhaseIcon:SetSize(26, 26)
        else
            self.PhaseIcon:SetSize(18, 18)
        end
    end

        -- Offline icons

    self.OfflineIcon = self:CreateTexture(nil, 'OVERLAY')
    self.OfflineIcon:SetPoint('TOPRIGHT', self.Portrait, 7, 7)
    self.OfflineIcon:SetPoint('BOTTOMLEFT', self.Portrait, -7, -7)

        -- Ready check icons

    if (unit == 'player' or self.IsPartyFrame) then
        self.ReadyCheck = self:CreateTexture(nil, 'OVERLAY')
        self.ReadyCheck:SetPoint('TOPRIGHT', self.Portrait, -7, -7)
        self.ReadyCheck:SetPoint('BOTTOMLEFT', self.Portrait, 7, 7)
        self.ReadyCheck.delayTime = 2
        self.ReadyCheck.fadeTime = 0.5
    end

        -- Threat textures

    self.ThreatGlow = self:CreateTexture(nil, 'BACKGROUND')

    if (unit == 'player') then
        self.ThreatGlow:SetSize(242, 92)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, 13, 0)
        self.ThreatGlow:SetTexture(tarTexPath..'UI-TargetingFrame-Flash')
        self.ThreatGlow:SetTexCoord(0.945, 0, 0 , 0.182)
    elseif (unit == 'pet') then
        self.ThreatGlow:SetSize(128, 64)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -4, 12)
        self.ThreatGlow:SetTexture(tarTexPath..'UI-PartyFrame-Flash')
        self.ThreatGlow:SetTexCoord(0, 1, 1, 0)
    elseif (unit == 'target' or unit == 'focus') then
        self.ThreatGlow:SetSize(239, 94)
        self.ThreatGlow:SetPoint('TOPRIGHT', self.Texture, -14, 1)
        self.ThreatGlow:SetTexture(tarTexPath..'UI-TargetingFrame-Flash')
        self.ThreatGlow:SetTexCoord(0, 0.945, 0, 0.182)
    elseif (self.IsPartyFrame) then
        self.ThreatGlow:SetSize(128, 63)
        self.ThreatGlow:SetPoint('TOPLEFT', self.Texture, -3, 4)
        self.ThreatGlow:SetTexture(tarTexPath..'UI-PartyFrame-Flash')
    end

        -- Lfd role icon

    if (self.IsPartyFrame or unit == 'player' or unit == 'target') then
        self.LFDRole = self:CreateTexture(nil, 'ARTWORK')
        self.LFDRole:SetSize(20, 20)

        if (unit == 'player') then
            self.LFDRole:SetPoint('BOTTOMRIGHT', self.Portrait, -2, -3)
        elseif (unit == 'target') then
            self.LFDRole:SetPoint('TOPLEFT', self.Portrait, -10, -2)
        else
            self.LFDRole:SetPoint('BOTTOMLEFT', self.Portrait, -5, -5)
        end
    end

        -- Playerframe

    if (unit == 'player') then
        self:SetSize(175, 42)

        self.Name.Bg = self:CreateTexture(nil, 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Name.Bg:SetVertexColor(0, 0, 0, 0.55)

            -- Warlock soulshard bar

        if (playerClass == 'WARLOCK') then
            ShardBarFrame:SetParent(oUF_Neav_Player)
            ShardBarFrame:SetScale(config.units.player.scale * 0.8)
            ShardBar_OnLoad(ShardBarFrame)
            ShardBarFrame:ClearAllPoints()
            ShardBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, -1)
            ShardBarFrame:Show()
        end

            -- Holy power bar

        if (playerClass == 'PALADIN') then
            PaladinPowerBar:SetParent(oUF_Neav_Player)
            PaladinPowerBar:SetScale(config.units.player.scale * 0.81)
            PaladinPowerBar_OnLoad(PaladinPowerBar)
            PaladinPowerBar:ClearAllPoints()
            PaladinPowerBar:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 25, 2)
            PaladinPowerBar:Show()
        end

            -- Deathknight runebar

        if (playerClass == 'DEATHKNIGHT') then
            RuneFrame:ClearAllPoints()
            RuneFrame:SetPoint('TOP', self.Power, 'BOTTOM', 2, -2)
            RuneFrame:SetParent(self)
        end

        if (playerClass == 'SHAMAN') then
            TotemFrame:ClearAllPoints()
            TotemFrame:SetPoint('TOP', self.Power, 'BOTTOM', -2, -0)
            TotemFrame:SetParent(oUF_Neav_Player)
            TotemFrame:SetScale(config.units.player.scale * 0.65)
            TotemFrame:Show()

            for i = 1, 4 do
                _G['TotemFrameTotem'..i]:SetFrameStrata('LOW')

                _G['TotemFrameTotem'..i..'IconCooldown']:SetAlpha(0)

                _G['TotemFrameTotem'..i..'Duration']:SetParent(self)
                _G['TotemFrameTotem'..i..'Duration']:SetDrawLayer('OVERLAY')
                _G['TotemFrameTotem'..i..'Duration']:ClearAllPoints()
                _G['TotemFrameTotem'..i..'Duration']:SetPoint('BOTTOM', _G['TotemFrameTotem'..i], 0, 3)
                _G['TotemFrameTotem'..i..'Duration']:SetFont(config.font.normal, 10, 'OUTLINE')
                _G['TotemFrameTotem'..i..'Duration']:SetShadowOffset(0, 0)
            end
        end

        if (playerClass == 'DRUID') then

                -- Druid eclipse bar

            EclipseBarFrame:SetParent(oUF_Neav_Player)
            EclipseBarFrame:SetScale(config.units.player.scale * 0.82)
            EclipseBar_OnLoad(EclipseBarFrame)
            EclipseBarFrame:ClearAllPoints()
            EclipseBarFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 30, 3)
            EclipseBarFrame:Show()

                -- Druid mushroom timer

            TotemFrame:ClearAllPoints()
            TotemFrame:SetPoint('TOP', oUF_Neav_Player, 'BOTTOM', 50, 20)
            TotemFrame:SetParent(oUF_Neav_Player)
            TotemFrame:SetScale(config.units.player.scale * 0.65)
            TotemFrame:Show()

            for i = 1, 3 do
                _G['TotemFrameTotem'..i]:EnableMouse(false)
                _G['TotemFrameTotem'..i]:SetAlpha(0)
                _G['TotemFrameTotem'..i..'Duration']:SetParent(self)
                _G['TotemFrameTotem'..i..'Duration']:SetDrawLayer('OVERLAY')
                _G['TotemFrameTotem'..i..'Duration']:SetFont(config.font.normal, 12)
                _G['TotemFrameTotem'..i..'Duration']:SetTextColor(0.3, 1, 0)
                -- _G['TotemFrameTotem'..i..'Duration']:SetTextColor(0.3, 1, 0)
                -- _G['TotemFrameTotem'..i..'Duration']:SetAlpha(0.75)
            end

            TotemFrameTotem3Duration:ClearAllPoints()
            TotemFrameTotem3Duration:SetPoint('LEFT', TotemFrameTotem2Duration, 'RIGHT', 5, 0)

            TotemFrameTotem1Duration:ClearAllPoints()
            TotemFrameTotem1Duration:SetPoint('RIGHT', TotemFrameTotem2Duration, 'LEFT', -6, 0)

                -- Druid powerbar

            self.DruidMana = CreateFrame('StatusBar', nil, self)
            self.DruidMana:SetPoint('TOP', self.Power, 'BOTTOM', 0, -1)
            self.DruidMana:SetStatusBarTexture(config.media.statusbar, 'BORDER')
            self.DruidMana:SetSize(99, 9)
            self.DruidMana:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
            self.DruidMana:SetBackdropColor(0, 0, 0, 0.55)
            self.DruidMana.colorPower = true

            self.DruidMana.Value = self.DruidMana:CreateFontString(nil, 'OVERLAY')
            self.DruidMana.Value:SetFont(config.font.normal, config.font.normalSize)
            self.DruidMana.Value:SetShadowOffset(1, -1)
            self.DruidMana.Value:SetPoint('CENTER', self.DruidMana, 0, 0.5)

            self:Tag(self.DruidMana.Value, '[druidmana]')
            
            self.DruidMana.Texture = self.DruidMana:CreateTexture(nil, 'ARTWORK')
            self.DruidMana.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\druidmanaTexture')
            self.DruidMana.Texture:SetSize(104, 28)
            self.DruidMana.Texture:SetPoint('TOP', self.Power, 'BOTTOM', 0, 6)
            
            local function MoveShrooms(self)
                if (EclipseBarFrame:IsVisible()) then
                    TotemFrameTotem2Duration:ClearAllPoints()
                    TotemFrameTotem2Duration:SetPoint('TOP', self.Power, 'BOTTOM', 0, -27)
                elseif (self.DruidMana:IsVisible()) then
                    TotemFrameTotem2Duration:ClearAllPoints()
                    TotemFrameTotem2Duration:SetPoint('TOP', self.Power, 'BOTTOM', 0, -15)
                else
                    TotemFrameTotem2Duration:ClearAllPoints()
                    TotemFrameTotem2Duration:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
                end
            end 


            self.DruidMana:HookScript('OnHide', function()
                MoveShrooms(self)
            end)

            self.DruidMana:HookScript('OnShow', function()
                MoveShrooms(self)
            end)

            EclipseBarFrame:SetScript('OnHide', function()
                MoveShrooms(self)
            end)

            EclipseBarFrame:SetScript('OnShow', function()
                MoveShrooms(self)
            end)

            MoveShrooms(self)
        end

            -- Raidgroup indicator

        local function UpdatePartyTab(self)
            for i = 1, MAX_RAID_MEMBERS do
                if (GetNumRaidMembers() > 0) then
                    local unitName, _, groupNumber = GetRaidRosterInfo(i)
                    if (unitName == UnitName('player')) then
                        self.TabText:SetText(GROUP..' '..groupNumber)
                        self.TabMiddle:SetWidth(self.TabText:GetWidth())

                        SetTabAlpha(self, 0.5)
                    end
                else
                    SetTabAlpha(self, 0)
                end
            end
        end

        CreateUnitTabTexture(self)
        UpdatePartyTab(self) 

        self:RegisterEvent('RAID_ROSTER_UPDATE', UpdatePartyTab)
        self:RegisterEvent('PARTY_MEMBER_CHANGED', UpdatePartyTab)

            -- Resting/combat status flashing

        if (config.units.player.showStatusFlash) then
            self.StatusFlash = self:CreateTexture(nil, 'ARTWORK')
            self.StatusFlash:SetTexture('Interface\\CharacterFrame\\UI-Player-Status')
            self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
            self.StatusFlash:SetBlendMode('ADD')
            self.StatusFlash:SetSize(192, 66)
            self.StatusFlash:SetPoint('TOPLEFT', self.Texture, 35, -8)
            self.StatusFlash:SetAlpha(0)

            UpdateFlashStatus(self, _, unit) 

            self:RegisterEvent('PLAYER_DEAD', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UNGHOST', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_ALIVE', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_UPDATE_RESTING', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateFlashStatus)
            self:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateFlashStatus)
        end

            -- Pvptimer

        if (self.PvP) then
            self.PvPTimer = self:CreateFontString(nil, 'OVERLAY')
            self.PvPTimer:SetFont(config.font.normal, config.font.normalSize)
            self.PvPTimer:SetShadowOffset(1, -1)
            self.PvPTimer:SetPoint('BOTTOM', self.PvP, 'TOP', -12, -3   )
            self.PvPTimer.frequentUpdates = 0.5
            self:Tag(self.PvPTimer, '[pvptimer]')
        end

            -- oUF_Swing support 

        if (config.units.player.showSwingTimer) then
            self.Swing = CreateFrame('Frame', nil, self)
            self.Swing:SetFrameStrata('LOW')
            -- self.Swing:SetSize(200, 7)
            self.Swing:SetHeight(7)
            self.Swing:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Swing:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Swing:Hide()

            self.Swing.texture = config.media.statusbar
            self.Swing.color = {0, 0.8, 1, 1}

            self.Swing.textureBG = config.media.statusbar
            self.Swing.colorBG = {0, 0, 0, 0.55}

            self.Swing:CreateBeautyBorder(11)
            self.Swing:SetBeautyBorderPadding(3)

            self.Swing.f = CreateFrame('Frame', nil, self.Swing)
            self.Swing.f:SetFrameStrata('HIGH')       

            self.Swing.Text = self.Swing.f:CreateFontString(nil, 'OVERLAY')
            self.Swing.Text:SetFont(config.font.normal, config.font.normalSize)
            self.Swing.Text:SetPoint('CENTER', self.Swing)

            self.Swing.disableMelee = false
            self.Swing.disableRanged = false
            self.Swing.hideOoc = true
        end

            -- oUF_Vengeance support 

        if (config.units.player.showVengeance) then
            self.Vengeance = CreateFrame('StatusBar', nil, self)
            self.Vengeance:SetHeight(7)
            self.Vengeance:SetPoint('TOPLEFT', self.Castbar, 'BOTTOMLEFT', 0, -10)
            self.Vengeance:SetPoint('TOPRIGHT', self.Castbar, 'BOTTOMRIGHT', 0, -10)
            self.Vengeance:SetStatusBarTexture(config.media.statusbar)
            self.Vengeance:SetStatusBarColor(1, 0, 0)

            self.Vengeance:CreateBeautyBorder(11)
            self.Vengeance:SetBeautyBorderPadding(3)

            self.Vengeance.Bg = self.Vengeance:CreateTexture(nil, 'BACKGROUND')
            self.Vengeance.Bg:SetAllPoints(self.Vengeance)
            self.Vengeance.Bg:SetTexture(0, 0, 0, 0.55)

            self.Vengeance.Text = self.Vengeance:CreateFontString(nil, 'OVERLAY')
            self.Vengeance.Text:SetFont(config.font.normal, config.font.normalSize)
            self.Vengeance.Text:SetPoint('CENTER', self.Vengeance)
        end

            -- Combat text

        if (config.units.player.showCombatFeedback) then
            self.CombatFeedbackText = self:CreateFontString(nil, 'OVERLAY')
            self.CombatFeedbackText:SetFont(config.font.normal, 18, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end

            -- Combat icon

        self.Combat = self:CreateTexture(nil, 'OVERLAY')
        self.Combat:SetPoint('CENTER', self.Level, 1, 0)
        self.Combat:SetSize(31, 33)

           -- Resting icon

        self.Resting = self:CreateTexture(nil, 'OVERLAY')
        self.Resting:SetPoint('CENTER', self.Level, -0.5, 0)
        self.Resting:SetSize(31, 34)

            -- Player frame vehicle/normal update

        CheckVehicleStatus(self, _, unit)

        self:RegisterEvent('UNIT_ENTERED_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_ENTERING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITING_VEHICLE', CheckVehicleStatus)
        self:RegisterEvent('UNIT_EXITED_VEHICLE', CheckVehicleStatus)
    end

        -- Petframe

    if (unit == 'pet') then
        self:SetSize(175, 42)


        if (not config.units[ns.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs.size = 20
            self.Debuffs:SetWidth(self.Debuffs.size * 4)
            self.Debuffs:SetHeight(self.Debuffs.size)
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 1, -3)
            self.Debuffs.initialAnchor = 'TOPLEFT'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs.num = 9
        end
    end

        -- Target + focusframe

    if (unit == 'target' or unit == 'focus') then
        self:SetSize(175, 42)

            -- Colored name background

        self.Name.Bg = self:CreateTexture(nil, 'BACKGROUND')
        self.Name.Bg:SetHeight(18)
        self.Name.Bg:SetTexCoord(0.2, 0.8, 0.3, 0.85)
        self.Name.Bg:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT')
        self.Name.Bg:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT') 
        self.Name.Bg:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\nameBackground')

            -- Combat feedback text

        if (config.units.target.showCombatFeedback or config.units.focus.showCombatFeedback) then
            self.CombatFeedbackText = self:CreateFontString(nil, 'OVERLAY')
            self.CombatFeedbackText:SetFont(config.font.normal, 18, 'OUTLINE')
            self.CombatFeedbackText:SetShadowOffset(0, 0)
            self.CombatFeedbackText:SetPoint('CENTER', self.Portrait)
        end

            -- Questmob icon

        self.QuestIcon = self:CreateTexture(nil, 'OVERLAY')
        self.QuestIcon:SetSize(32, 32)
        self.QuestIcon:SetPoint('CENTER', self.Health, 'TOPRIGHT', 1, 10)

        table.insert(self.__elements, UpdateFrame)
    end

    if (unit == 'target') then
        CreateUnitTabTexture(self, SET_FOCUS)

        self.TabMiddle:SetWidth(self.TabText:GetWidth() - 10)
        self.TabMiddle:SetPoint('BOTTOM', self.Name.Bg, 'TOP', 0, 1)

        SetTabAlpha(self, 0)
        CreateFocusButton(self)

            -- combo point stuff

        if (config.units.target.showComboPoints) then

                -- owl rotater

            local h = CreateFrame('Frame', nil, self.Health)
            h:SetSize(55, 55)
            h:SetPoint('CENTER', self.Portrait.Bg or self.Portrait, 0, -0.5)
            h:SetAlpha(0.8)

            h.Texture = h:CreateTexture(nil, 'BACKGROUND')
            h.Texture:SetAllPoints(h)
            h.Texture:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\owlRotater')
            h.Texture:SetBlendMode('BLEND')
            h.Texture.minAlpha = 0.25
            h.Texture:SetAlpha(0)

            local group = h.Texture:CreateAnimationGroup()
            group:SetLooping('REPEAT')

            local path = group:CreateAnimation('Rotation')
            path:SetDegrees(-360)
            path:SetDuration(9)

            if (config.units.target.showComboPointsAsNumber) then
                self.ComboPoints = self:CreateFontString(nil, 'OVERLAY')
                self.ComboPoints:SetFont(DAMAGE_TEXT_FONT, 26, 'OUTLINE')
                self.ComboPoints:SetShadowOffset(0, 0)
                self.ComboPoints:SetPoint('LEFT', self.Portrait, 'RIGHT', 8, 4)
                self.ComboPoints:SetTextColor(unpack(config.units.target.numComboPointsColor))
                self:Tag(self.ComboPoints, '[combopoints]')
            else
                self.CPoints = {}

                for i = 1, 5 do
                    self.CPoints[i] = self:CreateTexture(nil, 'OVERLAY')
                    self.CPoints[i]:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\comboPoint')
                    self.CPoints[i]:SetSize(15, 15)
                end

                self.CPoints[1]:SetPoint('TOPRIGHT', self.Texture, -42, -8)
                self.CPoints[2]:SetPoint('TOP', self.CPoints[1], 'BOTTOM', 7.33, 6.66)
                self.CPoints[3]:SetPoint('TOP', self.CPoints[2], 'BOTTOM', 4.66, 4.33)
                self.CPoints[4]:SetPoint('TOP', self.CPoints[3], 'BOTTOM', 1.33 , 3.66)     
                self.CPoints[5]:SetPoint('TOP', self.CPoints[4], 'BOTTOM', -1.66, 3.66)
                
                self.CPointsBG = {}
                for i = 1, 5 do
                    self.CPointsBG[i] = self:CreateTexture(nil, 'ARTWORK')
                    self.CPointsBG[i]:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\comboPointBackground')
                    self.CPointsBG[i]:SetSize(15, 15)
                    self.CPointsBG[i]:SetAllPoints(self.CPoints[i])
                    self.CPointsBG[i]:SetAlpha(0)
                end

                hooksecurefunc(self.CPoints[1], 'Show', function()
                    for i = 1, 5 do
                        securecall('UIFrameFadeIn', self.CPointsBG[i], 0.25, self.CPointsBG[i]:GetAlpha(), 0.9)
                    end
                end)

                hooksecurefunc(self.CPoints[1], 'Hide', function()
                    for i = 1, 5 do
                        self.CPointsBG[i]:SetAlpha(0)
                    end
                end)

                hooksecurefunc(self.CPoints[5], 'Show', function()
                    group:Play()
                    ns.StartFlash(h.Texture, 0.4, 0.4, 0, 0)
                end)

                hooksecurefunc(self.CPoints[5], 'Hide', function()
                    group:Stop()
                    ns.StopFlash(h.Texture)
                end)
            end
        end

        if (not config.units[ns.cUnit(unit)].disableAura) then
            self.Auras = CreateFrame('Frame', nil, self)
            self.Auras.gap = true
            self.Auras.size = 20
            self.Auras:SetHeight(self.Auras.size * 3)
            self.Auras:SetWidth(self.Auras.size * 5)
            self.Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -5)
            self.Auras.initialAnchor = 'TOPLEFT'
            self.Auras['growth-x'] = 'RIGHT'
            self.Auras['growth-y'] = 'DOWN'
            self.Auras.numBuffs = config.units.target.numBuffs
            self.Auras.numDebuffs = config.units.target.numDebuffs
            self.Auras.spacing = 4.5

            self.Auras.customBreak = true
        end
    end

    if (unit == 'focus') then
        CreateUnitTabTexture(self, FOCUS)

        self.TabText:SetPoint('BOTTOM', self.TabMiddle, -4, 2)

        self.TabMiddle:SetPoint('BOTTOM', self.Name.Bg, 'TOP', 0, 1)
        self.TabMiddle:SetWidth(self.TabText:GetWidth() + 4)

        self.FClose = CreateFrame('Button', nil, self, 'SecureActionButtonTemplate')
        self.FClose:EnableMouse(true)
        self.FClose:RegisterForClicks('AnyUp')
        self.FClose:SetAttribute('type', 'macro')
        self.FClose:SetAttribute('macrotext', '/clearfocus')
        self.FClose:SetSize(20, 20)
        self.FClose:SetAlpha(0.65)
        self.FClose:SetPoint('TOPLEFT', self, (56 + (self.TabMiddle:GetWidth()/2)), 17)
        self.FClose:SetNormalTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Up')
        self.FClose:SetPushedTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Down')
        self.FClose:SetHighlightTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight')
        self.FClose:GetHighlightTexture():SetBlendMode('ADD')

        self.FClose:HookScript('OnLeave', function()
            securecall('UIFrameFadeOut', self.TabText, 0.15, self.TabText:GetAlpha(), 0.5)
        end)

        self.FClose:HookScript('OnEnter', function()
            securecall('UIFrameFadeIn', self.TabText, 0.15, self.TabText:GetAlpha(), 1)
        end)

        if (not config.units[ns.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs.size = 26
            self.Debuffs:SetHeight(self.Debuffs.size * 3)
            self.Debuffs:SetWidth(self.Debuffs.size * 3)
            self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -5)
            self.Debuffs.initialAnchor = 'TOPLEFT'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs.num = config.units.focus.numDebuffs
            self.Debuffs.spacing = 4
        end
    end

    if (self.IsTargetFrame) then
        self:SetSize(85, 20)

        if (not config.units[ns.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs:SetHeight(20)
            self.Debuffs:SetWidth(20 * 3)
            self.Debuffs.size = 20
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 7, 0)
            self.Debuffs.initialAnchor = 'LEFT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs.num = 4
        end
    end

    if (self.IsPartyFrame) then
        self:SetSize(105, 30)

        if (not config.units[ns.cUnit(unit)].disableAura) then
            self.Debuffs = CreateFrame('Frame', nil, self)
            self.Debuffs:SetFrameStrata('BACKGROUND')
            self.Debuffs:SetHeight(20)
            self.Debuffs:SetWidth(20 * 3)
            self.Debuffs.size = 20
            self.Debuffs.spacing = 4
            self.Debuffs:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 5, 1)
            self.Debuffs.initialAnchor = 'LEFT'
            self.Debuffs['growth-y'] = 'DOWN'
            self.Debuffs['growth-x'] = 'RIGHT'
            self.Debuffs.num = 3
        end
    end

        -- Mouseover text

    if (config.units[ns.cUnit(unit)] and config.units[ns.cUnit(unit)].mouseoverText) then
        EnableMouseOver(self)
    end

    if (self.Auras) then
        self.Auras.PostCreateIcon = ns.UpdateAuraIcons
        self.Auras.PostUpdateIcon = ns.PostUpdateIcon
        self.Auras.showDebuffType = true
    elseif (self.Buffs) then
        self.Buffs.PostCreateIcon = ns.UpdateAuraIcons
        self.Buffs.PostUpdateIcon = ns.PostUpdateIcon
    elseif (self.Debuffs) then
        self.Debuffs.PostCreateIcon = ns.UpdateAuraIcons
        self.Debuffs.PostUpdateIcon = ns.PostUpdateIcon
        self.Debuffs.showDebuffType = true
    end

    self:SetScale(config.units[ns.cUnit(unit)] and config.units[ns.cUnit(unit)].scale or 1)

        -- OOR and oUF_SpellRange settings

    if (unit == 'pet' or self.IsPartyFrame) then
        self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }

        self.SpellRange = true

        self.SpellRange = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }
    end

    return self
end

oUF:RegisterStyle('oUF_Neav', CreateUnitLayout)
oUF:Factory(function(self)

        -- Player frame spawn

    local player = self:Spawn('player', 'oUF_Neav_Player')
    player:SetPoint('TOPLEFT', __pa)

    player:SetScript('OnDragStart', function()
        __pa:StartMoving()
    end)

    player:SetScript('OnDragStop', function()
        __pa:StopMovingOrSizing()
    end)

    player:SetScript('OnReceiveDrag', function()
        if (CursorHasItem()) then
            AutoEquipCursorItem()
        end
    end)

        -- Pet frame spawn

    local pet = self:Spawn('pet', 'oUF_Neav_Pet')
    pet:SetPoint('TOPLEFT', player, 'BOTTOMLEFT', unpack(config.units.pet.position))
    
        -- Target frame spawn

    local target = self:Spawn('target', 'oUF_Neav_Target')
    target:SetPoint('TOPLEFT', __ta)
    
    target:SetScript('OnDragStart', function()
        __ta:StartMoving()
    end)

    target:SetScript('OnDragStop', function()
        __ta:StopMovingOrSizing()
    end)

    target:SetScript('OnReceiveDrag', function()
        if (CursorHasItem()) then
            AutoEquipCursorItem()
        end
    end)

        -- Targettarget frame spawn

    local targettarget = self:Spawn('targettarget', 'oUF_Neav_TargetTarget')
    targettarget:SetPoint('TOPLEFT', target, 'BOTTOMRIGHT', -78, -15)

        -- Focus frame spawn

    local focus = self:Spawn('focus', 'oUF_Neav_Focus')
    focus:SetPoint('TOPLEFT', __fa)
    focus:RegisterForDrag('LeftButton') 

    focus:SetScript('OnDragStart', function()
        FOCUS_FRAME_MOVING = false
        if (not FOCUS_FRAME_LOCKED) then
            __fa:StartMoving()
            FOCUS_FRAME_MOVING = true
        end
    end)

    focus:SetScript('OnDragStop', function()
        if (not FOCUS_FRAME_LOCKED and FOCUS_FRAME_MOVING) then
            __fa:StopMovingOrSizing()
            FOCUS_FRAME_MOVING = false
        end
    end)

        -- Focustarget frame spawn

    local focustarget = self:Spawn('focustarget', 'oUF_Neav_FocusTarget')
    focustarget:SetPoint('TOPLEFT', focus, 'BOTTOMRIGHT', -78, -15)

        -- Party frame spawn

    if (config.units.party.show) then
        local party = oUF:SpawnHeader('oUF_Neav_Party', nil, (config.units.party.hideInRaid and 'party') or 'party,raid',
            'oUF-initialConfigFunction', [[
                self:SetWidth(105)
                self:SetHeight(30)
            ]],
            'showParty', true,
            'yOffset', -30
        )
        party:SetPoint(unpack(config.units.party.position))
    end
end)