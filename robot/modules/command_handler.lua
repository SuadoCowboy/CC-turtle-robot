--[[
Receives commands from other modules
]]--

CommandHandler = {}

---@class Command
---@field callback fun()
---@field description string
if Commands == nil then
	Commands = {}
end

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

		TaskSystem.push(computersWhitelist, Commands[data.command].callback, data.args)
	else
		WriteError(computersWhitelist, 'Received invalid data type\n')
	end
end

Commands['help'] = {
	callback = function(ctx, command)
		if command == nil then
			local commandsList = ''
			for commandName, command in pairs(Commands) do
				if type(command.description) == 'string' then
					commandsList = commandsList .. commandName .. ' ' .. command.description .. '\n'
				end
			end

			Write(ctx.task.computers, commandsList)

		elseif Commands[command] == nil then
			WriteError(ctx.task.computers, 'Unknown command "' .. command .. '"\n')

		else
			if type(Commands[command].description) == 'string' then
				Write(ctx.task.computers, command .. ' ' .. Commands[c].description .. '\n')
			else
				Write(ctx.task.computers, command .. '\n')
			end
		end
	end,
	description = '<command?> - Prints a list of commands'
}