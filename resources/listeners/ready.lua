local function handleReady()
	print("Logged in as "..client.user.username)
	local correct = client.shardCount == 1 and "shard" or "shards"
	client.framework.modules["logger"][1]:sendLog("Master","Started "..client.shardCount.." "..correct..".","8901500")
end

framework:wrapHandler("ready",handleReady)