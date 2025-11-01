--[[
Receives tasks from other commands and runs them.
]]--

TaskSystem = {
	tasks = {},
	size = 0
}

---@param computersWhitelist number[]
---@param callback fun() If it returns true, considers it as finished and removes it.
---@param args table? callback args
---@param keepRunning boolean? default = false
function TaskSystem.push(computersWhitelist, callback, args, keepRunning)
	local uuid = RandomUUID()
	while TaskSystem.tasks[uuid] ~= nil do
		uuid = RandomUUID()
	end

	if DebugMode then
		Write(computersWhitelist, 'Create task ' .. uuid .. '\n')
	end

	TaskSystem.tasks[uuid] = {
		computers = computersWhitelist,
		callback = callback,
		args = args,
		keepRunning = keepRunning
	}

	TaskSystem.size = TaskSystem.size + 1

	return uuid
end

---@param uuid string
function TaskSystem.pop(uuid)
	if TaskSystem.tasks[uuid] then
		TaskSystem.tasks[uuid] = nil
		TaskSystem.size = TaskSystem.size - 1
	end
end


UpdateFunctions[#UpdateFunctions+1] = function()
	while true do
		for uuid, task in pairs(TaskSystem.tasks) do
			local ok, err
			if task.args == nil then
				ok, err = pcall(task.callback, {uuid=uuid, task=task})
			else
				ok, err = pcall(task.callback, {uuid=uuid, task=task}, unpack(task.args))
			end
	
			if not ok then
				if err == 'Terminated' then
					Write(task.computers, 'Terminated task "' .. uuid .. '"\n')
				else
					WriteError(task.computers, 'An error occurred in task "' .. uuid .. '": ' .. result .. '\n')
				end
			end
	
			if task.keepRunning ~= true then
				if DebugMode then
					Write(task.computers, 'Task "' .. uuid .. '" finished\n')
				end
				TaskSystem.pop(uuid)
			end
		end

		os.queueEvent('fake_event')
		os.pullEvent('fake_event')
	end
end

if Commands == nil then
	Commands = {}
end

Commands['tasks'] = {
	callback = function(ctx)
		local out = ''
		for uuid, _ in pairs(TaskSystem.tasks) do
			out = out .. uuid .. '\n'
		end

		out = out .. 'Tasks: ' .. TaskSystem.size .. '\n'

		Write(ctx.task.computers, out)
	end,
	description = '- Prints a list of current tasks'
}