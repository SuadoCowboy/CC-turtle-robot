--[[
Receives commands from rednet.
Hosts a server which some client connects and sends/receives information to/from it.

TURTLE MUST BE EQUIPPED WITH A MODEM ON THE LEFT.
]]--

InitFunctions[#InitFunctions+1] = function()
	local hostName = "turtle" .. os.getComputerID()
	rednet.host("command_handler", hostName)

	Write(nil, 'Hosting command_handler protocol as "' .. hostName .. '"\n')

	return true
end

CleanupFunctions[#CleanupFunctions+1] = function()
	Write(nil, 'Closing host\n')
	rednet.unhost("command_handler", "turtle" .. os.getComputerID())
end

UpdateFunctions[#UpdateFunctions+1] = function()
	while true do
		local id, data = rednet.receive("command_handler", 10000)

		if data ~= nil then
			CommandHandler.parse({id}, data.command, data.args)
		end
	end
end