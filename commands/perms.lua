return {
    permissions = {
        serverOwnerOnly = true
        
    },
    category = "admin"
},
function(message,args,flags)
    local newArgs = {}
    local arg = respond:args {
        {
          prompt = "Would you like to **grant** or **deny** a permission?",
          choices = {"grant","deny"},
          type = "choice",
          name = "choice"
        }
    }  
    if not arg then return end
    newArgs.first = arg.choice
    arg = respond:args {
        {
          prompt = "Would you like to **"..arg.choice.."** this permission to a **role**, a **channel**, or a **user**?",
          choices = {"role","channel","user"},
          type = "choice",
          name = "choice"
        }
    } 
    if not arg then return end
    newArgs.second = arg.choice
    arg = respond:args {
        {
          prompt = "Please specify the **"..arg.choice.."**.",
          type = arg.choice,
          name = "item"
        }
    }
    if not arg then return end
    newArgs.third = arg.item
    arg = respond:args {
        {
          prompt = "Please specify the **command node** that you would like to **"..newArgs.first.."** this permission to.\nExamples: mod.ban, misc.ping, ping ",
          type = "string",
          name = "item",
          node = true
        }
    }
    if not arg then return end
    newArgs.node = arg.item
    
    local first,second = framework.modules.permissions[1]:splitFromNode(newArgs.node)
    
    local data = {
        [((second ~= "*" and second) or first)] = {allow=newArgs.first == "grant",category=(second and first),all=(second=="*") or nil}
    }
    p(data)
    local result = framework.modules.db[1]:set("guilds/"..message.guild.id.."/perms/"..newArgs.second.."/"..newArgs.third.id.."/"..newArgs.first,"",data)
        
  
    if result then
        respond:success("Successfully saved the **"..newArgs.second.."** permission.")
    else
        respond:error("Failed to **"..newArgs.first.."** the permission to the **"..newArgs.second.."**.")
    end
end
