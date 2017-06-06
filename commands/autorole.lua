return {
    permissions = {
        serverOwnerOnly = true
        
    },
    description = "sets up an automatic role.",
    category = "admin",
    args = {
        {"choice","Would you like to **create** an autorole, **delete** an existing one, or **list** the current autoroles?",choices={"create","delete","list"}},
        
    }
},
function(message,args,flags)
    local role
    local mainArg = args.myArgs[1]
    if mainArg ~= "list" then
        local arg = respond:args {
            {
                prompt = "What **role** are you targeting?",
                type = "role",
                name = "role"
            }
        }
        if not arg then return end
        role = arg.role
    end
    if mainArg == "create" then
        local arg = respond:args {
            {
                prompt = "What condition would you like to apply to this role?\nConditions: **get**, **join**, **bot**",
                choices = {"get","join","bot"},
                type = "choice",
                name = "choice"
            }
        }
        if not arg then return end
        framework.modules.db[1]:set("guilds/"..message.guild.id.."/autoroles/","autoroles",{[role.id] = arg.choice})
        respond:success("Successfully **saved** your new autorole.")
    elseif mainArg == "remove" or mainArg == "delete" then
        framework.modules.db[1]:delete("guilds/"..message.guild.id.."/autoroles/"..role.id.."/")
        respond:success("Successfully **deleted** your autorole.")
    elseif mainArg == "list" then
        local autoroles = framework.modules.db[1]:get("guilds/"..message.guild.id.."/autoroles/") or {}
        local fields = {}
        local conditions = {}
        local invalidRoles = 0
        for i,v in pairs(autoroles) do
            local role = message.guild:getRole(i)
            if role then
                conditions[v] = conditions[v] or {} 
                table.insert(conditions[v],role.name)
            else
                invalidRoles = invalidRoles + 1
                framework.modules.db[1]:delete("guilds/"..message.guild.id.."/autoroles/"..i.."/")
            end
        end
        for i,v in pairs(conditions) do
            table.insert(fields,{name=i,value=table.concat(v,"\n"),inline=false})
        end
        if invalidRoles > 0 then
            table.insert(fields,{name="Invalid Roles",value=invalidRoles,inline=false})
        end
        if #fields == 0 then
            table.insert(fields,{name="Autoroles",value="None to show.",inline=false})
        end
        message.channel:sendMessage {
            embed = {
                --title = "Tiger Autoroles",
                description = "Autoroles for **"..message.guild.name.."**",
                fields = fields
                
            }
        }
    end
    
end
