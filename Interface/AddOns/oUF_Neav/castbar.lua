
local _, ns = ...

local function CreateAnchor(unit, text)
    local config = ns.Config.units[ns.cUnit(unit)].castbar
    local width = (config.width + config.height) * config.scale
    local height = config.height * config.scale

    local anchorFrame = CreateFrame("Frame", "oUF_Neav "..unit.."_Castbar_Anchor", UIParent)
    anchorFrame:SetSize(width, height)
    anchorFrame:SetScale(1.193)
    anchorFrame:SetPoint(unpack(config.position))
    anchorFrame:SetFrameStrata("HIGH")
    anchorFrame:SetMovable(true)
    anchorFrame:SetClampedToScreen(true)
    anchorFrame:SetUserPlaced(true)
    anchorFrame:SetBackdrop({bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background",})
    anchorFrame:CreateBeautyBorder(11)
    anchorFrame:SetBeautyBorderPadding(2.66)
    anchorFrame:EnableMouse(true)
    anchorFrame:RegisterForDrag("LeftButton")
    anchorFrame:Hide()

    anchorFrame.text = anchorFrame:CreateFontString(nil, "OVERLAY")
    anchorFrame.text:SetAllPoints(anchorFrame)
    anchorFrame.text:SetFont(STANDARD_TEXT_FONT, 13)
    anchorFrame.text:SetText(text.." Castbar Anchor")

    anchorFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    anchorFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    return anchorFrame
end

local playerCastbarHolder = CreateAnchor("player","Player")
local targetCastbarHolder = CreateAnchor("target","Target")
local petCastbarHolder = CreateAnchor("pet","Pet")

    -- Create the castbars

function ns.CreateCastbars(self, unit)
    local config = ns.Config.units[ns.cUnit(unit)].castbar

    if ns.MultiCheck(unit, "player", "target", "focus", "pet") and config and config.show then
        self.Castbar = CreateFrame("StatusBar", self:GetName().."Castbar", self)
        self.Castbar:SetStatusBarTexture(ns.Config.media.statusbar)
        self.Castbar:SetSize(config.width, config.height)
        self.Castbar:SetScale(config.scale)
        self.Castbar.castColor = config.castColor
        self.Castbar.channeledColor = config.channeledColor
        self.Castbar.nonInterruptibleColor = config.nonInterruptibleColor
        self.Castbar.failedCastColor = config.failedCastColor
        self.Castbar.timeToHold = 1

        if unit == "focus" then
            self.Castbar:SetPoint("BOTTOM", self, "TOP", 0, 25)
        elseif unit == "player" then
            self.Castbar:SetPoint("BOTTOMRIGHT", playerCastbarHolder)
        elseif unit == "target" then
            self.Castbar:SetPoint("BOTTOMRIGHT", targetCastbarHolder)
        elseif unit == "pet" then
            self.Castbar:SetPoint("BOTTOMRIGHT", petCastbarHolder)
        end

        self.Castbar.Background = self.Castbar:CreateTexture("$parentBackground", "BACKGROUND")
        self.Castbar.Background:SetTexture("Interface\\Buttons\\WHITE8x8")
        self.Castbar.Background:SetAllPoints(self.Castbar)

        if unit == "player" then
            if config.classcolor then
                local playerColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
                self.Castbar.castColor = {playerColor.r, playerColor.g, playerColor.b}
                self.Castbar.channeledColor = {playerColor.r, playerColor.g, playerColor.b}
            end

            if config.showSafezone then
                self.Castbar.SafeZone = self.Castbar:CreateTexture("$parentSafeZoneTexture", "BORDER")
                self.Castbar.SafeZone:SetColorTexture(unpack(config.safezoneColor))
            end

            if config.showLatency then
                self.Castbar.Latency = self.Castbar:CreateFontString("$parentLatency", "OVERLAY")
                self.Castbar.Latency:SetFont(ns.Config.font.normal, ns.Config.font.normalSize - 1)
                self.Castbar.Latency:SetShadowOffset(1, -1)
                self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6, 1)
            end
        end

        self.Castbar:CreateBeautyBorder(11)
        self.Castbar:SetBeautyBorderPadding(2.66)

        ns.CreateCastbarStrings(self)

        if config.icon.show then
            self.Castbar.Icon = self.Castbar:CreateTexture("$parentIcon", "ARTWORK")
            self.Castbar.Icon:SetSize(config.height + 2, config.height + 2)
            self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if config.icon.position == "LEFT" then
                self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", (config.icon.positionOutside and -8) or 0, 0)
            else
                self.Castbar.Icon:SetPoint("LEFT", self.Castbar, "RIGHT", (config.icon.positionOutside and 8) or 0, 0)
            end

            if config.icon.positionOutside then
                self.Castbar.IconOverlay = CreateFrame("Frame", "$parentIconOverlay", self.Castbar)
                self.Castbar.IconOverlay:SetAllPoints(self.Castbar.Icon)
                self.Castbar.IconOverlay:CreateBeautyBorder(10)
                self.Castbar.IconOverlay:SetBeautyBorderPadding(2)
            else
                if config.icon.position == "LEFT" then
                    self.Castbar:SetBeautyBorderPadding(4 + config.height, 3, 3, 3, 4 + config.height, 3, 3, 3, 3)
                else
                    self.Castbar:SetBeautyBorderPadding(3, 3, 4 + config.height, 3, 3, 3, 4 + config.height, 3, 3)
                end
            end
        end

            -- Interrupt indicator

        self.Castbar.PostCastStart = function(self, unit)
            ns.UpdateCastbarColor(self)

            if unit == "player" then
                if self.Latency then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2

                    self.Latency:ClearAllPoints()
                    self.Latency:SetPoint("RIGHT", self, "BOTTOMRIGHT", -1, -2)
                    self.Latency:SetText(string.format("%.0f", avgLag).."ms")
                end
            end

                -- Hide some special spells like waterbold or firebold (pets) because it gets really spammy

            if ns.Config.units.pet.castbar.ignoreSpells then
                if unit == "pet" then
                    self:SetAlpha(1)

                    for _, spellID in pairs(ns.Config.units.pet.castbar.ignoreList) do
                        if UnitCastingInfo("pet") == GetSpellInfo(spellID) then
                            self:SetAlpha(0)
                        end
                    end
                end
            end
        end

        self.Castbar.PostChannelStart = function(self, unit)
            ns.UpdateCastbarColor(self)

            if unit == "player" then
                if self.Latency then
                    local down, up, lagHome, lagWorld = GetNetStats()
                    local avgLag = (lagHome + lagWorld) / 2

                    self.Latency:ClearAllPoints()
                    self.Latency:SetPoint("LEFT", self, "BOTTOMLEFT", 1, -2)
                    self.Latency:SetText(string.format("%.0f", avgLag).."ms")
                end
            end

            if ns.Config.units.pet.castbar.ignoreSpells then
                if unit == "pet" and self:GetAlpha() == 0 then
                    self:SetAlpha(1)
                end
            end
        end

        self.Castbar.PostCastInterrupted = function(self, unit)
            self:SetStatusBarColor(unpack(self.failedCastColor))
            self.Background:SetVertexColor(self.failedCastColor[1]*0.3, self.failedCastColor[2]*0.3, self.failedCastColor[3]*0.3)
        end

        self.Castbar.PostCastInterruptible = ns.UpdateCastbarColor
        self.Castbar.PostCastNotInterruptible = ns.UpdateCastbarColor

        self.Castbar.CustomDelayText = ns.CustomDelayText
        self.Castbar.CustomTimeText = ns.CustomTimeText
    end
end

    -- Mirror timers

for i = 1, MIRRORTIMER_NUMTIMERS do
    local bar = _G["MirrorTimer"..i]
    bar:SetParent(UIParent)
    bar:SetScale(1.132)
    bar:SetSize(220, 18)

    bar:CreateBeautyBorder(11)
    bar:SetBeautyBorderPadding(3)

    if i > 1 then
        local p1, p2, p3, p4, p5 = bar:GetPoint()
        bar:SetPoint(p1, p2, p3, p4, p5 - 15)
    end

    local statusbar = _G["MirrorTimer"..i.."StatusBar"]
    statusbar:SetStatusBarTexture(ns.Config.media.statusbar)
    statusbar:SetAllPoints(bar)

    local backdrop = select(1, bar:GetRegions())
    backdrop:SetTexture("Interface\\Buttons\\WHITE8x8")
    backdrop:SetVertexColor(0, 0, 0, 0.5)
    backdrop:SetAllPoints(bar)

    local border = _G["MirrorTimer"..i.."Border"]
    border:Hide()

    local text = _G["MirrorTimer"..i.."Text"]
    text:SetFont(ns.Config.font.normal, ns.Config.font.normalSize)
    text:ClearAllPoints()
    text:SetPoint("CENTER", bar)
end

    -- Battleground timer

local f = CreateFrame("Frame")
f:RegisterEvent("START_TIMER")
f:SetScript("OnEvent", function(self, event)
    for _, b in pairs(TimerTracker.timerList) do
        if not b["bar"].beautyBorder then
            local bar = b["bar"]
            bar:SetScale(1.132)
            bar:SetSize(220, 18)

            for i = 1, select("#", bar:GetRegions()) do
                local region = select(i, bar:GetRegions())

                if region and region:GetObjectType() == "Texture" then
                    region:SetTexture(nil)
                end

                if region and region:GetObjectType() == "FontString" then
                    region:ClearAllPoints()
                    region:SetPoint("CENTER", bar)
                    region:SetFont(ns.Config.font.normal, ns.Config.font.normalSize)
                end
            end

            bar:CreateBeautyBorder(11)
            bar:SetBeautyBorderPadding(3)
            bar:SetStatusBarTexture(ns.Config.media.statusbar)

            local backdrop = select(1, bar:GetRegions())
            backdrop:SetTexture("Interface\\Buttons\\WHITE8x8")
            backdrop:SetVertexColor(0, 0, 0, 0.5)
            backdrop:SetAllPoints(bar)
        end
    end
end)

SlashCmdList["oUF_Neav_Castbar_AnchorToggle"] = function()
    if InCombatLockdown() then
        print("oUF_Neav: You cant do this in combat!")
        return
    end
    if not playerCastbarHolder:IsShown() then
        playerCastbarHolder:Show()
        targetCastbarHolder:Show()
        petCastbarHolder:Show()
    else
        playerCastbarHolder:Hide()
        targetCastbarHolder:Hide()
        petCastbarHolder:Hide()
    end
end
SLASH_oUF_Neav_Castbar_AnchorToggle1 = "/neavcast"
