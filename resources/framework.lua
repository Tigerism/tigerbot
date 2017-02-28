local framework = {scripts={}}

local lfs = require("lfs")

local client

local function init(...)
	local tuple = ...
	for i,v in pairs(...) do
		framework.scripts[i] = v
	end
	client = tuple.litcord(tuple.settings.token)
	registerListeners()
	extendClient()
	client:run()
	return framework
end

function registerListeners()
	framework:loadScripts("./resources/listeners")
end

function extendClient()
	client.framework = framework
end

function framework:getHtml(file)
	local f = io.open(file, "rb")
	local content = f:read("*a")
	f:close()
	return content
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