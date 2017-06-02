local stringResolver = {}

function stringResolver:resolve(message,content)
	--TODO: ???
	return content or message.content
end

return stringResolver