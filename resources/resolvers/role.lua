local role = {}

function role:resolve(message,content,arg)
	local guild = message.guild
	local id = content:match("<@&(.*)>") or (tonumber(content) and content:len() > 16 and content)
	
	for role in guild.roles do
		if role.name == content or role.id == id then
			return role
		end
	end
end

return role