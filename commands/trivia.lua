return function(message,args,flags)
    local guild = message.guild
    local trivia = framework.modules.games.trivia[1][1]
    if flags.array["list"] then
        local categories = trivia:getCategories(100)
        local newMsg = message.channel:sendMessage("loading categories...")
        local fields = {}
        for i,v in pairs(categories) do
            table.insert(fields,{name=v.title,value=v.clues_count.." total questions"})
        end
        modules.listeners.reactions[1][1]:newReactionMenu(message,newMsg,fields,{
            description = "trivia categories"
        })
        newMsg:setContent("")
        return
    end
    local currentGame = trivia:getCurrentGame(guild)
    if currentGame then
        local arg = respond:args {
            {
                prompt = "A game already exists! Would you like to **end** the current game, or **start** a new one?",
                choices = {"end","start"},
                type = "choice",
                name = "choice"
            }
        }
        if arg.choice == "end" then
            currentGame:endGame()
            respond:success("Successfully **ended** the current trivia game.")
        elseif arg.choice == "start" then
            currentGame:restartGame()
            respond:success("Successfully **restarted** trivia.")           
        end
    else
        local categories = trivia:getCategories(100,true)
        table.insert(categories,"random")
        local arg = respond:args {
            {
                prompt = "Please state the **category** of the trivia questions you'd like. Don't know the category name? Say **tiger trivia --list** to get the categories.\nSay **random** to get a random category.\n",
                choices = categories,
                type = "choice",
                name = "category"
            }
        }
        trivia.new(message):startGame(arg.category)
    end
end,
{
    description="start a game of trivia!",
    category="fun",
    permissions = {roles={"Bot Commander"}}
}