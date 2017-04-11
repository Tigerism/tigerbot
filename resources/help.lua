return function(command)
    local info = {name=command.name,subcommands={},listSubcommands={}}
    for i,v in pairs(command) do
        if type(v) == "table" then
            if v.type == "description" or v.description or v.fullDescription then
                info.description = v.description or v.fullDescription or "no description available"
            elseif v.type == "subcommands" then
                for l,k in pairs(v) do
                    if type(k) == "function" then
                        info.subcommands[l] = k
                        table.insert(info.listSubcommands,l)
                    end
                end
            end
            
        end
    end
    return info
end