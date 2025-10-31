--[[
Handles turtle refuelling
]]--

Refuel = function()
	if turtle.getFuelLevel() > 0 then
		if DebugMode and (turtle.getFuelLevel() % 5) == 0 then
			Write(nil, "Fuel Level: ".. turtle.getFuelLevel()/turtle.getFuelLimit()*100 .. '%\n')
		end
		return true
	end

	local selected = turtle.getSelectedSlot()
	turtle.select(Inventory.fuel)

	local ok = turtle.refuel(1)

	turtle.select(selected)

	if not ok then
		WriteError(nil, 'Missing fuel on slot ' .. Inventory.fuel .. '\n')
		return false
	end

	return true
end