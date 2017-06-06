return {
    description = "warn a member.",
    args = {{"user","Please specify a user."},{"string","Please state the reason."}},
    permissions = {roles = {"Bot Commander"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local guild = message.guild
    respond:success("Successfully warned **"..user.username.."**")
    modules.logger[1]:newModLog(guild,user,{
        type = "Warn",
        reason = args.myArgs[2],
        mod = message.author.id
    })
end