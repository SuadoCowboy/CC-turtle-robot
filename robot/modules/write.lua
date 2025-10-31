---@param computersWhitelist integer[]? if not nil, sends them the write output instead of broadcasting it to all computers.
function Write(computersWhitelist, ...)
	local args = {...}
	local out = ''

	for i,v in pairs(args) do
		out = out .. v
	end

	io.write(out)

	if computersWhitelist == nil then
		rednet.broadcast({type='log', text=out}, 'command_handler')
	else
		for _,id in pairs(computersWhitelist) do
			rednet.send(id, {type='log', text=out}, 'command_handler')
		end
	end
end

---@param computersWhitelist integer[]? if not nil, sends them the write output instead of broadcasting it to all computers.
function WriteError(computersWhitelist, ...)
	local args = {...}
	local out = ''

	for i,v in pairs(args) do
		out = out .. v
	end

	local originalColor = term.getTextColor()
	term.setTextColor(colors.red)

	io.write(out)

	term.setTextColor(originalColor)

	if computersWhitelist == nil then
		rednet.broadcast({type='log', text=out, isError=true}, 'command_handler')
	else
		for _,id in pairs(computersWhitelist) do
			rednet.send(id, {type='log', text=out, isError=true}, 'command_handler')
		end
	end
end