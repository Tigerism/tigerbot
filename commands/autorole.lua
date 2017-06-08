return {
    permissions = {
        serverOwnerOnly = true
        
    },
    description = locale("autorole.description"),
    category = "admin",
    args = {
        {"choice",locale("autorole.firstPrompt"),choices={locale("autorole.choices.create"),locale("autorole.choices.delete"),locale("autorole.choices.list")}},
        
    }
},
function(message,args,flags)
    local role
    local member = message.member
    local mainArg = args.myArgs[1]
    if mainArg ~= locale("autorole.choices.list") then
        local arg = respond:args {
            {
                prompt = locale("autorole.roleFind"),
                type = "role",
                name = "role"
            }
        }
        role = arg.role
    end
    if mainArg == locale("autorole.choices.create") then
        local arg = respond:args {
            {
                prompt = locale("autorole.secondPrompt"),
                choices = {locale("autorole.choices.get"),locale("autorole.choices.join"),locale("autorole.choices.bot")},
                type = "choice",
                name = "choice"
            }
        }
        if (role.position < member.highestRole.position) or message.guild.owner.id == message.author.id then
            framework.modules.db[1]:set("guilds/"..message.guild.id.."/autoroles/","autoroles",{[role.id] = arg.choice})
            respond:success(locale("autorole.saveSuccess"))
        else
            respond:error(locale("autorole.roleError"))
        end
    elseif mainArg == "remove" or mainArg == locale("autorole.choices.delete") then
        framework.modules.db[1]:delete("guilds/"..message.guild.id.."/autoroles/"..role.id.."/")
        respond:success(locale("autorole.roleDelete"))
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
            table.insert(fields,{name=locale("autorole.invalidRoles"),value=invalidRoles,inline=false})
        end
        if #fields == 0 then
            table.insert(fields,{name=locale("autorole.name"),value=locale("autorole.none"),inline=false})
        end
        message.channel:sendMessage {
            embed = {
                description = locale("autorole.autorolesFor",message.guild.name),
                fields = fields
                
            }
        }
    end
    
end
