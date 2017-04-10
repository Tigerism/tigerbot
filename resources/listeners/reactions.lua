local reactions = {menus={}}

local info = "ℹ"
local leftArrow = "⬅"
local rightArrow = "➡"
local wasteBin = "🗑"
	
function reactions:newReactionMenu(oldMessage,msg,fields)
	coroutine.wrap(function()
		msg:addReaction(info)
		msg:addReaction(leftArrow)
		msg:addReaction(rightArrow)
		msg:addReaction(wasteBin)
	end)()
	reactions.menus[msg.id] = {oldMessage=oldMessage,msg=msg,infoEmbed=msg.embed,fields=fields,page=0,emojis={leftArrow,rightArrow}}
end

local function reactionAdd(reaction,user)
	if user.id == client.user.id then return end
	local emoji = reaction.emoji
	local message = reaction.message
	local guild = message.guild
	local member = user:getMembership(guild)
	local menu = reactions.menus[message.id]
	if menu then
		message:removeReaction(emoji,member)
		local embed
		if user.id == menu.oldMessage.author.id then
			if emoji == leftArrow then
				local fields = modules.pagination:toEmbed(menu.page-1,menu.fields,5)
				if #fields > 0 then
					menu.page = menu.page - 1
					embed = {}
					embed.fields = fields
				end
			elseif emoji == rightArrow then
				local fields = modules.pagination:toEmbed(menu.page+1,menu.fields,5)
				if #fields > 0 then
					menu.page = menu.page + 1
					embed = {}
					embed.fields = fields
				end
			elseif emoji == info then
				menu.page = 0
				embed = menu.infoEmbed
			elseif emoji == wasteBin then
				message:delete()
				menu.oldMessage:delete()
			end
			message:setEmbed(embed)
		end
	end
end

client:on("reactionAdd",reactionAdd)

return reactions