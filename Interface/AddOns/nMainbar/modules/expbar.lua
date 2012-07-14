
local _, nMainbar = ...
local cfg = nMainbar.Config

    -- experience bar mouseover text

MainMenuBarExpText:SetFont(cfg.expBar.font, cfg.expBar.fontsize, 'THINOUTLINE')
MainMenuBarExpText:SetShadowOffset(0, 0)

if (cfg.expBar.mouseover) then
    MainMenuBarExpText:SetAlpha(0)
    
    MainMenuExpBar:HookScript('OnEnter', function()
        securecall('UIFrameFadeIn', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 1)
    end)

    MainMenuExpBar:HookScript('OnLeave', function()
        securecall('UIFrameFadeOut', MainMenuBarExpText, 0.2, MainMenuBarExpText:GetAlpha(), 0) 
    end)
else
    MainMenuBarExpText:Show()
    MainMenuBarExpText.Hide = function() end
end

-- Hack to force OverrideActionBarExpBar's textures being drawn above its statusbar
for _, texture in pairs({
    'XpMid',
    'XpL',
    'XpR',
}) do
    OverrideActionBarExpBar[texture]:SetDrawLayer('OVERLAY', 0)
end
