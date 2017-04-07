local function getGuildCount(shardId)
	local count = 0
	for guild in client.guilds do
		if guild.shardId == shardId then
			count = count + 1
		end
	end
	return count
end

local function shardReady(shardId)
--	client.framework.modules["logger"]:sendLog("Shard "..shardId,"Connected to "..getGuildCount(shardId).." guilds.","8901500")
end

--client:on("shardReady",shardReady)