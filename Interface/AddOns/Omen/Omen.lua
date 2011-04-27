-----------------------------------------------------------------------------
-- Addon declaration
local Omen = LibStub("AceAddon-3.0"):NewAddon("Omen", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Omen", false)
local LSM = LibStub("LibSharedMedia-3.0")
local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)
Omen.version = GetAddOnMetadata("Omen", "Version")
Omen.versionstring = "Omen v"..GetAddOnMetadata("Omen", "Version")
_G["Omen"] = Omen


-----------------------------------------------------------------------------
-- Keybinding globals
BINDING_HEADER_OMEN = Omen.versionstring
BINDING_NAME_OMENTOGGLE = L["Toggle Omen"]
BINDING_NAME_OMENTOGGLEFOCUS = L["Toggle Focus"]


-----------------------------------------------------------------------------
-- Register some media
LSM:Register("sound", "Rubber Ducky", [[Sound\Doodad\Goblin_Lottery_Open01.wav]])
LSM:Register("sound", "Cartoon FX", [[Sound\Doodad\Goblin_Lottery_Open03.wav]])
LSM:Register("sound", "Explosion", [[Sound\Doodad\Hellfire_Raid_FX_Explosion05.wav]])
LSM:Register("sound", "Shing!", [[Sound\Doodad\PortcullisActive_Closed.wav]])
LSM:Register("sound", "Wham!", [[Sound\Doodad\PVP_Lordaeron_Door_Open.wav]])
LSM:Register("sound", "Simon Chime", [[Sound\Doodad\SimonGame_LargeBlueTree.wav]])
LSM:Register("sound", "War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.wav]])
LSM:Register("sound", "Cheer", [[Sound\Event Sounds\OgreEventCheerUnique.wav]])
LSM:Register("sound", "Humm", [[Sound\Spells\SimonGame_Visual_GameStart.wav]])
LSM:Register("sound", "Short Circuit", [[Sound\Spells\SimonGame_Visual_BadPress.wav]])
LSM:Register("sound", "Fel Portal", [[Sound\Spells\Sunwell_Fel_PortalStand.wav]])
LSM:Register("sound", "Fel Nova", [[Sound\Spells\SeepingGaseous_Fel_Nova.wav]])
LSM:Register("sound", "You Will Die!", [[Sound\Creature\CThun\CThunYouWillDIe.wav]])
LSM:Register("sound", "Omen: Aoogah!", [[Interface\AddOns\Omen\aoogah.ogg]])


-----------------------------------------------------------------------------
-- Localize some global functions
local floor, format, random, pairs, type = floor, format, random, pairs, type
local tinsert, tremove, next, sort, wipe = tinsert, tremove, next, sort, wipe
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitExists, UnitGUID, UnitName, UnitClass, UnitHealth = UnitExists, UnitGUID, UnitName, UnitClass, UnitHealth
local UnitIsPlayer, UnitPlayerControlled, UnitCanAttack = UnitIsPlayer, UnitPlayerControlled, UnitCanAttack
local GetNumRaidMembers, GetNumPartyMembers = GetNumRaidMembers, GetNumPartyMembers


-----------------------------------------------------------------------------
-- Local variables used
local db
local defaults = {
	profile = {
		Alpha        = 1,
		Scale        = 1,
		GrowUp       = false,
		Autocollapse = false,
		NumBars      = 10,
		CollapseHide = false,
		Locked       = false,
		PositionW    = 200,
		PositionH    = 82,
		VGrip1       = 85,
		VGrip2       = 115,
		UseFocus     = false,
		IgnorePlayerPets = true,
		FrameStrata = "3-MEDIUM",
		ClampToScreen = true,
		ClickThrough = false,
		Background = {
			Texture = "Blizzard Parchment",
			BorderTexture = "Blizzard Dialog",
			Color = {r = 1, g = 1, b = 1, a = 1,},
			BorderColor = {r = 0.8, g = 0.6, b = 0, a = 1,},
			Tile = false,
			TileSize = 32,
			EdgeSize = 8,
			BarInset = 3,
		},
		TitleBar = {
			Height = 16,
			Font = "Friz Quadrata TT",
			FontOutline = "",
			FontColor = {r = 1, g = 1, b = 1, a = 1,},
			FontSize = 10,
			ShowTitleBar = true,
			UseSameBG = true,
			Texture = "Blizzard Parchment",
			BorderTexture = "Blizzard Dialog",
			Color = {r = 1, g = 1, b = 1, a = 1,},
			BorderColor = {r = 0.8, g = 0.6, b = 0, a = 1,},
			Tile = false,
			TileSize = 32,
			EdgeSize = 8,
		},
		Bar = {
			Texture = "Blizzard",
			Height = 12,
			Spacing = 0,
			AnimateBars  = true,
			ShortNumbers = true,
			Font = "Friz Quadrata TT",
			FontOutline = "",
			FontColor = {r = 1, g = 1, b = 1, a = 1,},
			FontSize = 10,
			Classes = {
				DEATHKNIGHT = true,
				DRUID = true,
				HUNTER = true,
				MAGE = true,
				PALADIN = true,
				PET = true,
				PRIEST = true,
				ROGUE = true,
				SHAMAN = true,
				WARLOCK = true,
				WARRIOR = true,
				["*NOTINPARTY*"] = true,
			},
			ShowTPS = true,
			TPSWindow = 10,
			ShowHeadings = true,
			HeadingBGColor = {r = 0, g = 0, b = 0, a = 0,},
			UseMyBarColor = false,
			MyBarColor = {r = 1, g = 0, b = 0, a = 1,},
			ShowPercent = true,
			ShowValue = true,
			UseClassColors = true,
			BarColor = {r = 1, g = 0, b = 0, a = 1,},
			UseTankBarColor = false,
			TankBarColor = {r = 1, g = 0, b = 0, a = 1,},
			AlwaysShowSelf = true,
			ShowAggroBar = true,
			AggroBarColor = {r = 1, g = 0, b = 0, a = 1,},
			PetBarColor = {r = 0.77, g = 0, b = 1, a = 1},
			FadeBarColor = {r = 0.5, g = 0.5, b = 0.5, a = 1},
			UseCustomClassColors = true,
			InvertColors = false,
		},
		ShowWith = {
			UseShowWith = true,
			Pet = true,
			Alone = false,
			Party = true,
			Raid = true,
			-- Deprecated SV values
			-- Resting = false, PVP = false, Dungeon = true, ShowOnlyInCombat = false,
			HideWhileResting = true,
			HideInPVP = true,
			HideWhenOOC = false,
		},
		FuBar = {
			HideMinimapButton = true,
			AttachMinimap = false,
		},
		Warnings = {
			Sound = true,
			Flash = true,
			Shake = false,
			Message = false,
			SinkOptions = {},
			Threshold = 90,
			SoundFile = "Fel Nova",
			DisableWhileTanking = true,
		},
		MinimapIcon = {
			hide = false,
			minimapPos = 220,
			radius = 80,
		},
	},
}
local guidNameLookup = {}   -- Format: guidNameLookup[guid] = "Unit Name"
local guidClassLookup = {}  -- Format: guidClassLookup[guid] = "CLASS"
local timers = {}           -- Format: timers.timerName = timer returned from AceTimer-3.0
local bars = {}             -- Format: bars[i] = frame containing the i-th bar from the top of Omen
local inRaid, inParty       -- boolean variables indicating if the player is in a raid and/or party
local testMode = false      -- boolean: Are we in test mode?
local manualToggle = false  -- boolean: Did we manually toggle Omen?
local moduleOptions = {}    -- Table for LoD module options registration

Omen.GuidNameLookup = guidNameLookup
Omen.GuidClassLookup = guidClassLookup
Omen.Timers = timers
Omen.Bars = bars
setmetatable(guidNameLookup, {__index = function(self, guid) return L["<Unknown>"] end})

-- For speedups. Rather than concantenating every time we need a unitID, we just look
-- it up instead. That is rID[i] is much faster than format("raid%d", i) or "raid"..i
local pID = {}
local ptID = {}
local ppID = {}
local pptID = {}
local rID = {}
local rtID = {}
local rpID = {}
local rptID = {}
for i = 1, 4 do
	pID[i] = format("party%d", i)
	ptID[i] = format("party%dtarget", i)
	ppID[i] = format("partypet%d", i)
	pptID[i] = format("partypet%dtarget", i)
end
for i = 1, 40 do
	rID[i] = format("raid%d", i)
	rtID[i] = format("raid%dtarget", i)
	rpID[i] = format("raidpet%d", i)
	rptID[i] = format("raidpet%dtarget", i)
end
local showClassesOptionTable = {
	DEATHKNIGHT = L["DEATHKNIGHT"],
	DRUID = L["DRUID"],
	HUNTER = L["HUNTER"],
	MAGE = L["MAGE"],
	PALADIN = L["PALADIN"],
	PET = L["PET"],
	PRIEST = L["PRIEST"],
	ROGUE = L["ROGUE"],
	SHAMAN = L["SHAMAN"],
	WARLOCK = L["WARLOCK"],
	WARRIOR = L["WARRIOR"],
	["*NOTINPARTY*"] = L["*Not in Party*"],
}


----------------------------------------------------------------------------------------
-- Use a common frame and setup some common functions for the Omen dropdown menus
local Omen_DropDownMenu = CreateFrame("Frame", "Omen_DropDownMenu")
Omen_DropDownMenu.displayMode = "MENU"
Omen_DropDownMenu.info = {}
Omen_DropDownMenu.HideMenu = function()
	if UIDROPDOWNMENU_OPEN_MENU == Omen_DropDownMenu then
		CloseDropDownMenus()
	end
end
Omen_DropDownMenu.OnClick = function(frame, button, down)
	if Omen_DropDownMenu.initialize ~= frame.initMenuFunc then
		CloseDropDownMenus()
		Omen_DropDownMenu.initialize = frame.initMenuFunc
	end
	ToggleDropDownMenu(1, nil, Omen_DropDownMenu, frame, 0, 0)
end


-----------------------------------------------------------------------------
-- Table Pool for recycling tables
local tablePool = {}
setmetatable(tablePool, {__mode = "kv"}) -- Weak table

-- Get a new table
local function newTable()
	local t = next(tablePool) or {}
	tablePool[t] = nil
	return t
end

-- Delete table and return to pool -- Recursive!! -- Use with care!!
local function delTable(t)
	if type(t) == "table" then
		for k, v in pairs(t) do
			if type(v) == "table" then
				delTable(v) -- child tables get put into the pool
			end
			t[k] = nil
		end
		t[true] = true -- resize table to 1 item
		t[true] = nil
		setmetatable(t, nil)
		tablePool[t] = true
	end
	return nil -- return nil to assign input reference
end


-----------------------------------------------------------------------------
-- Omen initialization and frame functions

local function startmoving(self)
	if not db.Locked then
		Omen.Anchor.IsMovingOrSizing = 1
		Omen.Anchor:StartMoving()
	end
end
local function stopmoving(self)
	if Omen.Anchor.IsMovingOrSizing then
		Omen.Anchor:StopMovingOrSizing()
		Omen:SetAnchors()
		Omen:UpdateBars()
		Omen.Anchor.IsMovingOrSizing = nil
	end
	if self == Omen.Anchor then db.Shown = self:IsShown() end
end
local function sizing(self)
	local w = Omen.Anchor:GetWidth()
	db.VGrip1 = w * Omen.Anchor.VGrip1Ratio
	db.VGrip2 = w * Omen.Anchor.VGrip2Ratio
	if db.VGrip1 < 10 then db.VGrip1 = 10 end
	if db.VGrip1 > w - 10 then db.VGrip1 = w - 10 end
	if db.Bar.ShowTPS then
		if db.VGrip2 < db.VGrip1 + 10 then db.VGrip2 = db.VGrip1 + 10 end
		if db.VGrip1 > w - 20 then
			db.VGrip1 = w - 20
			db.VGrip2 = w - 10
		end
		Omen.VGrip2:ClearAllPoints()
		Omen.VGrip2:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip2, 0)
		Omen.VGrip2:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip2, 0)
	end
	Omen.VGrip1:ClearAllPoints()
	Omen.VGrip1:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip1, 0)
	Omen.VGrip1:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip1, 0)
	Omen:ResizeBars()
	Omen:ReAnchorLabels()
	Omen:UpdateBars()
end
local function movegrip1(self)
	local x = GetCursorPosition() / UIParent:GetEffectiveScale() / Omen.Anchor:GetScale()
	local x1 = Omen.Anchor:GetLeft() + 10
	local x2 = db.Bar.ShowTPS and Omen.Anchor:GetLeft() + db.VGrip2 - 10 or Omen.Anchor:GetRight() - 10
	if x > x1 and x < x2 then
		db.VGrip1 = x - x1 + 10
		Omen.VGrip1:ClearAllPoints()
		Omen.VGrip1:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip1, 0)
		Omen.VGrip1:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip1, 0)
	end
	Omen:ReAnchorLabels()
end
local function movegrip2(self)
	local x = GetCursorPosition() / UIParent:GetEffectiveScale() / Omen.Anchor:GetScale()
	local x1 = Omen.Anchor:GetLeft() + db.VGrip1 + 10
	local x2 = Omen.Anchor:GetRight() - 10
	if x > x1 and x < x2 then
		db.VGrip2 = x - x1 + db.VGrip1 + 10
		Omen.VGrip2:ClearAllPoints()
		Omen.VGrip2:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip2, 0)
		Omen.VGrip2:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip2, 0)
	end
	Omen:ReAnchorLabels()
end

