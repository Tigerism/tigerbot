

return {
    description = "reloads a module"
},
{
	type = "permissions",
	ids = {"260157417445130241"}
},
function(message,args,flags)
    local moduleName = args[1]
    if moduleName then
        local error = framework:reloadModule(moduleName,flags["run"])
        if error then
            return "Module failed to reload: ``"..error.."``"
        else
           return "Successfully reloaded module ``"..moduleName.."``" 
        end
    else
        return "Please specify a module name."
    end
end

