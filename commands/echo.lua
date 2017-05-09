

return {
    description = "mainly a testing command",
    args = {"member","string"}
},
function(message,args,flags)

   --[[ local args = respond:args({
        {
            prompt = "Please specify the **member** argument.",
            type = "member",
            name = "member"
        }
    })
    if not args then return end]]
    message.channel:sendMessage(args.myArgs[1].username)
    message.channel:sendMessage(args.myArgs[2])

end