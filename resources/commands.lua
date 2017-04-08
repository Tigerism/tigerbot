local Command = {commands={}}
local prefixes = settings.prefixes

local commands = framework:getFiles(module.dir.."/../commands/")

local function checkPermissions(message,command)
	local member = message.member
	local author = message.author
	local guild = message.guild
	--if author.id == "260157417445130241" then return end
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

local function makeCommand(message,name,path)
	local locale = locale(db:get("guilds/"..message.guild.id.."/locale"),name)
	local command = framework:loadModule(path,{
		locale = locale
	})
	if command then
		command = {command()}
		return command
	end
	
end

local respond = {}
function respond:embed(...)
	local embed = {}
	--soonTM
end

local function checkMatch(prefix,message)
	local content = message.content
	local channel = message.channel
	local beginning = content:sub(1,prefix:len()):lower()
	if beginning == prefix:lower() then
		local after = content:sub(beginning:len()+1)
		local args = client.framework:split(after," ")
		for i,v in pairs(commands) do
			if args[1] and args[1]:lower() == i:lower() then
				table.remove(args,1)
				
				--checks for permissions
				local command = makeCommand(message,i,v)
				local isNotAllowed = checkPermissions(message,command)
				if isNotAllowed then
					channel:sendMessage(":x: Insufficient permissions! ``"..isNotAllowed.."``")
				else
					if true then
						--another temp thing for something else
						command.args = args
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
	for _,v in pairs(prefixes) do
		local command,args = checkMatch(v,message)
		if command and not command.error then
			for i,v in pairs(command) do
				if type(v) == "function" then
					local success, msg = pcall(v,message,command.args)
					if success then
						if msg then
							channel:sendMessage(msg)
						end
					else
						channel:sendMessage(":warning: This command has failed execution!\nError information: ``"..msg.."``")
					end
				end
			end
		elseif command and command.error then
			channel:sendMessage(":warning: This command has failed execution!\nError information: ``"..command.error.."``")
		end
	end
end


return Command