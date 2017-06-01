return {
    description = "bans a member from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the ban reason."}},
    permissions = {roles = {"Bot Commander"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local result = message.guild:banUser(user,7)
    if result then
        respond:success("Successfully banned **"..user.username.."**")
    else
        respond:error("Failed to ban **"..user.username.."**")
    end
end