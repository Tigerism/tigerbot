local respond = {}
respond.__index = respond

setmetatable(respond,{
    __call = function(self,message,emitter)
    return setmetatable({
      message = message,
      channel = message.channel,
      guild = message.guild,
      emitter = emitter,
      author = message.author
    },self)
end})

function respond:embed(...)
  local embed = {}
  --soon
end

function respond:success(text)
  
end

function respond:error(text)
  
end

function respond:args(args)
  local co = coroutine.running()
  for i,v in pairs(args) do
    self.channel:sendMessage(v.prompt)
    self.emitter:on(self.author.id,function(message)
      coroutine.resume(co)
    end)
    coroutine.yield()
  end
end

return respond