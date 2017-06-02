return function(message)
    message.channel:sendMessage {
        embed = {
            title = "Invite Tiger",
            fields = {
                {name="Bot Invite",value="https://discordapp.com/oauth2/authorize?&client_id=225079733799485441&scope=bot&permissions=8",inline=true},
                {name="Help Server Invite",value="https://discord.gg/62qYz8J",inline=true},
            }
        }
    }
end,
{
    description=locale("invite.description"),
    category="misc"
}