local http = require("coro-http")
local json = require("json")

local function getDog()
	local res, data = http.request('GET', "https://random.dog/woof")
	return "https://random.dog/"..data
end

return function(message)
    coroutine.wrap(function()
        message.channel:broadcastTyping()
    end)()
    message.channel:sendMessage {
	    content = "Here's a dog! :dog:",
		file = getDog()
    }   
end,
{
    description=locale("dog.description"),
    category="fun"
}