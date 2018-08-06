local _, nCore = ...

function nCore:SpellID()
    if not nCoreDB.SpellID then return end

    local select = select
    local find = string.find
    local sub = string.sub

    hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
        local id = select(10, UnitBuff(...))
        if id then
            self:AddLine("SpellID: "..id, 1, 1, 1)
            self:Show()
        end
    end)

    hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
        local id = select(10, UnitDebuff(...))
        if id then
            self:AddLine("SpellID: "..id, 1, 1, 1)
            self:Show()
        end
    end)

    hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
        local id = select(10, UnitAura(...))
        if id then
            self:AddLine("SpellID: "..id, 1, 1, 1)
            self:Show()
        end
    end)

    hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
        if find(link,"^spell:") then
            local id = sub(link, 7)
            ItemRefTooltip:AddLine("SpellID: "..id, 1, 1, 1)
            ItemRefTooltip:Show()
        end
    end)

    GameTooltip:HookScript("OnTooltipSetSpell", function(self)
        local id = select(2, self:GetSpell())
        if id then
            -- Workaround for weird issue when this gets triggered twice on the Talents frame
            -- https://github.com/renstrom/NeavUI/issues/76
            for i = 1, self:NumLines() do
                if _G["GameTooltipTextLeft"..i]:GetText() == "SpellID: "..id then
                    return
                end
            end

            self:AddLine("SpellID: "..id, 1, 1, 1)
            self:Show()
        end
    end)
end
