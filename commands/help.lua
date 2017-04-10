
local function generateCommandHelp(message)
    local channel = message.channel
    local commandList = {}
    local embed = {
        title = ":question: Help for Tiger 2.0",
        description = "Hello! I'm Tiger, a bot written in Lua with the Discordia library.\nUse the reaction buttons to filter through the command list.\n\nOfficial links: [Discord Server](https://discord.gg/62qYz8J) | [Invite](https://discordapp.com/oauth2/authorize?&client_id=225079733799485441&scope=bot&permissions=8)",
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
    modules.listeners.reactions[1]:newReactionMenu(message,newMsg,fields)
end


return {
    description = "shows this menu"
},
{
	--Permissions
	type = "permissions"
},
function(message,args)
    generateCommandHelp(message)
end,
{
    type = "args"
	--args
},
{
    type = "subcommands"
	--subcommands
}

