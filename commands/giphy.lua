local http = require("coro-http")
local json = require("json")
local qs = require("querystring")

local function getGiphys(query)
    query = qs.urlencode(query)
    local gifs = {}
	local res, data = http.request('GET', "http://api.giphy.com/v1/gifs/search?q="..query.."&api_key=dc6zaTOxFJmzC")
	data = json.parse(data)
	if data then
	    for i = 1, 10 do
	        if data.data then
                if data.data[i] then
                    table.insert(gifs,data.data[i].images.downsized_medium.url)
                end
            end
        end
        return gifs
	end
end

return function(message, args)
    local newMsg = message.channel:sendMessage("loading giphy results...")
    local query = args.myArgs[1]
    local gifs = getGiphys(query)
	if not gifs or #gifs == 0 then newMsg:setContent('Could not find a GIF with that query.') return end
    modules.listeners.reactions[1][1]:newReactionMenu(message,newMsg,gifs,{
        type = "image"
    })	
    newMsg:setContent("")
end,
{
    description=locale("giphy.description"),
    category="fun",
    args = {{"string","Please specify the giphy query."}}
}