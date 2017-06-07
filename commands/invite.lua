return function(message)
    message.channel:sendMessage {
        embed = {
            title = "Invite Tiger",
            fields = {
                {name="Bot Invite",value="https://discordapp.com/oauth2/authorize?permissions=85064&scope=bot&client_id=225079733799485441",inline=true},
                {name="Help Server Invite",value="https://discord.gg/62qYz8J",inline=true},
            }
        }
    }
end,
{
    description=locale("invite.description"),
    category="misc"
}