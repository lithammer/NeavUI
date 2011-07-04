    
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

    -- hide the tracking button

MiniMapTracking:UnregisterAllEvents()
MiniMapTracking:Hide()

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

function GetMinimapShape()
    return 'SQUARE'
end

Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

Minimap:CreateBeautyBorder(11)
Minimap:SetBeautyBorderPadding(1)

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
    self:CreateBeautyBorder(12)
end)

local function GetZoneColor()
	local zoneType = GetZonePVPInfo()
    
	if (zoneType == 'sanctuary') then
		return 0.4, 0.8, 0.94
	elseif (zoneType == 'arena') then
		return 1, 0.1, 0.1
	elseif (zoneType == 'friendly') then
		return 0.1, 1, 0.1
	elseif (zoneType == 'hostile') then
		return 1, 0.1, 0.1
	elseif (zoneType == 'contested') then
		return 1, 0.8, 0
	else
		return 1, 1, 1
	end
end

    -- mouseover zone text
    
local MainZone = Minimap:CreateFontString(nil, 'OVERLAY')
MainZone:SetParent(Minimap)
MainZone:SetFont('Fonts\\ARIALN.ttf', 16, 'THINOUTLINE')
MainZone:SetPoint('TOP', Minimap, 0, -22)
MainZone:SetTextColor(1, 1, 1)
MainZone:SetAlpha(0)
MainZone:SetSize(130, 32)
MainZone:SetJustifyV('BOTTOM')

local SubZone = Minimap:CreateFontString(nil, 'OVERLAY')
SubZone:SetParent(Minimap)
SubZone:SetFont('Fonts\\ARIALN.ttf', 13, 'THINOUTLINE')
SubZone:SetPoint('TOP', MainZone, 'BOTTOM', 0, -1)
SubZone:SetTextColor(1, 1, 1)
SubZone:SetAlpha(0)
SubZone:SetSize(130, 26)
SubZone:SetJustifyV('TOP')

Minimap:HookScript('OnEnter', function()

        -- disable the mouseover if the shift key is pressed, in cases we want to make a ping and the text is annoying
        
    if (nMinimap.showMouseoverZoneText and SubZone and not IsShiftKeyDown()) then
        SubZone:SetTextColor(GetZoneColor())
        SubZone:SetText(GetSubZoneText())
        securecall('UIFrameFadeIn', SubZone, 0.235, SubZone:GetAlpha(), nMinimap.alphaMouseoverZoneText)
        
        MainZone:SetTextColor(GetZoneColor())
        MainZone:SetText(GetRealZoneText())
        securecall('UIFrameFadeIn', MainZone, 0.235, MainZone:GetAlpha(), nMinimap.alphaMouseoverZoneText)
   end
end)

Minimap:HookScript('OnLeave', function()
    if (nMinimap.showMouseoverZoneText and SubZone) then
        securecall('UIFrameFadeOut', SubZone, 0.235, SubZone:GetAlpha(), 0)
        securecall('UIFrameFadeOut', MainZone, 0.235, MainZone:GetAlpha(), 0)
    end
end)

-- Used by some addons that manipulate the minimap to determine the shape, e.g. MiniBlobs and NPCScan.Overlay
-- http://www.wowpedia.org/GetMinimapShape
function GetMinimapShape()
	return 'SQUARE'
end
