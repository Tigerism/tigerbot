local function generateCommandHelp(message)
    local channel = message.channel
    local commandList = {}
    local embed = {
        title = ":question: "..locale("help.embedTitle"),
        description = locale("help.embedDescription"),
        fields = {}
    }
    local categories = {}
    local fields = {}
    for i,v in pairs(command.commands) do
        local newCommand = command:makeCommand(message,i,v) 
        for l,k in pairs(newCommand) do
            if type(k) == "table" and (k.description or k.category) then
                local category = k.category or "misc"
                local description = k.description or "this command is not documented"
                if not categories[category] then
                    categories[category] = {}
                end
                table.insert(categories[category],{name=i,value=description,inline=true,category=category,description="test"})
            end
        end
    end
    for i,v in pairs(categories) do
        for l,k in pairs(v) do
            table.insert(fields,k)
        end
    end
    local newMsg = channel:sendMessage{embed=embed}
    modules.listeners.reactions[1][1]:newReactionMenu(message,newMsg,fields)
end


return {
    description = locale("help.description")
},
function(message,args,flags)
    generateCommandHelp(message)
end
