local litcord = require('litcord')
local settings = require("resources.settings")

local framework = require('resources.framework'){
	settings = settings,
	litcord = litcord
		
}