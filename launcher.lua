--Courtesy of SinisterRectus for this script

local fs = require('coro-fs')
local timer = require('timer')
local spawn = require('coro-spawn')
local split = require('coro-split')
local http = require("coro-http")
local json = require("json")

local fmt = '!%Y-%m-%d %H:%M:%S'

local cmd = ""
local settings = require(module.dir.."/resources/settings.lua")
local webhook = "https://discordapp.com/api/webhooks/"..settings.logger.status[1].."/"..settings.logger.status[2]

local tries = {}
local closeTimes = 0
local sleepDuration = 0

local function sendLog(title,description,color)
    local post = {
	  embeds = {
			{
				title = title,
				description = description,
				color = color
			}
		}
	}	
	http.request("POST",webhook,{{"Content-Type","application/json"}},json.encode(post))	
end

coroutine.wrap(function()
    
	while true do

		local log = fs.open("logs.txt", 'a')
		
		sendLog("Master","Attempting to start bot.","8901500")
		
		table.insert(tries,os.time())
		local child = spawn("luvit", {
			args = {cmd},
			stdio = {nil, true, true}
		})

		split(function()
			local line = {nil, ' ', nil}
			for data in child.stdout.read do
				line[1] = os.date(fmt)
				line[3] = data
				p(line)
				fs.write(log, line)
			end
		end, function()
			local line = {nil, ' ', nil}
			for data in child.stderr.read do
				line[1] = os.date(fmt)
				line[3] = data
				local error = data:match("Uncaught Error: (.*)stack traceback:")
				local error2 = data:match("Uncaught exception:(.*)stack traceback:")
				if error or error2 then
			    	sendLog("Master",(error or error2),"12597547")
				end
				fs.write(log, line)
			end
		end, child.waitExit)
		local currentTime = os.time()
		
		for i,v in pairs(tries) do
			if (currentTime - v) > 5 then
				closeTimes = closeTimes + 1
			end
		end
		if closeTimes ~= 0 and closeTimes % 5 == 0 then
			sleepDuration = sleepDuration + 300000
			sendLog("Master","Restarted too many times, waiting "..(sleepDuration/1000).." seconds.","12597547")
		end
		fs.close(log)
		timer.sleep(7000+sleepDuration)

	end

end)()