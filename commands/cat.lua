local http = require("coro-http")
local json = require("json")

local function getCat()
	local res, data = http.request('GET', "http://random.cat/meow")
	return json.parse(data).file
end

return function(message)
    coroutine.wrap(function()
        message.channel:broadcastTyping()
    end)()
    message.channel:sendMessage {
	    content = "Here's a cat! :cat:",
		file = getCat()
    }   
end,
{
    description=locale("cat.description"),
    category="fun"
}