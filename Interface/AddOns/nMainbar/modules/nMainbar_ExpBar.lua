
    -- experience bar mouseover text
    
MainMenuBarExpText:SetFont(nMainbar.expBar.font, nMainbar.expBar.fontsize, 'THINOUTLINE')
MainMenuBarExpText:SetShadowOffset(0, 0)

if (nMainbar.expBar.mouseover) then
    MainMenuBarExpText:SetAlpha(0)
else
    MainMenuBarExpText:Show()
    MainMenuBarExpText.Hide = function() end
end

MainMenuExpBar:HookScript('OnEnter', function()
    if (nMainbar.expBar.mouseover) then
        securecall('UIFrameFadeIn', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
    end
end)

MainMenuExpBar:HookScript('OnLeave', function()
    if (nMainbar.expBar.mouseover) then
        securecall('UIFrameFadeOut', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0) 
    end
end)