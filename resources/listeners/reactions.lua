local reactions = {menus={}}

local info = "ℹ"
local leftArrow = "⬅"
local rightArrow = "➡"
local wasteBin = "🗑"
	
function reactions:newReactionMenu(oldMessage,msg,fields,options)
	options = options or {}
	coroutine.wrap(function()
		msg:addReaction(info)
		msg:addReaction(leftArrow)
		msg:addReaction(rightArrow)
		msg:addReaction(wasteBin)
	end)()
	if options.startingPage then
		local embed = msg.embed
		local fields = modules.pagination[1]:toEmbed(options.startingPage,fields,5)
		if #fields == 0 then
			--embed.description = embed.description.."\n\n**There's no data to show.**"
		else
			embed.fields = fields
		end
		msg:setEmbed(embed)
	end
	reactions.menus[msg.id] = {oldMessage=oldMessage,msg=msg,infoEmbed=msg.embed,fields=fields,page=(options.startingPage or 0),emojis={leftArrow,rightArrow},options=options}
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
		local embed = {}
		if user.id == menu.oldMessage.author.id then
			if emoji == leftArrow then
				local fields = modules.pagination[1]:toEmbed(menu.page-1,menu.fields,5)
				if #fields > 0 then
					menu.page = menu.page - 1
					embed.fields = fields
				end
			elseif emoji == rightArrow then
				local fields = modules.pagination[1]:toEmbed(menu.page+1,menu.fields,5)
				if #fields > 0 then
					menu.page = menu.page + 1
					embed.fields = fields
				end
			elseif emoji == info then
				if menu.options.infoPage then
					embed = menu.options.infoPage
				else
					embed = menu.infoEmbed
				end
				menu.page = 0
			elseif emoji == wasteBin then
				message:delete()
				menu.oldMessage:delete()
			end
			if emoji ~= info then
				if not embed.fields or #embed.fields == 0  then
					if embed.description then
						embed.description = embed.description.."\n\n**There's no data to show.**"
					else
						embed.description = "**There's no data to show.**"
					end
				else
					embed.description = menu.options.description or embed.description or ""
				end
			end
			if emoji == leftArrow or emoji == rightArrow then
				if embed.fields and #embed.fields ~= 0 then
					message:setEmbed(embed)
				end
			elseif emoji == info then
				message:setEmbed(embed)
			end
		end
	end
end

framework:wrapHandler("reactionAdd",reactionAdd)

return reactions