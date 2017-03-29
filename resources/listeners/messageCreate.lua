local function handleMessage(message)
	if message.author.bot then return end
	message.client.commands:newMessage(message)
end

client:on("messageCreate",handleMessage)