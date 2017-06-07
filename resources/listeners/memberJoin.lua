framework:wrapHandler("memberJoin",function(member)
    local guild = member.guild
    if not guild then return end
    
    local serverlock = framework.modules.db[1]:get("guilds/"..guild.id.."/serverlock/")
    if serverlock then
        local whitelist = framework.modules.db[1]:get("guilds/"..guild.id.."/whitelist/"..member.id.."/")
        if not whitelist then
            member:kick()
            return
        end
    end

    local autoroles = framework.modules.db[1]:get("guilds/"..guild.id.."/autoroles/") or {}
    local autorole = member.bot and "bot" or "join"
    
    for i,v in pairs(autoroles) do
        if v == autorole then
            local role = guild:getRole(i)
            if role then
                member:addRoles(role)
            end
        end
    end

end)