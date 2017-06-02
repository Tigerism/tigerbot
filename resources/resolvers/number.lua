local number = {}

function number:resolve(message,content)
	--TODO: ???
	local content = content or message.content
	return tonumber(content)
end

return number