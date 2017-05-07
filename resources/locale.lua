local locale = {}

local translations = framework:loadModules(module.dir.."/translations/")

local function rec(this,that,name,path)
    for i,v in pairs(this) do
        if type(v) == "table" then
            if i == that[1] then
                table.remove(that,1)
            end
            return rec(v,that)
        end
        if that and #that ~= 0 then
            for l,k in pairs(that) do
                if k == that[1] and k == i then
                    return v
                end
            end
        end
    end
end

function locale.new(language,name,only)
    return function(path,...)
        local tuple = ...
        local tuple2 = {...}
        local newPath = type(path) == "string" and framework:split(path,"%.") or path
        local findLocale = translations[language] and translations[language][1] or translations["en"][1]
        if findLocale then
            local command
            if findLocale[newPath[1]] then
                command = findLocale[newPath[1]]
                table.remove(newPath,1)
            else
                command = findLocale[name]
            end
            if command then
                if command[newPath[1]] then
                    local this = command[newPath[1]]
                    table.remove(newPath,1)
                    if type(this) == "table" and #newPath > 0 then
                        local thing = rec(this,newPath,name,path)
                        if thing then
                            return thing
                        end
                    else
                        for i,v in pairs(tuple2) do
                            this = this:gsub("{{arg"..i.."}}",v)
                        end
                        return this
                    end
                end
            end
        end
        return only and path or locale.new("en",name,true)(path,table.unpack(tuple2))
    end
end

return locale.new