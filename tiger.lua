local discordia = require("discordia")
local client = discordia.Client({fetchMembers = true})


local framework = require("./resources/framework.lua")(client)
client.modules = framework:loadScript(module.dir.."/resources/modules/")
client.settings = framework:loadScript(module.dir.."/resources/settings.lua")
client.framework = framework

client:run(client.settings.token)
