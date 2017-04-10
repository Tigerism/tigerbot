local pagination = {}


function pagination:toEmbed(number,fields,toShow,inline)
  local newFields = {}
  local maxNum = math.ceil(#fields / toShow)
  for i = number * toShow - (toShow-1), number * toShow do
    if fields[i] then
      table.insert(newFields,{name = i..") "..fields[i].name,value = fields[i].value,inline = (inline or false)})
    else
      break
    end
  end
  return newFields
end

return pagination