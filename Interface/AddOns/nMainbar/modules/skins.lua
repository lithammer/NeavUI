
local _, nMainbar = ...
local cfg = nMainbar.Config

if (not cfg.MainMenuBar.skinButton) then
    return
end

local _G, pairs, unpack = _G, pairs, unpack
local path = 'Interface\\AddOns\\nMainbar\\media\\'

local function IsSpecificButton(self, name)
    local sbut = self:GetName():match(name)
    if (sbut) then
        return true
    else
        return false
    end
end

local function UpdateVehicleButton()
    for i = 1, NUM_OVERRIDE_BUTTONS do
        local hotkey = _G['OverrideActionBarButton'..i..'HotKey']
        if (cfg.button.showVehicleKeybinds) then
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize + 3, 'OUTLINE')
            hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
        else
            hotkey:Hide()
        end
    end
end

hooksecurefunc('PetActionBar_Update', function()
    for _, name in pairs({
        'PetActionButton',
        'PossessButton',
        'StanceButton',
    }) do
        for i = 1, 12 do
            local button = _G[name..i]
            if (button) then
                button:SetNormalTexture(path..'textureNormal')

                if (not InCombatLockdown()) then
                    local cooldown = _G[name..i..'Cooldown']
                    cooldown:ClearAllPoints()
                    cooldown:SetPoint('TOPRIGHT', button, -2, -2)
                    cooldown:SetPoint('BOTTOMLEFT', button, 1, 1)
                end

                if (not button.Shadow) then
                    local normal = _G[name..i..'NormalTexture2'] or _G[name..i..'NormalTexture']
                    normal:ClearAllPoints()
                    normal:SetPoint('TOPRIGHT', button, 1.5, 1.5)
                    normal:SetPoint('BOTTOMLEFT', button, -1.5, -1.5)
                    normal:SetVertexColor(cfg.color.Normal[1], cfg.color.Normal[2], cfg.color.Normal[3], 1)

                    local icon = _G[name..i..'Icon']
                    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
                    icon:SetPoint('TOPRIGHT', button, 1, 1)
                    icon:SetPoint('BOTTOMLEFT', button, -1, -1)

                    local flash = _G[name..i..'Flash']
                    flash:SetTexture(flashtex)

                    button:SetCheckedTexture(path..'textureChecked')
                    button:GetCheckedTexture():SetAllPoints(normal)

                    button:SetPushedTexture(path..'texturePushed')
                    button:GetPushedTexture():SetAllPoints(normal)

                    button:SetHighlightTexture(path..'textureHighlight')
                    button:GetHighlightTexture():SetAllPoints(normal)

                    local buttonBg = _G[name..i..'FloatingBG']
                    if (buttonBg) then
                        buttonBg:ClearAllPoints()
                        buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
                        buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
                        buttonBg:SetTexture(path..'textureShadow')
                        buttonBg:SetVertexColor(0, 0, 0, 1)
                        button.Shadow = true
                    else
                        button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                        button.Shadow:SetParent(button)
                        button.Shadow:SetPoint('TOPRIGHT', normal, 4, 4)
                        button.Shadow:SetPoint('BOTTOMLEFT', normal, -4, -4)
                        button.Shadow:SetTexture(path..'textureShadow')
                        button.Shadow:SetVertexColor(0, 0, 0, 1)
                    end

                    local hotkey = _G[name..i..'HotKey']
                    if (cfg.button.showKeybinds) then
                        hotkey:ClearAllPoints()
                        hotkey:SetPoint('TOPRIGHT', button, 0, -3)
                        hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.petHotKeyFontsize, 'OUTLINE')
                        hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
                    end
                end
            end
        end
    end
end)
-- Force an update for StanceButton for those who doesn't have pet bar
securecall('PetActionBar_Update')

