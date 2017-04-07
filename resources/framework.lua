local framework = {scripts={},modules={}}

local client

local fs = require('fs')
local pathjoin = require('pathjoin')
local timer = require("timer")
local http = require("coro-http")
local firebase = require("luvit-firebase")

local splitPath, pathJoin = pathjoin.splitPath, pathjoin.pathJoin
local readFile, scandir = fs.readFileSync, fs.scandirSync
local remove, insert, concat = table.remove, table.insert, table.concat
local sub,find = string.sub, string.find


local function getNewEnv(extended)
	local env = setmetatable({
    	require = require,
    	client = client,
		modules = framework.modules,
		framework = framework,
		module = module,
		settings = client.settings,
		locale = framework.modules.locale
	}, {__index = _G})
	if extended and type(extended) == "table" then
		for i,v in pairs(extended) do
			env[i] = v
		end
	end
	return env
end
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

function framework:loadModule(path,env)
    local code = assert(readFile(path))
    local name = remove(splitPath(path))
    env = getNewEnv(env)
    local fn, error = loadstring(code, name, 't', env)
    if not fn then
    	return {error=error}
    end
	return fn
end

function framework:loadModules(path)
	local fns = {}
    for k, v in scandir(path) do
        if v == 'file' and k:find(".lua") then
        	local fn = framework:loadModule(pathJoin(path, k))
	        local name = k:gsub(".lua","")
	        fns[name] = {fn(),path}
        end
    end
    return fns
end

function framework:getFiles(path,recursive)
	local files = {}
	for k, v in scandir(path) do
		if v == 'file' and k:find(".lua") then
			local name = k:gsub(".lua","")
			files[name] = path..name..".lua"
		end
	end
	return files
end

local function reloadModule(moduleName)
	local module = framework.modules[moduleName]
	if module then
		local fn
		local success, err = pcall(function()
			fn = framework:loadModule(module[2])
		end)
		if success then
			framework.modules[moduleName] = fn
		else
			return err
		end
	end
end

local function registerModules()
	framework.modules["locale"] = framework:loadModule(module.dir.."/locale.lua")()
	framework.modules["listeners"] = framework:loadModules(module.dir.."/listeners/")
	framework.modules["resolvers"] = framework:loadModules(module.dir.."/resolvers/")
	framework.modules["logger"] = framework:loadModule(module.dir.."/logger.lua")()
	framework.modules["commands"] = framework:loadModule(module.dir.."/commands.lua")()
	client.framework = framework
end

local function init(bot,...)
	local tuple = ...
	client = bot
	for i,v in pairs(...) do
		framework.scripts[i] = v
		client[i] = v
	end
	registerModules()
	return framework
end

return init