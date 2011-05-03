    
    -- a "new" mail notification    

MiniMapMailFrame.Text = MiniMapMailFrame:CreateFontString(nil, 'OVERLAY')
MiniMapMailFrame.Text:SetParent(MiniMapMailFrame)
MiniMapMailFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapMailFrame.Text:SetPoint('BOTTOMRIGHT', MiniMapMailFrame)
MiniMapMailFrame.Text:SetTextColor(1, 0, 1)
MiniMapMailFrame.Text:SetText('N')

MiniMapMailFrame:SetSize(14, 14)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, -4, 5)

hooksecurefunc(MiniMapMailFrame, 'Show', function()
    MiniMapMailBorder:SetTexture(nil)
    MiniMapMailIcon:SetTexture(nil)
end)

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

    -- hide all unwanted stuff
    
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

MiniMapWorldMapButton:Hide()

MinimapNorthTag:SetAlpha(0)

MinimapBorder:Hide()
MinimapBorderTop:Hide()

MinimapZoneText:Hide()
MinimapZoneTextButton:Hide()

    -- hide the durability frame (the armored man)
    
DurabilityFrame:Hide()

    -- make the minimap bigger
    
MinimapCluster:SetScale(1.18)
MinimapCluster:EnableMouse(false)

    -- new position
    
Minimap:ClearAllPoints()
Minimap:SetPoint('TOPRIGHT', UIParent, -26, -26)

    -- make it square and add a border
    
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

Minimap:CreateBorder(11)
Minimap:SetBorderPadding(1)

    -- enable mousewheel zooming

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, delta)
	if (delta > 0) then
		_G.MinimapZoomIn:Click()
	elseif delta < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

    -- a "new" mail notification    
    
MiniMapMailBorder:SetTexture(nil)
MiniMapMailIcon:SetTexture(nil)

MiniMapMailFrame.Text = MiniMapMailFrame:CreateFontString(nil, 'OVERLAY')
MiniMapMailFrame.Text:SetParent(MiniMapMailFrame)
MiniMapMailFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapMailFrame.Text:SetPoint('BOTTOMRIGHT', MiniMapMailFrame)
MiniMapMailFrame.Text:SetTextColor(1, 0, 1)
MiniMapMailFrame.Text:SetText('N')

MiniMapMailFrame:SetWidth((MiniMapMailFrame.Text:GetStringWidth()))
MiniMapMailFrame:SetHeight(18)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('BOTTOMRIGHT', Minimap, -4, 5)

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
-- MiniMapTracking:ClearAllPoints()
-- MiniMapTracking:SetPoint('CENTER', 9999, 9999)
-- MiniMapTracking.Show = function() end

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
    
    -- if (not self.hasBorder) then
        CreateBorder(self, 12, 1, 1, 1)
        -- self.hasBorder = true
    -- end
end)