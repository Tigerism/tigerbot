return function(message,args)
    framework.modules.db[1]:set("guilds/"..message.guild.id,"locale",{locale = args.myArgs[1]})
    return ":ok_hand:"
end,
{
    permissions = {
        serverOwnerOnly = true
        
    },
    category = "admin",
    description = "changes the language of the bot.",
    args = {{"string","Please state the locale."}}
}