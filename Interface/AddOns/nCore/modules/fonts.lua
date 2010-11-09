
local font = 'Fonts\\ARIALN.ttf'

GameFontNormalHuge:SetFont(font, 20, 'OUTLINE')
GameFontNormalHuge:SetShadowOffset(0, 0)

GameTooltipHeaderText:SetFont(font, 17)
GameTooltipText:SetFont(font, 15)
GameTooltipTextSmall:SetFont(font, 15)

for _, font in pairs({
    _G['GameFontHighlight'],
    
    _G['GameFontDisable'],

    _G['GameFontHighlightExtraSmall'],
    _G['GameFontHighlightMedium'],
    
    _G['GameFontNormal'],
    _G['GameFontNormalSmall'],
--  _G['GameFontNormalLarge'],
--  _G['GameFontNormalHuge'],
    
    _G['TextStatusBarText'],
    
    _G['GameFontDisableSmall'],
    _G['GameFontHighlightSmall'],
}) do
    font:SetFont('Fonts\\ARIALN.ttf', 13)
end

for _, font in pairs({
    _G['AchievementPointsFont'],
    _G['AchievementPointsFontSmall'],
    _G['AchievementDescriptionFont'],
    _G['AchievementCriteriaFont'],
    _G['AchievementDateFont'],
}) do
    font:SetFont('Fonts\\ARIALN.ttf', 12)
end

--[[
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
]]