
DEFAULT_CHATFRAME_ALPHA = 0.25 -- chatframe mouseover alpha

CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0     -- set to 0 if u want to hide the tabs when no mouse is over them or the chat
    
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.5
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0      -- set to 0 if u want to hide the tabs when no mouse is over them or the chat
    
CHAT_FRAME_FADE_OUT_TIME = 0.5
CHAT_FRAME_FADE_TIME = 0.1

CHAT_FONT_HEIGHTS = {
    [1] = 8,
    [2] = 9,
    [3] = 10,
    [4] = 11,
    [5] = 12,
    [6] = 13,
    [7] = 14,
    [8] = 15,
    [9] = 16,
    [10] = 17,
    [11] = 18,
    [12] = 19,
    [13] = 20,
}

CHAT_FLAG_AFK = '[AFK] '
CHAT_FLAG_DND = '[DND] '
CHAT_FLAG_GM = '[GM] '

CHAT_SAY_GET = '%s:\32'
CHAT_YELL_GET = '%s:\32'

CHAT_WHISPER_GET = '[from] %s:\32'
CHAT_WHISPER_INFORM_GET = '[to] %s:\32'

CHAT_BN_WHISPER_GET = "[from] %s:\32"
CHAT_BN_WHISPER_INFORM_GET = "[to] %s:\32"

CHAT_GUILD_GET = '[|Hchannel:Guild|hG|h] %s:\32'
CHAT_OFFICER_GET = '[|Hchannel:o|hO|h] %s:\32'

CHAT_PARTY_GET = '[|Hchannel:party|hP|h] %s:\32'
CHAT_PARTY_LEADER_GET = '[|Hchannel:party|hPL|h] %s:\32'
CHAT_PARTY_GUIDE_GET = '[|Hchannel:party|hDG|h] %s:\32'
CHAT_MONSTER_PARTY_GET = '[|Hchannel:raid|hR|h] %s:\32'

CHAT_RAID_GET = '[|Hchannel:raid|hR|h] %s:\32'
CHAT_RAID_WARNING_GET = '[RW!] %s:\32'
CHAT_RAID_LEADER_GET = '[|Hchannel:raid|hL|h] %s:\32'

CHAT_BATTLEGROUND_GET = '[|Hchannel:Battleground|hBG|h] %s:\32'
CHAT_BATTLEGROUND_LEADER_GET = '[|Hchannel:Battleground|hBL|h] %s:\32'

CHAT_YOU_CHANGED_NOTICE_BN = '# |Hchannel:%d|h%s|h'
CHAT_YOU_JOINED_NOTICE_BN = '+ |Hchannel:%d|h%s|h'
CHAT_YOU_LEFT_NOTICE_BN = '- |Hchannel:%d|h%s|h'
CHAT_SUSPENDED_NOTICE_BN = '- |Hchannel:%d|h%s|h'

ChatTypeInfo['CHANNEL'].sticky = 1
ChatTypeInfo['GUILD'].sticky = 1
ChatTypeInfo['OFFICER'].sticky = 1
ChatTypeInfo['PARTY'].sticky = 1
ChatTypeInfo['RAID'].sticky = 1
ChatTypeInfo['BATTLEGROUND'].sticky = 1
ChatTypeInfo['BATTLEGROUND_LEADER'].sticky = 1
ChatTypeInfo['WHISPER'].sticky = 0
ChatTypeInfo["BN_WHISPER"].sticky = 0

local AddMessage = ChatFrame1.AddMessage

function FCF_AddMessage(self, text, ...)
    if (type(text) == 'string') then
        -- bnet names-
        
        text = text:gsub('(|HBNplayer.-|h)%[(.-)%]|h', '%1%2|h')
        text = text:gsub('(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')
                
        text = text:gsub('%[(%d+)%. (.+)%].+(|Hplayer.+)', '[|Hchannel:channel|h%1|h] %3') 
    --  text = format('%s %s', date'%H:%M', text)  
    end
    return AddMessage(self, text, ...)
end

    -- modify the editbox

ChatFrame1EditBox:SetAltArrowKeyMode(false)
ChatFrame1EditBox:ClearAllPoints()
ChatFrame1EditBox:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 2, 33)
ChatFrame1EditBox:SetPoint('BOTTOMRIGHT', ChatFrame1, 'TOPRIGHT', 0, 33)
ChatFrame1EditBox:SetBackdrop({
    bgFile = 'Interface\\Buttons\\WHITE8x8',
    insets = { 
        left = 3, 
        right = 3, 
        top = 2, 
        bottom = 2 
    },
})
    
ChatFrame1EditBox:SetBackdropColor(0, 0, 0, 0.5)
    
