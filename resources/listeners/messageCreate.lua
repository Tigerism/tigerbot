local function handleMessage(message)
	if message.author.bot then return end
	framework.modules.commands:newMessage(message)
end

client:on("messageCreate",handleMessage)