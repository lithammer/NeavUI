local _, nCore = ...

local L = {}
nCore.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

------------------------------------------------------------------------
-- English
------------------------------------------------------------------------

L.OptionsLabel = "Options"
L.AltBuy = "Alt Buy"
L.AltBuyTooltip = "Hold the alt key to buy a stack of an item."
L.AltBuyVendorToolip = "<Alt-click, to buy an stack>"
L.ArchaeologyHelper = "Archaeology Helper"
L.ArchaeologyHelperTooltip = "Double right click to survey at digsites."
L.AutoGreed = "Auto Greed"
L.AutoGreedTooltip = "Automaticly role greed on green items at max level."
L.AutoQuest = "Auto Quest"
L.AutoQuestTooltip = "Hold shift to automaticly accept and turnin quests."
L.CombatWarning = "nCore: You cant do this in combat!"
L.Dressroom = "Dressroom Tweaks"
L.DressroomTooltip = "Adds clothed and naked buttons to the dressroom frame."
L.Durability = "Durability"
L.DurabilityTooltip = "Adds durability information to the character frame."
L.ErrorFilter = "Error Filter"
L.ErrorFilterTooltip = "Filter common error spam."
L.Fonts = "Font Fix"
L.FontsTooltip = "Modifies some default font objects."
L.ObjectiveTracker = "Moveable Objective Tracker"
L.ObjectiveTrackerTooltip = "Makes the objective tracker movable."
L.ObjectiveTrackerButtonTooltip = "Shift + left-click to Drag"
L.MapCoords = "Map Coords"
L.MapCoordsTooltip = "Adds player and cursor location to the world map."
L.MoveTalkingHeads = "Moveable Talking Heads"
L.MoveTalkingHeadsTooltip = "Makes the talking heads frame movable. /alertframemover to unlock the frame."
L.QuestTracker = "Quest Tracker"
L.QuestTrackerTooltip = "Add current number of quests to the worldmap title text."
L.Skins = "Skin Addons"
L.SkinsTooltip = "Skin Omen, DBM, TinyDPS, Recount, Skada, and Numeration to closer match the Neav UI look."
L.SpellID = "Spell IDs"
L.SpellIDTooltip = "Add spell ids to the tooltip."
L.VignetteAlert = "Vignette Alerts"
L.VignetteAlertTooltip = "Alerts you when you detect a rare or chest."

local CURRENT_LOCALE = GetLocale()
if CURRENT_LOCALE == "enUS" then return end

------------------------------------------------------------------------
-- German
------------------------------------------------------------------------

if CURRENT_LOCALE == "deDE" then

L.AltBuyVendorToolip = "<Alt-klicken, um einen ganzen Stapel zu kaufen>"

return end

------------------------------------------------------------------------
-- Spanish
------------------------------------------------------------------------

if CURRENT_LOCALE == "esES" then

L.AltBuyVendorToolip = "<Alt-clic, para comprar una pila>"

return end

------------------------------------------------------------------------
-- Latin American Spanish
------------------------------------------------------------------------

if CURRENT_LOCALE == "esMX" then

return end

------------------------------------------------------------------------
-- French
------------------------------------------------------------------------

if CURRENT_LOCALE == "frFR" then

L.AltBuyVendorToolip = "<Alt-clic, d acheter une pile>"

return end

------------------------------------------------------------------------
-- Italian
------------------------------------------------------------------------

if CURRENT_LOCALE == "itIT" then

return end

------------------------------------------------------------------------
-- Brazilian Portuguese
------------------------------------------------------------------------

if CURRENT_LOCALE == "ptBR" then

return end

------------------------------------------------------------------------
-- Russian
------------------------------------------------------------------------

if CURRENT_LOCALE == "ruRU" then

return end

------------------------------------------------------------------------
-- Korean
------------------------------------------------------------------------

if CURRENT_LOCALE == "koKR" then

return end

------------------------------------------------------------------------
-- Simplified Chinese
------------------------------------------------------------------------

if CURRENT_LOCALE == "zhCN" then

return end

------------------------------------------------------------------------
-- Traditional Chinese
------------------------------------------------------------------------

if CURRENT_LOCALE == "zhTW" then

return end
