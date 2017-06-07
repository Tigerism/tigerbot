local userCache = {}

local userResolver = {}

function userResolver:resolve(message,content)
	content = content or message.content
	local guild = message.guild
	
	local id = content:match("<@!?(.*)>") or (tonumber(content) and content:len() > 16 and content)
	local discrim , name
	if not id then
		name , discrim = content:match("@(.*)#(.*)")
	end
	for member in guild.members do
		if member.id == id or (member.username == name and member.discriminator == discrim) or member.username == content then
			local highestRole
			for role in member.roles do
				if highestRole then
					if highestRole.position < role.position then
						highestRole = role
					end
				else
					highestRole = role
				end
			end
			if not highestRole then highestRole = guild.defaultRole end
			member.highestRole = highestRole
			local memberPermissions = framework.modules.permissions[1]:getMemberPermissions(member)
			member.permissions = memberPermissions
			return member
		end
	end
	if id then
		return client:getUser(id)
	end
end

return userResolver