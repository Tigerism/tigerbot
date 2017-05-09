

return {
    description = "bans a member from the server.",
    args = {"member","string"},
    permissions = {roles = {"Bot Commander"}}
},
function(message,args,flags)
    local member = args.myArgs[1]
    local result = member:ban(7)
    if result then
        respond:success("Successfully banned **"..member.username.."**")
    else
        respond:error("Failed to ban **"..member.username.."**")
    end
end