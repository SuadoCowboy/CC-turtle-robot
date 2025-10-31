--[[
Receives commands from other modules
]]--

CommandHandler = {}

---@class Command
---@field callback fun()
---@field description string
Commands = {}

function CommandHandler.parse(computersWhitelist, data)
	if type(data) == 'string' then
		Write(computersWhitelist, 'Received:', data .. '\n')

	elseif type(data) == 'table' then
		if data.command == nil or type(data.command) ~= 'string' then
			Write(computersWhitelist, 'Missing command in received data\n')
		end

		if Commands[data.command] == nil then
			WriteError(computersWhitelist, 'Command "' .. data.command .. '" not found\n')
			return
		end

		local ok, err
		if data.args == nil then
			ok, err = pcall(Commands[data.command].callback, computersWhitelist)
		else
			ok, err = pcall(Commands[data.command].callback, computersWhitelist, unpack(data.args))
		end

		if not ok then
			if err == 'Terminated' then
				Write(computersWhitelist, 'Terminated\n')
			else
				WriteError(computersWhitelist, 'An error occurred: ' .. err .. '\n')
			end
		end

	else
		Write(computersWhitelist, 'Received invalid data type\n')
	end
end

Commands['help'] = {
	callback = function(computersWhitelist, command)
		if command == nil then
			local commandsList = ''
			for commandName, command in pairs(Commands) do
				if type(command.description) == 'string' then
					commandsList = commandsList .. commandName .. ' ' .. command.description .. '\n'
				end
			end

			Write(computersWhitelist, commandsList)

		elseif Commands[command] == nil then
			WriteError(computersWhitelist, 'Unknown command "' .. command .. '"\n')

		else
			if type(Commands[command].description) == 'string' then
				Write(computersWhitelist, command .. ' ' .. Commands[c].description .. '\n')
			else
				Write(computersWhitelist, command .. '\n')
			end
		end
	end,
	description = '<command?> - Prints a list of commands'
}