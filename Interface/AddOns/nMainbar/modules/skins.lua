
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.skinButton) then
    return
end

local _G, pairs, unpack = _G, pairs, unpack
local path = 'Interface\\AddOns\\nMainbar\\media\\'

local function IsSpecificButton(self, name)
    local totemButton = self:GetName():match(name)
    if (totemButton) then
        return true
    else
        return false
    end
end

local function UpdateVehicleButton()
    for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
        local hotkey = _G['VehicleMenuBarActionButton'..i..'HotKey']
        if (cfg.button.showVehicleKeybinds) then
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize + 3, 'OUTLINE')
            hotkey:SetVertexColor(cfg.color.HotKeyText[1], cfg.color.HotKeyText[2], cfg.color.HotKeyText[3])
        else
            hotkey:Hide()
        end
    end
end

hooksecurefunc('PetActionBar_Update', function()
    for _, name in pairs({
        'PetActionButton',
        'PossessButton',    
        'ShapeshiftButton', 
    }) do
        for i = 1, 12 do
            local button = _G[name..i]
            if (button) then
                button:SetNormalTexture(path..'textureNormal')

                local icon = _G[name..i..'Icon']
                icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
                icon:SetPoint('TOPRIGHT', button, 1, 1)
                icon:SetPoint('BOTTOMLEFT', button, -1, -1)

                if (not InCombatLockdown()) then
                    local cooldown = _G[name..i..'Cooldown']
                    cooldown:ClearAllPoints()
                    cooldown:SetPoint('BOTTOMLEFT', icon, -1, -1)
                    cooldown:SetPoint('TOPRIGHT', icon, 1, 1)
                end

                local normal = _G[name..i..'NormalTexture2'] or _G[name..i..'NormalTexture']
                normal:ClearAllPoints()
                normal:SetPoint('TOPRIGHT', button, 1.5, 1.5)
                normal:SetPoint('BOTTOMLEFT', button, -1.5, -1.5)
                normal:SetVertexColor(cfg.color.Normal[1], cfg.color.Normal[2], cfg.color.Normal[3], 1)

                local flash = _G[name..i..'Flash']
                flash:SetTexture(flashtex)

                if (not InCombatLockdown()) then
                    local cooldown = _G[name..i..'Cooldown']
                    cooldown:ClearAllPoints()
                    cooldown:SetPoint('TOPRIGHT', icon, -2.33, -2.33)
                    cooldown:SetPoint('BOTTOMLEFT', icon, 1.66, 2.33)
                    -- cooldown:SetDrawEdge(true)
                end

                button:SetCheckedTexture(path..'textureChecked')
                button:GetCheckedTexture():SetAllPoints(normal)
                button:GetCheckedTexture():SetDrawLayer('OVERLAY')

                button:SetPushedTexture(path..'texturePushed')
                button:GetPushedTexture():SetAllPoints(normal)
                button:GetPushedTexture():SetDrawLayer('OVERLAY')

                button:SetHighlightTexture(path..'textureHighlight')
                button:GetHighlightTexture():SetAllPoints(normal)

                if (not button.Shadow) then
                    button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                    button.Shadow:SetParent(button)  
                    button.Shadow:SetPoint('TOPRIGHT', normal, 4, 4)
                    button.Shadow:SetPoint('BOTTOMLEFT', normal, -4, -4)
                    button.Shadow:SetTexture(path..'textureShadow')
                    button.Shadow:SetVertexColor(0, 0, 0, 1)
                end
            end
        end
    end
end)

