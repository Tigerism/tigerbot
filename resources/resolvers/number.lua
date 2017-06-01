return function(message,content)
	--TODO: ???
	local content = content or message.content
	return tonumber(content)
end