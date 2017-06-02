return function(command,myArgs,neededArgs,message,emitter)
	local newArgs = {}
	for i,v in pairs(neededArgs) do
		if framework.modules.resolvers[v[1]] then
			local match
			if myArgs[i] then
				match = framework.modules.resolvers[v[1]][1][1]:resolve(message,myArgs[i])
			else
				match = framework.modules.respond[1](message,emitter):args{
					{
						prompt = (v[2] or "Please specify the **"..v[1].."** argument."),
						type = v[1],
						name = "res"
					}
				}
				
			end
			if match then
				match = (type(match) ~= "string" and type(match) ~= "number" and match["res"]) or match
				table.insert(newArgs,match)
			else
				message.parent:sendMessage("Invalid usage: ``"..v[1].."`` not found.")
				return
			end
		end
	end
	return newArgs
end