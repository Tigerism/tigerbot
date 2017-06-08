local http = require("coro-http")
local base64 = require("base64")

return {
    description = locale("setavatar.description"),
    permissions = {
       ids = {"260157417445130241"} 
    },
    category = "dev",
},
function(message,args,flags)
    local image = table.concat(args.stringArgs," ")
    local success,result = pcall(function()
		local _,av = http.request("GET",image)
		client:setAvatar("data:image/png;base64,"..base64.encode(av))
	end)
	if success then
	    respond:success("Successfully **changed** the avatar.")
    else
        respond:error("**Failed** to change the avatar.")
    end
end

