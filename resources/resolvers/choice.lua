local choice = {}

function choice:resolve(message,content,choices)
	content = content:lower()
	for i,v in pairs(choices) do
		if content == v or content:sub(1,1) == v:sub(1,1) then
			return v
		end
	end
	
end

return choice