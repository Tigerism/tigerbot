return {
    description = "clears 1-100 messages from the server.",
    args = {{"number","Please state the amount to prune."}},
    permissions = {raw={"manageMessages"}},
    category = "mod"
},
function(message,args,flags)
    local amount = args.myArgs[1]
    local result = message.channel:bulkDelete(amount,function(message)
        return not message.pinned
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