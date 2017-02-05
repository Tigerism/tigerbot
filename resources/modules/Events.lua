return function(client)
	local commands = client.commands
	
	client:on("ready",function()
		p("Logged in as "..client.user.username)
		client.started = os.time()
	end)
	
	client:on("messageCreate",function(message)
		commands:newMsg(message)
	end)
	
end