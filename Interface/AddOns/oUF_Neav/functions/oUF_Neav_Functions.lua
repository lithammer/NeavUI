
local _, ns = ...

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

function ns.FormatTime(time)
    if (time >= day) then
        return format('%dd', floor(time/day + 0.5))
    elseif (time>= hour) then
        return format('%dh', floor(time/hour + 0.5))
    elseif (time >= minute) then
        return format('%dm', floor(time/minute + 0.5))
    end

    return format('%d', fmod(time, minute))
end

function ns.DeficitValue(self)
    if (self >= 1000) then
		return format('-%.1f', self/1000)
	else
		return self
	end
end

function ns.FormatValue(self)
    if (self >= 1000000) then
		return ('%.2fm'):format(self / 1e6)
        -- return ('%.3fK'):format(self / 1e6):gsub('%.', 'M ')
    elseif (self >= 100000) then
		return ('%.1fk'):format(self / 1e3)
        -- return ('%.3f'):format(self / 1e3):gsub('%.', 'K ')
    else
        return self
    end
end

function ns.MultiCheck(what, ...)
    for i = 1, select('#', ...) do
        if (what == select(i, ...)) then 
            return true 
        end
    end
    
    return false
end

function ns.utf8sub(string, index)
	local bytes = string:len()
	if (bytes <= index) then
		return string
	else
		local length, currentIndex = 0, 1

		while currentIndex <= bytes do
			length = length + 1
			local char = string:byte(currentIndex)
            
			if (char > 240) then
				currentIndex = currentIndex + 4
			elseif (char > 225) then
				currentIndex = currentIndex + 3
			elseif (char > 192) then
				currentIndex = currentIndex + 2
			else
				currentIndex = currentIndex + 1
			end

			if (length == index) then
				break
			end
		end

		if (length == index and currentIndex <= bytes) then
			return string:sub(1, currentIndex - 1)
		else
			return string
		end
	end
end
