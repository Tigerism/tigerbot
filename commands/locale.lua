return function(message,args)
    framework.modules.db:set("guilds/"..message.guild.id,"locale",{locale = args.stringArgs[1]})
    return ":ok_hand:"
end