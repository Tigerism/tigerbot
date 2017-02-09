local MoonCake = require("mooncake")
local server = MoonCake:new()
local bot


local function getRoutes()
	coroutine.wrap(function()
		local routes = bot.framework:loadScripts(module.dir.."/routes/")
		for i,v in pairs(routes) do
			local params,func = v[1],v[2]
			server:get("/"..i.."/"..params,function(req,res)
				func(req,res)
			end)
		end
	end)()
end

local function init(client)
	bot = client
	getRoutes()
end


server:start(8080)

return init