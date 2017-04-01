local function shardDied(shardId,payload)
	client.framework.modules["logger"]:sendLog("Shard "..shardId,"Has died. Debug: "..payload,"12597547")
end

client:on("shardDied",shardReady)