hooksecurefunc('ActionButton_Update', function(self)
    -- Force an initial update because it isn't triggered on login (v6.0.2)
    ActionButton_UpdateHotkeys(self, self.buttonType)

    if (IsSpecificButton(self, 'MultiCast')) then
        for _, icon in pairs({
            self:GetName(),
            'MultiCastRecallSpellButton',
            'MultiCastSummonSpellButton',
        }) do
            local button = _G[icon]
            -- XXX: Causes an error on 6.0.2
            -- button:SetNormalTexture(nil)

            if (not button.Shadow) then
                local icon = _G[self:GetName()..'Icon']
                icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

                button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
                button.Shadow:SetParent(button)
                button.Shadow:SetPoint('TOPRIGHT', button, 4.5, 4.5)
                button.Shadow:SetPoint('BOTTOMLEFT', button, -4.5, -4.5)
                button.Shadow:SetTexture(path..'textureShadow')
                button.Shadow:SetVertexColor(0, 0, 0, 0.85)
            end
        end
    elseif (not IsSpecificButton(self, 'ExtraActionButton')) then
        local button = _G[self:GetName()]

        --[[
            -- no 'macr...'

        local macroname = _G[self:GetName()..'Name']
        if (macroname) then
            if (cfg.button.showMacronames) then
                if (macroname:GetText()) then
                    macroname:SetText(macroname:GetText():sub(1, 6))
                end
            end
        end
        --]]

        if (not button.Background) then
            local normal = _G[self:GetName()..'NormalTexture']
            if (normal) then
                normal:ClearAllPoints()
                normal:SetPoint('TOPRIGHT', button, 1, 1)
                normal:SetPoint('BOTTOMLEFT', button, -1, -1)
                normal:SetVertexColor(unpack(cfg.color.Normal))
            end

            button:SetNormalTexture(path..'textureNormal')

            button:SetCheckedTexture(path..'textureChecked')
            button:GetCheckedTexture():SetAllPoints(normal)

            button:SetPushedTexture(path..'texturePushed')
            button:GetPushedTexture():SetAllPoints(normal)

            button:SetHighlightTexture(path..'textureHighlight')
            button:GetHighlightTexture():SetAllPoints(normal)

            local icon = _G[self:GetName()..'Icon']
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

            local count = _G[self:GetName()..'Count']
            if (count) then
                count:SetPoint('BOTTOMRIGHT', button, 0, 1)
                count:SetFont(cfg.button.countFont, cfg.button.countFontsize, 'OUTLINE')
                count:SetVertexColor(unpack(cfg.color.CountText))
            end

            local macroname = _G[self:GetName()..'Name']
            if (macroname) then
                if (not cfg.button.showMacronames) then
                    macroname:SetAlpha(0)
                else
                    macroname:SetWidth(button:GetWidth() + 15)
                    macroname:SetFont(cfg.button.macronameFont, cfg.button.macronameFontsize, 'OUTLINE')
                    macroname:SetVertexColor(unpack(cfg.color.MacroText))
                end
            end

            local buttonBg = _G[self:GetName()..'FloatingBG']
            if (buttonBg) then
                buttonBg:ClearAllPoints()
                buttonBg:SetPoint('TOPRIGHT', button, 5, 5)
                buttonBg:SetPoint('BOTTOMLEFT', button, -5, -5)
                buttonBg:SetTexture(path..'textureShadow')
                buttonBg:SetVertexColor(0, 0, 0, 1)
            end

            button.Background = button:CreateTexture(nil, 'BACKGROUND', nil, -8)
            button.Background:SetTexture(path..'textureBackground')
            button.Background:SetPoint('TOPRIGHT', button, 14, 12)
            button.Background:SetPoint('BOTTOMLEFT', button, -14, -16)
        end

        if (not InCombatLockdown()) then
            local cooldown = _G[self:GetName()..'Cooldown']
            cooldown:ClearAllPoints()
            cooldown:SetPoint('TOPRIGHT', button, -2, -2.5)
            cooldown:SetPoint('BOTTOMLEFT', button, 2, 2)
        end

        local border = _G[self:GetName()..'Border']
        if (border) then
            if (IsEquippedAction(self.action)) then
                _G[self:GetName()..'Border']:SetAlpha(1)
                _G[self:GetName()..'Border']:SetVertexColor(unpack(cfg.color.IsEquipped))
            else
                _G[self:GetName()..'Border']:SetAlpha(0)
            end
        end
    end
end)

hooksecurefunc('ActionButton_ShowGrid', function(self)
    local normal = _G[self:GetName()..'NormalTexture']
    if (normal) then
        normal:SetVertexColor(unpack(cfg.color.Normal))
    end
end)

hooksecurefunc('ActionButton_UpdateUsable', function(self)
    if (IsAddOnLoaded('RedRange') or IsAddOnLoaded('GreenRange') or IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end

    local normal = _G[self:GetName()..'NormalTexture']
    if (normal) then
        normal:SetVertexColor(unpack(cfg.color.Normal))
    end

    local isUsable, notEnoughMana = IsUsableAction(self.action)
    if (isUsable) then
        _G[self:GetName()..'Icon']:SetVertexColor(1, 1, 1)
    elseif (notEnoughMana) then
        _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.OutOfMana))
    else
        _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.NotUsable))
    end
end)

hooksecurefunc('ActionButton_UpdateHotkeys', function(self, actionButtonType)
    local hotkey = _G[self:GetName()..'HotKey']

    if (not IsSpecificButton(self, 'OverrideActionBarButton')) then
        if (cfg.button.showKeybinds) then
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT', self, 0, -3)
            hotkey:SetFont(cfg.button.hotkeyFont, cfg.button.hotkeyFontsize, 'OUTLINE')
            hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
        else
            hotkey:Hide()
        end
    else
        UpdateVehicleButton()
    end
end)

hooksecurefunc('ActionButton_OnUpdate', function(self, elapsed)
    if (IsAddOnLoaded('tullaRange') or IsAddOnLoaded('RangeColors')) then
        return
    end

    if (self.rangeTimer == TOOLTIP_UPDATE_TIME) then
        local hotkey = _G[self:GetName()..'HotKey']
        local valid = IsActionInRange(self.action)
        if ( hotkey:GetText() == RANGE_INDICATOR ) then
            if ( valid == false ) then
                hotkey:Show()
                --if ( cfg.button.OutOfRangeType == 'icon' ) then
                --    _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.OutOfRange))
                --else
                    hotkey:SetVertexColor(unpack(cfg.color.OutOfRange))
                --end
            elseif ( valid ) then
                hotkey:Show()
                hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
                ActionButton_UpdateUsable(self)
            else
                hotkey:Hide()
            end
        else
            if ( valid == false ) then
                --if ( cfg.button.OutOfRangeType == 'icon' ) then
                --    _G[self:GetName()..'Icon']:SetVertexColor(unpack(cfg.color.OutOfRange))
                --else
                    hotkey:SetVertexColor(unpack(cfg.color.OutOfRange))
                --end
            else
                hotkey:SetVertexColor(unpack(cfg.color.HotKeyText))
                ActionButton_UpdateUsable(self)
            end
        end
    end
end)
