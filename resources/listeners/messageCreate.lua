local function handleMessage(message)
	if message.author.bot then return end
	framework.modules.commands[1]:newMessage(message)
end

framework:wrapHandler("messageCreate",handleMessage)
