local User = {}
local client

local function init(bot)
	client = bot
	return User
end

function User:getMatch(command,myArgs,currentArg,message)
	--[[local mentions = message.mentions
	if #mentions > 0 then return mentions[1] end
	local server = message.server
	local joined = table.concat(myArgs," ")]]
	
	
end


return init