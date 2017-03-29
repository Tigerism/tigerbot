local framework = {scripts={},modules={}}

local client
local env

local fs = require('fs')
local pathjoin = require('pathjoin')
local timer = require("timer")
local http = require("coro-http")
local firebase = require("luvit-firebase")

local splitPath, pathJoin = pathjoin.splitPath, pathjoin.pathJoin
local readFile, scandir = fs.readFileSync, fs.scandirSync
local remove, insert, concat = table.remove, table.insert, table.concat
local sub,find = string.sub, string.find
	
--[[ function framework:reloadModule(name)
	if client.listeners[name] then
		client:removeListener(name,client.listeners[name])
		client.listeners[name] = framework:loadScripts(module.dir.."/listeners/"..name..".lua",true)
	end
end]]

function framework:getHtml(file)
	local f = io.open(file, "rb")
	local content = f:read("*a")
	f:close()
	return content
end

function framework:split(str, delim)
	--credit to finitereality
	if (not str) or (not delim) or str == "" or delim == "" then
		return {}
	else
		local current = 1
		local result = { }
		while true do
			local start, finish = find(str, delim, current)
			if start and finish then
				insert(result, sub(str, current, start-1))
				current = finish + 1
			else
				break
			end
		end
		insert(result, sub(str, current))
		return result
	end
end

local function scan(path, name)
    for k, v in scandir(path) do
        local joined = pathJoin(path, name)
        if v == 'file' then
            if k:lower() == name then
                return joined
            end
        else
            scan(joined)
        end
    end
end

function framework:loadScripts(filePath,noCache,...)
	local tuple = {...}
	if filePath:find(".lua") then
		local file
		local fileName = filePath:match("([^/]-)%..-$")
		if framework.scripts[fileName] and not noCache then return framework.scripts[fileName] end
		local success, err = pcall(function()
			if tuple and #tuple > 0 then
				file = dofile(filePath)(client,tuple)
			else
				print("new module")
				file = dofile(filePath)(client)
			end
		end)
		if not success then
			return
		end
		framework.scripts[fileName] = file
		return file
	else
		local t = {}
		local files = fs.readdirSync(filePath)
		if files then
			for i,v in pairs(files) do
				local fileName = v:gsub(".lua","")
				if not framework.scripts[fileName] then
					local file
					local success, err = pcall(function()
						if tuple and #tuple > 0 then
							file = dofile(filePath.."/"..v)(client,tuple)
						else
							file = dofile(filePath.."/"..v)(client)
						end
					end)
					if success then
						t[fileName] = file
						framework.scripts[fileName] = file
					else
						print(fileName)
						print(filePath)
						print(err)
						p("-----------")
					end
				end
			end
		end
		return t
	end
end


local function loadModule(path)
    local code = assert(readFile(path))
    local name = remove(splitPath(path))
    local fn = assert(loadstring(code, name, 't', env))
    framework.modules[name] = fn
    return fn
end

local function loadModules(path)
	local fns = {modules={}}
    for k, v in scandir(path) do
        if v == 'file' and k:find(".lua") then
        	local fn = loadModule(pathJoin(path, k))
        	local name = k:gsub(".lua","")
        	fns.modules[name] = {fn,path}
        	
        end
    end
    function fns:run(moduleName)
    	if moduleName then
    		return fns.modules[moduleName]()
    	else
    		for i,v in pairs(fns.modules) do
    			v[1]()
    		end
    	end
    end
    return fns
end

local function reloadModule(moduleName)
	local Module = framework.modules[moduleName]
	if Module then
		local fn
		local success, err = pcall(function()
			fn = loadModule(Module.path)
		end)
		if success then
			framework.modules[moduleName] = fn
		else
			return err
		end
	end
end

local function registerModules()
	framework.modules["listeners"] = loadModules(module.dir.."/listeners/"):run()
	framework.modules["resolvers"] = loadModules(module.dir.."/resolvers/"):run()
	framework.modules["commands"] = loadModule(module.dir.."/commands.lua")()
	
end

local function init(bot,...)
	local tuple = ...
	client = bot
	for i,v in pairs(...) do
		framework.scripts[i] = v
		client[i] = v
	end
	env = setmetatable({
    	require = require,
    	client = client,
		modules = framework.modules,
		framework = framework
	}, {__index = _G})
	registerModules()
	return framework
end

return init