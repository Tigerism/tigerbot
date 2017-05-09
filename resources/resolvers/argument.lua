return function(command,myArgs,neededArgs,message,emitter)
	local newArgs = {}
	for i,v in pairs(neededArgs) do
		if framework.modules.resolvers[v] then
			local match
			if myArgs[i] then
				match = framework.modules.resolvers[v][1](message,myArgs[i])
			else
				match = framework.modules.respond(message,emitter):args{
					{
						prompt = "Please specify the **"..v.."** argument.",
						type = v,
						name = "res"
					}
				}
				
			end
			if match then
				table.insert(newArgs,(match["res"]) or match)
			else
				message.parent:sendMessage("Invalid usage. ``"..v.."`` not found.")
				return
			end
		end
	end
	return newArgs
end