function Omen:CreateFrames()
	-- Create anchor
	self.Anchor = CreateFrame("Frame", "OmenAnchor", UIParent)
	self.Anchor:SetResizable(true)
	self.Anchor:SetMinResize(90, db.Background.EdgeSize * 2)
	self.Anchor:SetMovable(true)
	self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.Anchor:SetWidth(225)
	self.Anchor:SetHeight(150)
	self.Anchor:SetScript("OnHide", stopmoving)
	self.Anchor:SetScript("OnShow", function(self) db.Shown = true Omen:UpdateBars() end)

	-- Create Title
	self.Title = CreateFrame("Button", "OmenTitle", self.Anchor)
	self.Title:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
	self.Title:SetPoint("TOPRIGHT", self.Anchor, "TOPRIGHT")
	self.Title:SetHeight(16)
	self.Title:SetMinResize(90, db.Background.EdgeSize * 2)
	self.Title:EnableMouse(true)
	self.Title:SetScript("OnMouseDown", startmoving)
	self.Title:SetScript("OnMouseUp", stopmoving)
	self.Title:SetScript("OnClick", Omen_DropDownMenu.OnClick)
	self.Title.initMenuFunc = self.TitleQuickMenu
	self.Title:RegisterForClicks("RightButtonUp")

	-- Create Title text
	self.TitleText = self.Title:CreateFontString(nil, nil, "GameFontNormal")
	self.TitleText:SetPoint("LEFT", self.Title, "LEFT", 8, 1)
	self.TitleText:SetJustifyH("LEFT")
	self.TitleText:SetTextColor(1, 1, 1, 1)
	self.defaultTitle = "Omen|cffffcc003|r"
	self.TitleText:SetText(self.defaultTitle)

	-- Create Bar List
	self.BarList = CreateFrame("Frame", "OmenBarList", self.Anchor)
	self.BarList:SetResizable(true)
	self.BarList:EnableMouse(true)
	self.BarList:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT")
	self.BarList:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")
	self.BarList:SetScript("OnMouseDown", startmoving)
	self.BarList:SetScript("OnMouseUp", stopmoving)
	self.BarList:SetScript("OnHide", stopmoving)
	self.BarList.barsShown = 0

	-- Create resizing corner grip
	self.Grip = CreateFrame("Button", "OmenResizeGrip", self.BarList)
	self.Grip:SetNormalTexture("Interface\\AddOns\\Omen\\ResizeGrip")
	self.Grip:SetHighlightTexture("Interface\\AddOns\\Omen\\ResizeGrip")
	self.Grip:SetWidth(16)
	self.Grip:SetHeight(16)
	self.Grip:SetPoint("BOTTOMRIGHT", self.BarList, "BOTTOMRIGHT", 0, 1)
	self.Grip:SetScript("OnMouseDown", function(self, button)
		if not db.Locked then
			Omen.Anchor.IsMovingOrSizing = 2
			Omen.Anchor.VGrip1Ratio = db.VGrip1 / Omen.Anchor:GetWidth()
			Omen.Anchor.VGrip2Ratio = db.VGrip2 / Omen.Anchor:GetWidth()
			Omen.Anchor:SetScript("OnSizeChanged", sizing)
			Omen.Anchor:StartSizing()
		end
	end)
	self.Grip:SetScript("OnMouseUp", function(self)
		if Omen.Anchor.IsMovingOrSizing == 2 then
			Omen.Anchor:SetScript("OnSizeChanged", nil)
			Omen.Anchor:StopMovingOrSizing()
			sizing()
			Omen:SetAnchors()
			Omen.Anchor.IsMovingOrSizing = nil
			Omen.Anchor.VGrip1Ratio = nil
		end
	end)
	self.Grip:SetScript("OnHide", self.Grip:GetScript("OnMouseUp"))

	-- Create label resizing vertical grip 1
	self.VGrip1 = CreateFrame("Button", "OmenVResizeGrip1", self.BarList)
	self.VGrip1:SetWidth(1)
	self.VGrip1:SetPoint("TOPLEFT", self.BarList, "TOPLEFT", db.VGrip1, 0)
	self.VGrip1:SetPoint("BOTTOMLEFT", self.BarList, "BOTTOMLEFT", db.VGrip1, 0)
	self.VGrip1:SetNormalTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	self.VGrip1:SetHighlightTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	self.VGrip1:GetNormalTexture():SetVertexColor(1, 1, 1, 0.5)
	self.VGrip1:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.5)
	self.VGrip1:SetScript("OnMouseDown", function(self)
		if not db.Locked then self:SetScript("OnUpdate", movegrip1) end
	end)
	self.VGrip1:SetScript("OnMouseUp", function(self) self:SetScript("OnUpdate", nil) end)
	self.VGrip1:SetScript("OnHide", self.VGrip1:GetScript("OnMouseUp"))
	self.VGrip1:SetFrameLevel(self.BarList:GetFrameLevel() + 2)

	-- Create label resizing vertical grip 2
	self.VGrip2 = CreateFrame("Button", "OmenVResizeGrip2", self.BarList)
	self.VGrip2:SetWidth(1)
	self.VGrip2:SetPoint("TOPLEFT", self.BarList, "TOPLEFT", db.VGrip2, 0)
	self.VGrip2:SetPoint("BOTTOMLEFT", self.BarList, "BOTTOMLEFT", db.VGrip2, 0)
	self.VGrip2:SetNormalTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	self.VGrip2:SetHighlightTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	self.VGrip2:GetNormalTexture():SetVertexColor(1, 1, 1, 0.5)
	self.VGrip2:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.5)
	self.VGrip2:SetScript("OnMouseDown", function(self)
		if not db.Locked then self:SetScript("OnUpdate", movegrip2) end
	end)
	self.VGrip2:SetScript("OnMouseUp", self.VGrip1:GetScript("OnMouseUp"))
	self.VGrip2:SetScript("OnHide", self.VGrip1:GetScript("OnMouseUp"))
	self.VGrip2:SetFrameLevel(self.BarList:GetFrameLevel() + 2)

	--[[self.FocusButton = CreateFrame("Button", "OmenFocusButton", self.Title, "OptionsButtonTemplate")
	self.FocusButton:SetWidth(16)
	self.FocusButton:SetHeight(16)
	self.FocusButton:SetPoint("TOPRIGHT")
	self.FocusButton:SetText("F")
	self.FocusButton:SetScript("OnClick", function(self, button, down)
		db.UseFocus = not db.UseFocus
		if db.UseFocus then
			self:GetFontString():SetTextColor(1, 0.82, 0, 1)
		else
			self:GetFontString():SetTextColor(0.5, 0.5, 0.5, 1)
		end
		Omen:UpdateBars()
	end)
	if db.UseFocus then
		self.FocusButton:GetFontString():SetTextColor(1, 0.82, 0, 1)
	else
		self.FocusButton:GetFontString():SetTextColor(0.5, 0.5, 0.5, 1)
	end]]

	self.CreateFrames = nil
end

