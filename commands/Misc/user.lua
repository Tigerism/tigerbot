local function getUserInfo(member)
	return {
		thumbnail = {url=member.avatarUrl},
		fields = {
			{name="Username",value=member.mentionString,inline=true},
			{name="Nickname",value=member.nickname or "None",inline=true},
			{name="ID",value=member.id,inline=true},
			{name="Discriminator",value=member.discriminator,inline=true},
			{name="Status",value=member.status,inline=true},
			{name="Playing",value=member.gameName or "None",inline=true}
		}
	}
end

return {
	description = "shows a member's information.",
	aliases = {"userinfo","uinfo"},
	usage = "user <member>",
	guildOnly = true
},function(data)
	local class = data.bot.class
	local member = class.Users:getMember(data) or data.member
	data.command:sendEmbed(data,"",getUserInfo(member))
end