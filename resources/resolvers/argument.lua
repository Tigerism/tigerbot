local client

local Argument = {}

local function init(bot)
	client = bot
	return Argument
end

function Argument:extract(command,myArgs,message)
	local args = command.args
	local newArgs = {}
	for i,v in pairs(args) do
		if client.resolvers[v] then
			local match = client.resolvers[v]:getMatch(command,myArgs,myArgs[i],message)
			if match then
				newArgs[v] = match
			else
				message.parent:sendMessage("Invalid usage. ``"..v.."`` not found.")
				break
			end
		end
	end
	return match
end



return init