local Command = {commands={}}
local prefixes = settings.prefixes

local commands = framework:getFiles(module.dir.."/../commands/")

local function isAllowed()
	return true
end

local function makeCommand(message,name,path)
	local locale = locale("en",name)
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
	local beginning = content:sub(1,prefix:len()):lower()
	if beginning == prefix:lower() then
		local after = content:sub(beginning:len()+1)
		local args = client.framework:split(after," ")
		for i,v in pairs(commands) do
			if args[1] and args[1]:lower() == i:lower() then
				table.remove(args,1)
				--checks for permissions
				if isAllowed() then
					--temp permission thing
					if true then
						--another temp thing for something else
						--ALL CHECKS HAVE PASSED, let's make le command 
						local command = makeCommand(message,i,v)
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
		local command = checkMatch(v,message)
		if command and not command.error then
			for i,v in pairs(command) do
				if type(v) == "function" then
					local success, msg = pcall(v,message)
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