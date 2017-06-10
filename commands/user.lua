
return function(message,args,flags)
    local member = args.myArgs[1]
    local author = member.user or member
    local guild = message.guild
    
    local options = {}
    if member.guild then
        if member.nickname then
            options["nickname"] = {name="Nickname",value=member.nickname,inline=true}
        end
        if member.roleCount > 0 then
            local roles = {}
            for role in member.roles do
                if role ~= guild.defaultRole then
                    table.insert(roles,role.name)
                end
            end
            options["roles"] = {name="Roles",value=table.concat(roles,", ")}
        end
        if member.gameName then
            options["game"] = {name="Game",value=member.gameName,inline=true}
        end
        if member.status then
            options["status"] = {name="Status",value=member.status,inline=true}
        end
        if member.voiceChannel then
            options["voiceChannel"] = {name="Voice Channel",value=member.voiceChannel.name,inline=true}
        end
        local keyPermissions = {}
        for i,v in pairs(member.permissions) do
            if i ~= "sendMessages" and i ~= "readMessages" and i ~= "createInstantInvite" and i ~= "speak" and i ~= "addReactions" and i ~= "readMessageHistory" and i~= "changeNickname" and i~= "useExternalEmojis" and i~= "embedLinks" and i~="connect" and i~="attachFiles" and i~="useVoiceActivity" then
                table.insert(keyPermissions,i)
            end
        end
        if #keyPermissions > 0 then
            options["permissions"] = {name="Key Permissions",value=table.concat(keyPermissions,", ")}
        end
    end
    options["avatar"] = {name="Avatar URL",value=author.avatarUrl,inine=true}

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
        embed.thumbnail = {url=author.avatarUrl}
        embed.title = author.username.."#"..author.discriminator
        embed.description = "("..author.id..")"  
        for i,v in pairs(options) do
            table.insert(embed.fields,v)
        end
    end
    
    message.channel:sendMessage {
        embed = embed
    }
    
end,
{
    description=locale("user.description"),
    category="misc",
    args = {{"user","Please specify the user."}},
    examples = {"tiger user @user","tiger user @user --avatar","tiger user @user --avatar --roles"},
    flags = {avatar="shows the person's avatar",roles="shows the person's roles",permissions="shows the person's permissions",nickname="shows the person's nickname",game="shows the person's game",status="shows the person's status",voiceChannel = "shows the person's connected voice channel"}
    
}