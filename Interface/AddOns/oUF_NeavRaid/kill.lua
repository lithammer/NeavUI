
InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

CompactRaidFrameManager:ClearAllPoints()
CompactRaidFrameManager:SetPoint('TOP', UIParent, 'BOTTOM', 0, -9000)
CompactUnitFrameProfiles:UnregisterAllEvents()

for i = 1, MAX_PARTY_MEMBERS do
    local name = 'PartyMemberFrame'..i
    local frame = _G[name]

    frame:ClearAllPoints()
    frame:SetPoint('TOP', UIParent, 'BOTTOM', 0, -9000)

    _G[name..'HealthBar']:UnregisterAllEvents()
    _G[name..'ManaBar']:UnregisterAllEvents()

    local pet = name..'PetFrame'
    local petframe = _G[pet]

    petframe:ClearAllPoints()
    petframe:SetPoint('TOP', UIParent, 'BOTTOM', 0, -9000)

    _G[pet]:UnregisterAllEvents()
end
