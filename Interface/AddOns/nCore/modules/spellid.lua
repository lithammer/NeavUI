
hooksecurefunc(GameTooltip, 'SetUnitBuff', function(self,...)
    local id = select(11, UnitBuff(...))
    if (id) then
        self:AddLine('SpellID: '..id, 1, 1, 1)
        self:Show()
    end
end)

hooksecurefunc(GameTooltip, 'SetUnitDebuff', function(self,...)
    local id = select(11, UnitDebuff(...))
    if (id) then
        self:AddLine('SpellID: '..id, 1, 1, 1)
        self:Show()
    end
end)

hooksecurefunc(GameTooltip, 'SetUnitAura', function(self,...)
    local id = select(11, UnitAura(...))
    if (id) then
        self:AddLine('SpellID: '..id, 1, 1, 1)
        self:Show()
    end
end)

hooksecurefunc('SetItemRef', function(link, text, button, chatFrame)
    if (string.find(link,'^spell:')) then
        local id = string.sub(link, 7)
        ItemRefTooltip:AddLine('SpellID: '..id, 1, 1, 1)
        ItemRefTooltip:Show()
    end
end)

GameTooltip:HookScript('OnTooltipSetSpell', function(self)
    local id = select(3, self:GetSpell())
    if (id) then
        -- Workaround for weird issue when this gets triggered twice on the Talents frame
        -- https://github.com/lithammer/NeavUI/issues/76
        for i = 1, self:NumLines() do
            if _G['GameTooltipTextLeft'..i]:GetText() == 'SpellID: '..id then
                return
            end
        end

        self:AddLine('SpellID: '..id, 1, 1, 1)
        self:Show()
    end
end)
