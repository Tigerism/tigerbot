return {
    permissions = {
        serverOwnerOnly = true
        
    }
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
          prompt = "Please specify a **command** or a **category** that you would like to **"..newArgs.first.."** this permission to. ",
          type = "command",
          name = "item",
          node = true
        }
    }
    if not arg then return end
    newArgs.command = arg.item
    
    local data = {
        [newArgs.command] = newArgs.first == "grant"
    }

    local result = framework.modules.db:set("guilds/"..message.guild.id.."/perms/"..newArgs.second.."/"..newArgs.third.id.."/","",data)
    if result then
        respond:success("Successfully **saved** your permission configuration.")
    else
        respond:error("Failed to save your permission configuration.")
    end
end