for k = 6, 11 do
        select(k, ChatFrame1EditBox:GetRegions()):SetTexture(nil)
end
    
CreateBorder(ChatFrame1EditBox, 11, 1, 1, 1, -2, -1, -2, -1, -2, -1, -2, -1)

    -- hide the menu and friend button
    
FriendsMicroButton:SetAlpha(0)
FriendsMicroButton:EnableMouse(false)
FriendsMicroButton:UnregisterAllEvents()

ChatFrameMenuButton:SetAlpha(0)
ChatFrameMenuButton:EnableMouse(false)
    -- tab text colors for the tabs
   
hooksecurefunc('FCFTab_UpdateColors', function(self, selected)
	if (selected) then
		self:GetFontString():SetTextColor(0, 0.75, 1)
	else
		self:GetFontString():SetTextColor(1, 1, 1)
	end
end)

    -- improved mousewheel scrolling
    
hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, direction)
    if (direction > 0) then
        if (IsShiftKeyDown()) then
            self:ScrollToTop()
        else
            self:ScrollUp()
            self:ScrollUp()
        end
    elseif (direction < 0)  then
        if (IsShiftKeyDown()) then
            self:ScrollToBottom()
        else
            self:ScrollDown()
            self:ScrollDown()
        end
    end
end)

    -- reposition toast frame
BNToastFrame:HookScript("OnShow", function(self)
    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetPoint("TOPLEFT", ChatFrame1, 10, 90)
end)


    -- modify the tabs
    
function SkinTab(self)
    local chat = _G[self]
    
    local tabLeft = _G[self..'TabLeft']
    tabLeft:SetTexture(nil)
    
    local tabMiddle = _G[self..'TabMiddle']
    tabMiddle:SetTexture(nil)
    
    local tabRight = _G[self..'TabRight']
    tabRight:SetTexture(nil)
    
    local tabText = _G[self..'TabText']
    tabText:SetFont('Fonts\\ARIALN.ttf', 14, 'OUTLINE')
    tabText:SetShadowOffset(0, 0)   -- (1, -1)
    tabText:SetJustifyH('CENTER')
    tabText:SetWidth(60)
    -- tabText:SetTextColor(1, 1, 1)
    
    local a1, a2, a3, a4, a5 = tabText:GetPoint()
    tabText:SetPoint(a1, a2, a3, a4, 1)
    
    local tabSelLeft = _G[self..'TabSelectedLeft']
    tabSelLeft:SetTexture(nil)
    
    local tabSelMiddle = _G[self..'TabSelectedMiddle']
    tabSelMiddle:SetTexture(nil)
    
    local tabSelRight = _G[self..'TabSelectedRight']
    tabSelRight:SetTexture(nil)
        
    local tabHigLeft = _G[self..'TabHighlightLeft']
    tabHigLeft:SetTexture(nil)
    
    local tabHigMiddle = _G[self..'TabHighlightMiddle']
    tabHigMiddle:SetTexture(nil)
    
    local tabHigRight = _G[self..'TabHighlightRight']
    tabHigRight:SetTexture(nil)
    
    local tabGlow = _G[self..'TabGlow']
    tabGlow:SetTexture(nil)
    
    tabGlow.Show = function()
        tabText:SetTextColor(1, 0, 1, CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA)
    end
    
    tabGlow.Hide = function()
        tabText:SetTextColor(1, 1, 1)
    end
    
    local tab = _G[self..'Tab']
    tab:SetScript('OnEnter', function()
        local al = tabText:GetAlpha()
        tabText:SetTextColor(1, 0, 1, al)
    end)
    
    tab:SetScript('OnLeave', function()
        local r, g, b
        local hasNofication = tabGlow:IsShown()

        if (_G[self] == SELECTED_CHAT_FRAME) then
            r, g, b = 0, 0.75, 1
        elseif (hasNofication) then
            r, g, b = 1, 0, 1
        else
            r, g, b = 1, 1, 1
        end

        tabText:SetTextColor(r, g, b)
    end)
    
    chat.hasSkinnedTabs = true
end  

    -- modify the chat

