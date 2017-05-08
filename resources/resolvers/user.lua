local userCache = {}

return function(message,content)
	
	content = content or message.content
	local guild = message.guild
	
	local id = content:match("<@!?(.*)>") or (tonumber(content) and content:len() > 13 and content)
	local discrim , name
	if not id then
		name , discrim = content:match("@(.*)#(.*)")
	end

	for member in guild.members do
		if member.id == id or (member.username == name and member.discriminator == discrim) or member.username == content then
			return member
		end
	end
	
	if id then
		return client:getUser(id)
	end
	
end