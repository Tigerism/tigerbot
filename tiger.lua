local discordia = require("discordia")
local client = discordia.Client({fetchMembers = true})

local commands = require("./resources/commands.lua"){
	prefix = {"tiger ","tiger, ","<@225079733799485441> ","t!","tiger!"},
	ownerName = "Mindy Lahiri",
	description = "An advanced bot written in Lua using the Discordia library. Say tiger help to get a list of commands.",
	commandDir = module.dir.."/commands/",
	owner = "217122202934444033",
	errorMsg = ":frowning: "

}

local framework = require("./resources/framework.lua")(client)
client.modules = framework:loadScript(module.dir.."/resources/modules/")
client.settings = framework:loadScript(module.dir.."/resources/settings.lua")
client.commands = commands
client.framework = framework

client:run(client.settings.token)