local function ModChat(self)
    local chat = _G[self]
    chat:SetShadowOffset(1, -1)
    chat:SetClampedToScreen(false)
    
    chat:SetClampRectInsets(0, 0, 0, 0)
    chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    chat:SetMinResize(150, 25)
    
    if (i ~= 2) then
        chat.AddMessage = FCF_AddMessage
    end
    
    local buttonUp = _G[self..'ButtonFrameUpButton']
    buttonUp:SetAlpha(0)
    buttonUp:EnableMouse(false)
   
    local buttonDown = _G[self..'ButtonFrameDownButton']
    buttonDown:SetAlpha(0)
    buttonDown:EnableMouse(false)
  
    local buttonBottom = _G[self..'ButtonFrameBottomButton']
    buttonBottom:SetAlpha(0)
    buttonBottom:EnableMouse(false)

        -- hide some pesky textures

    for _, texture in pairs({
        'ButtonFrameBackground',
        'ButtonFrameTopLeftTexture',
        'ButtonFrameBottomLeftTexture',
        'ButtonFrameTopRightTexture',
        'ButtonFrameBottomRightTexture',
        'ButtonFrameLeftTexture',
        'ButtonFrameRightTexture',
        'ButtonFrameBottomTexture',
        'ButtonFrameTopTexture',
    }) do
		_G[self..texture]:SetTexture(nil)
	end
    
    chat.hasModification = true
end

    -- wtf?
    
local NEW_NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS + 1

hooksecurefunc('FCF_OpenTemporaryWindow', function()
	local chatFrame, chatTab, conversationIcon
	for _, chatFrameName in pairs(CHAT_FRAMES) do
		local frame = _G[chatFrameName]
		if (frame.isTemporary) then
			if (not frame.inUse and not frame.isDocked) then
				chatFrame = frame
				break
			end
		end
	end
	
	if (not chatFrame) then
		NEW_NUM_CHAT_WINDOWS = NEW_NUM_CHAT_WINDOWS + 1	
	end
end)
    
hooksecurefunc('FCF_OpenTemporaryWindow', function()
    for i = NUM_CHAT_WINDOWS, NEW_NUM_CHAT_WINDOWS do
        if (_G['ChatFrame'..i]) then
            if (_G['ChatFrame'..i]:IsShown()) then
                if (not _G['ChatFrame'..i].hasModification) then
                    ModChat('ChatFrame'..i)
                end
                
                if (not _G['ChatFrame'..i].hasSkinnedTabs) then
                    SkinTab('ChatFrame'..i)
                end
                
                -- local chatMinimize = _G['ChatFrame'..i..'ButtonFrameMinimizeButton']
                -- chatMinimize:ClearAllPoints()
                -- chatMinimize:SetPoint('TOPRIGHT', _G['ChatFrame'..i], 'TOPLEFT', -2, 0)
            
                local convButton = _G['ChatFrame'..i..'ConversationButton']
                if (convButton) then
                    convButton:SetAlpha(0)
                    convButton:EnableMouse(false)
                end
            end
        end
    end
    
    for i = NUM_CHAT_WINDOWS, NEW_NUM_CHAT_WINDOWS do
        local chat = _G['ChatFrame'..i]

        local chatMinimize = _G['ChatFrame'..i..'ButtonFrameMinimizeButton']
        if (chatMinimize) then
            chatMinimize:SetAlpha(0)
            chatMinimize:EnableMouse(0)
        end
    end
end)
    
    -- skin the normal chat windows
    
for i = 1, NUM_CHAT_WINDOWS do
    ModChat('ChatFrame'..i)
    SkinTab('ChatFrame'..i)
end

    -- new position for the minimize button (only chat frame 2 - 10)
    
for i = 2, NUM_CHAT_WINDOWS do
    local chat = _G['ChatFrame'..i]

    local chatMinimize = _G['ChatFrame'..i..'ButtonFrameMinimizeButton']
    chatMinimize:SetAlpha(0)
    chatMinimize:EnableMouse(0)
end

    -- modify the gm chatframe
    
local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(_, event)
    if (event == 'ADDON_LOADED' and arg1 == 'Blizzard_GMChatUI') then
        GMChatFrame:EnableMouseWheel(true)
        GMChatFrame:SetScript('OnMouseWheel', ChatFrame1:GetScript('OnMouseWheel'))
        GMChatFrame:SetHeight(200)
        
        GMChatFrameUpButton:SetAlpha(0)
        GMChatFrameUpButton:EnableMouse(false)
        
        GMChatFrameDownButton:SetAlpha(0)
        GMChatFrameDownButton:EnableMouse(false)
        
        GMChatFrameBottomButton:SetAlpha(0)
        GMChatFrameBottomButton:EnableMouse(false)
    end
end)

	-- play sound files system

local SoundSys = CreateFrame('Frame')
SoundSys:RegisterEvent('CHAT_MSG_WHISPER')
SoundSys:RegisterEvent('CHAT_MSG_BN_WHISPER')
SoundSys:HookScript('OnEvent', function(self, event, ...)
	if event == 'CHAT_MSG_WHISPER' or 'CHAT_MSG_BN_WHISPER' then
		PlaySoundFile('Sound\\Spells\\Simongame_visual_gametick.wav')
	end
end)