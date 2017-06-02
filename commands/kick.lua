return {
    description = "kicks a member from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the kick reason."}},
    permissions = {roles = {"Bot Commander"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local guild = message.guild
    local result = guild:kickUser(user)
    if result then
        respond:success("Successfully kicked **"..user.username.."**")
        modules.logger[1]:newModLog(guild,user,{
            type = "Kick",
            reason = args.myArgs[2],
            mod = message.author.id
        })
    else
        respond:error("Failed to kick **"..user.username.."**")
    end
end