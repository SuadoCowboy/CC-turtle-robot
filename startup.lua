local modem = peripheral.find("modem")
if modem then
	rednet.open(peripheral.getName(modem))
end

shell.run('bg robot/main.lua')