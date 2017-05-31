local Command = {commands=framework:getFiles(module.dir.."/../commands/")}
local prefixes = settings.prefixes

function Command:checkPermission(message,command)
	local member = message.member
	local author = message.author
	local guild = message.guild
	local channel = message.channel
	--if author.id == "260157417445130241" then return end
	local category = command.help.category
	
	local permissions = framework.modules.db:get("guilds/"..guild.id.."/perms") or {}

	if guild.owner.id ~= author.id then
		if category ~= "dev" then
			if permissions.user then
				if permissions.user[author.id] then
					if permissions.user[author.id].deny then
						if permissions.user[author.id].deny[category] or permissions.user[author.id].deny[command.name] then
							return "User permissions restrict you from using this command."
						end
					end
					if permissions.user[author.id].grant then
						if permissions.user[author.id].grant[category] or permissions.user[author.id].grant[command.name] then
							return true
						end
					end
				end
			end	
			if permissions.channel then
				if permissions.channel[channel.id] then
					if permissions.channel[channel.id].deny then
						if permissions.channel[channel.id].deny[category] or permissions.channel[channel.id].deny[command.name] then
							return "Channel permissions restrict you from using this command."
						end
					end
					if permissions.channel[channel.id].grant then
						if permissions.channel[channel.id].grant[category] or permissions.channel[channel.id].grant[command.name] then
							return true
						end
					end
				end
			end
			if permissions.role then
				for role in member.roles do
					if permissions.role[role.id] then
						if permissions.role[role.id].deny then
							if permissions.role[role.id].deny[category] or permissions.role[role.id].deny[command.name] then
								return "Role permissions restrict you from using this command."
							end
						end
						if permissions.role[role.id].grant then
							if permissions.role[role.id].grant[category] or permissions.role[role.id].grant[command.name] then
								return true
							end
						end
					end
				end
			end	
		end
	end
	for i,v in pairs(command) do
		if type(v) == "table" and v.permissions then
			if v.permissions.roles then
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
					return "Restricted command."
				end
			elseif v.permissions.serverOwnerOnly then
				if guild.owner.id ~= author.id then
					return "Restricted command only to the server owner."
				end
			end
		end
	end
end

function Command:makeCommand(message,name,path)
	local locale = framework.modules["locale"](framework.modules.db:get("guilds/"..message.guild.id.."/locale"),name)
	local command = framework:loadModule(path,{
		locale = locale,
		command = Command,
		respond = modules.respond(message,emitter)
	},true)
	if command then
		command = {command()}
		return command
	end
	
end

local function extractFlags(content)
	local flags = {}
	for m,b in string.gmatch(content,"%-%-(%w+)([^%-]*)") do
		flags[m] = b:trim()
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
		local after = content:sub(beginning:len()+1)
		local args = client.framework:split(after," ")
		local otherArgs = client.framework:split(table.concat(args," ")," ")
		for i,v in pairs(Command.commands) do
			if args[1] and args[1]:lower() == i:lower() then
				table.remove(args,1)
				table.remove(otherArgs,1)
				local command = Command:makeCommand(message,i,v)
				command.name = i
				command.help = modules.help(command)
				local check = Command:checkPermission(message,command)
				
				if type(check) == "string" then
					channel:sendMessage(":x: Insufficient permissions! ``"..check.."``")
				else
					local newArgs , neededArgs
					for i,v in pairs(command) do
						if type(v) == "table" and v.args then
							neededArgs = true
							newArgs = framework.modules.resolvers["argument"][1](command,otherArgs,v.args,message,emitter)
						end
					end
					if newArgs or not neededArgs then
						command.args = args
						command.myArgs = newArgs
						command.flags = extractFlags(table.concat(args," "))
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
			local isSubcommand = args[1] and help.subcommands[args[1]]
			if command.flags["help"] then
				if not isSubcommand then
					channel:sendMessage({embed={
						title=command.name,
						description=help.description,
						fields = {
							{name="subcommands",value=(#help.listSubcommands > 0 and table.concat(help.listSubcommands,"\n") or "none"),inline=false},
							{name="flags",value=(#help.flags > 0 and table.concat(help.flags,"\n") or "none"),inline=false}
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