local discordia = require('discordia')
local settings = require("./resources/settings.lua")
local client = discordia.Client{fetchMembers=true}

local framework = require('./resources/framework.lua')(client,{settings=settings})

client:run(settings.token)
