--[[
Receives commands from command_handler event
]]--

UpdateFunctions[#UpdateFunctions+1] = function()
	while true do
		local event, computersWhitelist, command, args = os.pullEvent('command_handler') -- TODO: does this filter works? ComputerCraft wiki is down right now.
		CommandHandler.parse(computersWhitelist, command, args)
	end
end