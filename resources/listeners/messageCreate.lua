return function (client)
	client:on("messageCreate",function(message)
		print(message.author.username)	
	end)
end