
return {
    description = "prevents new joiners quickly, without the need to edit any permissions. Useful for raiders. Use **whitelist** to allow a person in.",
    permissions = {raw={"manageGuild"}},
    args = {{"choice","Would you like to **enable** the serverlock, **disable** it, or **whitelist** a user?",choices={"enable","disable","whitelist"}}},
},
function(message,args,flags)
    local mainArg = args.myArgs[1]
    if mainArg == "whitelist" then
        local arg = respond:args {
            {
                prompt = "Who would you like to add/remove to the **whitelist?**",
                type = "user",
                name = "user"
            }
        }
        local user = arg.user
        local res = framework.modules.db[1]:get("guilds/"..message.guild.id.."/whitelist/"..user.id)
        if res then
            arg = respond:args {
                {
                    prompt = "This person is already whitelisted. Remove them from the whitelist? ``yes/no``",
                    type = "choice",
                    name = "choice",
                    choices = {"yes","no"}
                }
            }
            if arg.choice == "yes" then
              framework.modules.db[1]:delete("guilds/"..message.guild.id.."/whitelist/"..user.id.."/")
              respond:success("Successfully **removed** this person from the whitelist.")
              return
            else
                message.channel:sendMessage("No action has taken place.")
                return
            end
        end
        framework.modules.db[1]:set("guilds/"..message.guild.id.."/whitelist/","whitelist",{[user.id] = true})
        respond:success("Successfully **added** this person to the whitelist!")
    else
        framework.modules.db[1]:set("guilds/"..message.guild.id,"serverlock",{serverlock=mainArg == "enable"})
        respond:success("Successfully **"..mainArg.."d** the server lock.")
        if mainArg == "enable" then
            message.channel:sendMessage("New joiners will be kicked (while I am online). Use the **whitelist** option to allow specific users in (provide an id), or the **disable** option to disable the server lock.")
        end
    end
end
