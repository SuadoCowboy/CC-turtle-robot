InitFunctions[#InitFunctions+1] = function()
	local modem = peripheral.find("modem")
	if modem then
		rednet.open(peripheral.getName(modem))
	end
	return true
end

CleanupFunctions[#CleanupFunctions+1] = function()
	local modem = peripheral.find("modem")

	if modem then
		rednet.close(peripheral.getName(modem))
	end
end