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
L.CombatWarning = "nCore: This is not possible in combat!"
L.Dressroom = "Dressroom Tweaks"
L.DressroomTooltip = "Adds clothed and naked buttons to the dressroom frame."
L.Durability = DURABILITY
L.DurabilityTooltip = "Adds durability information to the character frame."
L.ErrorFilter = "Error Filter"
L.ErrorFilterTooltip = "Filter common error spam."
L.Fonts = "Font Fix"
L.FontsTooltip = "Modifies some default font objects."
L.MapCoords = "Map Coords"
L.MapCoordsTooltip = "Adds player and cursor location to the world map."
L.Skins = "Skin Addons"
L.SkinsTooltip = "Skin Omen, DBM, TinyDPS, Recount, Skada, and Numeration to closer match the Neav UI look."
L.SpellID = "Spell IDs"
L.SpellIDTooltip = "Add spell ids to the tooltip."

local CURRENT_LOCALE = GetLocale()
if CURRENT_LOCALE == "enUS" then return end

------------------------------------------------------------------------
-- German
------------------------------------------------------------------------

if CURRENT_LOCALE == "deDE" then

L.OptionsLabel = "Einstellungen"
L.AltBuy = "Alt-Kaufen"
L.AltBuyTooltip = "Die Alt-Taste gedrückt halten um einen Stapel von einem Gegenstand zu kaufen."
L.AltBuyVendorToolip = "<Alt-Klick um einen Stapel zu kaufen>"
L.CombatWarning = "nCore: Das ist im Kampf nicht möglich!"
L.Dressroom = "Anpassungen für die Anprobe"
L.DressroomTooltip = "Fügt dem Anprobefester Buttons zum An- und Ausziehen hinzu."
L.Durability = DURABILITY
L.DurabilityTooltip = "Zeigt Haltbarkeitinformationen im Charakterfenster an."
L.ErrorFilter = "Fehlerfilter"
L.ErrorFilterTooltip = "Filtert oft vorkommende Fehlermeldungen aus."
L.Fonts = "Schriftenreparatur"
L.FontsTooltip = "Modifiziert manche der Standardschriften."
L.MapCoords = "Kartenkoordinaten"
L.MapCoordsTooltip = "Zeigt die Player- und die Kursorposition auf der Weltkarte an."
L.Skins = "Addonsdarstellung"
L.SkinsTooltip = "Das Aussehen von Omen, DBM, TinyDPS, Recount, Skada und Numeration anpassen, damit sie dem Aussehen von Neav UI ähneln."
L.SpellID = "Zauber IDs"
L.SpellIDTooltip = "Zauber IDs in Tooltips anzeigen."

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
