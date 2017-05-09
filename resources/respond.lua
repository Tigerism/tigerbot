local respond = {pending={}}
respond.__index = respond

setmetatable(respond,{
    __call = function(self,message,emitter,hasPermission)
    return setmetatable({
      message = message,
      channel = message.channel,
      guild = message.guild,
      emitter = emitter,
      author = message.author,
      hasPermission = hasPermission
    },self)
end})

function respond:embed(...)
  local embed = {}
  --soon
end

function respond:success(text)
  self.channel:sendMessage(":ok_hand: "..text)
end

function respond:error(text)
  self.channel:sendMessage(":frowning: "..text)
end

local function deActivate(self)
  self.emitter:removeListener(self.author.id,self.listener)
end

local function isCorrect(message,arg)
  local argType = arg.type
  if argType == "member" then
    local user = message.mentionedUsers()
    if user then
      return user
    else
      return framework.modules.resolvers.member[1](message)
    end
  elseif argType == "string" then
    return framework.modules.resolvers.string[1](message)
  end
end

function respond:args(args)
  if respond.pending[self.author.id] then return end
  respond.pending[self.author.id] = self.channel.id
  local newArgs = {}
  local co = coroutine.running()
  for i,v in pairs(args) do
    self.channel:sendMessage(v.prompt)
    self.listener = function(message)
      if message.channel.id ~= self.channel.id then return end
      local content = message.content
      if content:lower():match("cancel") then
        self.channel:sendMessage("**Cancelled prompt.**")
        respond.pending[self.author.id] = nil
        deActivate(self)
        return
      end
      local check = isCorrect(message,v)
      if check then
        newArgs[v.name] = check
        deActivate(self)
        coroutine.resume(co)  
      else
        self.channel:sendMessage("Incorrect **"..v.type.."** argument. Please try again.")
        return
      end
    end
    
    self.emitter:on(self.author.id,self.listener)

    coroutine.yield()
    
  end
  respond.pending[self.author.id] = nil
  return newArgs
end

return respond