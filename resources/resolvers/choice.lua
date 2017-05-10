return function(arg,message,content)
	content = content or message.content
	content = content:lower()
	
	for i,v in pairs(arg.choices) do
		if content == v or content:sub(1,1) == v:sub(1,1) then
			return v
		end
	end
	
end