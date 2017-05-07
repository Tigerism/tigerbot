return function(message)
    local newMsg = message.channel:sendMessage(locale("ping.ping"))
    newMsg:setContent(locale("ping.pong",(math.abs(math.floor(((newMsg.createdAt - message.createdAt)*1000))))))
end,
{
    description=locale("ping.description"),
    category="misc"
}