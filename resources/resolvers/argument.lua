return function(command,myArgs,neededArgs,message,emitter)
	local newArgs = {}
	for i,v in pairs(neededArgs) do
		if framework.modules.resolvers[v[1]] then
			local match
			local args = {}
			local args2 = {}
			local x = 0
			for l,k in pairs(v) do
				x = x + 1
				if x ~= 1 and x ~= 2 then
					table.insert(args,k)
					if type(k) == "table" then
						args2[l] = k
					end
				end
			end
			if myArgs[i] then
				match = framework.modules.resolvers[v[1]][1][1]:resolve(message,myArgs[i],table.unpack(args))
			else
				args2["prompt"] = (v[2] or "Please specify the **"..v[1].."** argument.")
				args2["type"] = v[1]
				args2["name"] = "res"
				match = framework.modules.respond[1](message,emitter):args({args2})
				
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