local function handleReady()
	print("Logged in as "..client.user.username)
	client:setGameName("tiger help | tiger invite")
end

framework:wrapHandler("ready",handleReady)