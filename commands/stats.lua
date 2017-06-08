local uv = require("uv")

return function(message,args,flags)
    
    local memUsage = math.floor(uv.resident_set_memory()/1024/1024)
    memUsage = tostring(memUsage.." mb ("..math.floor((memUsage/uv.get_total_memory()))).."%)"
    
    message.channel:sendMessage {
        embed = {
            title = "About",
            description = "I'm an advanced bot written in Lua for the Luvit runtime environment.",
            fields = {
                {name = "Developer",value = "Tom Daley#2347",inline=true},
                {name = "Library",value = "Discordia (Lua)",inline=true},
                {name = "Guilds",value = client.guildCount,inline=true},
                {name = "Shards",value = client.shardCount,inline=true},
                {name = "Uptime",value = (client.started and modules.resolvers.duration[1][1]:toHumanTime(math.abs(os.time()-client.started),true)) or "bot just started...",inline=true},
                {name = "Memory Usage",value = memUsage,inline=true},
                
            }
        }
    }
    
    
    
end,
{
    description=locale("stats.description"),
    category="misc"
}