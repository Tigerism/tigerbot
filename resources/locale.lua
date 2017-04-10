local locale = {}
locale.__index = locale

local translations = framework:loadModules(module.dir.."/translations/")

for name, file in pairs(translations) do
    locale[name] = {}
    for commandName, stuff in pairs(file[1]) do
        locale[name][commandName] = {}
        for func, content in pairs(stuff) do --rip
            locale[name][commandName][func] = function(...) --(╯°□°）╯︵ ┻━┻
                local content = content
                local tuple = {...}
                for i,v in pairs(tuple) do
                   content = content:gsub("{{arg"..i.."}}",v)
                end
                return content
            end
        end
    end
end

setmetatable(locale,{
    __call = function(self,language,name)
        language = locale[language] and language or "en"
        return setmetatable({
          language = language or "en",
          name = name,
          currentCommand = locale[language][name]
        },
    self)
end})

return locale