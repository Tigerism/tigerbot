local perms = {}

function perms:splitFromNode(node)
    --mod.ban
    --misc.*
    local split = framework:split(node,"%.")
    if split[1] and split[2] then
        return split[1], split[2]
    else
        return node
    end
end


return perms