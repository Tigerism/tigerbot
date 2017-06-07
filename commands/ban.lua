return {
    description = "ban a member from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the ban reason."},{"duration","Please state the ban duration.\nSay **none** if the action is permanent."}},
    permissions = {raw={"banMembers"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local member = message.member
    local guild = message.guild
    if user.guild and guild.owner.id ~= user.id then
        if member.highestRole.position < user.highestRole.position then
            respond:error("**"..user.username.."** has a higher role than you.")
            return
        end
    end
    local result = guild:banUser(user,7)
    if result then
        respond:success("Successfully banned **"..user.username.."**")
        modules.logger[1]:newModLog(guild,user,{
            type = "Ban",
            reason = args.myArgs[2],
            duration = args.myArgs[3],
            mod = message.author.id,
        })
    else
        respond:error("Failed to ban **"..user.username.."**")
    end
end