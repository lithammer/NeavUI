
--[[
    -- A list of all fonts

    'GameFontNormal',
    'GameFontHighlight',
    'GameFontDisable',
    'GameFontNormalSmall',
    'GameFontHighlightExtraSmall',
    'GameFontHighlightMedium',
    'GameFontNormalLarge',
    'GameFontNormalHuge',

    'BossEmoteNormalHuge',

    'NumberFontNormal',
    'NumberFontNormalSmall',
    'NumberFontNormalLarge',
    'NumberFontNormalHuge',

    'ChatFontNormal',
    'ChatFontSmall',

    'QuestTitleFont',
    'QuestFont',
    'QuestFontNormalSmall',
    'QuestFontHighlight',

    'ItemTextFontNormal',
    'MailTextFontNormal',
    'SubSpellFont',
    'DialogButtonNormalText',
    'ZoneTextFont',
    'SubZoneTextFont',
    'PVPInfoTextFont',
    'ErrorFont',
    'TextStatusBarText',
    'CombatLogFont',

    'GameTooltipText',
    'GameTooltipTextSmall',
    'GameTooltipHeaderText',

    'WorldMapTextFont',

    'InvoiceTextFontNormal',
    'InvoiceTextFontSmall',
    'CombatTextFont',
    'MovieSubtitleFont',

    'AchievementPointsFont',
    'AchievementPointsFontSmall',
    'AchievementDescriptionFont',
    'AchievementCriteriaFont',
    'AchievementDateFont',
    'ReputationDetailFont',
--]]

for _, font in pairs({
    GameFontHighlight,

    GameFontDisable,

    GameFontHighlightExtraSmall,
    GameFontHighlightMedium,

    GameFontNormal,
    GameFontNormalSmall,

    TextStatusBarText,

    GameFontDisableSmall,
    GameFontHighlightSmall,
}) do
    font:SetFont('Fonts\\ARIALN.ttf', 13)
    font:SetShadowOffset(1, -1)
end
   
for _, font in pairs({
    AchievementPointsFont,
    AchievementPointsFontSmall,
    AchievementDescriptionFont,
    AchievementCriteriaFont,
    AchievementDateFont,
}) do
    font:SetFont('Fonts\\ARIALN.ttf', 12)
end

GameFontNormalHuge:SetFont('Fonts\\ARIALN.ttf', 20, 'OUTLINE')
GameFontNormalHuge:SetShadowOffset(0, 0)