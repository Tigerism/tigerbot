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

function logger:newModLog(guild,user,options)
	options = options or {}
	options.timestamp = os.time()
	if options.duration then
		if options.duration ~= "none" then
			--timed action
			options.expiresOn = os.time() + options.duration
			options.duration = nil
			framework.modules.timedActions[1](true,guild.id,user.id,options)
			framework.modules.db[1]:set("pendingActions/"..guild.id.."/"..user.id.."/","user",options)
		else
			if options.type == "Ban" or options.type == "Mute" then
			--permanent action
				options.duration = nil	
			end
			
		end
	else
		if options.type == "Unban" or options.type == "Unmute" then
			framework.modules.timedActions[1](false,guild.id,user.id,options)	
		end
	end
	local logNumber = framework.modules.db[1]:get("guilds/"..guild.id.."/logs/"..user.id.."/logNumber") or 0
	logNumber = logNumber + 1
	framework.modules.db[1]:set("guilds/"..guild.id.."/logs/"..user.id.."/","logNumber",{logNumber = logNumber})
	framework.modules.db[1]:set("guilds/"..guild.id.."/logs/"..user.id.."/"..logNumber,"logs",options)
end


return logger