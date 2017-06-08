local responses = {
	"Heads",
	"Tails"
}

return function(message)
	local chosen = responses[math.random(1,#responses)]
	return chosen 
end,
{
    description=locale("flipcoin.description"),
    category="fun"
}