function Omen:OnInitialize()
	-- Create savedvariables
	self.db = LibStub("AceDB-3.0"):New("Omen3DB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	self:SetSinkStorage(db.Warnings.SinkOptions)

	LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateUsedMedia")

	-- These 2 functions self GC after running
	self:CreateFrames()
	self:SetupOptions()

	self:RegisterEvent("PLAYER_LOGIN")
	self.OnInitialize = nil
end

function Omen:PLAYER_LOGIN()
	-- We set up anchors here because we only want to do it once on
	-- PLAYER_LOGIN, hence we don't do it in OnEnable() which triggers on
	-- the same event as well as on every subsequent Enable()/Disable() calls.
	-- It cannot be earlier than PLAYER_LOGIN because layout-cache.txt
	-- is loaded just before this event fires.
	self:SetAnchors(true)
	self.Anchor:SetAlpha(db.Alpha)
	self.Anchor:SetFrameStrata(strsub(db.FrameStrata, 3))
	self.Anchor:SetClampedToScreen(db.ClampToScreen)
	self:UpdateBackdrop()
	self:UpdateTitleBar()
	self:UpdateGrips()
	self:UpdateClickThrough()
	self:UpdateRaidClassColors()
	self:ClearAll()
	self:UnregisterEvent("PLAYER_LOGIN")
	if not db.Shown then self.Anchor:Hide() end -- Auto-show/hide will override this later if enabled

	-- Optional !ClassColors addon support
	if CUSTOM_CLASS_COLORS then
		CUSTOM_CLASS_COLORS:RegisterCallback("UpdateBars", self)
	end

	-- ConfigMode support
	do
		CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
		local oldTestMode = testMode
		local oldLocked = db.Locked
		function CONFIGMODE_CALLBACKS.Omen(action)
			if action == "ON" then
				oldTestMode = testMode
				oldLocked = db.Locked
				testMode = true
				db.Locked = false
				Omen:Toggle(true)
			elseif action == "OFF" then
				testMode = oldTestMode
				db.Locked = oldLocked
				manualToggle = false
				Omen:UpdateVisible()
			end
			Omen:UpdateGrips()
			Omen:UpdateBars()
			LibStub("AceConfigRegistry-3.0"):NotifyChange("Omen")
		end
	end

	-- LDB launcher
	if LDB then
		OmenLauncher = LDB:NewDataObject("Omen", {
			type = "launcher",
			icon = "Interface\\AddOns\\Omen\\icon",
			OnClick = function(clickedframe, button)
				if button == "RightButton" then Omen:ShowConfig() else Omen:Toggle() end
			end,
			OnTooltipShow = function(tt)
				tt:AddLine(self.defaultTitle)
				tt:AddLine("|cffffff00" .. L["Click|r to toggle the Omen window"])
				tt:AddLine("|cffffff00" .. L["Right-click|r to open the options menu"])
			end,
		})
		if LDBIcon and not IsAddOnLoaded("Broker2FuBar") and not IsAddOnLoaded("FuBar") then
			LDBIcon:Register("Omen", OmenLauncher, db.MinimapIcon)
		end
	end

	-- Optional launcher support for LFBP-3.0 if present, this code is placed here so
	-- that it runs after all other addons have loaded since we don't embed LFBP-3.0
	-- Yes, this is one big hack since LFBP-3.0 is a Rock library, and we embed it
	-- via Ace3. OnEmbedInitialize() needs to be called manually.
	if LibStub:GetLibrary("LibFuBarPlugin-3.0", true) and not IsAddOnLoaded("FuBar2Broker") then
		local LFBP = LibStub:GetLibrary("LibFuBarPlugin-3.0")
		LibStub("AceAddon-3.0"):EmbedLibrary(self, "LibFuBarPlugin-3.0")
		self:SetFuBarOption("tooltipType", "GameTooltip")
		self:SetFuBarOption("hasNoColor", true)
		self:SetFuBarOption("cannotDetachTooltip", true)
		self:SetFuBarOption("hideWithoutStandby", true)
		self:SetFuBarOption("iconPath", [[Interface\AddOns\Omen\icon]])
		self:SetFuBarOption("hasIcon", true)
		self:SetFuBarOption("defaultPosition", "RIGHT")
		self:SetFuBarOption("tooltipHiddenWhenEmpty", true)
		self:SetFuBarOption("configType", "None")
		LFBP:OnEmbedInitialize(self)
		function Omen:OnUpdateFuBarTooltip()
			GameTooltip:AddLine(self.defaultTitle)
			GameTooltip:AddLine("|cffffff00" .. L["Click|r to toggle the Omen window"])
			GameTooltip:AddLine("|cffffff00" .. L["Right-click|r to open the options menu"])
		end
		function Omen:OnFuBarClick(button)
			if button == "RightButton" then self:ShowConfig() else self:Toggle() end
		end
		self.optionsFrames["FuBar"] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Omen", L["FuBar Options"], self.versionstring, "FuBar")
		self:UpdateFuBarSettings()
	end

	self.PLAYER_LOGIN = nil
end

function Omen:OnEnable()
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")

	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("UNIT_PET", "PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("UNIT_NAME_UPDATE", "PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("PLAYER_PET_CHANGED", "PARTY_MEMBERS_CHANGED")
	--self:RegisterEvent("RAID_ROSTER_UPDATE", "PARTY_MEMBERS_CHANGED") -- Is this needed?

	self:RegisterEvent("PLAYER_UPDATE_RESTING", "UpdateVisible")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	CreateBorder(OmenBarList, 12, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2)

	if db.ShowWith.HideWhenOOC then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateVisible")
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateVisible")
	end
	if db.UseFocus then
		self:RegisterEvent("UNIT_TARGET")
	end

	self:PARTY_MEMBERS_CHANGED()
	self:PLAYER_TARGET_CHANGED()
end

function Omen:OnDisable()
	-- Cancel all timers (well at least nil them all
	-- out in timers[], since AceTimer-3.0 cancels
	-- them all OnDisable anyway).
	for k, v in pairs(timers) do
		self:CancelTimer(v, true)
		timers[k] = nil
	end

	self:_toggle(false)
end

function Omen:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
	self:SetAnchors(true)
	self.Anchor:SetAlpha(db.Alpha)
	self.Anchor:SetFrameStrata(strsub(db.FrameStrata, 3))
	self.Anchor:SetClampedToScreen(db.ClampToScreen)
	self:UpdateBackdrop()
	self:UpdateTitleBar()
	self:UpdateGrips()
	self:ResizeBars()
	self:ReAnchorBars()
	self:ReAnchorLabels()
	self:UpdateBarLabelSettings()
	self:UpdateBarTextureSettings()
	self:UpdateClickThrough()
	self:UpdateRaidClassColors()
	self:UpdateFuBarSettings()
	-- These remainder settings were not placed in functions
	-- and were just updated directly from the config code.
	if LDBIcon and not IsAddOnLoaded("Broker2FuBar") and not IsAddOnLoaded("FuBar") then
		LDBIcon:Refresh("Omen", db.MinimapIcon)
	end
	if db.ShowWith.HideWhenOOC then
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateVisible")
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateVisible")
	else
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
	if db.UseFocus then
		self:RegisterEvent("UNIT_TARGET")
	else
		self:UnregisterEvent("UNIT_TARGET")
	end
	local f = self.TPSUpdateFrame
	if f then
		if db.Bar.ShowTPS then f:Show() else f:Hide() end
	end
	if db.Bar.ShowValue and db.Bar.ShowPercent then
		bars[0].Text2:SetText(L["Threat [%]"])
	else
		bars[0].Text2:SetText(L["Threat"])
	end

	self:UpdateVisible()
	self:UpdateBars()
end

function Omen:UpdateUsedMedia(event, mediatype, key)
	if mediatype == "statusbar" then
		if key == db.Bar.Texture then self:UpdateBarTextureSettings() end
	elseif mediatype == "font" then
		if key == db.TitleBar.Font then self:UpdateTitleBar() end
		if key == db.Bar.Font then self:UpdateBarLabelSettings() self:UpdateBars() end
	elseif mediatype == "background" then
		if key == db.Background.Texture then self:UpdateBackdrop() end
	elseif mediatype == "border" then
		if key == db.Background.BorderTexture then self:UpdateBackdrop() end
	--elseif mediatype == "sound" then
		-- Do nothing
	end
end

function Omen:SetAnchors(useDB)
	local x, y, w, h

	-- Set the scale, since the scaling affects the position
	self.Anchor:SetScale(db.Scale)
	self.VGrip1:SetWidth(1 / self.VGrip1:GetEffectiveScale())
	self.VGrip2:SetWidth(1 / self.VGrip2:GetEffectiveScale())

	-- Get position
	if useDB then
		x, y = db.PositionX, db.PositionY
		if not x or not y then
			self.Anchor:ClearAllPoints()
			self.Anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
			x, y = self.Anchor:GetLeft(), db.GrowUp and self.Anchor:GetBottom() or self.Anchor:GetTop()
		end
	else
		x, y = self.Anchor:GetLeft(), db.GrowUp and self.Anchor:GetBottom() or self.Anchor:GetTop()
	end

	-- Get width/height
	w = useDB and db.PositionW or self.Anchor:GetWidth()
	h = useDB and db.PositionH or self.Anchor:GetHeight()

	-- Set the anchors and size
	self.Anchor:ClearAllPoints()
	self.Anchor:SetPoint(db.GrowUp and "BOTTOMLEFT" or "TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
	self.Anchor:SetWidth(w)
	self.Anchor:SetHeight(h)
	self.Anchor:SetUserPlaced(nil)

	-- Save the data
	db.PositionX, db.PositionY = x, y
	db.PositionW, db.PositionH = w, h
end

-- For public use
function Omen:Toggle(setting)
	-- Don't set the manualToggle flag if "Hide Omen on 0 bars" option is active
	if not (db.Autocollapse and db.CollapseHide) then
		manualToggle = true
	end
	return self:_toggle(setting)
end

-- For internal use
function Omen:_toggle(setting)
	if setting == nil then
		setting = not self.Anchor:IsShown()
	end
	if setting then
		self.Anchor:Show()
	else
		self.Anchor:Hide()
	end
end

function Omen:UpdateVisible(event)
	local t = db.ShowWith
	if not t.UseShowWith or manualToggle then return end

	-- Hide if HideWhenOOC option is on, we're not in combat, and the triggering event is not
	-- "PLAYER_REGEN_DISABLED" (we're out of combat during this event just before entering combat)
	if t.HideWhenOOC and not InCombatLockdown() and event ~= "PLAYER_REGEN_DISABLED" then
		self:_toggle(false)
		return
	end

	-- Check for pet|party|raid|alone
	local show = (t.Pet and UnitExists("pet")) or
		(t.Party and inParty) or
		(t.Raid and inRaid) or
		(t.Alone and not inParty and not inRaid and not UnitExists("pet"))

	-- Then hide override if necessary for resting|pvp
	local inInstance, instanceType = IsInInstance()
	if (t.HideWhileResting and IsResting()) or (t.HideInPVP and (instanceType == "pvp" or instanceType == "arena")) then
		show = false
	end

	-- Hide if Autocollapse and Hide Omen on 0 Bars are both active and there are 0 bars.
	if db.Autocollapse and db.CollapseHide and self.BarList.barsShown == 0 then
		show = false
	end

	self:_toggle(show)
end

local bgFrame = {insets = {}}
function Omen:UpdateBackdrop()
	bgFrame.bgFile = LSM:Fetch("background", db.Background.Texture)
	bgFrame.edgeFile = LSM:Fetch("border", db.Background.BorderTexture)
	bgFrame.tile = db.Background.Tile
	bgFrame.tileSize = db.Background.TileSize
	bgFrame.edgeSize = db.Background.EdgeSize
	local inset = floor(db.Background.EdgeSize / 4)
	bgFrame.insets.left = inset
	bgFrame.insets.right = inset
	bgFrame.insets.top = inset
	bgFrame.insets.bottom = inset
	self.BarList:SetBackdrop(bgFrame)
	if not db.TitleBar.UseSameBG then
		bgFrame.bgFile = LSM:Fetch("background", db.TitleBar.Texture)
		bgFrame.edgeFile = LSM:Fetch("border", db.TitleBar.BorderTexture)
		bgFrame.tile = db.TitleBar.Tile
		bgFrame.tileSize = db.TitleBar.TileSize
		bgFrame.edgeSize = db.TitleBar.EdgeSize
		local inset = floor(db.TitleBar.EdgeSize / 4)
		bgFrame.insets.left = inset
		bgFrame.insets.right = inset
		bgFrame.insets.top = inset
		bgFrame.insets.bottom = inset

	end
	self.Title:SetBackdrop(bgFrame)

	local c = db.Background.Color
	self.BarList:SetBackdropColor(c.r, c.g, c.b, c.a)
	if not db.TitleBar.UseSameBG then c = db.TitleBar.Color end
	self.Title:SetBackdropColor(c.r, c.g, c.b, c.a)

	c = db.Background.BorderColor
	self.BarList:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
	if not db.TitleBar.UseSameBG then c = db.TitleBar.BorderColor end
	self.Title:SetBackdropBorderColor(c.r, c.g, c.b, c.a)

	local h = db.Background.EdgeSize * 2
	if not db.TitleBar.UseSameBG then h = db.TitleBar.EdgeSize * 2 end
	self.Anchor:SetMinResize(90, h)
	self.Title:SetMinResize(90, h)
	if not db.TitleBar.ShowTitleBar then
		self.Title:SetHeight(1e-6) -- See comment in Omen:UpdateTitleBar()
	elseif h > db.TitleBar.Height then
		self.Title:SetHeight(h)
	else
		self.Title:SetHeight(db.TitleBar.Height)
	end
	if self.Options then
		self.Options.args.TitleBar.args.Height.min = h
	end

	--self.FocusButton:SetPoint("TOPRIGHT", -inset, -inset)

	self.BarList:ClearAllPoints() -- See comment in Omen:UpdateTitleBar()
	self.BarList:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT")
	self.BarList:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")

	self:ResizeBars()
	self:ReAnchorBars()
	self:UpdateBars()
end

function Omen:UpdateTitleBar()
	local font = LSM:Fetch("font", db.TitleBar.Font)
	local size = db.TitleBar.FontSize
	local flags = db.TitleBar.FontOutline
	local color = db.TitleBar.FontColor
	self.TitleText:SetFont(font, size, flags)
	self.TitleText:SetTextColor(color.r, color.g, color.b, color.a)
	local h = db.Background.EdgeSize * 2
	if not db.TitleBar.UseSameBG then h = db.TitleBar.EdgeSize * 2 end
	if not db.TitleBar.ShowTitleBar then
		-- Yes, its a hack, since it can't be set to 0
		self.Title:SetHeight(1e-6)
		self.Title:Hide()
	elseif h > db.TitleBar.Height then
		self.Title:SetHeight(h)
		self.Title:Show()
	else
		self.Title:SetHeight(db.TitleBar.Height)
		self.Title:Show()
	end
	-- This forces the UI to redraw it, I couldn't find a better way. Although it is
	-- anchored to the Title, it doesn't update automatically on the height change.
	self.BarList:ClearAllPoints()
	self.BarList:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT")
	self.BarList:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")
end

function Omen:UpdateFuBarSettings()
	if LibStub:GetLibrary("LibFuBarPlugin-3.0", true) then
		if db.FuBar.HideMinimapButton then
			self:Hide()
		else
			self:Show()
			if self:IsFuBarMinimapAttached() ~= db.FuBar.AttachMinimap then
				self:ToggleFuBarMinimapAttached()
			end
		end
	end
end

function Omen:UpdateGrips()
	self.VGrip1:ClearAllPoints()
	self.VGrip1:SetPoint("TOPLEFT", self.BarList, "TOPLEFT", db.VGrip1, 0)
	self.VGrip1:SetPoint("BOTTOMLEFT", self.BarList, "BOTTOMLEFT", db.VGrip1, 0)
	self.VGrip2:ClearAllPoints()
	self.VGrip2:SetPoint("TOPLEFT", self.BarList, "TOPLEFT", db.VGrip2, 0)
	self.VGrip2:SetPoint("BOTTOMLEFT", self.BarList, "BOTTOMLEFT", db.VGrip2, 0)
	if db.Locked then
		self.Grip:Hide()
		self.VGrip1:Hide()
		self.VGrip2:Hide()
	else
		self.Grip:Show()
		self.VGrip1:Show()
		if db.Bar.ShowTPS then
			self.VGrip2:Show()
		else
			self.VGrip2:Hide()
		end
	end
end

function Omen:ToggleFocus()
	db.UseFocus = not db.UseFocus
	if db.UseFocus then
		Omen:RegisterEvent("UNIT_TARGET")
	else
		Omen:UnregisterEvent("UNIT_TARGET")
	end
	Omen:UpdateBars()
end

function Omen:UpdateRaidClassColors()
	if CUSTOM_CLASS_COLORS and db.Bar.UseCustomClassColors then
		RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS
	else
		RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
	end
	Omen:UpdateBars()
end


-----------------------------------------------------------------------------
-- Omen warnings

function Omen:Flash()
	if not self.FlashFrame then
		local flasher = CreateFrame("Frame", "OmenFlashFrame")
		flasher:SetToplevel(true)
		flasher:SetFrameStrata("FULLSCREEN_DIALOG")
		flasher:SetAllPoints(UIParent)
		flasher:EnableMouse(false)
		flasher:Hide()
		flasher.texture = flasher:CreateTexture(nil, "BACKGROUND")
		flasher.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < 2.6 then
				local alpha = elapsed % 1.3
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.FlashFrame = flasher
	end

	self.FlashFrame:Show()
end

-- This function is adapted from Omen2 to be self-contained,
-- which was initially taken from BigWigs
function Omen:Shake()
	local shaker = self.ShakerFrame
	if not shaker then
		shaker = CreateFrame("Frame", "OmenShaker", UIParent)
		shaker:Hide()
		shaker:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			local x, y = 0, 0 -- Resets to original position if we're supposed to stop.
			if elapsed >= 0.8 then
				self:Hide()
			else
				x, y = random(-8, 8), random(-8, 8)
			end
			if WorldFrame:IsProtected() and InCombatLockdown() then
				if not shaker.fail then
					Omen:Print(L["|cffff0000Error:|r Omen cannot use shake warning if you have turned on nameplates at least once since logging in."])
					shaker.fail = true
				end
				self:Hide()
			else
				WorldFrame:ClearAllPoints()
				for i = 1, #self.originalPoints do
					local v = self.originalPoints[i]
					WorldFrame:SetPoint(v[1], v[2], v[3], v[4] + x, v[5] + y)
				end
			end
			self.elapsed = elapsed
		end)
		shaker:SetScript("OnShow", function(self)
			-- Store old worldframe positions, we need them all, people have frame modifiers for it
			if not self.originalPoints then
				self.originalPoints = {}
				for i = 1, WorldFrame:GetNumPoints() do
					tinsert(self.originalPoints, {WorldFrame:GetPoint(i)})
				end
			end
			self.elapsed = 0
		end)
		self.ShakerFrame = shaker
	end

	shaker:Show()
end

function Omen:Warn(sound, flash, shake, message)
	if sound then PlaySoundFile(LSM:Fetch("sound", db.Warnings.SoundFile)) end
	if flash then self:Flash() end
	if shake then self:Shake() end
	if message then self:Pour(message, 1, 0, 0, nil, 24, "OUTLINE", true) end
end


-----------------------------------------------------------------------------
-- Omen bar stuff

do
	-- OnUpdate function for bar animation, lasts 0.25 seconds
	local function animate(self, elapsed)
		local t = self.animationCursor + elapsed
		local animData = self.animData
		if t >= 0.25 then
			self.texture2:SetWidth(animData[4])
			animData[6] = nil
			animData[5] = nil
			animData[4] = nil
			self.texture:SetWidth(animData[1])
			animData[3] = nil
			animData[2] = nil
			animData[1] = nil
			t = 0
			self:SetScript("OnUpdate", nil)
		else
			self.texture:SetWidth(animData[2] + animData[3] * t / 0.25)
			self.texture2:SetWidth(animData[5] + animData[6] * t / 0.25)
		end
		self.animationCursor = t
	end

	-- function to start bar animations
	local function AnimateTo(self, val, val2)
		if val == 1/0 or val == -1/0 then return end -- infinity, do nothing
		if val2 == 1/0 or val2 == -1/0 then return end -- infinity, do nothing
		if val == 0 then val = 1 end -- at least 1 pixel width
		if val2 == 0 then val2 = 1 end -- at least 1 pixel width
		local animData = self.animData
		if animData[1] == val and animData[4] == val2 then return end -- there is already an animation to the target width
		local currentWidth = self.texture:GetWidth()
		local currentWidth2 = self.texture2:GetWidth()
		--if currentWidth > self:GetWidth() then currentWidth = self:GetWidth() end
		if val == currentWidth and val2 == currentWidth2 then return end -- the current width is already the target width
		animData[1] = val
		animData[2] = currentWidth
		animData[3] = val - currentWidth
		animData[4] = val2
		animData[5] = currentWidth2
		animData[6] = val2 - currentWidth2
		self.animationCursor = 0
		self:SetScript("OnUpdate", animate)
	end

	-- Create bars on demand
	setmetatable(bars, {__index = function(self, barID)
		local bar = CreateFrame("Frame", nil, Omen.BarList)
		self[barID] = bar

		local inset = db.Background.BarInset
		local inset2 = db.Background.BarInset * 2
		local color = db.Bar.InvertColors and db.Bar.BarColor or db.Bar.FontColor

		bar:SetWidth(Omen.Anchor:GetWidth() - inset2)
		bar:SetHeight(db.Bar.Height)
		if db.Bar.ShowHeadings then
			bar:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", inset, -inset + (barID) * -(db.Bar.Height + db.Bar.Spacing))
		else
			bar:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", inset, -inset + (barID-1) * -(db.Bar.Height + db.Bar.Spacing))
		end

		bar.Text1 = bar:CreateFontString(nil, nil, "GameFontNormalSmall")
		bar.Text1:SetPoint("LEFT", bar, "LEFT", 5, 1)
		bar.Text1:SetJustifyH("LEFT")
		bar.Text1:SetFont(LSM:Fetch("font", db.Bar.Font), db.Bar.FontSize, db.Bar.FontOutline)
		bar.Text1:SetTextColor(color.r, color.g, color.b, color.a)
		bar.Text1:SetWidth(db.VGrip1 - 5)
		bar.Text1:SetHeight(db.Bar.FontSize)
		bar.Text1:SetNonSpaceWrap(false)

		bar.Text2 = bar:CreateFontString(nil, nil, "GameFontNormalSmall")
		bar.Text2:SetPoint("RIGHT", bar, "RIGHT", -5, 1)
		bar.Text2:SetJustifyH("RIGHT")
		bar.Text2:SetFont(LSM:Fetch("font", db.Bar.Font), db.Bar.FontSize, db.Bar.FontOutline)
		bar.Text2:SetTextColor(color.r, color.g, color.b, color.a)
		if db.Bar.ShowTPS then
			bar.Text2:SetWidth(Omen.BarList:GetWidth() - db.VGrip2 - 5)
		else
			bar.Text2:SetWidth(Omen.BarList:GetWidth() - db.VGrip1 - 5)
		end
		bar.Text2:SetHeight(db.Bar.FontSize)
		bar.Text2:SetNonSpaceWrap(false)

		bar.Text3 = bar:CreateFontString(nil, nil, "GameFontNormalSmall")
		bar.Text3:SetPoint("LEFT", bar.Text1, "RIGHT", 0, 0)
		bar.Text3:SetJustifyH("RIGHT")
		bar.Text3:SetFont(LSM:Fetch("font", db.Bar.Font), db.Bar.FontSize, db.Bar.FontOutline)
		bar.Text3:SetTextColor(color.r, color.g, color.b, color.a)
		bar.Text3:SetWidth(db.VGrip2 - db.VGrip1 - 5)
		bar.Text3:SetHeight(db.Bar.FontSize)
		bar.Text3:SetNonSpaceWrap(false)
		if not db.Bar.ShowTPS then bar.Text3:Hide() end

		bar.texture = bar:CreateTexture()
		bar.texture:SetTexture(LSM:Fetch("statusbar", db.Bar.Texture))
		bar.texture:SetPoint("TOPLEFT", bar, "TOPLEFT")
		bar.texture:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT")
		color = db.Bar.InvertColors and db.Bar.FontColor or db.Bar.BarColor
		bar.texture:SetVertexColor(color.r, color.g, color.b, color.a)

		bar.texture2 = bar:CreateTexture()
		bar.texture2:SetTexture(LSM:Fetch("statusbar", db.Bar.Texture))
		bar.texture2:SetPoint("TOPLEFT", bar.texture, "TOPRIGHT")
		bar.texture2:SetPoint("BOTTOMLEFT", bar.texture, "BOTTOMRIGHT")
		color = db.Bar.FadeBarColor
		bar.texture2:SetVertexColor(color.r, color.g, color.b, color.a)
		bar.texture2:SetWidth(1)
		bar.texture2:Hide()

		bar.animData = {}
		bar.animationCursor = 0
		bar.AnimateTo = AnimateTo

		if barID == 0 then
			bar.Text1:SetText(L["Name"])
			if db.Bar.ShowValue and db.Bar.ShowPercent then
				bar.Text2:SetText(L["Threat [%]"])
			else
				bar.Text2:SetText(L["Threat"])
			end
			bar.Text3:SetText(L["TPS"])
			color = db.Bar.InvertColors and db.Bar.FontColor or db.Bar.HeadingBGColor
			bar.texture:SetVertexColor(color.r, color.g, color.b, color.a)
			bar:Hide()
		elseif barID == 1 then
			-- Parent our TPS update frame to the first bar, so that TPS updates
			-- updates happen when at least 1 bar (the first bar) is shown.
			Omen.TPSUpdateFrame = CreateFrame("Frame", nil, bar)
			Omen.TPSUpdateFrame:SetScript("OnUpdate", function(self, elapsed) Omen:UpdateTPS() end)
			if not db.Bar.ShowTPS then Omen.TPSUpdateFrame:Hide() end
		end

		return bar
	end})
end

function Omen:ResizeBars()
	local inset = db.Background.BarInset * 2
	local w = Omen.Anchor:GetWidth() - inset
	for i = 0, #bars do
		bars[i]:SetWidth(w)
		bars[i]:SetHeight(db.Bar.Height)
	end
end

function Omen:ReAnchorBars()
	local inset = db.Background.BarInset
	if db.Bar.ShowHeadings then
		for i = 0, #bars do
			bars[i]:SetPoint("TOPLEFT", self.BarList, "TOPLEFT", inset, -inset + (i) * -(db.Bar.Height + db.Bar.Spacing))
		end
	else
		for i = 1, #bars do
			bars[i]:SetPoint("TOPLEFT", self.BarList, "TOPLEFT", inset, -inset + (i-1) * -(db.Bar.Height + db.Bar.Spacing))
		end
		bars[0]:Hide()
	end
end

function Omen:UpdateBarLabelSettings()
	local font = LSM:Fetch("font", db.Bar.Font)
	local size = db.Bar.FontSize
	local flags = db.Bar.FontOutline
	local color = db.Bar.InvertColors and db.Bar.BarColor or db.Bar.FontColor
	local color2 = db.Bar.InvertColors and db.Bar.FontColor or db.Bar.BarColor
	for i = 0, #bars do
		bars[i].Text1:SetFont(font, size, flags)
		bars[i].Text2:SetFont(font, size, flags)
		bars[i].Text3:SetFont(font, size, flags)
		bars[i].Text1:SetTextColor(color.r, color.g, color.b, color.a)
		bars[i].Text2:SetTextColor(color.r, color.g, color.b, color.a)
		bars[i].Text3:SetTextColor(color.r, color.g, color.b, color.a)
		bars[i].Text1:SetHeight(size)
		bars[i].Text2:SetHeight(size)
		bars[i].Text3:SetHeight(size)
		bars[i].texture:SetVertexColor(color2.r, color2.g, color2.b, color2.a)
	end
	color = db.Bar.InvertColors and db.Bar.FontColor or db.Bar.HeadingBGColor
	color2 = db.Bar.InvertColors and db.Bar.HeadingBGColor or db.Bar.FontColor
	bars[0].texture:SetVertexColor(color.r, color.g, color.b, color.a)
	bars[0].Text1:SetTextColor(color2.r, color2.g, color2.b, color2.a)
	bars[0].Text2:SetTextColor(color2.r, color2.g, color2.b, color2.a)
	bars[0].Text3:SetTextColor(color2.r, color2.g, color2.b, color2.a)
end

function Omen:ReAnchorLabels()
	local w = db.VGrip1
	local w2 = db.Bar.ShowTPS and Omen.BarList:GetWidth() - db.VGrip2 or Omen.BarList:GetWidth() - w
	local w3 = db.VGrip2 - db.VGrip1
	for i = 0, #bars do
		bars[i].Text1:SetWidth(w - 5)
		bars[i].Text2:SetWidth(w2 - 5)
		if db.Bar.ShowTPS then
			bars[i].Text3:SetWidth(w3 - 5)
			bars[i].Text3:Show()
		else
			bars[i].Text3:Hide()
		end
	end
end

function Omen:UpdateBarTextureSettings()
	local texturepath = LSM:Fetch("statusbar", db.Bar.Texture)
	for i = 0, #bars do
		bars[i].texture:SetTexture(texturepath)
	end
end

function Omen:UpdateClickThrough()
	self.Title:EnableMouse(not db.ClickThrough)
	self.BarList:EnableMouse(not db.ClickThrough)
end


-----------------------------------------------------------------------------
-- Omen event functions

-- Fired when a mob has its threat list updated. The mob that
-- had its list updated is the first parameter of the event.
function Omen:UNIT_THREAT_LIST_UPDATE(event, unitID)
	-- It appears that unitID can only be "target" or "focus"
	self:UpdateBars()
end

-- Fired when a unit's threat situation changes. The unit that
-- had a change in threat situation is the first parameter of
-- the event. Note that this only triggers when major state
-- changes, not when the raw threat values change.
function Omen:UNIT_THREAT_SITUATION_UPDATE(...)
	self:UpdateBars()
end

function Omen:PLAYER_TARGET_CHANGED()
	-- Stop our unit update timer for updating threat on "targettarget"
	if timers.UpdateBars then
		self:CancelTimer(timers.UpdateBars, true)
		timers.UpdateBars = nil
	end
	self:UpdateBars()
end

function Omen:UNIT_TARGET(event, unitID)
	if unitID == "focus" and db.UseFocus and self.unitID == "focustarget" then
		self:UpdateBars()
	end
end

local lastPartyUpdateTime = GetTime()

function Omen:PARTY_MEMBERS_CHANGED()
	local oldInParty, oldInRaid = inParty, inRaid
	inParty = GetNumPartyMembers() > 0
	inRaid = GetNumRaidMembers() > 0
	if oldInParty ~= inParty or oldInRaid ~= inRaid then manualToggle = false end
	self:UpdateVisible()

	-- Run the update if the last call is more than 0.5 seconds ago else
	-- schedule an update 0.5 seconds later if one isn't already scheduled
	if GetTime() - lastPartyUpdateTime > 0.5 then
		self:UpdatePartyGUIDs()
	elseif not timers.UpdatePartyGUIDs then
		timers.UpdatePartyGUIDs = self:ScheduleTimer("UpdatePartyGUIDs", 0.5)
	end
end

-- This function updates the name and class guid lookup tables of the raid
function Omen:UpdatePartyGUIDs()
	lastPartyUpdateTime = GetTime()
	if timers.UpdatePartyGUIDs then
		self:CancelTimer(timers.UpdatePartyGUIDs, true)
		timers.UpdatePartyGUIDs = nil
	end

	local _
	local me = UnitGUID("player")
	wipe(guidClassLookup)
	if me then -- Because it sometimes is nil on zoning/logging in.
		guidNameLookup[me] = UnitName("player")
		_, guidClassLookup[me] = UnitClass("player")
	else
		timers.UpdatePartyGUIDs = self:ScheduleTimer("UpdatePartyGUIDs", 0.5)
	end
	if UnitExists("pet") then
		local petGUID = UnitGUID("pet")
		guidClassLookup[petGUID] = "PET"
		guidNameLookup[petGUID] = UnitName("pet")--.." ["..UnitName("player").."]"
	end

	if inParty or inRaid then
		local playerFmt = inRaid and rID or pID
		local petFmt = inRaid and rpID or ppID
		local currentPartySize = inRaid and GetNumRaidMembers() or GetNumPartyMembers()

		for i = 1, currentPartySize do
			local unitID = playerFmt[i]
			local pGUID = UnitGUID(unitID)

			if pGUID then
				guidNameLookup[pGUID] = UnitName(unitID)
				_, guidClassLookup[pGUID] = UnitClass(unitID)

				-- lookup pet (if existing)
				local petID = petFmt[i]
				local petGUID = UnitGUID(petID)
				if petGUID then
					guidNameLookup[petGUID] = UnitName(petID)--.." ["..UnitName(unitID).."]"
					guidClassLookup[petGUID] = "PET"
				end
			end
		end
	end
	guidNameLookup["AGGRO"] = L["> Pull Aggro <"]
	guidClassLookup["AGGRO"] = "AGGRO"
end


-- For temporary threat tracking, modified code submitted by Melaar
local mdtricksActors = {}       -- Format: mdtricksActors[fromGUID] = toGUID
local mdtricksActiveActors = {} -- Format: mdtricksActors2[fromGUID] = toGUID
local tempThreat = {}           -- Format: tempThreat[mobGUID][toGUID][fromGUID] = damage
local tempThreatExpire = {}     -- Format: tempThreatExpire[fromGUID] = GetTime()
local mifadeThreat = {}    		-- Format: mifadeThreat[fromGUID][mobGUID] = threat

--[[
For Tricks and Misdirect
1. Watch for SPELL_CAST_SUCCESS to determine the target to transfer threat to
2. Start recording when the first damage event or the SPELL_AURA_APPLIED on the
   threat transfer buff, whichever is earlier
3. Stop recording on threat transfer buff expiry

For Mirror Image, Fade and Hand of Salvation (Glyphed)
1. Watch for the SPELL_AURA_APPLIED buff, which always occurs before the
   SPELL_CAST_SUCCESS and start recording
2. Stop recording when buff expires
The combat log offers no hint as to which version of Hand of Salvation is casted,
so we record anyway.
]]

local TOC -- Pre-4.1 CLEU compat
local dummyTable = {}
do
	-- Because GetBuildInfo() still returns 40000 on the PTR
	local major, minor, rev = strsplit(".", (GetBuildInfo()))
	TOC = major*10000 + minor*100
end
function Omen:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	-- Pre-4.1 CLEU compat
	if TOC < 40100 and hideCaster ~= dummyTable then
		-- Insert a dummy for the new argument introduced in 4.1 and perform a tail call
		return self:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventtype, dummyTable, hideCaster, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	end

	if eventtype == "SPELL_CAST_SUCCESS" then
		local spellID = ...
		if spellID == 34477 or spellID == 57934 then  -- Misdirection and Tricks of the Trade
			--self:Print("|cff40ff40"..srcName.."|r cast "..GetSpellLink(spellID).." on |cffff4040"..dstName.."|r")
			mdtricksActors[srcGUID] = dstGUID
		end

	elseif eventtype == "SPELL_AURA_APPLIED" then
		local spellID = ...
		local mdtricksTarget = mdtricksActors[srcGUID]

		-- Misdirection and Tricks of the Trade buff
		if mdtricksTarget and not mdtricksActiveActors[srcGUID] and (spellID == 35079 or spellID == 59628) then
			-- This will almost never trigger because the first damage event is usually before the buff gain
			-- except for Sap which counts as a trigger to start Tricks
			--self:Print("|cff40ff40"..srcName.."|r transferring threat with "..GetSpellLink(spellID))
			mdtricksActiveActors[srcGUID] = mdtricksTarget
			tempThreatExpire[srcGUID] = GetTime() + 30
			self:ScheduleTimer("ThreatExpire", 30, srcGUID)

		elseif spellID == 55342 or spellID == 586 or spellID == 1038 then -- Mirror Image, Fade and Hand of Salvation buff
			-- The aura event for this always occurs before the one for SPELL_CAST_SUCCESS
			--self:Print("|cff40ff40"..srcName.."|r casts "..GetSpellLink(spellID).." on ".."|cff40ff40"..dstName.."|r")
			mifadeThreat[dstGUID] = newTable()
			if spellID == 55342 then -- Mirror Image
				tempThreatExpire[dstGUID] = GetTime() + 30
				self:ScheduleTimer("FadeExpire", 30, dstGUID)
				mifadeThreat[dstGUID].display = true
			elseif spellID == 586 then -- Fade
				tempThreatExpire[dstGUID] = GetTime() + 10
				self:ScheduleTimer("FadeExpire", 10, dstGUID)
				mifadeThreat[dstGUID].display = true
			else -- Hand of Salvation
				tempThreatExpire[dstGUID] = GetTime() + 10
				self:ScheduleTimer("FadeExpire", 10, dstGUID)
				-- Need to determine later if its a glyphed salv or not, so don't display first
			end
			self:RecordThreat(dstGUID)

		elseif spellID == 32612 and mifadeThreat[srcGUID] then -- Invisibility buff while Mirror Image is active
			wipe(mifadeThreat[srcGUID])

		end

	elseif eventtype == "SPELL_AURA_REMOVED" then
		local spellID = ...
		if spellID == 35079 or spellID == 59628 then
			--self:Print(GetSpellLink(spellID).." fades from |cffff4040"..srcName.."|r")
			mdtricksActors[dstGUID] = nil
			mdtricksActiveActors[dstGUID] = nil
		elseif spellID == 55342 or spellID == 586 or spellID == 1038 then
			--self:Print(GetSpellLink(spellID).." fades from |cffff4040"..dstName.."|r")
			self:FadeExpire(dstGUID)
		end

	else
		-- Track damage done by players with active MD or Tricks
		local mdtricksTarget = mdtricksActors[srcGUID]
		if mdtricksTarget then
			local _, damage
			if eventtype == "SPELL_DAMAGE" or eventtype == "RANGE_DAMAGE" or eventtype == "SPELL_PERIODIC_DAMAGE" then
				_, _, _, damage = ...
			elseif eventtype == "SWING_DAMAGE" then
				damage = ...
			end
			if damage then
				-- We assume the first damage event starts the 30 sec timer
				-- We usually can't use the buff gained event because it occurs
				-- after the damage attack event that triggers it to start
				--self:Print(eventtype, srcName, damage)
				if not mdtricksActiveActors[srcGUID] then
					--self:Print("|cff40ff40"..srcName.."|r triggered threat transfer with damage")
					mdtricksActiveActors[srcGUID] = mdtricksTarget
					tempThreatExpire[srcGUID] = GetTime() + 30
					self:ScheduleTimer("ThreatExpire", 30, srcGUID)
				end
				-- Do nothing if it did 0 damage
				if damage < 1 then return end
				-- Create tables
				tempThreat[dstGUID] = tempThreat[dstGUID] or newTable()
				local t = tempThreat[dstGUID]
				t[mdtricksTarget] = t[mdtricksTarget] or newTable()
				t = t[mdtricksTarget]
				-- Damage
				t[srcGUID] = (t[srcGUID] or 0) + damage
				t.total = (t.total or 0) + damage
			end

		elseif mifadeThreat[srcGUID] then
			local _, damage
			if eventtype == "SPELL_DAMAGE" or eventtype == "RANGE_DAMAGE" or eventtype == "SPELL_PERIODIC_DAMAGE" then
				_, _, _, damage = ...
			elseif eventtype == "SWING_DAMAGE" then
				damage = ...
			end
			if damage then
				--self:Print(eventtype, srcName, damage)
				mifadeThreat[srcGUID][dstGUID] = (mifadeThreat[srcGUID][dstGUID] or 0) + damage * 100
			end
		end
	end
end

function Omen:ThreatExpire(srcGUID)
	-- Remove all temp threat caused by srcGUID
	for mobGUID, recvTbl in pairs(tempThreat) do
		for recvGUID, srcTbl in pairs(recvTbl) do
			if srcTbl[srcGUID] then
				--self:Print("THREATEXPIREtot "..srcTbl.total)
				srcTbl.total = srcTbl.total - srcTbl[srcGUID]
				srcTbl[srcGUID] = nil
				if srcTbl.total < 1 then  -- No more temp threat to be transferred for this mob on any player for this actor
					recvTbl[recvGUID] = delTable(recvTbl[recvGUID])
				end
			end
		end
		if next(recvTbl) == nil then  -- No more temp threat to be transferred for this mob on any player
			tempThreat[mobGUID] = delTable(tempThreat[mobGUID])
		end
	end
	tempThreatExpire[srcGUID] = nil
	mdtricksActors[srcGUID] = nil
	mdtricksActiveActors[srcGUID] = nil
	--if next(tempThreat) == nil then print("Good") end -- Sanity check
end

function Omen:FadeExpire(srcGUID)
	-- Remove all threat caused by srcGUID
	mifadeThreat[srcGUID] = delTable(mifadeThreat[srcGUID])
	tempThreatExpire[srcGUID] = nil
end

local function recordThreat(unitid, mobunitid, srcGUID)
	if UnitCanAttack(unitid, mobunitid) then
		mifadeThreat[srcGUID][UnitGUID(mobunitid)] = select(5, UnitDetailedThreatSituation(unitid, mobunitid))
	end
end

function Omen:RecordThreat(srcGUID)
	-- First find the unitID of the player that matches srcGUID
	local unitID
	if UnitGUID("player") == srcGUID then
		unitID = "player"
	end
	if not unitID and inRaid then
		for i = 1, GetNumRaidMembers() do
			if UnitGUID(rID[i]) == srcGUID then
				unitID = rID[i]
				break
			end
		end
	end
	if not unitID and inParty then
		for i = 1, GetNumPartyMembers() do
			if UnitGUID(pID[i]) == srcGUID then
				unitID = pID[i]
				break
			end
		end
	end
	if not unitID then return end
	--self:Print('UnitID "'..unitID..'" found to be caster of MI/Fade')

	-- Record the threat of this unitID on all reachable targets
	if inParty or inRaid then
		if inRaid then
			for i = 1, GetNumRaidMembers() do
				recordThreat(unitID, rID[i], srcGUID)
				recordThreat(unitID, rpID[i], srcGUID)
				recordThreat(unitID, rtID[i], srcGUID)
				recordThreat(unitID, rptID[i], srcGUID)
			end
		else
			for i = 1, GetNumPartyMembers() do
				recordThreat(unitID, pID[i], srcGUID)
				recordThreat(unitID, ppID[i], srcGUID)
				recordThreat(unitID, ptID[i], srcGUID)
				recordThreat(unitID, pptID[i], srcGUID)
			end
		end

	end
	if not inRaid then
		recordThreat(unitID, "player", srcGUID)
		recordThreat(unitID, "pet", srcGUID)
		recordThreat(unitID, "target", srcGUID)
		recordThreat(unitID, "pettarget", srcGUID)
	end
	recordThreat(unitID, "target", srcGUID)
	recordThreat(unitID, "targettarget", srcGUID)
	recordThreat(unitID, "focus", srcGUID)
	recordThreat(unitID, "focustarget", srcGUID)
	recordThreat(unitID, "mouseover", srcGUID)
	recordThreat(unitID, "mouseovertarget", srcGUID)
end

function Omen:UpdateCountDowns()
	if timers.UpdateCountDowns then
		self:CancelTimer(timers.UpdateCountDowns, true)
		timers.UpdateCountDowns = nil
	end

	local mobGUID = self.guid
	for i = 1, #bars do
		local bar = bars[i]
		local guid = bar.guid
		if guid then
			-- Update the text on the bar
			if mifadeThreat[guid] and mifadeThreat[guid].display then
				bar.Text1:SetFormattedText("%s [%.0f]", guidNameLookup[guid], tempThreatExpire[guid] - GetTime())
				if not timers.UpdateCountDowns then
					timers.UpdateCountDowns = self:ScheduleTimer("UpdateCountDowns", 0.25)
				end
			elseif tempThreat[mobGUID] and tempThreat[mobGUID][guid] then
				local expireTime = 30
				for srcGUID, damage in pairs(tempThreat[mobGUID][guid]) do
					if tempThreatExpire[srcGUID] then
						local expire = tempThreatExpire[srcGUID] - GetTime()
						if expire > 0 and expire < expireTime then expireTime = expire end
					end
				end
				bar.Text1:SetFormattedText("%s [%.0f]", guidNameLookup[guid], expireTime)
				if not timers.UpdateCountDowns then
					timers.UpdateCountDowns = self:ScheduleTimer("UpdateCountDowns", 0.25)
				end
			else
				bar.Text1:SetText(guidNameLookup[guid])
			end
		end
	end
end

function Omen:PLAYER_ENTERING_WORLD()
	manualToggle = false
	wipe(guidNameLookup)
	wipe(mdtricksActors)
	wipe(mdtricksActiveActors)
	wipe(tempThreatExpire)
	delTable(mifadeThreat)
	mifadeThreat = newTable()
	delTable(tempThreat)
	tempThreat = newTable()
	self:PARTY_MEMBERS_CHANGED()
end


-----------------------------------------------------------------------------
-- Omen update functions

--[[
First, some definitions:
* mob - enemy creature
* threat list - a mob's list of possible targets, along with each possible target's current threat value
* threat situation - the situation that a unit is currently in (either globally, or with respect to a certain mob)
* scaled percentage - a threat percentage, where 100% means you will pull aggro (become the primary target of the mob), and thus this % cannot be higher than 100% under normal circumstances
* raw threat percentage - the percentage of the units threat when divided by the threat of the mob's current primary target, this % CAN be over 100%
---------
state = UnitThreatSituation(unit, mob)

Returns the unit's threat situation with respect to the given mob. The state can be one of the following values:
nil = the unit is not on the mob's threat list
0 = 0-99% raw threat percentage (no indicator shown)
1 = 100% or more raw threat percentage (yellow warning indicator shown)
2 = tanking, other has 100% or more raw threat percentage (orange indicator shown)
3 = tanking, all others have less than 100% raw percentage threat (red indicator shown)
---------
state = UnitThreatSituation(unit)

Returns the unit's maximum threat state on any mob's threat list.
---------
isTanking, state, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, mob)

Returns detailed information about the unit's state on the mob's threat list.
isTanking is true if the unit the primary target of the mob (and by definition has 100% threat)
state is the unit's threat situation, as listed above.
scaledPercent is the current percent threat of the unit, scaled in the 0-100% range based on distance from target.
rawPercent is the current percent threat of the unit relative to the primary target of the mob.
threatValue is the amount of threat that the unit has on the mob's threat list. This is roughly approximate to the amount of damage and healing the unit has done.
---------
r, g, b = GetThreatStatusColor(state)

Returns the colors used in the UI to represent each major threat state.
]]

local threatTable           -- Format: threatTable[guid] = threatValue
local sortTable = {}        -- Format: threatTable[i] = guid -- used for sorting by sortfunction()
local tankGUID              -- Used to store which unit is tanking and hence has 100% threat by definition
local topthreat             -- Used to store the top threat value
local lastWarn = {          -- Used to store information for threat warnings
	threatpercent = 0,
}
local threatStore = {}      -- Format: threatStore[i] = threatTable[guid] -- used for storing past threatTables
local threatStoreTime = {}  -- Format: threatStoreTime[i] = GetTime()

local function sortfunction(a, b)
	return threatTable[a] > threatTable[b]
end

local function updatethreat(unitid, mobunitid)
	local guid = UnitGUID(unitid)
	if guid and not threatTable[guid] then
		local isTanking, state, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unitid, mobunitid)
		if threatValue then
			if threatValue == 0 and mifadeThreat[guid] then
				threatValue = mifadeThreat[guid][UnitGUID(mobunitid)] or 0
				-- Check for glyphed Hand of Salvation
				if threatValue > 0 then mifadeThreat[guid].display = true end
			end
			if threatValue > topthreat then topthreat = threatValue end
			if isTanking then tankGUID = guid end
			threatTable[guid] = threatValue
		else
			-- We use the special value -1 to indicate nil here.
			threatTable[guid] = -1
		end
	end
end

local threatUnitIDFindList = {"target", "targettarget"}
local threatUnitIDFindList2 = {"focus", "focustarget", "target", "targettarget"}
function Omen:FindThreatMob()
	-- Figure out which mob to show threat on.
	-- It has to be attackable and not human controlled.
	local t = db.UseFocus and threatUnitIDFindList2 or threatUnitIDFindList
	local name, name2
	for i = 1, #t do
		local mob = t[i]
		if UnitExists(mob) then
			name2 = UnitName(mob)
			guidNameLookup[UnitGUID(mob)] = name2
			if not name then name = name2 end
			if not UnitIsPlayer(mob) and UnitCanAttack("player", mob) and UnitHealth(mob) > 0 then
				if not db.IgnorePlayerPets or not UnitPlayerControlled(mob) then
					self.TitleText:SetText(name2)
					self.unitID = mob
					self.guid = UnitGUID(mob)
					return mob
				end
			end
		end
	end
	self.TitleText:SetText(name)
	self.unitID = nil
	self.guid = nil
end

-- Frame for throtling updates
local OmenUpdateBarsThrotleFrame = CreateFrame("Frame")
OmenUpdateBarsThrotleFrame:Hide()
OmenUpdateBarsThrotleFrame:SetScript("OnUpdate", function(self, elapsed)
	self:Hide()
	Omen:UpdateBarsReal()
end)
function Omen:UpdateBars()
	OmenUpdateBarsThrotleFrame:Show()
end

local queried = false
function Omen:UpdateBarsReal()
	if db.Autocollapse and db.CollapseHide then
		-- Update the visibility because it could have been hidden on 0 bars
		self.BarList.barsShown = 1 -- Dummy value
		self:UpdateVisible()
	end
	if not self.Anchor:IsShown() then
		self.BarList.barsShown = 0
		return
	end

	local myGUID = UnitGUID("player")
	local dbBar = db.Bar
	local mob, mobGUID, mobTargetGUID
	topthreat = -1

	if testMode then
		threatTable = newTable()
		local key = next(showClassesOptionTable)
		for i = 1, 25 do
			if i == 22 and myGUID then -- Because I've got myGUID == nil before
				threatTable[myGUID] = i*5000
			else
				threatTable[i] = i*5000
				guidNameLookup[i] = showClassesOptionTable[key]
				if key ~= "*NOTINPARTY*" then guidClassLookup[i] = key end
				key = next(showClassesOptionTable, key) or next(showClassesOptionTable)
			end
		end
		tankGUID = 25
		topthreat = 25*5000
		mob = ""
		self.TitleText:SetText(L["Test Mode"])
	else
		mob = self:FindThreatMob()
		if not mob then
			self:ClearAll()
			return
		end
		mobGUID = UnitGUID(mob)

		-- Schedule a repeating timer for updating threat on "targettarget"
		-- since we get no events on a targettarget change.
		if mob == "targettarget" and not timers.UpdateBars then
			timers.UpdateBars = self:ScheduleRepeatingTimer("UpdateBars", 0.5)
		end

		-- We want the mob's target just in case the tank isn't
		-- in our raid (say an NPC or some other player)
		local mobTarget = mob.."target"
		local mobTargetGUID = UnitGUID(mobTarget)
		if mobTargetGUID then
			guidNameLookup[mobTargetGUID] = UnitName(mobTarget)
		end

		threatTable = newTable()
		threatTable[mobGUID] = -1
		tankGUID = nil

		-- Get data for threat on mob by scanning the whole raid
		if inParty or inRaid then
			if inRaid then
				for i = 1, GetNumRaidMembers() do
					updatethreat(rID[i], mob)
					updatethreat(rpID[i], mob)
					updatethreat(rtID[i], mob)
					updatethreat(rptID[i], mob)
				end
			else
				for i = 1, GetNumPartyMembers() do
					updatethreat(pID[i], mob)
					updatethreat(ppID[i], mob)
					updatethreat(ptID[i], mob)
					updatethreat(pptID[i], mob)
				end
			end

		end
		if not inRaid then
			updatethreat("player", mob)
			updatethreat("pet", mob)
			updatethreat("target", mob)
			updatethreat("pettarget", mob)
		end
		updatethreat("target", mob)
		updatethreat("targettarget", mob)
		updatethreat("focus", mob)
		updatethreat("focustarget", mob)
		updatethreat(mobTarget, mob)
		updatethreat("mouseover", mob)
		updatethreat("mouseovertarget", mob)
	end
	local tankThreat = tankGUID and threatTable[tankGUID] or mobTargetGUID and threatTable[mobTargetGUID] or topthreat
	if dbBar.ShowAggroBar and tankThreat > 0 then
		if GetItemInfo(37727) then -- 5 yards (Ruby Acorn - http://www.wowhead.com/?item=37727)
			threatTable["AGGRO"] = tankThreat * (IsItemInRange(37727, mob) == 1 and 1.1 or 1.3)
		else -- 9 yards compromise
			threatTable["AGGRO"] = tankThreat * (CheckInteractDistance(mob, 3) and 1.1 or 1.3)
			if not queried and not ItemRefTooltip:IsVisible() then
				ItemRefTooltip:SetHyperlink("item:37727")
				queried = true -- Only query once per session
			end
		end
	end

	-- Sort the threatTable
	local i = 1
	for k, v in pairs(threatTable) do
		if v ~= -1 then
			sortTable[i] = k
			i = i + 1
		end
	end
	for j = i, #sortTable do
		sortTable[j] = nil
	end
	if #sortTable == 0 then
		self:ClearAll()
		self.TitleText:SetText(guidNameLookup[mobGUID])
		return
	end
	sort(sortTable, sortfunction)

	-- Now update the bars on screen
	local inset = db.Background.BarInset * 2
	local w = self.BarList:GetWidth() - inset
	local h = self.BarList:GetHeight() - inset
	topthreat = threatTable[sortTable[1]]
	if topthreat == 0 then topthreat = 1 end -- To avoid 0/0 division
	local showSelfYet = true

	if dbBar.AlwaysShowSelf then
		-- Check if we're one of the bars to be displayed
		for j = 1, #sortTable do
			if sortTable[j] == myGUID then
				showSelfYet = false -- Yes, so flag it false
				break
			end
		end
	end

	-- Check how many bars of space we have
	local numBars = db.Autocollapse and db.NumBars or floor((h - dbBar.Height) / (dbBar.Height + dbBar.Spacing) + 1.01)

	i = 1 -- Counts one higher than number of bars used
	if dbBar.ShowHeadings then
		if i <= numBars then
			i = i + 1
			bars[0].texture:SetWidth(w)
			bars[0]:Show()
		end
	else
		bars[0]:Hide()
	end
	for j = 1, #sortTable do
		if i > numBars then break end
		local guid = sortTable[j]
		local class = guidClassLookup[guid]
		local show = class == nil and dbBar.Classes["*NOTINPARTY*"] or class == "AGGRO" and dbBar.ShowAggroBar or dbBar.Classes[class]
		if dbBar.AlwaysShowSelf and i == numBars and not showSelfYet and guid ~= myGUID then
			show = false
		end
		if dbBar.AlwaysShowSelf and guid == myGUID then
			show = true
			showSelfYet = true
		end
		if show then
			local bar = bars[dbBar.ShowHeadings and i-1 or i]
			local threat = threatTable[guid]

			-- Update the text on the bar
			if mifadeThreat[guid] and mifadeThreat[guid].display then
				bar.Text1:SetFormattedText("%s [%.0f]", guidNameLookup[guid], tempThreatExpire[guid] - GetTime())
				if not timers.UpdateCountDowns then
					timers.UpdateCountDowns = self:ScheduleTimer("UpdateCountDowns", 0.25)
				end
			elseif tempThreat[mobGUID] and tempThreat[mobGUID][guid] then
				local expireTime = 30
				for srcGUID, damage in pairs(tempThreat[mobGUID][guid]) do
					if tempThreatExpire[srcGUID] then
						local expire = tempThreatExpire[srcGUID] - GetTime()
						if expire > 0 and expire < expireTime then expireTime = expire end
					end
				end
				bar.Text1:SetFormattedText("%s [%.0f]", guidNameLookup[guid], expireTime)
				if not timers.UpdateCountDowns then
					timers.UpdateCountDowns = self:ScheduleTimer("UpdateCountDowns", 0.25)
				end
			else
				bar.Text1:SetText(guidNameLookup[guid])
			end
			if dbBar.ShowPercent and dbBar.ShowValue then
				if dbBar.ShortNumbers and threat >= 100000 then
					bar.Text2:SetFormattedText("%2.1fk [%d%%]", threat / 100000, tankThreat == 0 and 0 or threat / tankThreat * 100)
				else
					bar.Text2:SetFormattedText("%d [%d%%]", threat / 100, tankThreat == 0 and 0 or threat / tankThreat * 100)
				end
			elseif dbBar.ShowValue then
				if dbBar.ShortNumbers and threat >= 100000 then
					bar.Text2:SetFormattedText("%2.1fk", threat / 100000)
				else
					bar.Text2:SetFormattedText("%d", threat / 100)
				end
			else
				bar.Text2:SetFormattedText("%d%%", tankThreat == 0 and 0 or threat / tankThreat * 100)
			end

			-- Update the color of the bar
			local c = (mifadeThreat[guid] and mifadeThreat[guid].display and dbBar.FadeBarColor) or
				(guid == myGUID and dbBar.UseMyBarColor and dbBar.MyBarColor) or
				(guid == tankGUID and dbBar.UseTankBarColor and dbBar.TankBarColor) or
				(guid == "AGGRO" and dbBar.AggroBarColor) or
				(dbBar.UseClassColors and (RAID_CLASS_COLORS[class] or (class == "PET" and dbBar.PetBarColor))) or
				dbBar.BarColor
			if dbBar.InvertColors then
				bar.Text1:SetTextColor(c.r, c.g, c.b, c.a or dbBar.BarColor.a or 1)
				bar.Text2:SetTextColor(c.r, c.g, c.b, c.a or dbBar.BarColor.a or 1)
				bar.Text3:SetTextColor(c.r, c.g, c.b, c.a or dbBar.BarColor.a or 1)
			else
				bar.texture:SetVertexColor(c.r, c.g, c.b, c.a or dbBar.BarColor.a or 1)
			end

			-- Get temporary threat values
			local temp = 0
			if tempThreat[mobGUID] and tempThreat[mobGUID][guid] then
				temp = tempThreat[mobGUID][guid].total * 100
				--self:Print("BARtemp "..tempThreat[mobGUID][guid].total)
				if temp > threat then temp = threat end  -- Cap the temp threat
			end

			-- Update the width of the bar, and animate if necessary
			local width = w * ((threat - temp) / topthreat)
			local tempwidth = w * (temp / topthreat)
			if width <= 0 then width = 1 end
			if tempwidth <= 0 then
				tempwidth = 1
				bar.texture2:Hide()
			else
				bar.texture2:Show()
			end

			if dbBar.AnimateBars and self.Anchor.IsMovingOrSizing ~= 2 then
				bar:AnimateTo(width, tempwidth)
			else
				bar.texture:SetWidth(width)
				bar.texture2:SetWidth(tempwidth)
			end

			bar.guid = guid -- For TPS calcs
			bar:Show()
			i = i + 1
		end
	end
	-- And hide the rest
	for j = dbBar.ShowHeadings and i-1 or i, #bars do
		bars[j]:Hide()
	end
	if db.Autocollapse then
		self.Anchor:SetHeight((i-1)*dbBar.Height + (i-2)*dbBar.Spacing + self.Title:GetHeight() + inset)
	end
	self.BarList:Show()
	self.BarList.barsShown = dbBar.ShowHeadings and i-2 or i-1

	-- Threat warnings
	if testMode then
		threatTable = delTable(threatTable)
	elseif myGUID then
		local myClass = guidClassLookup[myGUID]
		local myThreatPercent = threatTable[myGUID] / tankThreat * 100
		local t = db.Warnings
		if lastWarn.mobGUID == mobGUID and myThreatPercent >= t.Threshold and t.Threshold > lastWarn.threatpercent then
			if not t.DisableWhileTanking or not (myClass == "WARRIOR" and GetBonusBarOffset() == 2 or
			  myClass == "DRUID" and GetBonusBarOffset() == 3 or
			  myClass == "PALADIN" and UnitAura("player", GetSpellInfo(25780)) or
			  myClass == "DEATHKNIGHT" and GetShapeshiftForm() ~= 0 and GetShapeshiftFormInfo(GetShapeshiftForm()) == "Interface\\Icons\\Spell_Deathknight_BloodPresence") then
				self:Warn(t.Sound, t.Flash, t.Shake, t.Message and L["Passed %s%% of %s's threat!"]:format(t.Threshold, guidNameLookup[lastWarn.tankGUID]))
			end
		end
		-- Remove TPS data if the last scanned mob is different
		if lastWarn.mobGUID ~= mobGUID then
			delTable(threatStore)
			threatStore = newTable()
			wipe(threatStoreTime)
		end
		tinsert(threatStore, threatTable)
		tinsert(threatStoreTime, GetTime())
		-- Store last scanned mob GUID
		local u = tankGUID or mobTargetGUID or (dbBar.ShowAggroBar and sortTable[2] or sortTable[1])
		if u ~= "AGGRO" then
			lastWarn.mobGUID = mobGUID
			lastWarn.tankGUID = u
			lastWarn.threatpercent = myThreatPercent
		end
		threatTable = nil
	end
end

function Omen:ClearAll()
	for i = 0, #bars do
		bars[i]:Hide()
	end
	self.TitleText:SetText(self.defaultTitle)
	if db.Autocollapse then
		self.Anchor:SetHeight(self.Title:GetHeight())
		self.BarList:Hide()
		if db.CollapseHide and not self.Anchor.IsMovingOrSizing and not manualToggle then
			self.Anchor:Hide()
		end
	end
	self.BarList.barsShown = 0
	-- Store last scanned mob GUID
	lastWarn.mobGUID = nil
	lastWarn.tankGUID = nil
	lastWarn.threatpercent = 0
	-- Remove TPS data
	delTable(threatStore)
	threatStore = newTable()
	wipe(threatStoreTime)
	threatTable = nil
end

function Omen:UpdateTPS()
	local numBars = #bars
	if testMode then
		if db.Bar.ShowAggroBar then
			bars[1].Text3:SetText("--")
			for i = 2, numBars do
				bars[i].Text3:SetText(1300 - 50*(i-1))
			end
		else
			for i = 1, numBars do
				bars[i].Text3:SetText(1300 - 50*i)
			end
		end
		return
	end
	-- Remove data that is too old
	local TPSWindow = db.Bar.TPSWindow
	local startTime = GetTime() - TPSWindow
	while threatStoreTime[2] and startTime > threatStoreTime[2] do
		delTable(tremove(threatStore, 1))
		tremove(threatStoreTime, 1)
	end
	-- Now check that we still have enough data
	local dataSize = #threatStoreTime
	if dataSize == 0 or startTime <= threatStoreTime[1] then
		-- We do not have enough data, TPSWindow seconds has not passed
		for i = 1, numBars do
			bars[i].Text3:SetText("??")
		end
		return
	end
	-- Check for special case with just 1 data point past TPSWindow seconds
	if dataSize == 1 then
		-- Threat generated is 0
		for i = 1, numBars do
			bars[i].Text3:SetText("0")
		end
		return
	end
	-- We have at least 2 data points
	for i = 1, numBars do
		local bar = bars[i]
		if not bar:IsShown() then return end
		local guid = bar.guid
		if guid == "AGGRO" then
			bar.Text3:SetText("--")
		else
			local baseThreat = threatStore[1][guid]
			local secondThreat = threatStore[2][guid]
			local finalThreat = threatStore[dataSize][guid]
			if baseThreat and secondThreat and finalThreat then
				-- Calculate TPS
				local ratio = (startTime - threatStoreTime[1]) / (threatStoreTime[2] - threatStoreTime[1])
				local startThreat = (secondThreat - baseThreat) * ratio + baseThreat
				bar.Text3:SetFormattedText("%d", (finalThreat - startThreat) / TPSWindow / 100)
			else
				-- We don't have enough data for this unit
				bar.Text3:SetText("??")
			end
		end
	end
end


-----------------------------------------------------------------------------
-- Title Right Click menu

do
	-- Upvalue the functions in the menu
	local function updateGrip()
		db.Locked = not db.Locked
		Omen:UpdateGrips()
		LibStub("AceConfigRegistry-3.0"):NotifyChange("Omen")
	end
	local function toggleFocus() Omen:ToggleFocus() end
	local function toggleTestMode()
		testMode = not testMode
		Omen:UpdateBars()
		LibStub("AceConfigRegistry-3.0"):NotifyChange("Omen")
	end
	local function showConfig() Omen:ShowConfig() end
	local function toggle() Omen:Toggle() end

	function Omen.TitleQuickMenu(self, level)
		if not level then return end
		local info = self.info
		wipe(info)
		info.isNotRadio = true
		if level == 1 then
			-- Create the title of the menu
			info.isTitle      = 1
			info.text         = L["Omen Quick Menu"]
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)

			info.disabled     = nil
			info.isTitle      = nil
			info.notCheckable = nil

			info.text = L["Lock Omen"]
			info.func = updateGrip
			info.checked = db.Locked
			info.tooltipTitle = L["Lock Omen"]
			info.tooltipText = L["Locks Omen in place and prevents it from being dragged or resized."]
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Use Focus Target"]
			info.func = toggleFocus
			info.checked = db.UseFocus
			info.tooltipTitle = L["Use Focus Target"]
			info.tooltipText = L["Tells Omen to additionally check your 'focus' and 'focustarget' before your 'target' and 'targettarget' in that order for threat display."]
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Test Mode"]
			info.func = toggleTestMode
			info.checked = testMode
			info.tooltipTitle = L["Test Mode"]
			info.tooltipText = L["Tells Omen to enter Test Mode so that you can configure Omen's display much more easily."]
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Open Config"]
			info.func = showConfig
			info.checked = nil
			info.notCheckable = true
			info.tooltipTitle = L["Open Config"]
			info.tooltipText = L["Open Omen's configuration panel"]
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Hide Omen"]
			info.func = toggle
			info.tooltipTitle = L["Hide Omen"]
			info.tooltipText = nil
			UIDropDownMenu_AddButton(info, level)

			-- Close menu item
			info.text         = CLOSE
			info.func         = self.HideMenu
			info.checked      = nil
			info.arg1         = nil
			info.notCheckable = 1
			info.tooltipTitle = CLOSE
			UIDropDownMenu_AddButton(info, level)
		end
	end
end


-----------------------------------------------------------------------------
-- Omen config stuff

function Omen:SetupOptions()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Omen", self.GenerateOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("OmenSlashCommand", self.OptionsSlash, "omen")

	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.Omen = ACD3:AddToBlizOptions("Omen", self.versionstring, nil, "General")
	self.optionsFrames.ShowWhen = ACD3:AddToBlizOptions("Omen", L["Show When..."], self.versionstring, "ShowWhen")
	self.optionsFrames.ShowClasses = ACD3:AddToBlizOptions("Omen", L["Show Classes..."], self.versionstring, "ShowClasses")
	self.optionsFrames.TitleBar = ACD3:AddToBlizOptions("Omen", L["Title Bar Settings"], self.versionstring, "TitleBar")
	self.optionsFrames.Bars = ACD3:AddToBlizOptions("Omen", L["Bar Settings"], self.versionstring, "Bars")
	self.optionsFrames.Warnings = ACD3:AddToBlizOptions("Omen", L["Warning Settings"], self.versionstring, "Warnings")
	self:RegisterModuleOptions("OmenSlashCommand", self.OptionsSlash, L["Slash Command"])
	self:RegisterModuleOptions("Profiles", function() return LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db) end, L["Profiles"])
	self.optionsFrames.Help = ACD3:AddToBlizOptions("Omen", L["Help File"], self.versionstring, "Help")

	self.SetupOptions = nil
