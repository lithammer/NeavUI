local noop = function() return end

local function Kill(object)
    if object.UnregisterAllEvents then
        object:UnregisterAllEvents()
    end
    object.Show = noop
    object:Hide()
end

Kill(CompactRaidFrameManager)
Kill(CompactUnitFrameProfiles)

for i = 1, MAX_PARTY_MEMBERS do
    local name = 'PartyMemberFrame'..i
    local frame = _G[name]

    Kill(frame)

    local pet = name..'PetFrame'
    local petframe = _G[pet]

    Kill(petframe)
end
