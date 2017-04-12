return function(command)
    local info = {name=command.name,subcommands={},listSubcommands={},flags={}}
    for i,v in pairs(command) do
        if type(v) == "table" then
            if v.type == "description" or v.description or v.fullDescription then
                info.description = v.description or v.fullDescription or "no description available"
            elseif v.type == "flags" then
                for l,k in pairs(v) do
                    if l ~= "type" then
                        table.insert(info.flags,l.." ➜ "..k)
                    end
                end
            elseif v.type == "subcommands" then
                for l,k in pairs(v) do
                    if type(k) == "table" and type(k[2]) == "function" then
                        info.subcommands[l] = {k[1],k[2]}
                        table.insert(info.listSubcommands,l)
                    end
                end
            end
            
        end
    end
    return info
end