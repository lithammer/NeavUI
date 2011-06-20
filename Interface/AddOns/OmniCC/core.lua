--[[
	OmniCC Basic
    
    A featureless, 'pure' version of OmniCC.
    This version should work on absolutely everything, but I've removed pretty much all of the options
--]]

OmniCC = true                               -- hack to work around detection from other addons for OmniCC

local FONT_COLOR = {1, 1, 1}
local FONT_FACE, FONT_SIZE = 'Fonts\\ARIALN.ttf', 18 

local MIN_DURATION = 2.5                    -- the minimum duration to show cooldown text for
local DECIMAL_THRESHOLD = 2                 -- threshold in seconds to start showing decimals

local MIN_SCALE = 0.5                       -- the minimum scale we want to show cooldown counts at, anything below this will be hidden
local ICON_SIZE = 36

local DAY, HOUR, MINUTE = 86400, 3600, 60
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5

local GetTime = GetTime

local min = math.min
local floor = math.floor
local format = string.format

local round = function(x) 
    return floor(x + 0.5) 
end

local function getTimeText(s)
	if (s < DECIMAL_THRESHOLD + 0.5) then
		return format('|cffff0000%.1f|r', s), s - format('%.1f', s)
	elseif (s < MINUTEISH) then
		local seconds = round(s)
		return format('|cffffff00%d|r', seconds), s - (seconds - 0.51)
	elseif (s < HOURISH) then
		local minutes = round(s/MINUTE)
		return format('|cffffffff%dm|r', minutes), minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
	elseif (s < DAYISH) then
		local hours = round(s/HOUR)
		return format('|cffccccff%dh|r', hours), hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
	else
		local days = round(s/DAY)
		return format('|cffcccccc%dd|r', days), days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

    -- stops the timer

local function Timer_Stop(self)
	self.enabled = nil
	self:Hide()
end

    -- forces the given timer to update on the next frame

local function Timer_ForceUpdate(self)
	self.nextUpdate = 0
	self:Show()
end

    -- adjust font size whenever the timer's parent size changes, hide if it gets too tiny

local function Timer_OnSizeChanged(self, width, height)
	local fontScale = round(width) / ICON_SIZE

	if (fontScale == self.fontScale) then
		return
	end

	self.fontScale = fontScale

	if (fontScale < MIN_SCALE) then
		self:Hide()
	else
		self.text:SetFont(FONT_FACE, fontScale * FONT_SIZE, 'OUTLINE')
		self.text:SetShadowColor(0, 0, 0, 0.5)
		self.text:SetShadowOffset(2, -2)
        
		if (self.enabled) then
			Timer_ForceUpdate(self)
		end
	end
end

    -- update timer text, if it needs to be, hide the timer if done

local function Timer_OnUpdate(self, elapsed)
	if (self.nextUpdate > 0) then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if (round(remain) > 0) then
			local time, nextUpdate = getTimeText(remain)
			self.text:SetText(time)
			self.nextUpdate = nextUpdate
		else
			Timer_Stop(self)
		end
	end
end

    -- returns a new timer object

local function Timer_Create(self)
	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame('Frame', nil, scaler)
    timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript('OnUpdate', Timer_OnUpdate)

	local text = timer:CreateFontString(nil, 'BACKGROUND ')
	text:SetPoint('CENTER', 0, 0)
	text:SetJustifyH("CENTER")
	timer.text = text

	Timer_OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript('OnSizeChanged', function(self, ...) 
        Timer_OnSizeChanged(timer, ...) 
    end)

	self.timer = timer

	return timer
end

    -- hook the SetCooldown method of all cooldown frames
    -- ActionButton1Cooldown is used here since its likely to always exist 
    -- and I'd rather not create my own cooldown frame to preserve a tiny bit of memory

hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', function(self, start, duration)
	if (self.noOCC) then 
        return 
    end

	if (start > 0 and duration > MIN_DURATION) then
		local timer = self.timer or Timer_Create(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0

		if (timer.fontScale >= MIN_SCALE) then 
            timer:Show() 
        end
	else
		local timer = self.timer
        
        if (timer) then
            Timer_Stop(timer)
        end
    end
end)