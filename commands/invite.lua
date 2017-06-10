return function(message)
    message.channel:sendMessage {
        embed = {
            title = locale("invite.title"),
            fields = {
                {name=locale("invite.botInvite"),value="https://discordapp.com/oauth2/authorize?permissions=85064&scope=bot&client_id=225079733799485441",inline=true},
                {name=locale("invite.helpInvite"),value="https://discord.gg/62qYz8J",inline=true},
            }
        }
    }
end,
{
    description=locale("invite.description"),
    category="misc"
}