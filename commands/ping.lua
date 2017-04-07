return {
	--Permissions
	type = "permissions"
},function(message)
    local newMsg = message.channel:sendMessage("pinging...")
    newMsg:setContent(locale.currentCommand.pong(math.abs(math.floor(((newMsg.createdAt - message.createdAt)*1000)))))
end,{
    type = "args"
	--args
},{
    type = "subcommands"
	--subcommands
}

