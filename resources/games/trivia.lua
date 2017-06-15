local trivia = {games={},categories={}}
trivia.__index = trivia

local http = require("coro-http")
local json = require("json")
local baseUrl = "http://jservice.io/api"

local emitter = require("discordia").Emitter()
client.emitters["trivia"] = emitter

for i = 1, 184 do
    local headers,body = http.request("GET",baseUrl.."/categories?count=100&offset="..i*100)
    for i,v in pairs(json.parse(body)) do
        table.insert(trivia.categories,v)
    end
end

table.sort(trivia.categories,function(a,b)
    return a.clues_count > b.clues_count
end)

local function getQuestion(category)
    local id
    local url = baseUrl.."/clues"
    if category then
        for i,v in pairs(trivia.categories) do
            if v.title == category then
                url = url.."?category="..v.id
                break
            end
        end
    end
    local headers, body = http.request("GET",url)
    local newBody = json.parse(body)
    local questionsTable = json.parse(body)
    local i = 0
    return function()
        i = i + 1
        local x = math.random(#questionsTable)
        if newBody[x] and #questionsTable ~= 0 then
            questionsTable[x] = nil
            return i,newBody[x]
        end
    end
end

function trivia:getCategories(limit,justNames)
    local categories = {}
    for i = 1, limit do
        if trivia.categories[i] then
            if justNames then
                table.insert(categories,trivia.categories[i].title)
            else
                table.insert(categories,trivia.categories[i])
            end
        else
            break
        end
    end
    return categories
end

function trivia.new(message)
    local mt = setmetatable({
        gameStarted = false,
        guild = message.guild,
        channel = message.channel,
        message = message,
        winners = {}
    },trivia)
    trivia.games[message.guild.id] = mt
    return mt
end

function trivia:showWinners()
    local embed = {title="Trivia Winners",fields={}}
    local correct = {[1] = "1st",[2] = "2nd",[3] = "3rd"}
    table.sort(self.winners,function(a,b)
        return a[1] > b[1]
    end)
    local x = 0
    for i,v in pairs(self.winners) do
        x = x + 1
        if x == 4 then
            break
        end
        table.insert(embed.fields,{name=":trophy: "..v[2].." | "..correct[x],value=v[1].." points"})
    end
    if #embed.fields == 0 then
        embed.description = "None to show :eyes:"
    end
    self.channel:sendMessage{content = "Round concluded!", embed = embed}    
end

function trivia:startGame(category)
    local co = coroutine.running()
    self.category = category or self.category
    self.questions = getQuestion(category)
    for i, question in self.questions do
        if question.question then
            self.channel:sendMessage("Q."..i..") "..question.question)
            emitter:on("trivia_"..self.guild.id,function(message)
                local content = message.content
                local channel = message.channel
                local author = message.author
                if content:lower() == question.answer:lower() then
                    channel:sendMessage(author.mentionString.." got it correct! They've been awarded a point.")
                    self.winners[author.id] = {self.winners[author.id] and self.winners[author.id][1] and self.winners[author.id][1] + 1 or 1,author.username}
                    coroutine.resume(co)
                end
            end)
            coroutine.yield()
            emitter:removeAllListeners("trivia_"..self.guild.id)
        end
    end
    --round concluded
    self:endGame()
end

function trivia:endGame(noExit)
    if not noExit then
        trivia.games[self.guild.id] = nil
    end
    emitter:removeAllListeners("trivia_"..self.guild.id)
    self:showWinners()
    if not noExit then
        coroutine.yield()
    end
end

function trivia:restartGame()
    self.winners = {}
    self:endGame(true)
    self:startGame()
end

function trivia:getCurrentGame(guild)
    return trivia.games[guild.id]
end



return trivia