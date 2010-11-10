--[[
	OmniCC Basic
		A featureless, 'pure' version of OmniCC.
		This version should work on absolutely everything, but I've removed pretty much all of the options
--]]

--constants!
OmniCC = true --hack to work around detection from other addons for OmniCC
local ICON_SIZE = 36 --the normal size for an icon (don't change this)
local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times

--configuration settings
local FONT_FACE = 'Fonts\\ARIALN.ttf' --what font to use
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local MIN_SCALE = 0.5 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 3 --the minimum number of seconds a cooldown's duration must be to display text
local EXPIRING_DURATION = 3 --the minimum number of seconds a cooldown must be to display in the expiring format
local EXPIRING_FORMAT = '|cffff0000%.1f|r' --format for timers that are soon to expire
local SECONDS_FORMAT = '|cffffff00%d|r' --format for timers that have seconds remaining
local MINUTES_FORMAT = '|cffffffff%dm|r' --format for timers that have minutes remaining
local HOURS_FORMAT = '|cff66ffff%dh|r' --format for timers that have hours remaining
local DAYS_FORMAT = '|cff6666ff%dh|r' --format for timers that have days remaining

--local bindings!
local floor = math.floor
local min = math.min
local round = function(x) return floor(x + 0.5) end
local GetTime = GetTime

--returns both what text to display, and how long until the next update
local function getTimeText(s)
	--format text as seconds with decimal
	if round(s) < EXPIRING_DURATION then
		return EXPIRING_FORMAT, s, (s*10 - floor(s*10)) / 10
	--format text as seconds when below a minute
	elseif s < MINUTEISH then
		local seconds = round(s)
		return SECONDS_FORMAT, seconds, s - (seconds - 0.51)
	--format text as minutes when below an hour
	elseif s < HOURISH then
		local minutes = round(s/MINUTE)
		return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
	--format text as hours when below a day
	elseif s < DAYISH then
		local hours = round(s/HOUR)
		return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
	--format text as days
	else
		local days = round(s/DAY)
		return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

local function Timer_SetNextUpdate(self, nextUpdate)
	self.updater:GetAnimations():SetDuration(nextUpdate)
	if self.updater:IsPlaying() then
		self.updater:Stop()
	end
	self.updater:Play()
end

--stops the timer
local function Timer_Stop(self)
	self.enabled = nil
	if self.updater:IsPlaying() then
		self.updater:Stop()
	end
	self:Hide()
end

local function Timer_UpdateText(self)
	local remain = self.duration - (GetTime() - self.start)
	if round(remain) > 0 then
		if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < MIN_SCALE then
			self.text:SetText('')
			Timer_SetNextUpdate(self, 1)
		else
			local formatStr, time, nextUpdate = getTimeText(remain)
			self.text:SetFormattedText(formatStr, time)
			Timer_SetNextUpdate(self, nextUpdate)
		end
	else
		Timer_Stop(self)
	end
end

--forces the given timer to update on the next frame
local function Timer_ForceUpdate(self)
	Timer_UpdateText(self)
	self:Show()
end

--adjust font size whenever the timer's parent size changes
--hide if it gets too tiny
local function Timer_OnSizeChanged(self, width, height)
	local fontScale = round(width) / ICON_SIZE
	if fontScale == self.fontScale then
		return
	end

	self.fontScale = fontScale
	if fontScale < MIN_SCALE then
		self:Hide()
	else
		self.text:SetFont(FONT_FACE, fontScale * FONT_SIZE, 'OUTLINE')
		self.text:SetShadowColor(0, 0, 0, 0.5)
		self.text:SetShadowOffset(2, -2)
		if self.enabled then
			Timer_ForceUpdate(self)
		end
	end
end

--returns a new timer object
local function Timer_Create(self)
	--a frame to watch for OnSizeChanged events
	--needed since OnSizeChanged has funny triggering if the frame with the handler is not shown
	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame('Frame', nil, scaler); timer:Hide()
	timer:SetAllPoints(scaler)

	local updater = timer:CreateAnimationGroup()
	updater:SetLooping('NONE')
	updater:SetScript('OnFinished', function(self) Timer_UpdateText(timer) end)

	local a = updater:CreateAnimation('Animation'); a:SetOrder(1)
	timer.updater = updater

	local text = timer:CreateFontString(nil, 'OVERLAY')
	text:SetPoint('TOPLEFT', 0, 0)
	text:SetFont(FONT_FACE, FONT_SIZE, 'OUTLINE')
	text:SetJustifyH("CENTER")
	timer.text = text

	Timer_OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript('OnSizeChanged', function(self, ...) Timer_OnSizeChanged(timer, ...) end)

	self.timer = timer
	return timer
end

--hook the SetCooldown method of all cooldown frames
--ActionButton1Cooldown is used here since its likely to always exist
--and I'd rather not create my own cooldown frame to preserve a tiny bit of memory
hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', function(self, start, duration)
	if self.noOCC then return end
	--start timer
	if start > 0 and duration > MIN_DURATION then
		local timer = self.timer or Timer_Create(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		Timer_UpdateText(timer)
		if timer.fontScale >= MIN_SCALE then timer:Show() end
	--stop timer
	else
		local timer = self.timer
		if timer then
			Timer_Stop(timer)
		end
	end
end)

