
local frameHider = CreateFrame('Frame')
frameHider:Hide()

InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

CompactRaidFrameManager:SetParent(frameHider)
CompactUnitFrameProfiles:UnregisterAllEvents()

for i = 1, MAX_PARTY_MEMBERS do
    local name = 'PartyMemberFrame'..i
    local frame = _G[name]

    frame:SetParent(frameHider)

    _G[name..'HealthBar']:UnregisterAllEvents()
    _G[name..'ManaBar']:UnregisterAllEvents()

    local pet = name..'PetFrame'
    local petframe = _G[pet]

    petframe:SetParent(frameHider)

    _G[pet]:UnregisterAllEvents()
end
