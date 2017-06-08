framework:wrapHandler("guildCreate",function(guild)
    
    guild:getDefaultChannel():sendMessage {
        embed = {
            title = "Welcome to Tiger",
            description = "**Thanks for adding Tiger to your server!**\nFor a list of commands, say ``tiger help``\nIf you ever have any questions, conerns, or suggestions, feel free to join [Tiger's Cave](https://discord.gg/62qYz8J)",
            footer = {text="Thank you, and have fun!"},
            thumbnail = {url=guild.me.user.avatarUrl}
        }
        
    }

end)