local framework = {scripts={}}
local fs = require("fs")
local timer = require("timer")

local client

local function init(bot)
	client = bot
	return framework
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
				file = dofile(filePath)
			end
		end)
		if not success then
			return
		end
		framework.scripts[fileName] = file
		return file
	else
		local t = {}
		local done
		fs.readdir(filePath,function(err,files) --put in a coroutine
			if files then
				for i,v in pairs(files) do
					local fileName = v:gsub(".lua","")
					if not framework.scripts[fileName] then
						local file
						local success, err = pcall(function()
							if tuple and #tuple > 0 then
								file = dofile(filePath..v)(client,tuple)
							else
								file = dofile(filePath..v)(client)
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
			done = true
		end)
		while not done do
			timer.sleep(1000)
		end
		return t
	end
end


return init