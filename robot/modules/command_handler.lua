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

---@param computersWhitelist number[]?
---@param data string
---@param args table?
function CommandHandler.parse(computersWhitelist, commandName, args)
	if commandName == nil then
		WriteError(computersWhitelist, 'Command is nil\n')

	elseif type(commandName) ~= 'string' then
		WriteError(computersWhitelist, 'Expected string for command but type is ' .. type(commandName) .. '\n')
	end

	if Commands[commandName] == nil then
		WriteError(computersWhitelist, 'Command "' .. commandName .. '" not found\n')
		return
	end

	TaskSystem.push(computersWhitelist, Commands[commandName].callback, args)
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
				Write(ctx.task.computers, command .. ' ' .. Commands[command].description .. '\n')
			else
				Write(ctx.task.computers, command .. '\n')
			end
		end
	end,
	description = '<command?> - Prints a list of commands'
}