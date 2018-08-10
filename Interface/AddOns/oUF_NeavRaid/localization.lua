
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
L.AssistFrame = "Show Main Tank & Assist Frames"
L.SortByRole = "Sort By Role"
L.SortByRoleTooltip = "Sorts the raid frames by role instead of group."
L.ShowRoleIcons = "Show Role Icons"
L.AnchorToControls = "Unlock Frame"
L.HorizontalHealthBars = "Horizontal Health Bars"
L.ShowPowerBars = "Show Power Bars"
L.ManaPowerBarsOnly = "Mana Only"
L.HorizontalPowerBars = "Horizontal Power Bars"
L.AuraOptions = "Buff/Debuff Options"
L.IndicatorSizeSlider = "Indicator Size"
L.DebuffSizeSlider = "Debuff Size"
L.LayoutOptions = "Display Options"
L.Orientation = "Orientation"
L.InitialAnchor = "Initial Anchor"
L.NameLengthSlider = "Name Length"
L.FrameWidthSlider = "Frame Width"
L.FrameHeightSlider = "Frame Height"
L.FrameOffsetSlider = "Frame Offset"
L.FrameScaleSlider = "Frame Scale"

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
