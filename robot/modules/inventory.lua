--[[
Defines inventory slots' purpose
]]--
Inventory = {
	fuel = 1
}

Commands['inv_select'] = {
	callback = function(computersWhitelist, slot)
		turtle.select(tonumber(slot))
		Write(computersWhitelist, 'Selected slot ' .. slot .. '\n')
	end,
	description = '<slot> - Calls turtle.select(slot)'
}

Commands['inv_get'] = {
	callback = function(computersWhitelist)
		Write(computersWhitelist, turtle.getSelectedSlot() .. '\n')
	end,
	description = '- Calls turtle.getSelectedSlot()'
}