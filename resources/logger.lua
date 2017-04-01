local logger = {}

local http = require("coro-http")
local json = require("json")

local webhook = "https://discordapp.com/api/webhooks/"..client.settings.logger.status[1].."/"..client.settings.logger.status[2]

function logger:sendLog(title,description,color)
    local post = {
	  embeds = {
			{
				title = title,
				description = description,
				color = color
			}
		}
	}	
	http.request("POST",webhook,{{"Content-Type","application/json"}},json.encode(post))	
end


return logger