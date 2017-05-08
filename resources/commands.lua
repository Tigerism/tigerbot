local Command = {commands=framework:getFiles(module.dir.."/../commands/")}
local prefixes = settings.prefixes

function Command:checkPermissions(message,command)
	local member = message.member
	local author = message.author
	local guild = message.guild
	--if author.id == "260157417445130241" then return end
	--local permissions = db:get("guilds/"..guild.id.."/permissions") or {}
	for i,v in pairs(command) do
		if type(v) == "table" and v.type == "permissions" then
			if v.roles then
				for l,k in pairs(v.roles) do
					local role = guild:getRole("name",k)
					if role then
						if not member:hasRole(role) then
							return "Missing role: "..k
						end
					else
						return "Missing role: "..k
					end
				end
			elseif v.ids then
				local badId = true
				for l,k in pairs(v.ids) do
					if k == author.id then
						badId = false
						break
					end
				end
				if badId then
					return "Restricted command."
				end
			end
		end
	end
end

function Command:makeCommand(message,name,path)
	local locale = framework.modules["locale"](db:get("guilds/"..message.guild.id.."/locale"),name)
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
	local success, msg = pcall(fn,message,command.args,flags)
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
		for i,v in pairs(Command.commands) do
			if args[1] and args[1]:lower() == i:lower() then
				table.remove(args,1)
				--checks for permissions
				local command = Command:makeCommand(message,i,v)
				local isNotAllowed = Command:checkPermissions(message,command)
				if isNotAllowed then
					channel:sendMessage(":x: Insufficient permissions! ``"..isNotAllowed.."``")
				else
					if true then
						--another temp thing for something else
						command.args = args
						command.flags = extractFlags(table.concat(args," "))
						command.name = i
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
			local help = modules.help(command)
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