return function(message)
    local newMsg = message.channel:sendMessage(locale.currentCommand.ping())
    newMsg:setContent(locale.currentCommand.pong(math.abs(math.floor(((newMsg.createdAt - message.createdAt)*1000)))))
end