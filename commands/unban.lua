return {
    description = "unbans a member from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the reason."}},
    permissions = {roles = {"Bot Commander"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local result = message.guild:unbanUser(user)
    if result then
        respond:success("Successfully unbanned **"..user.username.."**")
    else
        respond:error("Failed to unban **"..user.username.."**")
    end
end