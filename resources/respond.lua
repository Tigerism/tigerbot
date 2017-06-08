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
  return self.channel:sendMessage(":ok_hand: "..text)
end

function respond:error(text)
  return self.channel:sendMessage(":frowning: "..text)
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
      return framework.modules.resolvers.user[1][1]:resolve(message,message.content,arg)
    end
  elseif argType == "string" then
    return framework.modules.resolvers.string[1][1]:resolve(message,message.content,arg)
  elseif argType == "number" then
    return framework.modules.resolvers.number[1][1]:resolve(message)
  elseif argType == "choice" or argType == "choices" then
    return framework.modules.resolvers.choice[1][1]:resolve(message,message.content,arg.choices)
  elseif argType == "role" then
    return framework.modules.resolvers.role[1][1]:resolve(message,message.content,arg)
  elseif argType == "channel" then
    return framework.modules.resolvers.channel[1][1]:resolve(message,message.content,arg)
  elseif argType == "command" then
    --return framework.modules.resolvers.command[1][1]:resolve(message,arg.node)
  elseif argType == "duration" then
    return framework.modules.resolvers.duration[1][1]:resolve(message,message.content,arg)
  end
end

function respond:quit()
  respond.pending[self.author.id] = nil
  deActivate(self)
end

function respond:args(args)
  if respond.pending[self.author.id] then return end
  respond.pending[self.author.id] = self.channel.id
  local newArgs = {}
  local co = coroutine.running()
  for i,v in pairs(args) do
    if v.prompt ~= "" then
      self.channel:sendMessage(v.prompt.."\nSay **cancel** to cancel.")
    end
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