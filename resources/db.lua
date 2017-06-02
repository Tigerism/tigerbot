local firebase = require("luvit-firebase")(settings.db.node,settings.db.auth)

local db = {cache={}}

function db:get(node)
    --if db.cache[node] then return db.cache[node] end
    local error, data = firebase:get(node)
    --db.cache[node] = data
    if error then p("firebase:",error) end
    return not error and data
end

function db:set(node,saveAs,saveData)
    local error, data = firebase:update(node,saveData)
    if error then
        p(error)
        p(saveData)
        return
    end
    --db.cache[node.."/"..saveAs] = saveData[saveAs]
    return true
end

return db