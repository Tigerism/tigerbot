local Command = {commands=framework:getFiles(module.dir.."/../commands/")}
local prefixes = settings.prefixes

function Command:checkPermission(message,command)
	local member = message.member
	local author = message.author
	local guild = message.guild
	local channel = message.channel
	local category = command.help.category
	
	if category == "dev" and author.id ~= "260157417445130241" then return "This command is reserved for the bot developer." end
	
	local memberPermissions = framework.modules.permissions[1]:getMemberPermissions(member)
	member.permissions = memberPermissions
	
	local highestRole
	for role in member.roles do
		if highestRole then
			if highestRole.position < role.position then
				highestRole = role
			end
		else
			highestRole = role
		end
	end
	if not highestRole then highestRole = guild.defaultRole end
	member.highestRole = highestRole
	if author.id == "260157417445130241" then return end
	local permissions = framework.modules.db[1]:get("guilds/"..guild.id.."/perms") or {}
		
	if category ~= "dev" then
		if permissions.user then
			if permissions.user[author.id] then
				if permissions.user[author.id].deny and guild.owner.id ~= author.id then
					if permissions.user[author.id].deny[category] or permissions.user[author.id].deny[command.name] or (permissions.user[author.id].deny[category] and permissions.user[author.id].deny[category].all) then
						return "User permissions restrict you from using this command."
					end
				end
				if permissions.user[author.id].grant then
					if permissions.user[author.id].grant[category] or permissions.user[author.id].grant[command.name] or (permissions.user[author.id].grant[category] and permissions.user[author.id].grant[category].all) then
						return true
					end
				end
			end
		end	
		if permissions.channel then
			if permissions.channel[channel.id] then
				if permissions.channel[channel.id].deny and guild.owner.id ~= author.id then
					if permissions.channel[channel.id].deny[category] or permissions.channel[channel.id].deny[command.name] or (permissions.channel[channel.id].deny[category] and permissions.channel[channel.id].deny[category].all) then
						return "Channel permissions restrict you from using this command."
					end
				end
				if permissions.channel[channel.id].grant then
					if permissions.channel[channel.id].grant[category] or permissions.channel[channel.id].grant[command.name] or (permissions.channel[channel.id].grant[category] and permissions.channel[channel.id].grant[category].all) then
						return true
					end
				end
			end
		end
		if permissions.role then
			for role in member.roles do
				if permissions.role[role.id] then
					if permissions.role[role.id].deny and guild.owner.id ~= author.id then
						if permissions.role[role.id].deny[category] or permissions.role[role.id].deny[command.name] or (permissions.role[role.id].deny[category] and permissions.role[role.id].deny[category].all) then
							return "Role permissions restrict you from using this command."
						end
					end
					if permissions.role[role.id].grant then
						if permissions.role[role.id].grant[category] or permissions.role[role.id].grant[command.name] or (permissions.role[role.id].grant[category] and permissions.role[role.id].grant[category].all) then
							return true
						end
					end
				end
			end
		end	
	end
	for i,v in pairs(command) do
		if type(v) == "table" and v.permissions then
			if v.permissions.roles and guild.owner.id ~= author.id then
				for l,k in pairs(v.permissions.roles) do
					local role = guild:getRole("name",k)
					if role then
						if not member:hasRole(role) then
							return "Missing role: "..k
						end
					else
						return "Missing role: "..k
					end
				end
			elseif v.permissions.ids then
				local badId = true
				for l,k in pairs(v.permissions.ids) do
					if k == author.id then
						badId = false
						break
					end
				end
				if badId then
					return "This command is restricted only to whitelisted IDs."
				end
			elseif v.permissions.serverOwnerOnly then
				if guild.owner.id ~= author.id then
					return "Command restricted to the server owner."
				end
			elseif v.permissions.raw then
				if memberPermissions["administrator"] or guild.owner.id == author.id then return end
				for l,k in pairs(v.permissions.raw) do
					if not memberPermissions[k] then
						return "Missing key permission: "..k
					end
				end
			end
		end
	end
end

