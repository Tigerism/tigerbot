return {
    description = "unmutes a member from the server.",
    args = {{"user","Please specify a user."},{"string","Please state the unmute reason."}},
    permissions = {raw={"muteMembers"}},
    category = "mod"
},
function(message,args,flags)
    local user = args.myArgs[1]
    local guild = message.guild
    local member = message.member
    local role = guild:getRole("name","TigerMuted") or guild:createRole("TigerMuted")
    if role then
        if user.guild then
            if member.highestRole.position < user.highestRole.position then
                respond:error("**"..user.username.."** has a higher role than you.")
                return
            end
            local result = user:removeRoles(role)
            if result then
                respond:success("Successfully unmuted **"..user.username.."**")
                modules.logger[1]:newModLog(guild,user,{
                    type = "Unmute",
                    reason = args.myArgs[2],
                    mod = message.author.id,
                })
            else
                respond:error("Failed to unmute **"..user.username.."**")
            end
        else
            respond:error("User must be a member of the server.")
        end
    else
        respond:error("Failed to create role.")
    end
end