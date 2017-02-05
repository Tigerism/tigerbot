local function getGuildInfo(guild)
	return {
		thumbnail = {url=guild.iconUrl},
		fields = {
			{name="Name",value=guild.name,inline=true},
			{name="ID",value=guild.id,inline=true},
			{name="Owner",value=guild.owner.mentionString,inline=true},
			{name="Members",value=guild.totalMemberCount,inline=true},
			{name="Unavailable",value=guild.unavailable,inline=true},
			{name="VIP",value=guild.vip,inline=true},
			{name="Verification",value=guild.verificationLevel,inline=true},
			{name="Text Channels",value=guild.textChannelCount,inline=true},
			{name="Voice Channels",value=guild.voiceChannelCount,inline=true},
			{name="Roles",value=guild.roleCount,inline=true}
		}
	}
end

return {
	description = "shows the guild's information.",
	aliases = {"guildinfo","server","serverinfo","sinfo","ginfo"},
	usage = "guild",
	guildOnly = true
},function(data)
	data.command:sendEmbed(data,"",getGuildInfo(data.guild))
end