local client

local Argument = {}

local function init(bot)
	client = bot
	return Argument
end

function Argument:extract(command,myArgs,message)
	local args = command.args
	for i,v in pairs(args) do
		if client.resolvers[v] then
			client.resolvers[v](command,myArgs,message)
		end
	end
end



return init