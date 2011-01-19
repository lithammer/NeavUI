   
   -- nmodify the lfg frame
    
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint('BOTTOMLEFT', Minimap, 4, 4)
MiniMapLFGFrame:SetWidth(14)
MiniMapLFGFrame:SetHeight(14)
MiniMapLFGFrame:SetHighlightTexture(nil)

MiniMapLFGFrame.eye:Hide()

hooksecurefunc('EyeTemplate_StartAnimating', function(eye)
	eye:SetScript('OnUpdate', nil)
end)

MiniMapLFGFrame.Text = MiniMapLFGFrame:CreateFontString(nil, 'OVERLAY')
MiniMapLFGFrame.Text:SetParent(MiniMapLFGFrame)
MiniMapLFGFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapLFGFrame.Text:SetPoint('TOP', MiniMapLFGFrame)
MiniMapLFGFrame.Text:SetTextColor(1, 0.4, 0)
MiniMapLFGFrame.Text:SetText('L')
MiniMapLFGFrame.Text:SetWidth(14)
MiniMapLFGFrame.Text:SetHeight(14)

   -- modify the battlefield frame
   
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint('BOTTOMLEFT', Minimap, 4, 4)
MiniMapBattlefieldFrame:SetWidth(14)
MiniMapBattlefieldFrame:SetHeight(14)

MiniMapBattlefieldBorder:Hide()

MiniMapBattlefieldIcon:SetTexture(nil)
MiniMapBattlefieldIcon.SetTexture = function() end

BattlegroundShine:Hide()

MiniMapBattlefieldFrame.Text = MiniMapBattlefieldFrame:CreateFontString(nil, 'OVERLAY')
MiniMapBattlefieldFrame.Text:SetParent(MiniMapBattlefieldFrame)
MiniMapBattlefieldFrame.Text:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
MiniMapBattlefieldFrame.Text:SetPoint('TOPLEFT', MiniMapBattlefieldFrame)
MiniMapBattlefieldFrame.Text:SetTextColor(0, 0.75, 1)
MiniMapBattlefieldFrame.Text:SetText('P')
MiniMapBattlefieldFrame.Text:SetWidth(14)
MiniMapBattlefieldFrame.Text:SetHeight(14)

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

CreateBorder(Minimap, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)

    -- enable mousewheel zooming

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, delta)
	if delta > 0 then
		_G.MinimapZoomIn:Click()
	elseif delta < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

    -- a "new" mail notification    
    
MiniMapMailBorder:Hide()

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

    -- modify the minimap tracking, remove the icon and add a mouseover text
    
local function GetTrackType()
	local hasActiveTracking = false
		
	for i = 1, GetNumTrackingTypes() do
		local trackingName, _, isActive = GetTrackingInfo(i)
		if (isActive) then
			hasActiveTracking = true
			return trackingName
		end
	end
	
	if (not hasActiveTracking) then
		return NONE
	end
end

MinimapTrackingText = Minimap:CreateFontString('$parentTrackingText', 'OVERLAY')
MinimapTrackingText:SetFont('Fonts\\ARIALN.ttf', 17, 'OUTLINE')
MinimapTrackingText:SetPoint('CENTER', Minimap, 0, 20)
MinimapTrackingText:SetWidth((Minimap:GetWidth() - 25))
MinimapTrackingText:SetAlpha(0)

Minimap:SetScript('OnMouseUp', function(self, button)
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    else
        Minimap_OnClick(self)
    end
end)

MiniMapTracking:Hide()
MiniMapTracking.Show = function() end

MiniMapTracking:SetScript('OnEvent', function(self, event)
    MinimapTrackingText:SetText(GetTrackType())
end)

Minimap:HookScript('OnEnter', function()
    MinimapTrackingText:SetText(GetTrackType())
    UIFrameFadeIn(MinimapTrackingText, 0.15, MinimapTrackingText:GetAlpha(), 1)
end)

Minimap:HookScript('OnLeave', function()
    MinimapTrackingText:SetText(GetTrackType())
    UIFrameFadeOut(MinimapTrackingText, 0.15, MinimapTrackingText:GetAlpha(), 0)
end)

    -- skin the ticket status frame
    
TicketStatusFrameButton:HookScript('OnShow', function(self)
	TicketStatusFrameButton:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8', 
        insets = {
            left = 3, 
            right = 3, 
            top = 3, 
            bottom = 3
        }
    })
    
    TicketStatusFrameButton:SetBackdropColor(0, 0, 0, 0.5)
    
    if (not TicketStatusFrameButton.hasBorder) then
        CreateBorder(TicketStatusFrameButton, 12, 1, 1, 1)
        TicketStatusFrameButton.hasBorder = true
    end
end)

    -- skin the LFD tooltip

LFDSearchStatus:HookScript('OnShow', function(self)
    LFDSearchStatus:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8', 
        insets = {
            left = 3, 
            right = 3, 
            top = 3, 
            bottom = 3
        }
    })

    LFDSearchStatus:SetBackdropColor(0, 0, 0, 0.5)

    if (not LFDSearchStatus.hasBorder) then
        CreateBorder(LFDSearchStatus, 12, 1, 1, 1)
        LFDSearchStatus.hasBorder = true
    end
end)

	-- NPCScan.Overlay uses this function to determine minimap shape
	-- http://www.wowinterface.com/downloads/info14686-_NPCScan.Overlay.html
	
if IsAddOnLoaded('_NPCScan.Overlay') then
	function GetMinimapShape()
		return 'SQUARE'
	end
end