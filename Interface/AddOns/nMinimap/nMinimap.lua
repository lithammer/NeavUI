    
    -- a 'new' mail notification    

MiniMapMailFrame:SetSize(14, 14)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, -4, 5)

MiniMapMailBorder:SetTexture(nil)
MiniMapMailIcon:SetTexture(nil)

hooksecurefunc(MiniMapMailFrame, 'Show', function()
    MiniMapMailBorder:SetTexture(nil)
    MiniMapMailIcon:SetTexture(nil)
end)

MiniMapMailFrame.Text = MiniMapMailFrame:CreateFontString(nil, 'OVERLAY')
MiniMapMailFrame.Text:SetParent(MiniMapMailFrame)
MiniMapMailFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapMailFrame.Text:SetPoint('BOTTOMRIGHT', MiniMapMailFrame)
MiniMapMailFrame.Text:SetTextColor(1, 0, 1)
MiniMapMailFrame.Text:SetText('N')

   -- modify the lfg frame
    
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint('TOPLEFT', Minimap, 4, -4)
MiniMapLFGFrame:SetSize(14, 14)
MiniMapLFGFrame:SetHighlightTexture(nil)

MiniMapLFGFrameBorder:SetTexture()
MiniMapLFGFrame.eye:Hide()
    
hooksecurefunc('EyeTemplate_StartAnimating', function(self)
	self:SetScript('OnUpdate', nil)
end)

MiniMapLFGFrame.Text = MiniMapLFGFrame:CreateFontString(nil, 'OVERLAY')
MiniMapLFGFrame.Text:SetParent(MiniMapLFGFrame)
MiniMapLFGFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapLFGFrame.Text:SetPoint('TOP', MiniMapLFGFrame)
MiniMapLFGFrame.Text:SetTextColor(1, 0.4, 0)
MiniMapLFGFrame.Text:SetText('L')

   -- modify the battlefield frame
   
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint('BOTTOMLEFT', Minimap, 5, 5)
MiniMapBattlefieldFrame:SetSize(14, 14)

hooksecurefunc(MiniMapBattlefieldFrame, 'Show', function()
    MiniMapBattlefieldIcon:SetTexture(nil)
    MiniMapBattlefieldBorder:SetTexture(nil)
    BattlegroundShine:SetTexture(nil)
end)

MiniMapBattlefieldFrame.Text = MiniMapBattlefieldFrame:CreateFontString(nil, 'OVERLAY')
MiniMapBattlefieldFrame.Text:SetParent(MiniMapBattlefieldFrame)
MiniMapBattlefieldFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapBattlefieldFrame.Text:SetPoint('BOTTOMLEFT', MiniMapBattlefieldFrame)
MiniMapBattlefieldFrame.Text:SetTextColor(0, 0.75, 1)
MiniMapBattlefieldFrame.Text:SetText('P')

    -- hide all unwanted things
    
MinimapZoomIn:Hide()
MinimapZoomIn:UnregisterAllEvents()

MinimapZoomOut:Hide()
MinimapZoomOut:UnregisterAllEvents()

MiniMapWorldMapButton:Hide()
MiniMapWorldMapButton:UnregisterAllEvents()

MinimapNorthTag:SetAlpha(0)

MinimapBorder:Hide()
MinimapBorderTop:Hide()

MinimapZoneText:Hide()

MinimapZoneTextButton:Hide()
MinimapZoneTextButton:UnregisterAllEvents()

    -- hide the durability frame (the armored man)
    
DurabilityFrame:Hide()
DurabilityFrame:UnregisterAllEvents()

    -- bigger minimap
    
MinimapCluster:SetScale(1.1)
MinimapCluster:EnableMouse(false)

    -- new position
    
Minimap:ClearAllPoints()
Minimap:SetPoint('TOPRIGHT', UIParent, -26, -26)

    -- square minimap and create a border
    
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

Minimap:CreateBorder(11)
Minimap:SetBorderPadding(1)

    -- enable mousewheel zooming

Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
	if (delta > 0) then
		_G.MinimapZoomIn:Click()
	elseif delta < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

    -- modify the minimap tracking

Minimap:SetScript('OnMouseUp', function(self, button)
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    else
        Minimap_OnClick(self)
    end
end)

    -- the dirty method, move it out of the screen, no error anymore? Will see.. 

MiniMapTracking:UnregisterAllEvents()
MiniMapTracking:Hide()

    -- skin the ticket status frame

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint('BOTTOMRIGHT', UIParent, 0, 0)

TicketStatusFrameButton:HookScript('OnShow', function(self)
	self:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8', 
        insets = {
            left = 3, 
            right = 3, 
            top = 3, 
            bottom = 3
        }
    })
    self:SetBackdropColor(0, 0, 0, 0.5)
    self:CreateBorder(12)
end)

    -- mouseover zone text
    
local MainZone = Minimap:CreateFontString(nil, 'OVERLAY')
MainZone:SetParent(Minimap)
MainZone:SetFont('Fonts\\ARIALN.ttf', 15, 'THINOUTLINE')
MainZone:SetPoint('TOP', Minimap, 0, -22)
MainZone:SetTextColor(1, 1, 1)
MainZone:SetAlpha(0)
MainZone:SetSize(130, 15)

local SubZone = Minimap:CreateFontString(nil, 'OVERLAY')
SubZone:SetParent(Minimap)
SubZone:SetFont('Fonts\\ARIALN.ttf', 12, 'THINOUTLINE')
SubZone:SetPoint('TOP', MainZone, 'BOTTOM', 0, 2)
SubZone:SetTextColor(1, 1, 1)
SubZone:SetAlpha(0)
SubZone:SetSize(130, 12)

Minimap:HookScript('OnEnter', function()

        -- disable the mouseover if the shift key is pressed, in cases we want to make a ping and the text is annoying
        
    if (nMinimap.showMouseoverZoneText and SubZone and not IsShiftKeyDown()) then
        SubZone:SetText(GetSubZoneText())
        UIFrameFadeIn(SubZone, 0.235, SubZone:GetAlpha(), nMinimap.alphaMouseoverZoneText)

        MainZone:SetText(GetRealZoneText())
        UIFrameFadeIn(MainZone, 0.235, MainZone:GetAlpha(), nMinimap.alphaMouseoverZoneText)
   end
end)

Minimap:HookScript('OnLeave', function()
    if (nMinimap.showMouseoverZoneText and SubZone) then
        UIFrameFadeOut(SubZone, 0.235, SubZone:GetAlpha(), 0)
        UIFrameFadeOut(MainZone, 0.235, MainZone:GetAlpha(), 0)
    end
end)