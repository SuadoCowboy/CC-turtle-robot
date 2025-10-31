--[[
Receives commands from command_handler event
]]--

UpdateFunctions[#UpdateFunctions+1] = function()
	while true do
		local event, data = os.pullEvent('command_handler') -- TODO: does this filter works? ComputerCraft wiki is down right now.
		if event == 'command_handler' then
			CommandHandler.parse(nil, data)
		end
	end
end