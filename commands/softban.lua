return {
    description = "softban (ban and unban) a member from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the softban reason."}},
    permissions = {raw={"kickMembers"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local guild = message.guild
    guild:banUser(user,7)
    local result = guild:unbanUser(user)
    if result then
        respond:success("Successfully softbanned **"..user.username.."**")
        modules.logger[1]:newModLog(guild,user,{
            type = "Softban",
            reason = args.myArgs[2],
            mod = message.author.id
        })
    else
        respond:error("Failed to softban **"..user.username.."**")
    end
end