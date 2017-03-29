local function handleReady()
	print("Logged in as "..client.user.username)
end

client:on("ready",handleReady)