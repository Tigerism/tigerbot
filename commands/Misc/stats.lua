local function getVoiceConnectionCount(bot)
	local num = 0
	for guild in bot.guilds do
		if guild.connection then
			num = num + 1
		end
	end
	return num
end

local function getStats(bot)
	return {
		thumbnail = {url=bot.user.avatarUrl},
		fields = {
			{name="About",value="Tiger, an advanced bot written in Lua. Say tiger help to get a list of commands.",inline=true},
			{name="Developer",value="Mindy Lahiri",inline=true},
			{name="Library",value="Discordia (Lua)",inline=true},
			{name="Database",value="SQLite3",inline=true},
			{name="Guilds",value=bot.guildCount,inline=true},
			{name="Voice Connections",value=getVoiceConnectionCount(bot),inline=true},
			{name="Shards",value=bot.shardCount,inline=true},
			{name="Uptime",value=(bot.resolvers.time:calculate(os.time()-bot.started)),inline=true},
		}
	}
end

return {
	description = "shows the bot's information.",
	aliases = {"info"},
	usage = "stats",
	guildOnly = true
},function(data)
	data.command:sendEmbed(data,"",getStats(data.bot))
end