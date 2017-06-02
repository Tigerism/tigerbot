return {
    description = locale("reload.description"),
    permissions = {
       ids = {"260157417445130241"} 
    },
    category = "dev",
    args = {{"string","Please specify the module name."}}
},
function(message,args,flags)
    local moduleName = args.myArgs[1]
    local error = framework:reloadModule(moduleName,flags["norun"])
    if error then
        return locale("reload.failed",error)
    else
        return locale("reload.success",moduleName)
    end
end