hooksecurefunc('ActionButton_Update', function(self)
    if (IsSpecificButton(self, 'MultiCast')) then
        for _, icon in pairs({
            self:GetName(),
            'MultiCastRecallSpellButton',
            'MultiCastSummonSpellButton',
        }) do
            local button = _G[icon]

            _G[icon..'NormalTexture']:SetTexture(nil)

            if (not button.Shadow) then
                button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                button.Shadow:SetParent(button)  
                button.Shadow:SetPoint('TOPRIGHT', button, 4.5, 4.5)
                button.Shadow:SetPoint('BOTTOMLEFT', button, -4.5, -4.5)
                button.Shadow:SetTexture(path..'textureShadow')
                button.Shadow:SetVertexColor(0, 0, 0, 0.85)
            end
        end
    else
        local button = _G[self:GetName()]
        button:SetNormalTexture(path..'textureNormal')

        local normal = _G[self:GetName()..'NormalTexture']
        normal:ClearAllPoints()
        normal:SetPoint('TOPRIGHT', button, 1, 1)
        normal:SetPoint('BOTTOMLEFT', button, -1, -1)
        normal:SetVertexColor(cfg.color.Normal[1], cfg.color.Normal[2], cfg.color.Normal[3], 1)
        normal:SetDrawLayer('ARTWORK')

        local icon = _G[self:GetName()..'Icon']
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        icon:SetDrawLayer('BORDER')

        if (not InCombatLockdown()) then
            local cooldown = _G[self:GetName()..'Cooldown']
            cooldown:ClearAllPoints()
            cooldown:SetPoint('TOPRIGHT', icon, -2, -2.5)
            cooldown:SetPoint('BOTTOMLEFT', icon, 2, 2)
        end

        button:SetCheckedTexture(path..'textureChecked')
        button:GetCheckedTexture():SetAllPoints(normal)

        button:SetPushedTexture(path..'texturePushed')
        button:GetPushedTexture():SetAllPoints(normal)

        button:SetHighlightTexture(path..'textureHighlight')
        button:GetHighlightTexture():SetAllPoints(normal)

        local border = _G[self:GetName()..'Border']
        border:SetAllPoints(normal)
        border:SetDrawLayer('OVERLAY')
        border:SetTexture(path..'textureHighlight')
        border:SetVertexColor(unpack(cfg.color.IsEquipped))

        local count = _G[self:GetName()..'Count']
        count:SetPoint('BOTTOMRIGHT', button, 0, 1)
        count:SetFont(cfg.button.countFont, cfg.button.countFontsize, 'OUTLINE')
        count:SetVertexColor(cfg.color.CountText[1], cfg.color.CountText[2], cfg.color.CountText[3], 1)

        local macroname = _G[self:GetName()..'Name']
        if (not cfg.button.showMacronames) then
            macroname:SetAlpha(0)
        else
            macroname:SetDrawLayer('OVERLAY')
            macroname:SetWidth(button:GetWidth() + 5)
            macroname:SetFont(cfg.button.macronameFont, cfg.button.macronameFontsize, 'OUTLINE')
            macroname:SetVertexColor(unpack(cfg.color.MacroText))
        end

        if (not button.Background) then
            button.Background = button:CreateTexture(nil, 'BACKGROUND')
            button.Background:SetParent(button)  
            button.Background:SetTexture(path..'textureBackground')
            button.Background:SetPoint('TOPRIGHT', button, 2, 2)
            button.Background:SetPoint('BOTTOMLEFT', button, -2, -2)
        end

        if (not button.Shadow) then
            button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
            button.Shadow:SetParent(button)  
            button.Shadow:SetPoint('TOPRIGHT', normal, 4.5, 4.5)
            button.Shadow:SetPoint('BOTTOMLEFT', normal, -4.5, -4.5)
            button.Shadow:SetTexture(path..'textureShadow')
            button.Shadow:SetVertexColor(0, 0, 0, 1)
        end

        if (IsEquippedAction(self.action)) then
            _G[self:GetName()..'Border']:SetAlpha(1)
        else
            _G[self:GetName()..'Border']:SetAlpha(0)
        end
    end
end)   

hooksecurefunc('ActionButton_ShowGrid', function(self)
    _G[self:GetName()..'NormalTexture']:SetVertexColor(cfg.color.Normal[1], cfg.color.Normal[2], cfg.color.Normal[3], 1) 

    if (IsEquippedAction(self.action)) then
        _G[self:GetName()..'Border']:SetAlpha(1)
    else
        _G[self:GetName()..'Border']:SetAlpha(0)
    end
end)

hooksecurefunc('ActionButton_UpdateUsable', function(self)
    _G[self:GetName()..'NormalTexture']:SetVertexColor(cfg.color.Normal[1], cfg.color.Normal[2], cfg.color.Normal[3], 1) 

    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if (isUsable) then
        _G[self:GetName()..'Icon']:SetVertexColor(1, 1, 1)
    elseif (notEnoughMana) then
        _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.OutOfMana))
    else
        _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.NotUsable))
    end
end)

hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
    local hotkey = _G[self:GetName()..'HotKey']

    if (not IsSpecificButton(self, 'VehicleMenuBarActionButton')) then
        if (cfg.button.showKeybinds) then
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT', self, 0, -3)
            hotkey:SetDrawLayer('OVERLAY')
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize, 'OUTLINE')
            hotkey:SetVertexColor(cfg.color.HotKeyText[1], cfg.color.HotKeyText[2], cfg.color.HotKeyText[3])
        else
            hotkey:Hide()    
        end
    else
        UpdateVehicleButton()
    end
end)

function ActionButton_OnUpdate(self, elapsed)
    if (ActionButton_IsFlashing(self)) then
        local flashtime = self.flashtime
        flashtime = flashtime - elapsed

        if (flashtime <= 0) then
            local overtime = - flashtime
            if (overtime >= ATTACK_BUTTON_FLASH_TIME) then
                overtime = 0
            end

            flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = _G[self:GetName()..'Flash']
            if (flashTexture:IsShown()) then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end

        self.flashtime = flashtime
    end

    local rangeTimer = self.rangeTimer
    if (rangeTimer) then
        rangeTimer = rangeTimer - elapsed
        if (rangeTimer <= 0) then
            local isInRange = false

            if (ActionHasRange(self.action) and IsActionInRange(self.action) == 0) then
                _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.OutOfRange))
                isInRange = true
            end

            if (self.isInRange ~= isInRange) then
                self.isInRange = isInRange
                ActionButton_UpdateUsable(self)
            end

            rangeTimer = TOOLTIP_UPDATE_TIME
        end

        self.rangeTimer = rangeTimer
    end
end