end

function Omen:RegisterModuleOptions(name, optionTbl, displayName)
	if moduleOptions then
		moduleOptions[name] = optionTbl
	else
		self.Options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	end
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Omen", displayName, self.versionstring, name)
end

function Omen:ShowConfig()
	-- Open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Omen)
end

function Omen.GenerateOptions()
	if Omen.noconfig then assert(false, Omen.noconfig) end
	if not Omen.Options then
		Omen.GenerateOptionsInternal()
		Omen.GenerateOptionsInternal = nil
		moduleOptions = nil
	end
	return Omen.Options
end


-----------------------------------------------------------------------------
-- Omen config tables

-- Option table for the slash command only
Omen.OptionsSlash = {
	type = "group",
	name = L["Slash Command"],
	order = -3,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["OMEN_SLASH_DESC"],
			cmdHidden = true,
		},
		toggle = {
			type = "execute",
			name = L["Toggle Omen"],
			desc = L["Toggle Omen"].." ( /omen toggle )",
			func = function() Omen:Toggle() end,
		},
		center = {
			type = "execute",
			name = L["Center Omen"],
			desc = L["Center Omen"].." ( /omen center )",
			func = function()
				Omen.Anchor:ClearAllPoints()
				Omen.Anchor:SetPoint("CENTER", UIParent, "CENTER")
				Omen:SetAnchors()
			end,
		},
		config = {
			type = "execute",
			name = L["Configure"],
			desc = L["Open the configuration dialog"].." ( /omen config )",
			func = function() Omen:ShowConfig() end,
			guiHidden = true,
		},
		show = {
			type = "execute",
			name = L["Show Omen"],
			desc = L["Show Omen"].." ( /omen show )",
			func = function() Omen:Toggle(true) end,
		},
		hide = {
			type = "execute",
			name = L["Hide Omen"],
			desc = L["Hide Omen"].." ( /omen hide )",
			func = function() Omen:Toggle(false) end,
		},
	},
}

