return {
    description = "clears 1-100 messages from the server.",
    args = {{"number","Please state the amount to prune."}},
    permissions = {raw={"manageMessages"}},
    category = "mod",
    flags = {bots = "prunes messages by bots",contains = "prunes messages that contain a certain phrase"},
    examples = {"tiger prune 100","tiger prune 100 --bots","tiger prune 100 --contains keyword","tiger prune 100 --bots --contains keyword"}
},
function(message,args,flags)
    local amount = args.myArgs[1]
    local result = message.channel:bulkDelete(amount,function(message)
        return ((flags.array.bots and message.author.bot) or (flags.array.contains and message.content:match(flags.array.contains)) or true) and not message.pinned 
    end)
    local prunedAmount = 0
    for message in result do
        prunedAmount = prunedAmount + 1
    end
    if result then
        local msg = respond:success("Successfully pruned **"..prunedAmount.."** messages.")
        sleep(5000)
        if msg then
            msg:delete()
        end
        message:delete()
    else
        respond:error("Failed to prune messages.")
    end
end