local _, nCore = ...

function nCore:Fonts()
    if not nCoreDB.Fonts then return end

    --[[
        -- A list of all fonts

        "GameFontNormal",
        "GameFontHighlight",
        "GameFontDisable",
        "GameFontNormalSmall",
        "GameFontHighlightExtraSmall",
        "GameFontHighlightMedium",
        "GameFontNormalLarge",
        "GameFontNormalHuge",

        "BossEmoteNormalHuge",

        "NumberFontNormal",
        "NumberFontNormalSmall",
        "NumberFontNormalLarge",
        "NumberFontNormalHuge",
        "NumberFontNormalSmallGray,

        "ChatFontNormal",
        "ChatFontSmall",

        "QuestTitleFont",
        "QuestFont",
        "QuestFontNormalSmall",
        "QuestFontHighlight",

        "ItemTextFontNormal",
        "MailTextFontNormal",
        "SubSpellFont",
        "DialogButtonNormalText",
        "ZoneTextFont",
        "SubZoneTextFont",
        "PVPInfoTextFont",
        "ErrorFont",
        "TextStatusBarText",
        "CombatLogFont",

        "GameTooltipText",
        "GameTooltipTextSmall",
        "GameTooltipHeaderText",

        "WorldMapTextFont",

        "InvoiceTextFontNormal",
        "InvoiceTextFontSmall",
        "CombatTextFont",
        "MovieSubtitleFont",

        "AchievementPointsFont",
        "AchievementPointsFontSmall",
        "AchievementDescriptionFont",
        "AchievementCriteriaFont",
        "AchievementDateFont",
        "ReputationDetailFont",
    --]]

    for _, font in pairs({
        GameFontDisable,
        GameFontDisableSmall,

        GameFontHighlight,
        GameFontHighlightMedium,
        GameFontHighlightSmall,
        GameFontHighlightExtraSmall,

        GameFontNormal,
        GameFontNormalSmall,

        TextStatusBarText,
    }) do
        font:SetFont(STANDARD_TEXT_FONT, 13)
        font:SetShadowOffset(1, -1)
    end

    for _, font in pairs({
        AchievementPointsFont,
        AchievementPointsFontSmall,
        AchievementDescriptionFont,
        AchievementCriteriaFont,
        AchievementDateFont,
    }) do
        font:SetFont(STANDARD_TEXT_FONT, 12)
    end

    GameFontNormalHuge:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
    GameFontNormalHuge:SetShadowOffset(0, 0)
end
