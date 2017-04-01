local Command = {commands={}}
local Data

local commands = framework:loadModules(module.dir.."/../commands/")
p(commands.ping[1].arguments)


setmetatable(Command,{
    __call = function(self,label,stuff)
		local mt = setmetatable({
    		label = label,
			options = stuff.options or {},
			func = stuff.func,
			args = stuff.arguments or {}
    },self)
	Command.commands[label] = mt
end})

local function isNotAllowed()
	
end

function Command:newSubcommand(label,funct,options)
	self.aliases = label
end

local function executeCommand(mt)
	
end

local function checkMatch(prefix,message)
	local content = message.content
	local beginning = content:sub(1,prefix:len()):lower()
	if beginning == prefix:lower() then
		local after = content:sub(beginning:len()+1)
		local args = client.framework:split(after," ")
		for i,v in pairs(Command.commands) do
			if args[1] and args[1]:lower() == v.label:lower() then
				table.remove(args,1)
				--checks for permissions
				if v.args and #v.args > 0 then
					--argument resolver
					local match = client.resolvers.argument:extract(v,args,message)
					if match then
						
					end
				end
			end
		end
	end
end

function Command:newMessage(message)
	local content = message.content
	local channel = message.channel
	--[[for _,v in pairs(Data.prefixes) do
		local command = checkMatch(v,message)
		if command then
			
		end
	end]]

end


return Command