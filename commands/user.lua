
return function(message,args,flags)
    local member = args.myArgs[1]
    local author = member.user or member
    local guild = message.guild
    
    local fields = {}
    if member.guild then
        if member.nickname then
            table.insert(fields,{name="Nickname",value=member.nickname,inline=true})
        end
        if member.roleCount > 0 then
            local roles = {}
            for role in member.roles do
                if role ~= guild.defaultRole then 
                    table.insert(roles,role.name)
                end
            end
            table.insert(fields,{name="Roles",value=table.concat(roles,", "),inline=true})
        end
        if member.gameName then
            table.insert(fields,{name="Game",value=member.gameName,inline=true})
        end
        if member.status then
            table.insert(fields,{name="Status",value=member.status,inline=true})
        end
        if member.voiceChannel then
            table.insert(fields,{name="Voice Channel",value=member.voiceChannel.name,inline=true})
        end
        local keyPermissions = {}
        for i,v in pairs(member.permissions) do
            if i ~= "sendMessages" and i ~= "readMessages" and i ~= "createInstantInvite" and i ~= "speak" and i ~= "addReactions" and i ~= "readMessageHistory" and i~= "changeNickname" and i~= "useExternalEmojis" and i~= "embedLinks" and i~="connect" and i~="attachFiles" and i~="useVoiceActivity" then
                table.insert(keyPermissions,i)
            end
        end
        if #keyPermissions > 0 then
            table.insert(fields,{name="Key Permissions",value=table.concat(keyPermissions,", "),inline=true})
        end
    end
    table.insert(fields,{name="Avatar URL",value=author.avatarUrl,inine=true})
    
    
    message.channel:sendMessage {
        embed = {
            thumbnail = {url=author.avatarUrl},
            title = author.username.."#"..author.discriminator,
            description = "("..author.id..")",
            fields = fields
        }
    }
    
    
    
end,
{
    description=locale("user.description"),
    category="misc",
    args = {{"user","Please specify the user."}}
}