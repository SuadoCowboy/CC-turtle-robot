--[[
Defines inventory slots' purpose
]]--
Inventory = {
	fuel = 1
}

Commands['inv_select'] = {
	callback = function(ctx, slot)
		turtle.select(tonumber(slot))
		Write(ctx.task.computers, 'Selected slot ' .. slot .. '\n')
	end,
	description = '<slot> - Calls turtle.select(slot)'
}

Commands['inv_get'] = {
	callback = function(ctx)
		Write(ctx.task.computers, turtle.getSelectedSlot() .. '\n')
	end,
	description = '- Calls turtle.getSelectedSlot()'
}