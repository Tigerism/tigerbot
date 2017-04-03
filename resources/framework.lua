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

function framework:loadModule(path)
    local code = assert(readFile(path))
    local name = remove(splitPath(path))
    local newEnv = env
	if path:find("commands") then
		--todo: make this better??
	--	newEnv["locale"] = framework.modules.locale[name]:getWords()
	end
    local fn = assert(loadstring(code, name, 't', newEnv))
    framework.modules[name] = fn
    return fn()
end

function framework:loadModules(path)
	local fns = {}
    for k, v in scandir(path) do
        if v == 'file' and k:find(".lua") then
        	local fn = framework:loadModule(pathJoin(path, k))
        	local name = k:gsub(".lua","")
        	fns[name] = {fn,path}
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
	framework.modules["listeners"] = framework:loadModules(module.dir.."/listeners/")
	framework.modules["resolvers"] = framework:loadModules(module.dir.."/resolvers/")
	framework.modules["commands"] = framework:loadModule(module.dir.."/commands.lua")
	framework.modules["logger"] = framework:loadModule(module.dir.."/logger.lua")
	client.framework = framework
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
		framework = framework,
		module = module,
		settings = client.settings
	}, {__index = _G})
	registerModules()
	return framework
end

return init