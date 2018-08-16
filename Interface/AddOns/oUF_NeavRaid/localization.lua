
local _, ns = ...

local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

------------------------------------------------------------------------
-- English
------------------------------------------------------------------------

L.GeneralOptions = "General Options"
L.ShowSolo = "Show Solo"
L.ShowParty = "Show Party"
L.AssistFrame = COMPACT_UNIT_FRAME_PROFILE_DISPLAYMAINTANKANDASSIST
L.SortByRole = "Sort By Role"
L.SortByRoleTooltip = "Sorts the raid frames by role instead of group."
L.ShowRoleIcons = "Show Role Icons"
L.AnchorToControls = UNLOCK
L.HorizontalHealthBars = "Horizontal Health Bars"
L.ShowPowerBars = COMPACT_UNIT_FRAME_PROFILE_DISPLAYPOWERBAR
L.ManaPowerBarsOnly = "Mana Only"
L.HorizontalPowerBars = "Horizontal Power Bars"
L.AuraOptions = "Buff & Debuff Options"
L.IndicatorSizeSlider = "Indicator Size"
L.DebuffSizeSlider = "Debuff Size"
L.LayoutOptions = "Display Options"
L.Orientation = "Orientation"
L.InitialAnchor = "Initial Anchor"
L.StatusBarTexture = "StatusBar Texture"
L.Font = "Font"
L.FontSize = "Font Size"
L.NameLengthSlider = "Name Length"
L.FrameWidthSlider = "Width"
L.FrameHeightSlider = "Height"
L.FrameOffsetSlider = "Offset"
L.FrameScaleSlider = "Scale"

L.Vertical = "Vertical"
L.Horizontal = "Horizontal"
L.TopLeft = "Top Left"
L.BottomLeft = "Bottom Left"
L.TopRight = "Top Right"
L.BottomRight = "Bottom Right"

local CURRENT_LOCALE = GetLocale()
if CURRENT_LOCALE == "enUS" then return end

------------------------------------------------------------------------
-- German
------------------------------------------------------------------------

if CURRENT_LOCALE == "deDE" then

L.GeneralOptions = "Allgemeine Einstellungen"
L.ShowSolo = "Anzeigen wenn solo"
L.ShowParty = "Gruppe anzeigen"
L.SortByRole = "Nach Rolle sortieren"
L.SortByRoleTooltip = "Sortiert Schlachtzugsmitglieder nach Rolle anstatt nach Gruppe."
L.ShowRoleIcons = "Rollensymbole anzeigen"
L.HorizontalHealthBars = "Horizontale Gesundheitsbalken"
L.ManaPowerBarsOnly = "Nur Mana"
L.HorizontalPowerBars = "Horizontale Ressourcenbalken"
L.AuraOptions = "Einstellungen für Stärkungs- und Schwächungszauber"
L.IndicatorSizeSlider = "Indikatorgröße"
L.DebuffSizeSlider = "Schwächungszaubergröße"
L.LayoutOptions = "Anzeigeeinstellungen"
L.Orientation = "Ausrichtung"
L.InitialAnchor = "Initialanker"
L.NameLengthSlider = "Namenslänge"
L.FrameWidthSlider = "Breite"
L.FrameHeightSlider = "Höhe"
L.FrameOffsetSlider = "Abstand"
L.FrameScaleSlider = "Skallierung"

L.Vertical = "Vertikal"
L.Horizontal = "Horizontal"
L.TopLeft = "Oben links"
L.BottomLeft = "Unten links"
L.TopRight = "Oben rechts"
L.BottomRight = "Unten rechts"

return end

------------------------------------------------------------------------
-- Spanish
------------------------------------------------------------------------

if CURRENT_LOCALE == "esES" then

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
