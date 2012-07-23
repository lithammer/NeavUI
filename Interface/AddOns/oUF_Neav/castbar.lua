
local _, ns = ...

local function UpdateCastbarColor(self, unit, config)
    if (self.interrupt) then
        ns.ColorBorder(self, 'white', unpack(config.interruptColor))

        if (self.IconOverlay) then
            ns.ColorBorder(self.IconOverlay, 'white', unpack(config.interruptColor))
        end
    else
        ns.ColorBorder(self, 'default', 1, 1, 1, 0)

        if (self.IconOverlay) then
            ns.ColorBorder(self.IconOverlay, 'default', 1, 1, 1, 0)
        end
    end
end

    -- Create the castbars

function ns.CreateCastbars(self, unit)
    local config = ns.Config.units[ns.cUnit(unit)].castbar

    if (ns.MultiCheck(unit, 'player', 'target', 'focus', 'pet') and config and config.show) then 
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture(ns.Config.media.statusbar)
        self.Castbar:SetScale(config.scale)
        self.Castbar:SetSize(config.width, config.height)
        self.Castbar:SetStatusBarColor(unpack(config.color))  
        
        if (unit == 'focus') then
            self.Castbar:SetPoint('BOTTOM', self, 'TOP', 0, 25)
        else
            self.Castbar:SetPoint(unpack(config.position))
        end

        self.Castbar.Background = self.Castbar:CreateTexture(nil, 'BACKGROUND')
        self.Castbar.Background:SetTexture('Interface\\Buttons\\WHITE8x8')
        self.Castbar.Background:SetAllPoints(self.Castbar)
        self.Castbar.Background:SetVertexColor(config.color[1]*0.3, config.color[2]*0.3, config.color[3]*0.3, 0.8)

        if (unit == 'player') then
            local playerColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

            if (config.classcolor) then
                self.Castbar:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
                self.Castbar.Background:SetVertexColor(playerColor.r * 0.3, playerColor.g * 0.3, playerColor.b * 0.3, 0.8)
            end

            if (config.showSafezone) then
                self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, 'BORDER') 
                self.Castbar.SafeZone:SetTexture(unpack(config.safezoneColor))
            end

            if (config.showLatency) then
                self.Castbar.Latency = self.Castbar:CreateFontString(nil, 'OVERLAY')
                self.Castbar.Latency:SetFont(ns.Config.font.normal, ns.Config.font.normalSize - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6, 1)
            end
        end

        self.Castbar:CreateBeautyBorder(11)
        self.Castbar:SetBeautyBorderPadding(2.66)

        ns.CreateCastbarStrings(self)

        if (config.icon.show) then
            self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
            self.Castbar.Icon:SetSize(config.height + 2, config.height + 2)
            self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if (config.icon.position == 'LEFT') then
                self.Castbar.Icon:SetPoint('RIGHT', self.Castbar, 'LEFT', (config.icon.positionOutside and -8) or 0, 0)
            else
                self.Castbar.Icon:SetPoint('LEFT', self.Castbar, 'RIGHT', (config.icon.positionOutside and 8) or 0, 0)
            end

            if (config.icon.positionOutside) then
                self.Castbar.IconOverlay = CreateFrame('Frame', nil, self.Castbar)
                self.Castbar.IconOverlay:SetAllPoints(self.Castbar.Icon)
                self.Castbar.IconOverlay:CreateBeautyBorder(10)
                self.Castbar.IconOverlay:SetBeautyBorderPadding(2)
            else
                if (config.icon.position == 'LEFT') then
                    self.Castbar:SetBeautyBorderPadding(4 + config.height, 3, 3, 3, 4 + config.height, 3, 3, 3, 3)
                else
                    self.Castbar:SetBeautyBorderPadding(3, 3, 4 + config.height, 3, 3, 3, 4 + config.height, 3, 3)
                end
            end
        end

            -- Interrupt indicator

        self.Castbar.PostCastStart = function(self, unit)
            if (unit == 'player') then
                if (self.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2

                    self.Latency:ClearAllPoints()
                    self.Latency:SetPoint('RIGHT', self, 'BOTTOMRIGHT', -1, -2) 
                    self.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end

            if (unit == 'target' or unit == 'focus') then
                UpdateCastbarColor(self, unit, config)
            end

                -- Hide some special spells like waterbold or firebold (pets) because it gets really spammy

            if (ns.Config.units.pet.castbar.ignoreSpells) then
                if (unit == 'pet') then
                    self:SetAlpha(1)

                    for _, spellID in pairs(ns.Config.units.pet.castbar.ignoreList) do
                        if (UnitCastingInfo('pet') == GetSpellInfo(spellID)) then
                            self:SetAlpha(0)
                        end
                    end
                end
            end
        end

        self.Castbar.PostChannelStart = function(self, unit)
            if (unit == 'player') then
                if (self.Latency) then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2

                    self.Latency:ClearAllPoints()
                    self.Latency:SetPoint('LEFT', self, 'BOTTOMLEFT', 1, -2)
                    self.Latency:SetText(string.format('%.0f', avgLag)..'ms')
                end
            end

            if (unit == 'target' or unit == 'focus') then
                UpdateCastbarColor(self, unit, config)
            end

            if (ns.Config.units.pet.castbar.ignoreSpells) then
                if (unit == 'pet' and self:GetAlpha() == 0) then
                    self:SetAlpha(1)
                end
            end
        end
        
        self.Castbar.PostCastInterruptible = UpdateCastbarColor
        self.Castbar.PostCastNotInterruptible = UpdateCastbarColor
        
        self.Castbar.CustomDelayText = ns.CustomDelayText
        self.Castbar.CustomTimeText = ns.CustomTimeText
    end
end

    -- Mirror timers

for i = 1, MIRRORTIMER_NUMTIMERS do
    local bar = _G['MirrorTimer'..i]
    bar:SetParent(UIParent)
    bar:SetScale(1.132)
    bar:SetSize(220, 18)
    
    bar:CreateBeautyBorder(11)
    bar:SetBeautyBorderPadding(3)

    if (i > 1) then
        local p1, p2, p3, p4, p5 = bar:GetPoint()
        bar:SetPoint(p1, p2, p3, p4, p5 - 15)
    end

    local statusbar = _G['MirrorTimer'..i..'StatusBar']
    statusbar:SetStatusBarTexture(ns.Config.media.statusbar)
    statusbar:SetAllPoints(bar)

    local backdrop = select(1, bar:GetRegions())
    backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
    backdrop:SetVertexColor(0, 0, 0, 0.5)
    backdrop:SetAllPoints(bar)

    local border = _G['MirrorTimer'..i..'Border']
    border:Hide()

    local text = _G['MirrorTimer'..i..'Text']
    text:SetFont(ns.Config.font.normal, ns.Config.font.normalSize)
    text:ClearAllPoints()
    text:SetPoint('CENTER', bar)
end

    -- Battleground timer

local f = CreateFrame('Frame')
f:RegisterEvent('START_TIMER')
f:SetScript('OnEvent', function(self, event)
    for _, b in pairs(TimerTracker.timerList) do
        if (not b['bar'].beautyBorder) then
            local bar = b['bar']
            bar:SetScale(1.132)
            bar:SetSize(220, 18)

            for i = 1, select('#', bar:GetRegions()) do
                local region = select(i, bar:GetRegions())

                if (region and region:GetObjectType() == 'Texture') then
                    region:SetTexture(nil)
                end

                if (region and region:GetObjectType() == 'FontString') then
                    region:ClearAllPoints()
                    region:SetPoint('CENTER', bar)
                    region:SetFont(ns.Config.font.normal, ns.Config.font.normalSize)
                end
            end

            bar:CreateBeautyBorder(11)
            bar:SetBeautyBorderPadding(3)
            bar:SetStatusBarTexture(ns.Config.media.statusbar)

            local backdrop = select(1, bar:GetRegions())
            backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
            backdrop:SetVertexColor(0, 0, 0, 0.5)
            backdrop:SetAllPoints(bar)
        end
    end
end)