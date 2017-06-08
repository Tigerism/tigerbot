
return function(message,args,flags)
    local guild = message.guild
    
    local fields = {
       {name="Owner",value=guild.owner.mentionString,inline=true} 
    }
    
    if guild.emojiCount > 0 then
        local emojis = {}
        for emoji in guild.emojis do
            table.insert(emojis,emoji.string)
        end
        table.insert(fields,{name="Emojis",value=(table.concat(emojis,", ").." ("..guild.emojiCount..")"),inline=true})
    end
    if guild.large then
        table.insert(fields,{name="Large Server",value=guild.large,inline=true})
    end
    if guild.large then
        table.insert(fields,{name="Large Server",value=guild.large,inline=true})
    end
    local members,bots = 0,0
    for member in guild.members do
        if member.bot then
            bots = bots + 1
        else
            members = members + 1
        end
    end
    table.insert(fields,{name="Members",value="Humans: **"..members.."**\nBots: **"..bots.."**",inline=true})
    table.insert(fields,{name="Region",value=guild.region,inline=true})
    if guild.roleCount > 0 then
        local roles = {}
        for role in guild.roles do
            table.insert(roles,role.mentionString)
        end
        table.insert(fields,{name="Roles",value=table.concat(roles,", "),inline=true})
    end
    
    message.channel:sendMessage {
        embed = {
            thumbnail = {url=guild.iconUrl},
            title = guild.name,
            description = "("..guild.id..")",
            fields = fields,
            footer = {text="This server is on Shard "..guild.shardId}
        }
    }
    
    
    
end,
{
    description=locale("server.description"),
    category="misc",
}