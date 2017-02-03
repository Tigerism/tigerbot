return {
	description = "shows latency information."
},function(data)
	local newMsg = data.channel:sendMessage("Pinging...")
	newMsg:setContent("Pong! ``"..math.abs(math.floor(((newMsg.createdAt - data.message.createdAt)*1000))).."ms``")
end