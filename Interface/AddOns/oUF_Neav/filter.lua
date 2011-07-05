
local _, ns = ...
local config = ns.config

ns.buffList = {

        -- druid spells

    [GetSpellInfo(61336)] = 1,      -- survival instincts
    [GetSpellInfo(29166)] = 1,      -- invervate
    [GetSpellInfo(22812)] = 1,      -- barskin
    [GetSpellInfo(50334)] = 1,      -- berserk

        -- deathknight spells

    [GetSpellInfo(49039)] = 1,      -- lich
    [GetSpellInfo(55233)] = 1,      -- vamp blood
    [GetSpellInfo(48707)] = 1,      -- antimagic shell
    [GetSpellInfo(48792)] = 1,      -- icebound fortitude

        -- mage spells

    [GetSpellInfo(45438)] = 1,      -- ice block

        -- warrior spells

    [GetSpellInfo(23920)] = 1,      -- spell reflect

        -- rogue spells

    [GetSpellInfo(2983)] = 1,       -- sprint
    [GetSpellInfo(5277)] = 1,       -- evasion
    [GetSpellInfo(31224)] = 1,      -- cloak

        -- paladin spells

    [GetSpellInfo(642)] = 1,        -- pala bubble

        -- shaman spells

    [GetSpellInfo(79206)] = 1,      -- spiritwalker

        -- other spells

    [GetSpellInfo(64356)] = 1,      -- drinking
}