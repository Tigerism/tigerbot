
return function(message,args,flags)
    local guild = message.guild
    local options = {}
    
    if guild.large then
        options["large"] = {name=locale("server.largeServer"),value=guild.large,inline=true}
    end
    local members,bots = 0,0
    for member in guild.members do
        if member.bot then
            bots = bots + 1
        else
            members = members + 1
        end
    end
    options["members"] = {name=locale("server.members"),value="Humans: **"..members.."**\nBots: **"..bots.."**\nTotal: **"..guild.totalMemberCount.."**",inline=true}
    options["region"] = {name="Region",value=guild.region}
   
    if guild.emojiCount > 0 then
        local emojis = {}
        for emoji in guild.emojis do
            table.insert(emojis,emoji.string)
        end
        options["emojis"] = {name=locale("server.emojis"),value=(table.concat(emojis,", ").." ("..guild.emojiCount..")")}
    end
    if guild.roleCount > 0 then
        local roles = {}
        for role in guild.roles do
            table.insert(roles,role.mentionString)
        end
        options["roles"] = {name="Roles",value=table.concat(roles,", ")}
    end
    local fields = {}
    local embed = {fields={}}
    if #flags.table >= 1 then
        for i,v in pairs(flags.array) do
            local field = options[i]
            if field then
                table.insert(embed.fields,field)
            else
               table.insert(embed.fields,{name=i,value="none"}) 
            end
        end
    else
        embed.thumbnail = {url=guild.iconUrl}
        embed.title = guild.name
        embed.description = "("..guild.id..")"
        embed.footer = {text="This server is on Shard "..guild.shardId}
        for i,v in pairs(options) do
            table.insert(embed.fields,v)
        end
        table.insert(embed.fields,{name=locale("server.owner"),value=guild.owner.mentionString})
    end
    
    table.reverse(embed.fields)
    message.channel:sendMessage {
        embed = embed
    }
    
    
    
end,
{
    description=locale("server.description"),
    category="misc",
    flags = {owner="shows the server's owner",roles="shows the server's roles",emojis = "shows the server's emojis",members="shows the server's member count",region="shows the server's region",large="shows whether the server is considered 'large'"},
    examples = {"tiger server","tiger server --emojis","tiger server --roles --members"}
}