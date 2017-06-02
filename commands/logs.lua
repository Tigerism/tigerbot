return {
    description = "views the moderation logs of a person.",
    args = {{"user","Please specify a user."}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local channel = message.channel
    
    local logs = framework.modules.db[1]:get("guilds/"..message.guild.id.."/logs/"..user.id) or {}
    local sortedLogs = {}
    local fields = {}
    for i,v in pairs(logs) do
        if type(v) == "table" then
            table.insert(sortedLogs,v)
        end
    end
    table.sort(sortedLogs,function(a,b)
        return a.timestamp > b.timestamp
    end)
    for i,v in pairs(sortedLogs) do
        local mod = client:getUser(v.mod)
        if mod then
            local timestamp = modules.resolvers.time[1][1]:toHumanTime(os.time()-v.timestamp,false).." ago"
            table.insert(fields,{name=v.type,value="**Reason:** "..v.reason.."\n**Issued:** "..timestamp.."\n**Moderator:** "..mod.username.."#"..mod.discriminator})
        end
    end
    
    local startingEmbed = {
        description = "Moderation Logs for **"..user.username.."#"..user.discriminator.."**"
    }
    
    local newMsg = channel:sendMessage {
        embed = startingEmbed
    }
    
    modules.listeners.reactions[1][1]:newReactionMenu(message,newMsg,fields,{
        description = startingEmbed.description,
        startingPage = 1,
        infoPage = {title="Tiger Moderation Logs",fields = {
            {name="FAQ",value="**Q1.) What's this?**\nAny moderation action you take with Tiger gets logged. This command allows you to view the moderation logs of a user with actions taken by Tiger.\n\n**Q2.) What actions get logged?**\nAny moderation taken by Tiger, such as a ban, kick, softban, mute, etc.",inline=false}

        }}
    })
end