function Command:makeCommand(message,name,path)
	local locale = framework.modules["locale"][1](framework.modules.db[1]:get("guilds/"..message.guild.id.."/locale"),name)
	local command = framework:loadModule(path,{
		locale = locale,
		command = Command,
		respond = modules.respond[1](message,emitter),
		sleep = require("timer").sleep
	},true)
	if command then
		if type(command) == "table" and command.error then
			message.channel:sendMessage(":warning: This command has failed execution!\nError information: ``"..command.error.."``")
			return
		end
		command = {command()}
		return command
	end
	
end

local function extractFlags(content)
	local flags = {table={},array={}}
	for m,b in string.gmatch(content,"%-%-(%w+)([^%-]*)") do
		content = content:gsub(m,"")
		content = content:gsub(b,"")
		content = content:gsub("-","")
		flags.array[m] = b:trim()
		table.insert(flags.table,{m,b:trim()})
	end
	
	return flags
end

local function useCommand(command,fn,message,flags)
	local channel = message.channel
	local args = {
		stringArgs = command.args,
		myArgs = command.myArgs
	}
	local success, msg = pcall(fn,message,args,flags)
	if success then
		if msg then
			channel:sendMessage(msg)
		end
	else
		channel:sendMessage(":warning: This command has failed execution!\nError information: ``"..msg.."``")
	end
end

local function checkMatch(prefix,message)
	local content = message.content
	local channel = message.channel
	local beginning = content:sub(1,prefix:len()):lower()
	if beginning == prefix:lower() then
		if not client.framework then message.channel:sendMessage("Please wait until the bot loads up.") return end
		local after = content:sub(beginning:len()+1)
		local newAfter = content:sub(beginning:len()+1)
		after = after:sub(1,(after:find("-%-") and after:find("-%-") -1) or after:len())
		after = after:trim()
		local args = client.framework:split(after," ")
		for i,v in pairs(Command.commands) do
			if args[1] and args[1]:lower() == i:lower() then
				table.remove(args,1)
				local otherArgs = client.framework:split(table.concat(args," ")," | ")
				local command = Command:makeCommand(message,i,v)
				if not command then return end
				command.name = i
				local flags
				command.flags = extractFlags(newAfter)
				command.help = modules.help[1](command)
				
				local help = command.help
			
				local isSubcommand = args[1] and help.subcommands[args[1]]
				command.isSubcommand = isSubcommand
				
				if command.flags.array["help"] then
					if not isSubcommand then
						channel:sendMessage({embed={
							title=command.name,
							description=help.description,
							fields = {
								{name="category",value=help.category,inline=false},
								{name="subcommands",value=(#help.listSubcommands > 0 and table.concat(help.listSubcommands,"\n") or "none"),inline=false},
								{name="flags",value=(#help.flags > 0 and table.concat(help.flags,"\n") or "none"),inline=false},
								{name="examples",value=(#help.examples > 0 and table.concat(help.examples,"\n") or "none"),inline=false}
							}
						}})
					else
						channel:sendMessage({embed={
							title=args[1],
							description=isSubcommand[1] or "no description available",
							fields = {
								{name="parent command",value=command.name,inline=false}
							}
						}})
					end
					
					return	
				end
				
				
				local check = Command:checkPermission(message,command)
				
				if type(check) == "string" then
					channel:sendMessage(":x: Insufficient permissions! ``"..check.."``")
				else
					local newArgs , neededArgs
					for i,v in pairs(command) do
						if type(v) == "table" and v.args then
							neededArgs = true
							newArgs = framework.modules.resolvers["argument"][1][1](command,otherArgs,v.args,message,emitter)
						end
					end
					if newArgs or not neededArgs then
						command.args = args
						command.myArgs = newArgs
						return command
					end
				end
			end
		end
	end
end

function Command:newMessage(message)
	local content = message.content
	local channel = message.channel
	emitter:emit(message.author.id,message)
	for _,v in pairs(prefixes) do
		local command = checkMatch(v,message)
		if command and not command.error then
			local help = command.help
			local args = command.args
			local isSubcommand = command.isSubcommand
			if isSubcommand then
				useCommand(command,help.subcommands[args[1]][2],message,command.flags)
			else
				for i,v in pairs(command) do
					if type(v) == "function" then
						useCommand(command,v,message,command.flags)
					end
				end
			end
		elseif command and command.error then
			channel:sendMessage(":warning: This command has failed execution!\nError information: ``"..command.error.."``")
		end
	end
end


return Command