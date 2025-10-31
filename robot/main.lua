--[[
Exit Codes:
	0 - Terminated (OK)
	1 - some module failed to initalize
	2 - update returned an error
]]--

DebugMode = false

InitFunctions = {}
UpdateFunctions = {}
CleanupFunctions = {}

require('modules.rednet')
require('modules.write')
require('modules.command_handler')
require('modules.inventory')
require('modules.refuel')
require('modules.position')
-- require('modules.local_command_handler')
require('modules.wireless_command_handler')


local function update()
	if #UpdateFunctions ~= 0 then
		parallel.waitForAll(unpack(UpdateFunctions))
	end
end

local function main()
	for i,func in pairs(InitFunctions) do
		local ok = func()
		if ok == nil and DebugMode then
			WriteError(nil, 'InitFunctions[' .. i .. '] returned nil. Expected boolean\n')
		end

		if not ok then
			return 1
		end
	end
	InitFunctions = nil

	local ok, err = pcall(update)

	if not ok then
		if err == 'Terminated' then
			return 0
		else
			WriteError(nil, 'An error occurred: ' .. err .. '\n')
			return 2
		end
	end

	return 0
end

local function run()
	local status = main()

	for _,func in pairs(CleanupFunctions) do
		func()
	end

	return status
end

Write(nil, 'Robot returned with exit code ' .. run() .. '\nPress ENTER to continue...')
read()