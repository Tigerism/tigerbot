local channel = {}

function channel:resolve(message,content)
	local guild = message.guild
	
	local id = content:match("<#(.*)>") or (tonumber(content) and content:len() > 16 and content)
	
	for channel in guild:getTextChannels() do
		if channel.name == content or channel.id == id then
			return channel
		end
	end
end

return channel