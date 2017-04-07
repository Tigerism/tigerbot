return {
	--Permissions
	type = "permissions"
},function(message,args)
    db:set("guilds/"..message.guild.id,"locale",{locale = args[1]})
    return ":ok_hand:"
end,{
    type = "args"
	--args
},{
    type = "subcommands"
	--subcommands
}

