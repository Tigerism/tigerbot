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

function logger:newModLog(guild,offender,options)
	options.timestamp = os.time()
	local logNumber = framework.modules.db[1]:get("guilds/"..guild.."/logs/"..offender.."/logNumber") or 0
	logNumber = logNumber + 1
	framework.modules.db[1]:set("guilds/"..guild.."/logs/"..offender.."/","logNumber",{logNumber = logNumber})
	framework.modules.db[1]:set("guilds/"..guild.."/logs/"..offender.."/"..logNumber,"logs",options)
end


return logger