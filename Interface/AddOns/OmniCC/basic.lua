--[[
	OmniCC Basic
		A featureless, 'pure' version of OmniCC.
		This version should work on absolutely everything, but I've removed pretty much all of the options
--]]

--local TEXT_FONT = "Fonts\\ARIALN.ttf" 
local TEXT_FONT = "Interface\\AddOns\\OmniCC\\font.ttf" 
local FONT_SIZE = 14
local MIN_SCALE = 0.5
local MIN_DURATION = 3
local R, G, B = 1, 1, 1

local i
local _G = getfenv(0)
local ClassColors = {}
local strformat, strfind = string.format, string.find

for k, v in pairs(RAID_CLASS_COLORS) do
	ClassColors[k] = strformat("%2x%2x%2x", v.r*255, v.g*255, v.b*255)
end

local function classHexColor(unit)
	_, v = UnitClass(unit)
	if v and ClassColors[v] then
		return ClassColors[v]
	else
		return "FFFFFF"
	end
end

local format = string.format
local floor = math.floor
local min = math.min
--[[
local function GetFormattedTime(s)
	if s >= 86400 then
		return format("|cffffffff%d|r|cff"..classHexColor("player").."d|r", floor(s/86400 + 0.5)), s % 86400
	elseif s >= 3600 then
		return format("|cffffffff%d|r|cff"..classHexColor("player").."h|r", floor(s/3600 + 0.5)), s % 3600
	elseif s >= 60 then
		return format("|cffffffff%d|r|cff"..classHexColor("player").."m|r", floor(s/60 + 0.5)), s % 60
	end
	return floor(s + 0.5), s - floor(s)
end
]]

local function GetFormattedTime(s)
	if s >= 86400 then
		return format("%dd", ceil(s / 86400)), s % 86400
	elseif s >= 3600 then
		return format("%dh", ceil(s / 3600)), s % 3600
	elseif s >= 60 then
		return format("%dm", ceil(s / 60)), s % 60
	elseif s < 2 then
		return format('|cffff0000%.1f|r', s), (s * 100 - floor(s * 100))/100
	end
	return floor(s), s - floor(s)
end

local function Timer_OnUpdate(self, elapsed)
	if self.text:IsShown() then
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			if (self:GetEffectiveScale()/UIParent:GetEffectiveScale()) < MIN_SCALE then
				self.text:SetText("")
				self.nextUpdate = 0.5
			else
				local remain = self.duration - (GetTime() - self.start)
				if floor(remain + 0.5) > 0 then
					local time, nextUpdate = GetFormattedTime(remain)
					self.text:SetText(time)
					self.nextUpdate = nextUpdate
				else
					self.text:Hide()
				end
			end
		end
	end
end

local function Timer_Create(self)
	local scale = min(self:GetParent():GetWidth() / 32, 1)
	if scale < MIN_SCALE then
		self.noOCC = true
	else
		local text = self:CreateFontString(nil, "OVERLAY")
		--text:SetPoint("CENTER", 0, 0)
		text:SetPoint("CENTER", -7, 7)
		text:SetFont(TEXT_FONT, (FONT_SIZE * scale) * 1.2, "OUTLINE")
		text:SetTextColor(R, G, B)

		self.text = text
		self:SetScript("OnUpdate", Timer_OnUpdate)
		return text
	end
end

local function Timer_Start(self, start, duration)
	self.start = start
	self.duration = duration
	self.nextUpdate = 0

	local text = self.text or (not self.noOCC and Timer_Create(self))
	if text then
		text:Show()
	end
end

local methods = getmetatable(ActionButton1Cooldown).__index
hooksecurefunc(methods, "SetCooldown", function(self, start, duration)
	if start > 0 and duration > MIN_DURATION then
		Timer_Start(self, start, duration)
	else
		local text = self.text
		if text then
			text:Hide()
		end
	end
end)
