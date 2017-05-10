return function(message,allowsNode)
	local content = message.content or message
	content = content:lower()
	
	local commands = framework.modules.commands
	if commands then
		for i,v in pairs(commands.commands) do
			if content:find(i) then
				return i
			else
				if allowsNode then
					local command = commands:makeCommand(message,i,v)
					local help = framework.modules.help(command)
					if help and help.category == content then
						return help.category
					end
				end
			end
		end
	end
	
end