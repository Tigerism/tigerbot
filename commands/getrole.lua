return {
    description = "gets an automatic role.",
    args = {{"role","Please specify the **role** you are trying to get"}}
},
function(message,args,flags)
    local guild = message.guild
    local member = message.member
    local role = args.myArgs[1]
    
    local autorole = framework.modules.db[1]:get("guilds/"..guild.id.."/autoroles/"..role.id)
    if autorole and autorole == "get" then
        local result = member:addRoles(role)
        if result then
            respond:success("Successfully **given** you the role.")
        else
            respond:error("**Failed** to give you the role.")
        end
    else
       respond:error("This role is not obtainable.") 
    end
end
