local perms = {
    
}

function perms:hasPermission(...)
    --SOON
end

function perms:getMemberPermissions(member)
    local permissions = {}
    
    for role in member.roles do
        local permTable = role.permissions:toTable()
        for i,v in pairs(permTable) do
           if v then
               permissions[i] = true
            end
        end
    end

    return permissions
end

function perms:splitFromNode(node)
    local split = framework:split(node,"%.")
    if split[1] and split[2] then
        return split[1], split[2]
    else
        return node
    end
end


return perms