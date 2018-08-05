
local _, nBuff = ...
local cfg = nBuff.Config

local unpack = unpack
local ceil = math.ceil
local match = string.match
local day, hour, minute = 86400, 3600, 60

--[[
_G.DAY_ONELETTER_ABBR = "|cffffffff%dd|r"
_G.HOUR_ONELETTER_ABBR = "|cffffffff%dh|r"
_G.MINUTE_ONELETTER_ABBR = "|cffffffff%dm|r"
_G.SECOND_ONELETTER_ABBR = "|cffffffff%d|r"

_G.DEBUFF_MAX_DISPLAY = 32 -- show more debuffs
_G.BUFF_MIN_ALPHA = 1
--]]

local origSecondsToTimeAbbrev = _G.SecondsToTimeAbbrev
local function SecondsToTimeAbbrevHook(seconds)
    origSecondsToTimeAbbrev(seconds)

    local tempTime
    if seconds >= day then
        tempTime = floor(seconds / day + 0.5)
        return "|cffffffff%dd|r", tempTime
    end

    if seconds >= hour then
        tempTime = floor(seconds/hour + 0.5)
        return "|cffffffff%dh|r", tempTime
    end

    if seconds >= minute then
        tempTime = floor(seconds / minute + 0.5)
        return "|cffffffff%dm|r", tempTime
    end

    return "|cffffffff%d|r", seconds
end
SecondsToTimeAbbrev = SecondsToTimeAbbrevHook

BuffFrame:SetScript("OnUpdate", nil)
hooksecurefunc(BuffFrame, "Show", function(self)
    self:SetScript("OnUpdate", nil)
end)

TempEnchant1:ClearAllPoints()
TempEnchant1:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -15, 0)

TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -cfg.paddingX, 0)

local function UpdateFirstButton(self)
    if self and self:IsShown() then
        self:ClearAllPoints()
        if UnitHasVehicleUI("player") then
            self:SetPoint("TOPRIGHT", TempEnchant1)
            return
        else
            if BuffFrame.numEnchants > 0 then
                self:SetPoint("TOPRIGHT", _G["TempEnchant"..BuffFrame.numEnchants], "TOPLEFT", -cfg.paddingX, 0)
                return
            else
                self:SetPoint("TOPRIGHT", TempEnchant1)
                return
            end
        end
    end
end

local function CheckFirstButton()
    if BuffButton1 then
        UpdateFirstButton(BuffButton1)
    end
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
    local previousBuff, aboveBuff
    local numBuffs = 0
    local numTotal = BuffFrame.numEnchants

    for i = 1, BUFF_ACTUAL_DISPLAY do
        local buff = _G["BuffButton"..i]

        numBuffs = numBuffs + 1
        numTotal = numTotal + 1

        buff:ClearAllPoints()
        if numBuffs == 1 then
            UpdateFirstButton(buff)
        elseif numBuffs > 1 and mod(numTotal, cfg.buffPerRow) == 1 then
            if numTotal == cfg.buffPerRow + 1 then
                buff:SetPoint("TOP", TempEnchant1, "BOTTOM", 0, -cfg.paddingY)
            else
                buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -cfg.paddingY)
            end

            aboveBuff = buff
        else
            buff:SetPoint("TOPRIGHT", previousBuff, "TOPLEFT", -cfg.paddingX, 0)
        end

        previousBuff = buff
    end
end)

