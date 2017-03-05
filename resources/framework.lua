local framework = {scripts={}}
local dbs = {}

local lfs = require("lfs")
local r = require("rethinkdb")

local sub,find = string.sub, string.find
local insert,concat = table.insert, table.concat

local client

local function init(...)
	local tuple = ...
	for i,v in pairs(...) do
		framework.scripts[i] = v
	end
	client = tuple.litcord(tuple.settings.token)
	registerListeners()
	establishDatabases()
	extendClient()
	client:run()
	return framework
end

function registerListeners()
	client.listeners = framework:loadScripts("./resources/listeners")
end

function establishDatabases()
	client.db = r
	local db = framework:loadScripts("./resources/db")
	for i,v in pairs(db) do
		r.connect(
			{
				host = 'localhost',
				port = 28015,
				db = i,
				--password = ''
			},
			function(err, conn)
				if conn then
					dbs[i] = conn
					client.db[i] = conn
				else
					print("RETHINKDB ERROR: "..err)
				end
			end
		)
	end

end

function extendClient()
	client.framework = framework
	client.commands = require("resources.commands")(client,{prefixes={"tiger "}})
	client.resolvers = framework:loadScripts("./resources/resolvers/")
end

function framework:getHtml(file)
	local f = io.open(file, "rb")
	local content = f:read("*a")
	f:close()
	return content
end

function framework:split(str, delim)
	--credit to finitreality
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

function framework:loadScripts(filePath,...)
	local tuple = {...}
	if filePath:find(".lua") then
		local file
		local fileName = filePath:match("([^/]-)%..-$")	
		if framework.scripts[fileName] then return framework.scripts[fileName] end
		local success, err = pcall(function()
			if tuple and #tuple > 0 then
				file = dofile(filePath)(client,tuple)
			else
				file = dofile(filePath)(client)
			end
		end)
		if not success then
			print("-----------")
			print(fileName)
			print(filePath)
			print(err)
			print("-----------")
			return
		end
		framework.scripts[fileName] = file
		return file
	else
		local files = {}
		for file in lfs.dir(filePath) do
			local currentFile
			if file ~= "." and file ~= ".."  then
				local f = filePath..'/'..file
				local attr = lfs.attributes (f)
				assert (type(attr) == "table")
				if attr.mode == "directory" then
					if tuple.recursive then
						--SOON (TM)
					end
				else
					local fileName = f:sub(2):match("([^/]-)%..-$")
					if not framework.scripts[fileName] then
						local success, err = pcall(function()
							if tuple and #tuple > 0 then
								currentFile = dofile(f)(client,tuple)
							else
								currentFile = dofile(f)(client)
							end
						end)
						if success then
							files[fileName] = currentFile
							framework.scripts[fileName] = currentFile
						else
							print("-----------")
							print(fileName)
							print(filePath)
							print(err)
							print("-----------")
						end
					end
				end
			end
		end
		return files
	end
end

return init