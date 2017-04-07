local Command = {commands={}}
local prefixes = settings.prefixes

local commands = framework:getFiles(module.dir.."/../commands/")

local function isAllowed()
	return true
end

local function makeCommand(message,path)
	local command = framework:loadModule(path,{
		--locale stuff here	
	})
	command = {command()}
	return command
	
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
						local command = makeCommand(message,v)
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
		if command then
				
		end
	end
end


return Command