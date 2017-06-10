local http = require("coro-http")
local json = require("json")

local function getGiphy(query)
	local res, data = http.request('GET', "http://api.giphy.com/v1/gifs/search?q="..query.."&api_key=dc6zaTOxFJmzC")
	return json.parse(data).data[0] or nil
end

return function(message, args)
    coroutine.wrap(function()
        message.channel:broadcastTyping()
    end)()
    local gif = getGiphy(args) 
	if not gif then respond:error('Could not find a GIF with that query.') end
	message.channel:sendMessage {
	    content = "Here's a giphy!",
		file = gif["images"]["fixed_height"]
    }  
end,
{
    description=locale("giphy.description"),
    category="fun"
}