return {
    description = locale("reload.description"),
    permissions = {
       ids = {"260157417445130241"} 
    },
    category = "dev"
},
function(message,args,flags)
    local moduleName = args.stringArgs[1]
    if moduleName then
        local error = framework:reloadModule(moduleName,flags["norun"])
        if error then
            return locale("reload.failed",error)
        else
            return locale("reload.success",moduleName)
        end
    else
        return locale("reload.noname")
    end
end

