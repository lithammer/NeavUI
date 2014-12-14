
local gradientColor = {
    1, 0, 0,
    1, 1, 0,
    0, 1, 0
}

local slotInfo = {
    [1] = {1, 'Head'},
    [2] = {3, 'Shoulder'},
    [3] = {5, 'Chest'},
    [4] = {6, 'Waist'},
    [5] = {9, 'Wrist'},
    [6] = {10, 'Hands'},
    [7] = {7, 'Legs'},
    [8] = {8, 'Feet'},
    [9] = {16, 'MainHand'},
    [10] = {17, 'SecondaryHand'},
}

local charString = CharacterLevelText
charString:SetFont('Fonts\\ARIALN.ttf', 14)

local f = CreateFrame('Button', 'PaperDollFrameDurabilityTab', PaperDollSidebarTab1, 'CharacterFrameTabButtonTemplate')
f:SetPoint('TOP', PaperDollFrame, 'BOTTOM', 170, 2)
f:Disable()
f:EnableMouse(false)
f:SetFrameStrata('BACKGROUND')

f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
f:RegisterEvent('MERCHANT_SHOW')

_G[f:GetName()..'LeftDisabled']:SetTexture(nil)
_G[f:GetName()..'RightDisabled']:SetTexture(nil)
_G[f:GetName()..'MiddleDisabled']:SetTexture(nil)

local function ColorGradient(perc, ...)
    if (perc >= 1) then
        local r, g, b = select(select('#', ...) - 2, ...)
        return r, g, b
    elseif (perc < 0) then
        local r, g, b = ... return r, g, b
    end

    local num = select('#', ...) / 3

    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

f:SetScript('OnEvent', function(event)
    local total = 1
    local overAll = 1

    for i = 1, #slotInfo do
        local id = GetInventorySlotInfo(slotInfo[i][2] .. 'Slot')
        local curr, max = GetInventoryItemDurability(slotInfo[i][1])
        local itemSlot = _G['Character'..slotInfo[i][2]..'Slot']

        if (curr and max and max ~= 0) then
            if (not itemSlot.Text) then
                itemSlot.Text = itemSlot:CreateFontString(nil, 'OVERLAY')
                itemSlot.Text:SetFont(NumberFontNormal:GetFont(), 15, 'THINOUTLINE')
                itemSlot.Text:SetPoint('BOTTOM', itemSlot, 0, 1)
            end

            if (itemSlot.Text) then
                local avg = curr/max
                local r, g, b = ColorGradient(avg, unpack(gradientColor))

                itemSlot.Text:SetTextColor(r, g, b)
                itemSlot.Text:SetText(string.format('%d%%', avg * 100))

                overAll = overAll + avg
                total = total + 1
            end
        else
            if (itemSlot.Text) then
                itemSlot.Text:SetText('')
            end
        end

        local r, g, b
        if (overAll/total and overAll/total < 1) then
            r, g, b = ColorGradient(overAll/total, unpack(gradientColor))
        elseif (overAll/total <= 0) then
            r, g, b = 1, 0, 0
        else
            r, g, b = 0, 1, 0
        end

        f:SetText(format('|cff%02x%02x%02x%d%%|r', r*255, g*255, b*255, (overAll/total)*100)..' '..DURABILITY)
    end
end)
