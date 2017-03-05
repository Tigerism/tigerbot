local function handleMessage(message)
	if message.author.bot then return end
	if message.content == "l" then os.exit() end
	local client = message.parent.parent.parent
	message.client = client
	client.commands:newMessage(message)
end

return function (client)
	client:on("messageCreate",handleMessage)
end