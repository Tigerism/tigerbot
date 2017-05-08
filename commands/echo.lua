

return {
    description = "mainly a testing command"
},
function(message,args)

    local args = respond:args({
        {
            prompt = "Please specify the **member** argument.",
            type = "member",
            name = "member"
        }
    })
    if not args then return end
    return args.member.username

end


