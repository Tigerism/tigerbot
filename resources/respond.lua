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
  if argType == "user" then
    local user = message.mentionedUsers()
    if user then
      return user
    else
      return framework.modules.resolvers.user[1](message)
    end
  elseif argType == "string" then
    return framework.modules.resolvers.string[1](message)
  elseif argType == "choice" or argType == "choices" then
    return framework.modules.resolvers.choice[1](arg,message)
  elseif argType == "role" then
    return framework.modules.resolvers.role[1](message,message.guild)
  elseif argType == "channel" then
    return framework.modules.resolvers.channel[1](message,message.guild)
  elseif argType == "command" then
    return framework.modules.resolvers.command[1](message,arg.node)
  end
end

function respond:args(args)
  if respond.pending[self.author.id] then return end
  respond.pending[self.author.id] = self.channel.id
  local newArgs = {}
  local co = coroutine.running()
  for i,v in pairs(args) do
    self.channel:sendMessage(v.prompt.."\nSay **cancel** to cancel.")
    self.listener = function(message)
      if message.channel.id ~= self.channel.id then return end
      local content = message.content
      if content:lower():match("cancel") then
        self.channel:sendMessage("**Canceled prompt.**")
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
        self.channel:sendMessage("Invalid **"..v.type.."** argument. Please try again or say **cancel** to cancel.")
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