--[[

    nMainbar
    Copyright (c) 2008-2010, Anton "Neav" I. (Neav @ Alleria-EU)
    All rights reserved.

--]]

ReputationWatchStatusBarText:SetFont(nMainbar.repBar.font, nMainbar.repBar.fontsize, 'OUTLINE')
ReputationWatchStatusBarText:SetShadowOffset(0, 0)

if (nMainbar.repBar.mouseover) then
    ReputationWatchStatusBarText:SetAlpha(0)

    ReputationWatchBar:HookScript('OnEnter', function()
        UIFrameFadeIn(ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 1)
    end)

    ReputationWatchBar:HookScript('OnLeave', function()
        UIFrameFadeOut(ReputationWatchStatusBarText, 0.2, ReputationWatchStatusBarText:GetAlpha(), 0) 
    end)
else
    ReputationWatchStatusBarText:Show()
    ReputationWatchStatusBarText.Hide = function() end
end

MainMenuBarExpText:SetFont(nMainbar.expBar.font, nMainbar.expBar.fontsize, 'OUTLINE')
MainMenuBarExpText:SetShadowOffset(0, 0)

if (nMainbar.expBar.mouseover) then
    MainMenuBarExpText:SetAlpha(0)
else
    MainMenuBarExpText:Show()
    MainMenuBarExpText.Hide = function() end
end

MainMenuExpBar:HookScript('OnEnter', function()
    if (nMainbar.expBar.mouseover) then
        UIFrameFadeIn(MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
    end
end)

MainMenuExpBar:HookScript('OnLeave', function()
    if (nMainbar.expBar.mouseover) then
        UIFrameFadeOut(MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0) 
    end
end)