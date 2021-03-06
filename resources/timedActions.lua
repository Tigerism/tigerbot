local pendingActions = {}
local actions = {}

local discordia = require("discordia")
local clock = discordia.Clock()

clock:on("min",function()
	for i,v in pairs(pendingActions) do
		for l,k in pairs(v) do
			if os.time() >= k.expiresOn then
				local guild = client:getGuild(k.guild)
				if guild then
					if k.type == "Ban" then
						guild:unbanUser(client:getUser(k.user))
					elseif k.type == "Mute" then
						local member = guild:getMember(k.user)
						if member then
							for role in member.roles do
								if role.name == "TigerMuted" then
									member:removeRoles(role)
								end
							end
						end
					end
				end
				table.remove(pendingActions[k.guild],l)
				framework.modules.db[1]:delete("pendingActions/"..k.guild.."/"..k.user)	
			end
		end
	end
end)

clock:start()

function actions.new(toAdd,guild,user,options)
	if not guild then return end
	if not user then return end
	if not options then return end
	if toAdd then
		if not pendingActions[guild] then
			pendingActions[guild] = {}
		end
		table.insert(pendingActions[guild],{guild=guild,user=user,type=options.type,expiresOn=options.expiresOn})
	else
		if pendingActions[guild] then
			for i,v in pairs(pendingActions[guild]) do
				if v.user == user then
					if (v.type == options.type) or (options.type == "Unban" and v.type == "Ban") or (options.type == "Unmute" and v.type == "Mute") then
						table.remove(pendingActions[guild],i)
						framework.modules.db[1]:delete("pendingActions/"..guild.."/"..user)
					end
				end
			end
		end
	end
end

local pendingStuff = framework.modules.db[1]:get("pendingActions/") or {}
for i,v in pairs(pendingStuff) do
	for l,k in pairs(v) do
		actions.new(true,k.guild,k.user,k)
	end
end


return actions.new