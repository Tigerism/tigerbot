local Events = {}

local function init(client)
	local commands = client.commands
	client:on("messageCreate",function(message)
		commands:newMsg(message)
	end)
end

return init