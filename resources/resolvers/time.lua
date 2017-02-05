local Time = {
	timeTables = {	
		m = {60,{"minute","minutes"}},
		h = {3600,{"hour","hours"}},
		d = {86400,{"day","days"}},
		w = {604800,{"week","weeks"}},
		mo = {2592000,{"month","months"}},
		y = {31536000,{"year","years"}} -- O_O
	}
}

function Time:calculate(seconds)
	local minutes = nil
	local hours = nil
	hours = math.floor(seconds/3600)
	local divisor_for_minutes = seconds % (60 * 60)
	minutes = math.floor(divisor_for_minutes / 60)
	local divisor_for_seconds = divisor_for_minutes % 60
	seconds = math.ceil(divisor_for_seconds)
	return hours..(hours == 1 and " hour, " or " hours, ")..minutes..(minutes == 1 and " minute, " or " minutes, ")..seconds..(seconds == 1 and " second " or " seconds")
end

function Time:resolve(content)
	local duration,day = string.match(content, '(%S+) (.*)')
	if not day then day = content duration = content end
	for i,v in pairs(Time.timeTables) do
		if day == i or content:sub(#content) == i then
			if tonumber(duration) then
				return tonumber(duration) * v[1]
			else
				content = content:gsub(i,"")
				content = content:gsub(" ","")
				if tonumber(content) then
					return content * v[1]
				end
			end
		else
			for l,k in pairs(v[2]) do
				if day == k or content:sub(#content) == k then
					if tonumber(duration) then
						return tonumber(duration) * v[1]
					else
						content = content:gsub(i,"")
						content = content:gsub(" ","")
						if tonumber(content) then
							return content * v[1]
						end
					end
				end
			end
		end
	end
end

local function init(client)
	return Time
end

return init