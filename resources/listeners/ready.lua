local function handleReady()
	print("Logged in as "..client.user.username)
end

framework:wrapHandler("ready",handleReady)