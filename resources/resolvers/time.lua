
local discordia = require("discordia")

local timeResolver = {
	timeTables = {	
		m = {60,{"minute","minutes"}},
		h = {3600,{"hour","hours"}},
		d = {86400,{"day","days"}},
		w = {604800,{"week","weeks"}},
		mo = {2592000,{"month","months"}},
		y = {31536000,{"year","years"}}
	}
}

function timeResolver:toHumanTime(seconds,shortTime)
	local days = math.floor(seconds/86400)
	local hours = math.floor((seconds/3600)%24)
	local divisor_for_minutes = seconds % (60 * 60)
	local minutes = math.floor(divisor_for_minutes / 60)
	local divisor_for_seconds = divisor_for_minutes % 60
	seconds = math.ceil(divisor_for_seconds)
    local time = ""
    if days ~= 0 then
        if days == 1 then
            time = "1 day"
        else
            time = days.." days"
        end
        if shortTime then
            return time
        else
            time = time.." "
	   end
    end
    
    if hours ~= 0 then
        if hours == 1 then
            time = time.."1 hour"
        else
            time = time..hours.." hours"
        end
        if shortTime then
            return time
        else
            time = time.." "
	   end
    end 

    if minutes ~= 0 then
        if minutes == 1 then
            time = time.."1 minute"
        else
            time = time..minutes.." minutes"
        end
        if shortTime then
            return time
        else
            time = time.." "
	   end
    end 

    if seconds ~= 0 then
        if seconds == 1 then
            time = time.."1 second"
        else
            time = time..seconds.." seconds"
        end
        if shortTime then
            return time
	   end
    end 

    return time  
    
end




return timeResolver