hooksecurefunc("DebuffButton_UpdateAnchors", function(self, index)
    local numBuffs = BUFF_ACTUAL_DISPLAY + BuffFrame.numEnchants
    local rowSpacing
    local debuffSpace = cfg.buffSize + cfg.paddingY
    local numRows = ceil(numBuffs/cfg.buffPerRow)

    if numRows and numRows > 1 then
        rowSpacing = -numRows * debuffSpace
    else
        rowSpacing = -debuffSpace
    end

    local buff = _G[self..index]
    buff:ClearAllPoints()

    if index == 1 then
        buff:SetPoint("TOP", TempEnchant1, "BOTTOM", 0, rowSpacing)
    elseif index >= 2 and mod(index, cfg.buffPerRow) == 1 then
        buff:SetPoint("TOP", _G[self..(index-cfg.buffPerRow)], "BOTTOM", 0, -cfg.paddingY)
    else
        buff:SetPoint("TOPRIGHT", _G[self..(index-1)], "TOPLEFT", -cfg.paddingX, 0)
    end
end)

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
    local button = _G["TempEnchant"..i]
    button:SetScale(cfg.buffScale)
    button:SetSize(cfg.buffSize, cfg.buffSize)

    button:SetScript("OnShow", function()
        CheckFirstButton()
    end)

    button:SetScript("OnHide", function()
        CheckFirstButton()
    end)

    local icon = _G["TempEnchant"..i.."Icon"]
    icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)

    local duration = _G["TempEnchant"..i.."Duration"]
    duration:ClearAllPoints()
    duration:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
    duration:SetFont(cfg.durationFont, cfg.buffFontSize, "OUTLINE")
    duration:SetShadowOffset(0, 0)
    duration:SetDrawLayer("OVERLAY")

    local border = _G["TempEnchant"..i.."Border"]
    border:ClearAllPoints()
    border:SetPoint("TOPRIGHT", button, 1, 1)
    border:SetPoint("BOTTOMLEFT", button, -1, -1)
    border:SetTexture(cfg.borderDebuff)
    border:SetTexCoord(0, 1, 0, 1)
    border:SetVertexColor(0.9, 0.25, 0.9)

    button.Shadow = button:CreateTexture("$parentBackground", "BACKGROUND")
    button.Shadow:SetPoint("TOPRIGHT", border, 3.35, 3.35)
    button.Shadow:SetPoint("BOTTOMLEFT", border, -3.35, -3.35)
    button.Shadow:SetTexture("Interface\\AddOns\\nBuff\\media\\textureShadow")
    button.Shadow:SetVertexColor(0, 0, 0, 1)
end

hooksecurefunc("AuraButton_Update", function(self, index)
    local button = _G[self..index]

    if button and not button.Shadow then
        if button then
            if self:match("Debuff") then
                button:SetSize(cfg.debuffSize, cfg.debuffSize)
                button:SetScale(cfg.debuffScale)
            else
                button:SetSize(cfg.buffSize, cfg.buffSize)
                button:SetScale(cfg.buffScale)
            end
        end

        local icon = _G[self..index.."Icon"]
        if icon then
            icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
        end

        local duration = _G[self..index.."Duration"]
        if duration then
            duration:ClearAllPoints()
            duration:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
            if self:match("Debuff") then
                duration:SetFont(cfg.durationFont, cfg.debuffFontSize, "OUTLINE")
            else
                duration:SetFont(cfg.durationFont, cfg.buffFontSize, "OUTLINE")
            end
            duration:SetShadowOffset(0, 0)
            duration:SetDrawLayer("OVERLAY")
        end

        local count = _G[self..index.."Count"]
        if count then
            count:ClearAllPoints()
            count:SetPoint("TOPRIGHT", button)
            if self:match("Debuff") then
                count:SetFont(cfg.countFont, cfg.debuffCountSize, "OUTLINE")
            else
                count:SetFont(cfg.countFont, cfg.buffCountSize, "OUTLINE")
            end
            count:SetShadowOffset(0, 0)
            count:SetDrawLayer("OVERLAY")
        end

        local border = _G[self..index.."Border"]
        if border then
            border:SetTexture(cfg.borderDebuff)
            border:SetPoint("TOPRIGHT", button, 1, 1)
            border:SetPoint("BOTTOMLEFT", button, -1, -1)
            border:SetTexCoord(0, 1, 0, 1)
        end

        if button and not border then
            if not button.texture then
                button.texture = button:CreateTexture("$parentOverlay", "ARTWORK")
                button.texture:SetParent(button)
                button.texture:SetTexture(cfg.borderBuff)
                button.texture:SetPoint("TOPRIGHT", button, 1, 1)
                button.texture:SetPoint("BOTTOMLEFT", button, -1, -1)
                button.texture:SetVertexColor(unpack(cfg.buffBorderColor))
            end
        end

        if button then
            if not button.Shadow then
                button.Shadow = button:CreateTexture("$parentShadow", "BACKGROUND")
                button.Shadow:SetTexture("Interface\\AddOns\\nBuff\\media\\textureShadow")
                button.Shadow:SetPoint("TOPRIGHT", button.texture or border, 3.35, 3.35)
                button.Shadow:SetPoint("BOTTOMLEFT", button.texture or border, -3.35, -3.35)
                button.Shadow:SetVertexColor(0, 0, 0, 1)
            end
        end
    end
end)
