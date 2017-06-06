return {
    description = "unban a user from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the reason."}},
    permissions = {roles = {"Bot Commander"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local guild = message.guild
    local result = guild:unbanUser(user)
    if result then
        respond:success("Successfully unbanned **"..user.username.."**")
        modules.logger[1]:newModLog(guild,user,{
            type = "Unban",
            reason = args.myArgs[2],
            mod = message.author.id
        })
    else
        respond:error("Failed to unban **"..user.username.."**")
    end
end