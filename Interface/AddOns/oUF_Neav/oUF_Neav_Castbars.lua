
local _, ns = ...

local interruptTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'
local normalTexture = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'

local function UpdateCastbarColor(self, unit, config)
    if (self.interrupt) then
        ns.ColorBorder(self, interruptTexture, unpack(config.interruptColor))

        if (self.IconOverlay) then
            ns.ColorBorder(self.IconOverlay, interruptTexture, unpack(config.interruptColor))
        end
    else
        ns.ColorBorder(self, normalTexture, 1, 1, 1, 0)

        if (self.IconOverlay) then
            ns.ColorBorder(self.IconOverlay, normalTexture, 1, 1, 1, 0)
        end
    end
end

    -- create the castbars

function ns.CreateCastbars(self, unit)
    local config = ns.config.units[ns.cUnit(unit)].castbar

    if (ns.MultiCheck(unit, 'player', 'target', 'focus', 'pet') and config.show) then 
        self.Castbar = CreateFrame('StatusBar', self:GetName()..'Castbar', self)
        self.Castbar:SetStatusBarTexture(ns.config.media.statusbar)
        self.Castbar:SetScale(0.93)
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
                self.Castbar.Latency:SetFont(ns.config.media.font, ns.config.font.fontBig - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6, 1)
            end
        end

        self.Castbar:CreateBorder(11)
        self.Castbar:SetBorderPadding(3)

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
                self.Castbar.IconOverlay:CreateBorder(10)
                self.Castbar.IconOverlay:SetBorderPadding(2)
            else
                if (config.icon.position == 'LEFT') then
                    self.Castbar:SetBorderPadding(4 + config.height, 3, 3, 3, 4 + config.height, 3, 3, 3, 3)
                else
                    self.Castbar:SetBorderPadding(3, 3, 4 + config.height, 3, 3, 3, 4 + config.height, 3, 3)
                end
            end
        end

            -- interrupt indicator

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

                -- hide some special spells like waterbold or firebold (pets) because it gets really spammy

            if (ns.config.units.pet.castbar.ignoreSpells) then
                if (unit == 'pet') then
                    self:SetAlpha(1)

                    for _, spellID in pairs(ns.config.units.pet.castbar.ignoreList) do
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

            if (ns.config.units.pet.castbar.ignoreSpells) then
                if (unit == 'pet' and self:GetAlpha() == 0) then
                    self:SetAlpha(1)
                end
            end
        end

        self.Castbar.CustomDelayText = ns.CustomDelayText
        self.Castbar.CustomTimeText = ns.CustomTimeText
    end
end

    -- mirror timers

for i = 1, MIRRORTIMER_NUMTIMERS do
    local bar = _G['MirrorTimer' .. i]
    bar:SetParent(UIParent)
    bar:SetScale(1.132)
    bar:SetHeight(18)
    bar:SetWidth(220)
    bar:CreateBorder(11)
    bar:SetBorderPadding(3)

    if (i > 1) then
        local p1, p2, p3, p4, p5 = bar:GetPoint()
        bar:SetPoint(p1, p2, p3, p4, p5 - 15)
    end

    local statusbar = _G['MirrorTimer' .. i .. 'StatusBar']
    statusbar:SetStatusBarTexture(ns.config.media.statusbar)
    statusbar:SetAllPoints(bar)

    local backdrop = select(1, bar:GetRegions())
    backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
    backdrop:SetVertexColor(0, 0, 0, 0.5)
    backdrop:SetAllPoints(bar)

    local border = _G['MirrorTimer' .. i .. 'Border']
    border:Hide()

    local text = _G['MirrorTimer' .. i .. 'Text']
    text:SetFont(ns.config.media.font, ns.config.font.fontBig)
    text:ClearAllPoints()
    text:SetPoint('CENTER', bar)
end

	-- battleground timer

local f = CreateFrame('Frame')
f:RegisterEvent('START_TIMER')
f:SetScript('OnEvent', function(self, event)
	for _, b in pairs(TimerTracker.timerList) do
		if (not b['bar'].beautyBorder) then
			local bar = b['bar']
			bar:SetScale(1.132)
			bar:SetHeight(18)
			bar:SetWidth(220)

            for i = 1, select('#', bar:GetRegions()) do
                local region = select(i, bar:GetRegions())

                if (region and region:GetObjectType() == 'Texture') then
                    region:SetTexture(nil)
                end

                if (region and region:GetObjectType() == 'FontString') then
                    region:ClearAllPoints()
                    region:SetPoint('CENTER', bar)
                    region:SetFont(ns.config.media.font, ns.config.font.fontBig)
                end
            end

            bar:CreateBorder(11)
            bar:SetBorderPadding(3)
            bar:SetStatusBarTexture(ns.config.media.statusbar)

			local backdrop = select(1, bar:GetRegions())
			backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
			backdrop:SetVertexColor(0, 0, 0, 0.5)
			backdrop:SetAllPoints(bar)
		end
	end
end)
