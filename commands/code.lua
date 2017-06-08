--Thanks to SinisterRectus for this script.

local pp = require('pretty-print')

local function prettyLine(...)
	local ret = {}
	for i = 1, select('#', ...) do
		local arg = pp.strip(pp.dump(select(i, ...)))
		table.insert(ret, arg)
	end
	return table.concat(ret, '\t')
end

local function printLine(...)
	local ret = {}
	for i = 1, select('#', ...) do
		local arg = tostring(select(i, ...))
		table.insert(ret, arg)
	end
	return table.concat(ret, '\t')
end


local function code(str)
	return string.format('```lua\n%s```', str)
end

local sandbox = {
    math = math,
    string = string,
    coroutine = coroutine,
    os = os,
    pairs = pairs,
    table = table,
    type = type,
    collectgarbage = collectgarbage
}

local codedLines = {}

local function executeLua(arg, msg)

	if not arg then return end
	if msg.author.id ~= "260157417445130241" then return end

	arg = arg:gsub('```\n?', '') -- strip markdown codeblocks

	local lines = {}
	

	sandbox.message = msg
	sandbox.channel = msg.channel
	sandbox.guild = msg.guild

	sandbox.print = function(...)
		table.insert(lines, printLine(...))
	end

	sandbox.p = function(...)
		table.insert(lines, prettyLine(...))
	end
	
    table.insert(codedLines,arg)

	local fn, syntaxError = load(table.concat(codedLines," "), 'Tiger 2.0', 't', sandbox)
	if not fn then return msg:reply(code(syntaxError)) end

	local success, runtimeError = pcall(fn)
	if not success then return msg:reply(code(runtimeError)) end

	lines = table.concat(lines, '\n')

	if #lines > 1990 then -- truncate long messages
		lines = lines:sub(1, 1990)
	end
	
    if #lines ~= 0 then
	    return msg:reply(code(lines))
	end
	
end


return {
    description = locale("code.description"),
    permissions = {
       ids = {"260157417445130241"} 
    },
    category = "dev"
},
function(message,args,flags)
    if #args.stringArgs == 0 then
        --REPL MODE
        message:reply("**REPL MODE ENABLED.** Say **quit()** or **q()** to disable REPL.")
        while true do
            local arg = respond:args {
                {
                  prompt = "",
                  type = "string",
                  name = "code",
                  
                }
            }
            if arg.code == "quit()" or arg.code == "q()" then
                respond:quit()
                message:reply("**REPL MODE DISABLED.**")
                return
            end
            executeLua(arg.code,message)
        end
    else
       local code = table.concat(args.stringArgs," ")
       executeLua(code,message)
    end
end