-- This is to provide better error reporting feedback, and stop loading the rest of the file.
if not AceGUIWidgetLSMlists then
	Omen.noconfig = 'Cannot find a library instance of "AceGUI-3.0-SharedMediaWidgets". Omen configuration will not be available.'
	assert(AceGUIWidgetLSMlists, Omen.noconfig)
end

function Omen.GenerateOptionsInternal()
	local outlines = {
		[""]             = L["None"],
		["OUTLINE"]      = L["Outline"],
		["THICKOUTLINE"] = L["Thick Outline"],
	}

	local function GetFuBarMinimapAttachedStatus(info)
		return Omen:IsFuBarMinimapAttached() or db.FuBar.HideMinimapButton
	end

-- Option table for the AceGUI config only
Omen.Options = {
	type = "group",
	name = "Omen",
	get = function(info) return db[ info[#info] ] end,
	set = function(info, value) db[ info[#info] ] = value end,
	args = {
		General = {
			order = 1,
			type = "group",
			name = L["General Settings"],
			desc = L["General Settings"],
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["OMEN_DESC"],
				},
				Alpha = {
					order = 3,
					name = L["Alpha"],
					desc = L["Controls the transparency of the main Omen window."],
					type = "range",
					min = 0, max = 1, step = 0.01,
					isPercent = true,
					set = function(info, value)
						db.Alpha = value
						Omen.Anchor:SetAlpha(value)
					end,
				},
				Scale = {
					order = 4,
					name = L["Scale"],
					desc = L["Controls the scaling of the main Omen window."],
					type = "range",
					min = 0.50, max = 1.50, step = 0.01,
					isPercent = true,
					set = function(info, value)
						db.Scale = value
						Omen:SetAnchors()
					end,
				},
				FrameStrata = {
					type = "select",
					order = 5,
					name = L["Frame Strata"],
					desc = L["Controls the frame strata of the main Omen window. Default: MEDIUM"],
					values = { -- A hack to sort them in the menu
						["1-BACKGROUND"] = "BACKGROUND",
						["2-LOW"] = "LOW",
						["3-MEDIUM"] = "MEDIUM",
						["4-HIGH"] = "HIGH",
						["5-DIALOG"] = "DIALOG",
						["6-FULLSCREEN"] = "FULLSCREEN",
						["7-FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG",
						["8-TOOLTIP"] = "TOOLTIP",
					},
					set = function(info, value)
						db.FrameStrata = value
						Omen.Anchor:SetFrameStrata(strsub(value, 3))
					end,
				},
				ClampToScreen = {
					type = "toggle",
					name = L["Clamp To Screen"],
					desc = L["Controls whether the main Omen window can be dragged offscreen"],
					order = 6,
					set = function(info, value)
						db.ClampToScreen = value
						Omen.Anchor:SetClampedToScreen(value)
					end,
				},
				Locked = {
					type = "toggle",
					name = L["Lock Omen"],
					desc = L["Locks Omen in place and prevents it from being dragged or resized."],
					order = 7,
					set = function(info, value)
						db.Locked = value
						Omen:UpdateGrips()
					end,
				},
				UseFocus = {
					type = "toggle",
					name = L["Use Focus Target"],
					desc = L["Tells Omen to additionally check your 'focus' and 'focustarget' before your 'target' and 'targettarget' in that order for threat display."],
					order = 8,
					set = function(info, value)
						Omen:ToggleFocus()
					end,
				},
				TestMode = {
					type = "toggle",
					name = L["Test Mode"],
					desc = L["Tells Omen to enter Test Mode so that you can configure Omen's display much more easily."],
					order = 9,
					get = function(info) return testMode end,
					set = function(info, value)
						testMode = value
						Omen:UpdateBars()
					end,
				},
				MinimapIcon = {
					type = "toggle",
					name = L["Show minimap button"],
					desc = L["Show the Omen minimap button"],
					order = 10,
					get = function(info) return not db.MinimapIcon.hide end,
					set = function(info, value)
						db.MinimapIcon.hide = not value
						if value then LDBIcon:Show("Omen") else LDBIcon:Hide("Omen") end
					end,
					hidden = function() return not LDBIcon or IsAddOnLoaded("Broker2FuBar") or IsAddOnLoaded("FuBar") end,
				},
				IgnorePlayerPets = {
					type = "toggle",
					name = L["Ignore Player Pets"],
					desc = L["IGNORE_PLAYER_PETS_DESC"],
					order = 11,
					set = function(info, value)
						db.IgnorePlayerPets = value
						Omen:UpdateBars()
					end,
				},
				ClickThrough = {
					type = "toggle",
					name = L["Click Through"],
					desc = L["Makes the Omen window non-interactive"],
					order = 12,
					set = function(info, value)
						db.ClickThrough = value
						Omen:UpdateClickThrough()
					end,
				},
				AutocollapseGroup = {
					type = "group",
					name = L["Autocollapse Options"],
					guiInline = true,
					order = 21,
					disabled = function() return not db.Autocollapse end,
					set = function(info, value)
						db[ info[#info] ] = value
						Omen:UpdateVisible()
						Omen:UpdateBars()
					end,
					args = {
						Autocollapse = {
							type = "toggle",
							name = L["Autocollapse"],
							desc = L["Collapse to show a minimum number of bars"],
							order = 1,
							set = function(info, value)
								db.Autocollapse = value
								Omen.Anchor:SetHeight(6*db.Bar.Height + 5*db.Bar.Spacing + Omen.Title:GetHeight() + 2*db.Background.BarInset)
								Omen:SetAnchors()
								Omen.BarList:Show()
								Omen:UpdateVisible()
								Omen:UpdateBars()
							end,
							disabled = false,
						},
						GrowUp = {
							order = 2,
							type = "toggle",
							name = L["Grow bars upwards"],
							desc = L["Grow bars upwards"],
							set = function(info, value)
								db.GrowUp = value
								Omen:SetAnchors()
							end,
						},
						CollapseHide = {
							order = 3,
							type = "toggle",
							name = L["Hide Omen on 0 bars"],
							desc = L["Hide Omen entirely if it collapses to show 0 bars"],
							set = function(info, value)
								db.CollapseHide = value
								if value then manualToggle = false end
								Omen:UpdateVisible()
								Omen:UpdateBars()
							end,
						},
						NumBars = {
							order = 4,
							name = L["Max bars to show"],
							desc = L["Max number of bars to show"],
							type = "range",
							min = 1, max = 40, step = 1,
						},
					},
				},
				Background = {
					type = "group",
					name = L["Background Options"],
					guiInline = true,
					order = 31,
					get = function(info) return db.Background[ info[#info] ] end,
					set = function(info, value)
						db.Background[ info[#info] ] = value
						Omen:UpdateBackdrop()
					end,
					args = {
						Texture = {
							type = "select", dialogControl = 'LSM30_Background',
							order = 1,
							name = L["Background Texture"],
							desc = L["Texture to use for the frame's background"],
							values = AceGUIWidgetLSMlists.background,
						},
						BorderTexture = {
							type = "select", dialogControl = 'LSM30_Border',
							order = 2,
							name = L["Border Texture"],
							desc = L["Texture to use for the frame's border"],
							values = AceGUIWidgetLSMlists.border,
						},
						Color = {
							type = "color",
							order = 3,
							name = L["Background Color"],
							desc = L["Frame's background color"],
							hasAlpha = true,
							get = function(info)
								local t = db.Background.Color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.Background.Color
								t.r, t.g, t.b, t.a = r, g, b, a
								Omen:UpdateBackdrop()
							end,
						},
						BorderColor = {
							type = "color",
							order = 4,
							name = L["Border Color"],
							desc = L["Frame's border color"],
							hasAlpha = true,
							get = function(info)
								local t = db.Background.BorderColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.Background.BorderColor
								t.r, t.g, t.b, t.a = r, g, b, a
								Omen:UpdateBackdrop()
							end,
						},
						Tile = {
							type = "toggle",
							order = 5,
							name = L["Tile Background"],
							desc = L["Tile the background texture"],
						},
						TileSize = {
							type = "range",
							order = 6,
							name = L["Background Tile Size"],
							desc = L["The size used to tile the background texture"],
							min = 16, max = 256, step = 1,
							disabled = function() return not db.Background.Tile end,
						},
						EdgeSize = {
							type = "range",
							order = 7,
							name = L["Border Thickness"],
							desc = L["The thickness of the border"],
							min = 1, max = 16, step = 1,
						},
						BarInset = {
							type = "range",
							order = 8,
							name = L["Bar Inset"],
							desc = L["Sets how far inside the frame the threat bars will display from the 4 borders of the frame"],
							min = 1, max = 16, step = 1,
						},
					},
				},
			},
		},
		ShowWhen = {
			order = 2,
			type = "group",
			name = L["Show When..."],
			desc = L["Show Omen when..."],
			get = function(info) return db.ShowWith[ info[#info] ] end,
			set = function(info, value)
				db.ShowWith[ info[#info] ] = value
				manualToggle = false
				Omen:UpdateVisible()
				Omen:UpdateBars()
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["This section controls when Omen is automatically shown or hidden."],
					disabled = false,
				},
				UseShowWith = {
					type = "toggle",
					order = 2,
					name = L["Use Auto Show/Hide"],
					desc = L["Use Auto Show/Hide"],
					disabled = false,
				},
				ShowWithGroup = {
					type = "group",
					order = 3,
					guiInline = true,
					name = L["Use Auto Show/Hide"],
					desc = L["Use Auto Show/Hide"],
					disabled = function(info) return not db.ShowWith.UseShowWith end,
					args = {
						intro2 = {
							order = 10,
							type = "description",
							name = L["Show Omen when any of the following are true"],
						},
						Alone = {
							type = "toggle",
							order = 11,
							name = L["You are alone"],
							desc = L["Show Omen when you are alone"],
						},
						Party = {
							type = "toggle",
							order = 12,
							name = L["You are in a party"],
							desc = L["Show Omen when you are in a 5-man party"],
						},
						Raid = {
							type = "toggle",
							order = 13,
							name = L["You are in a raid"],
							desc = L["Show Omen when you are in a raid"],
						},
						Pet = {
							type = "toggle",
							order = 14,
							name = L["You have a pet"],
							desc = L["Show Omen when you have a pet out"],
						},
						intro3 = {
							order = 20,
							type = "description",
							name = L["However, hide Omen if any of the following are true (higher priority than the above)."],
						},
						HideInPVP = {
							type = "toggle",
							order = 21,
							width = "double",
							name = L["You are in a battleground"],
							desc = L["Turning this on will cause Omen to hide whenever you are in a battleground or arena."],
						},
						HideWhileResting = {
							type = "toggle",
							order = 22,
							width = "double",
							name = L["You are resting"],
							desc = L["Turning this on will cause Omen to hide whenever you are in a city or inn."],
						},
						HideWhenOOC = {
							type = "toggle",
							order = 23,
							width = "double",
							name = L["You are not in combat"],
							desc = L["Turning this on will cause Omen to hide whenever you are not in combat."],
							set = function(info, value)
								db.ShowWith.HideWhenOOC = value
								manualToggle = false
								if value then
									Omen:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateVisible")
									Omen:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateVisible")
								else
									Omen:UnregisterEvent("PLAYER_REGEN_DISABLED")
									Omen:UnregisterEvent("PLAYER_REGEN_ENABLED")
								end
								Omen:UpdateVisible()
								Omen:UpdateBars()
							end,
						},
						intro4 = {
							order = 30,
							type = "description",
							name = L["AUTO_SHOW/HIDE_NOTE"],
						},
					},
				},
			},
		},
		ShowClasses = {
			order = 3,
			type = "group",
			name = L["Show Classes..."],
			desc = L["Show Classes..."],
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["SHOW_CLASSES_DESC"],
				},
				Classes = {
					type = "multiselect",
					order = 30,
					name = L["Show bars for these classes"],
					values = showClassesOptionTable,
					get = function(info, k) return db.Bar.Classes[k] end,
					set = function(info, k, v)
						db.Bar.Classes[k] = v
						Omen:UpdateBars()
					end,
				},
			},
		},
		TitleBar = {
			order = 4,
			type = "group",
			name = L["Title Bar Settings"],
			desc = L["Title Bar Settings"],
			get = function(info) return db.TitleBar[ info[#info] ] end,
			set = function(info, value)
				db.TitleBar[ info[#info] ] = value
				Omen:UpdateTitleBar()
				Omen:UpdateBars()
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["Configure title bar settings."],
				},
				ShowTitleBar = {
					type = "toggle",
					order = 2,
					name = L["Show Title Bar"],
					desc = L["Show the Omen Title Bar"],
				},
				Height = {
					type = "range",
					order = 5,
					name = L["Title Bar Height"],
					desc = L["Height of the title bar. The minimum height allowed is twice the background border thickness."],
					min = 2, max = 32, step = 1,
					disabled = function() return not db.TitleBar.ShowTitleBar end,
				},
				TitleText = {
					type = "group",
					name = L["Title Text Options"],
					guiInline = true,
					order = 20,
					set = function(info, value)
						db.TitleBar[ info[#info] ] = value
						Omen:UpdateTitleBar()
					end,
					disabled = function() return not db.TitleBar.ShowTitleBar end,
					args = {
						Font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 1,
							name = L["Font"],
							desc = L["The font that the title text will use"],
							values = AceGUIWidgetLSMlists.font,
						},
						FontOutline = {
							type = "select",
							order = 2,
							name = L["Font Outline"],
							desc = L["The outline that the title text will use"],
							values = outlines,
						},
						FontColor = {
							type = "color",
							order = 3,
							name = L["Font Color"],
							desc = L["The color of the title text"],
							hasAlpha = true,
							get = function(info)
								local t = db.TitleBar.FontColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.TitleBar.FontColor
								t.r, t.g, t.b, t.a = r, g, b, a
								Omen:UpdateTitleBar()
							end,
						},
						FontSize = {
							type = "range",
							order = 4,
							name = L["Font Size"],
							desc = L["Control the font size of the title text"],
							min = 4, max = 30, step = 1,
						},
					},
				},
				UseSameBG = {
					type = "toggle",
					order = 30,
					width = "double",
					name = L["Use Same Background"],
					desc = L["Use the same background settings for the title bar as the main window's background"],
					set = function(info, value)
						db.TitleBar.UseSameBG = value
						Omen:UpdateBackdrop()
					end,
					disabled = function() return not db.TitleBar.ShowTitleBar end,
				},
				Background = {
					type = "group",
					name = L["Title Bar Background Options"],
					guiInline = true,
					order = 31,
					get = function(info) return db.TitleBar[ info[#info] ] end,
					set = function(info, value)
						db.TitleBar[ info[#info] ] = value
						Omen:UpdateBackdrop()
					end,
					disabled = function() return not db.TitleBar.ShowTitleBar or db.TitleBar.UseSameBG end,
					args = {
						Texture = {
							type = "select", dialogControl = 'LSM30_Background',
							order = 1,
							name = L["Background Texture"],
							desc = L["Texture to use for the frame's background"],
							values = AceGUIWidgetLSMlists.background,
						},
						BorderTexture = {
							type = "select", dialogControl = 'LSM30_Border',
							order = 2,
							name = L["Border Texture"],
							desc = L["Texture to use for the frame's border"],
							values = AceGUIWidgetLSMlists.border,
						},
						Color = {
							type = "color",
							order = 3,
							name = L["Background Color"],
							desc = L["Frame's background color"],
							hasAlpha = true,
							get = function(info)
								local t = db.TitleBar.Color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.TitleBar.Color
								t.r, t.g, t.b, t.a = r, g, b, a
								Omen:UpdateBackdrop()
							end,
						},
						BorderColor = {
							type = "color",
							order = 4,
							name = L["Border Color"],
							desc = L["Frame's border color"],
							hasAlpha = true,
							get = function(info)
								local t = db.TitleBar.BorderColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.TitleBar.BorderColor
								t.r, t.g, t.b, t.a = r, g, b, a
								Omen:UpdateBackdrop()
							end,
						},
						Tile = {
							type = "toggle",
							order = 5,
							name = L["Tile Background"],
							desc = L["Tile the background texture"],
						},
						TileSize = {
							type = "range",
							order = 6,
							name = L["Background Tile Size"],
							desc = L["The size used to tile the background texture"],
							min = 16, max = 256, step = 1,
							disabled = function() return not db.TitleBar.ShowTitleBar or db.TitleBar.UseSameBG or not db.TitleBar.Tile end,
						},
						EdgeSize = {
							type = "range",
							order = 7,
							name = L["Border Thickness"],
							desc = L["The thickness of the border"],
							min = 1, max = 16, step = 1,
						},
					},
				},
			},
		},
		Bars = {
			order = 5,
			type = "group",
			name = L["Bar Settings"],
			desc = L["Bar Settings"],
			get = function(info) return db.Bar[ info[#info] ] end,
			set = function(info, value)
				db.Bar[ info[#info] ] = value
				Omen:UpdateBars()
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["Configure bar settings."],
				},
				AnimateBars = {
					type = "toggle",
					order = 2,
					name = L["Animate Bars"],
					desc = L["Smoothly animate bar changes"],
				},
				ShortNumbers = {
					type = "toggle",
					order = 3,
					name = L["Short Numbers"],
					desc = L["Display large numbers in Ks"],
					disabled = function() return not db.Bar.ShowValue end
				},
				Height = {
					type = "range",
					order = 4,
					name = L["Bar Height"],
					desc = L["Height of each bar"],
					min = 5, max = 50, step = 1, bigStep = 1,
					set = function(info, value)
						db.Bar.Height = value
						Omen:ReAnchorBars()
						Omen:ResizeBars()
						Omen:UpdateBars()
					end,
				},
				Spacing = {
					type = "range",
					order = 5,
					name = L["Bar Spacing"],
					desc = L["Spacing between each bar"],
					min = 0, max = 20, step = 1, bigStep = 1,
					set = function(info, value)
						db.Bar.Spacing = value
						Omen:ReAnchorBars()
						Omen:UpdateBars()
					end,
				},
				ShowTPS = {
					type = "toggle",
					order = 6,
					name = L["Show TPS"],
					desc = L["Show threat per second values"],
					set = function(info, value)
						db.Bar.ShowTPS = value
						if db.VGrip1 > db.VGrip2 then
							db.VGrip1, db.VGrip2 = db.VGrip2, db.VGrip1
						end
						movegrip1()
						movegrip2()
						Omen:UpdateGrips()
						local f = Omen.TPSUpdateFrame
						if f then
							if value then f:Show() else f:Hide() end
						end
					end,
				},
				TPSWindow = {
					type = "range",
					order = 7,
					name = L["TPS Window"],
					desc = L["TPS_WINDOW_DESC"],
					min = 3, max = 15, step = 0.1,
					disabled = function() return not db.Bar.ShowTPS end,
				},
				ShowValue = {
					type = "toggle",
					order = 8,
					name = L["Show Threat Values"],
					desc = L["Show Threat Values"],
					set = function(info, value)
						db.Bar.ShowValue = value
						if not value then
							db.Bar.ShowPercent = true
							bars[0].Text2:SetText(L["Threat"])
						elseif db.Bar.ShowPercent then
							bars[0].Text2:SetText(L["Threat [%]"])
						end
						Omen:UpdateBars()
					end,
				},
				ShowPercent = {
					type = "toggle",
					order = 9,
					name = L["Show Threat %"],
					desc = L["Show Threat %"],
					set = function(info, value)
						db.Bar.ShowPercent = value
						if not value then
							db.Bar.ShowValue = true
							bars[0].Text2:SetText(L["Threat"])
						elseif db.Bar.ShowValue then
							bars[0].Text2:SetText(L["Threat [%]"])
						end
						Omen:UpdateBars()
					end,
				},
				ShowHeadings = {
					type = "toggle",
					order = 11,
					name = L["Show Headings"],
					desc = L["Show column headings"],
					set = function(info, value)
						db.Bar.ShowHeadings = value
						Omen:ReAnchorBars()
						Omen:UpdateBars()
					end,
				},
				HeadingBGColor = {
					type = "color",
					order = 12,
					name = L["Heading BG Color"],
					desc = L["Heading background color"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.HeadingBGColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.HeadingBGColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBarLabelSettings()
						Omen:UpdateBars()
					end,
					disabled = function() return not db.Bar.ShowHeadings end,
				},
				UseMyBarColor = {
					type = "toggle",
					order = 13,
					name = L["Use 'My Bar' color"],
					desc = L["Use a different colored background for your threat bar in Omen"],
				},
				MyBarColor = {
					type = "color",
					order = 14,
					name = L["'My Bar' BG Color"],
					desc = L["The background color for your threat bar"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.MyBarColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.MyBarColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBars()
					end,
					disabled = function() return not db.Bar.UseMyBarColor end,
				},
				UseTankBarColor = {
					type = "toggle",
					order = 15,
					name = L["Use Tank Bar color"],
					desc = L["Use a different colored background for the tank's threat bar in Omen"],
				},
				TankBarColor = {
					type = "color",
					order = 16,
					name = L["Tank Bar Color"],
					desc = L["The background color for your tank's threat bar"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.TankBarColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.TankBarColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBars()
					end,
					disabled = function() return not db.Bar.UseTankBarColor end,
				},
				ShowAggroBar = {
					type = "toggle",
					order = 17,
					name = L["Show Pull Aggro Bar"],
					desc = L["Show a bar for the amount of threat you will need to reach in order to pull aggro."],
				},
				AggroBarColor = {
					type = "color",
					order = 18,
					name = L["Pull Aggro Bar Color"],
					desc = L["The background color for your Pull Aggro bar"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.AggroBarColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.AggroBarColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBars()
					end,
					disabled = function() return not db.Bar.ShowAggroBar end,
				},
				UseClassColors = {
					type = "toggle",
					order = 21,
					name = L["Use Class Colors"],
					desc = L["Use standard class colors for the background color of threat bars"],
				},
				PetBarColor = {
					type = "color",
					order = 22,
					name = L["Pet Bar Color"],
					desc = L["The background color for pets"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.PetBarColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.PetBarColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBars()
					end,
					disabled = function() return not db.Bar.UseClassColors end,
				},
				UseCustomClassColors = {
					type = "toggle",
					order = 23,
					name = L["Use !ClassColors"],
					desc = L["Use !ClassColors addon for class colors for the background color of threat bars"],
					set = function(info, v)
						db.Bar.UseCustomClassColors = v
						Omen:UpdateRaidClassColors()
					end,
					disabled = function() return not db.Bar.UseClassColors or not CUSTOM_CLASS_COLORS end,
				},
				FadeBarColor = {
					type = "color",
					order = 24,
					name = L["Temp Threat Bar Color"],
					desc = L["The background color for players under the effects of Fade, Mirror Image, glyphed Hand of Salvation, Tricks of the Trade and Misdirection"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.FadeBarColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.FadeBarColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBars()
					end,
				},
				BarColor = {
					type = "color",
					order = 25,
					name = L["Bar BG Color"],
					desc = L["The background color for all threat bars"],
					hasAlpha = true,
					get = function(info)
						local t = db.Bar.BarColor
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = db.Bar.BarColor
						t.r, t.g, t.b, t.a = r, g, b, a
						Omen:UpdateBars()
					end,
					disabled = function() return db.Bar.UseClassColors end,
				},
				AlwaysShowSelf = {
					type = "toggle",
					order = 26,
					name = L["Always Show Self"],
					desc = L["Always show your threat bar on Omen (ignores class filter settings), showing your bar on the last row if necessary"],
				},
				InvertColors = {
					type = "toggle",
					order = 27,
					name = L["Invert Bar/Text Colors"],
					desc = L["Switch the colors so that the bar background colors and the text colors are swapped."],
					set = function(info, v)
						db.Bar.InvertColors = v
						Omen:UpdateBarLabelSettings()
						Omen:UpdateBars()
					end,
				},
				Texture = {
					type = "select", dialogControl = 'LSM30_Statusbar',
					order = 29,
					name = L["Bar Texture"],
					desc = L["The texture that the bar will use"],
					values = AceGUIWidgetLSMlists.statusbar,
					set = function(info, v)
						db.Bar.Texture = v
						Omen:UpdateBarTextureSettings()
					end,
				},
				BarLabelsGroup = {
					type = "group",
					name = L["Bar Label Options"],
					guiInline = true,
					order = 30,
					set = function(info, v)
						db.Bar[ info[#info] ] = v
						Omen:UpdateBarLabelSettings()
						Omen:UpdateBars()
					end,
					args = {
						Font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 1,
							name = L["Font"],
							desc = L["The font that the labels will use"],
							values = AceGUIWidgetLSMlists.font,
						},
						FontOutline = {
							type = "select",
							order = 2,
							name = L["Font Outline"],
							desc = L["The outline that the labels will use"],
							values = outlines,
						},
						FontColor = {
							type = "color",
							order = 3,
							name = L["Font Color"],
							desc = L["The color of the labels"],
							hasAlpha = true,
							get = function(info)
								local t = db.Bar.FontColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.Bar.FontColor
								t.r, t.g, t.b, t.a = r, g, b, a
								Omen:UpdateBarLabelSettings()
								Omen:UpdateBars()
							end,
						},
						FontSize = {
							type = "range",
							order = 4,
							name = L["Font Size"],
							desc = L["Control the font size of the labels"],
							min = 4, max = 30, step = 1,
						},
					},
				},
			},
		},
		Warnings = {
			order = 6,
			type = "group",
			name = L["Warning Settings"],
			desc = L["Warning Settings"],
			get = function(info) return db.Warnings[ info[#info] ] end,
			set = function(info, value)
				db.Warnings[ info[#info] ] = value
			end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["OMEN_WARNINGS_DESC"],
				},
				Sound = {
					type = "toggle",
					order = 2,
					name = L["Enable Sound"],
					desc = L["Causes Omen to play a chosen sound effect"],
				},
				Flash = {
					type = "toggle",
					order = 3,
					name = L["Enable Screen Flash"],
					desc = L["Causes the entire screen to flash red momentarily"],
				},
				Shake = {
					type = "toggle",
					order = 4,
					name = L["Enable Screen Shake"],
					desc = L["Causes the entire game world to shake momentarily. This option only works if nameplates are turned off."],
				},
				Message = {
					type = "toggle",
					order = 5,
					name = L["Enable Warning Message"],
					desc = L["Print a message to screen when you accumulate too much threat"],
				},
				Output = Omen:GetSinkAce3OptionsDataTable(),
				Threshold = {
					type = "range",
					order = 7,
					name = L["Warning Threshold %"],
					desc = L["Warning Threshold %"],
					min = 60, max = 130, step = 1,
				},
				SoundFile = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 8,
					name = L["Sound to play"],
					desc = L["Sound to play"],
					values = AceGUIWidgetLSMlists.sound,
					disabled = function() return not db.Warnings.Sound end,
				},
				DisableWhileTanking = {
					type = "toggle",
					order = 9,
					name = L["Disable while tanking"],
					desc = L["DISABLE_WHILE_TANKING_DESC"],
				},
				test = {
					type = "execute",
					order = -1,
					name = L["Test warnings"],
					desc = L["Test warnings"],
					func = function()
						local t = db.Warnings
						Omen:Warn(t.Sound, t.Flash, t.Shake, t.Message and L["Test warnings"])
					end,
				},
			},
		},
		FuBar = {
			order = -4,
			type = "group",
			name = L["FuBar Options"],
			desc = L["FuBar Options"],
			hidden = function() return Omen.IsFuBarMinimapAttached == nil end,
			args = {
				hideIcon = {
					type = "toggle",
					order = 1,
					name = L["Hide minimap/FuBar icon"],
					desc = L["Hide minimap/FuBar icon"],
					get = function(info) return db.FuBar.HideMinimapButton end,
					set = function(info, v)
						db.FuBar.HideMinimapButton = v
						Omen:UpdateFuBarSettings()
					end,
				},
				attachMinimap = {
					type = "toggle",
					order = 2,
					name = L["Attach to minimap"],
					desc = L["Attach to minimap"],
					get = function(info) return Omen:IsFuBarMinimapAttached() end,
					set = function(info, v)
						Omen:ToggleFuBarMinimapAttached()
						db.FuBar.AttachMinimap = Omen:IsFuBarMinimapAttached()
					end,
					disabled = function() return db.FuBar.HideMinimapButton end,
				},
				showIcon = {
					type = "toggle",
					order = 3,
					name = L["Show icon"],
					desc = L["Show icon"],
					get = function(info) return Omen:IsFuBarIconShown() end,
					set = function(info, v) Omen:ToggleFuBarIconShown() end,
					disabled = GetFuBarMinimapAttachedStatus,
				},
				showText = {
					type = "toggle",
					order = 4,
					name = L["Show text"],
					desc = L["Show text"],
					get = function(info) return Omen:IsFuBarTextShown() end,
					set = function(info, v) Omen:ToggleFuBarTextShown() end,
					disabled = GetFuBarMinimapAttachedStatus,
				},
				position = {
					type = "select",
					order = 5,
					name = L["Position"],
					desc = L["Position"],
					values = {LEFT = L["Left"], CENTER = L["Center"], RIGHT = L["Right"]},
					get = function() return Omen:GetPanel() and Omen:GetPanel():GetPluginSide(Omen) end,
					set = function(info, val)
						if Omen:GetPanel() and Omen:GetPanel().SetPluginSide then
							Omen:GetPanel():SetPluginSide(Omen, val)
						end
					end,
					disabled = GetFuBarMinimapAttachedStatus,
				}
			}
		},
		Help = {
			type = "group",
			order = -1,
			name = L["Help File"],
			desc = L["A collection of help pages"],
			childGroups = "select",
			args = {
				FAQ1 = {
					type = "group",
					order = 1,
					name = L["FAQ Part 1"],
					args = {
						header = {
							type = "header",
							name = L["Frequently Asked Questions"],
							order = 0,
						},
						text = {
							order = 1,
							type = "description",
							name = L["GENERAL_FAQ"],
						},
					},
				},
				FAQ2 = {
					type = "group",
					order = 2,
					name = L["FAQ Part 2"],
					args = {
						header = {
							type = "header",
							name = L["Frequently Asked Questions"],
							order = 0,
						},
						text = {
							order = 1,
							type = "description",
							name = L["GENERAL_FAQ2"],
						},
					},
				},
--[[
				WARRIOR = {
					type = "group",
					name = L["Warrior"],
					args = {
						header = {
							type = "header",
							name = L["Warrior"],
							order = 0,
						},
						text = {
							order = 1,
							type = "description",
							name = L["WARRIOR_FAQ"],
						},
					},
				},
]]
			},
		},
	},
}
Omen.Options.args.Warnings.args.Output.order = 6
Omen.Options.args.Warnings.args.Output.inline = true
Omen.Options.args.Warnings.args.Output.disabled = function() return not db.Warnings.Message end

	for k, v in pairs(moduleOptions) do
		Omen.Options.args[k] = (type(v) == "function") and v() or v
	end

	-- Add ordering data to the option table generated by AceDBOptions-3.0
	Omen.Options.args.Profiles.order = -2

	local h = db.Background.EdgeSize * 2
	if not db.TitleBar.UseSameBG then h = db.TitleBar.EdgeSize * 2 end
	Omen.Options.args.TitleBar.args.Height.min = h
end

