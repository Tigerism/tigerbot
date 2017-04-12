

return {
    description = "reloads a module"
},
{
	type = "permissions"
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
    end
end

