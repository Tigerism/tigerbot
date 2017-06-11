local reactions = {menus={}}

local info = "ℹ"
local leftArrow = "⬅"
local rightArrow = "➡"
local wasteBin = "🗑"

local timer = require("timer")

local function turnPage(menu,page)
	local embed = {}
	local options = menu.options
	local type = options.type or "fields"
	local resultsPerPage = options.resultsPerPage or 5
	if page == 0 then
		if options.startPage then
			embed = options.startPage
			menu.msg:setEmbed(embed)
			menu.page = 0
		end
	else
		if type == "fields" then
			local fields = modules.pagination[1]:toEmbed(page,menu.items,resultsPerPage)
			if #fields ~= 0 then
				menu.page = page
				embed.fields = fields
				embed = embed
			end
		elseif type == "image" then
			if menu.items[page] then
				menu.page = page
				embed.image = {url=menu.items[page]}
				embed = embed
			end
		end
	end
	if not embed.description and options.description then
		embed.description = options.description
	end
	if embed.fields or embed.image then
		menu.msg:setEmbed(embed)
	end	
end

function reactions:newReactionMenu(originalMsg,msg,items,options)
	options = options or {}
	coroutine.wrap(function()
		if options.startPage then
			msg:addReaction(info)
		end
		timer.sleep(1100)
		msg:addReaction(leftArrow)
		timer.sleep(1100)
		msg:addReaction(rightArrow)
		timer.sleep(1100)
		msg:addReaction(wasteBin)
	end)()
	local startNumber = options.startNumber or 1
	reactions.menus[msg.id] = {items=items,options=options,msg=msg,original=originalMsg,page=startNumber}
	turnPage(reactions.menus[msg.id],startNumber)
end


local function reactionAdd(reaction,user)
	if user.id == client.user.id then return end
	local emoji = reaction.emoji
	local message = reaction.message
	local guild = message.guild
	local member = user:getMembership(guild)
	local menu = reactions.menus[message.id]
	local options = menu.options
	options.type = options.type or "fields"
	local resultsPerPage = options.resultsPerPage or 5
	if menu then
		message:removeReaction(emoji,member)
		if user.id ~= menu.original.author.id then return end
		local page = menu.page
		if emoji == rightArrow then
			turnPage(menu,menu.page+1)
		elseif emoji == leftArrow then
			turnPage(menu,menu.page-1)
		elseif emoji == info then
			turnPage(menu,0)
		elseif emoji == wasteBin then
			message:delete()
			menu.original:delete()
			reactions.menus[message.id] = nil
		end
	end
end

framework:wrapHandler("reactionAdd",reactionAdd)

return reactions