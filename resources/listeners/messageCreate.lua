local function handleMessage(message)
	if message.author.bot then return end
	if not framework then return end
	if not client.emitters then return end
	client.emitters.trivia:emit("trivia_"..message.guild.id,message)
	if not message.guild then 
		message.channel:sendMessage("I don't accept DM commands! Send me commands through a server with the ``tiger`` prefix. Example: ``tiger ban @user``")
		return 
	end
	framework.modules.commands[1]:newMessage(message)
end

framework:wrapHandler("messageCreate",handleMessage)
