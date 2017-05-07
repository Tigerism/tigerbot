local discordia = require('discordia')
local settings = require("./resources/settings.lua")
local client = discordia.Client{fetchMembers=true}

coroutine.wrap(function() require('./resources/framework.lua')(client,{settings=settings}) end)()

client:run(settings.token)
