--[[
Handles coordinates, movement, rotation and facing direction.

DIRECITON FACING INFORMATION:
	- Position.facing should always be one of these: 'N' = North; 'S' = South; 'E' = East; 'W' = West;
	- South = Positive Z;
	- North = Negative Z;
	- East = Positive X;
	- West = Negative X.
]]--

---@class Position
---@param facing string
Position = {}

function Position.forward()
	Refuel()

	if turtle.forward() then
		if Position.facing == 'S' then
			Position.z = Position.z+1
		elseif Position.facing == 'N' then
			Position.z = Position.z-1
		elseif Position.facing == 'E' then
			Position.x = Position.x+1
		elseif Position.facing == 'W' then
			Position.x = Position.x-1
		elseif Position.facing == nil then
			Write(nil, 'Facing is nil\n')
		else
			Write(nil, 'Unknwon facing: ' .. Position.facing .. '\n')
		end

		return true
	end

	return false
end

function Position.back()
	Refuel()

	if turtle.back() then
		if Position.facing == 'S' then
			Position.z = Position.z-1
		elseif Position.facing == 'N' then
			Position.z = Position.z+1
		elseif Position.facing == 'E' then
			Position.x = Position.x-1
		elseif Position.facing == 'W' then
			Position.x = Position.x+1
		end

		return true
	end

	return false
end

function Position.up()
	Refuel()

	if turtle.up() then
		Position.y = Position.y+1
		return true
	end

	return false
end

function Position.down()
	Refuel()

	if turtle.down() then
		Position.y = Position.y-1
		return true
	end

	return false
end

function Position.turnLeft()
	if not turtle.turnLeft() then
		return false
	end

	if Position.facing == 'N' then
		Position.facing = 'W'
	elseif Position.facing == 'W' then
		Position.facing = 'S'
	elseif Position.facing == 'S' then
		Position.facing = 'E'
	else
		Position.facing = 'N'
	end

	return true
end

function Position.turnRight()
	if not turtle.turnRight() then
		return false
	end

	if Position.facing == 'N' then
		Position.facing = 'E'
	elseif Position.facing == 'E' then
		Position.facing = 'S'
	elseif Position.facing == 'S' then
		Position.facing = 'W'
	else
		Position.facing = 'N'
	end

	return true
end

function Position.update()
	Write(nil, 'Locating itself with GPS...\n')
	local x, y, z = gps.locate(5)

	if x == nil then
		Write(nil, 'Could not locate itself with GPS\n')
		return false
	end

	Position.x = x
	Position.y = y
	Position.z = z
	return true
end

InitFunctions[#InitFunctions+1] = function()
	Position.update()
	local horizontalPosition = { x = Position.x, z = Position.z }

	if not Position.forward() then
		WriteError(nil, 'Could not get facing direction\n')
		return false
	end

	Position.update()

	if DebugMode then
		Write(nil, 'From: ', horizontalPosition.x, horizontalPosition.z, '\nTo:', Position.x, Position.z .. '\n')
	end
	if horizontalPosition.x ~= Position.x then
		Position.facing = Position.x > horizontalPosition.x and 'E' or 'W'

	elseif horizontalPosition.z ~= Position.z then
		Position.facing = Position.z > horizontalPosition.z and 'S' or 'N'
	end

	Write(nil, 'Facing: ' .. Position.facing .. '\n')
	return true
end

Commands['go'] = {
	callback = function(ctx, direction, distance)
		if distance == nil then
			distance = 1
		else
			distance = tonumber(distance)
		end

		local i = 0
		if direction == 'left' then
			while i < distance do
				if not Position.turnLeft() then
					WriteError(ctx.task.computers, 'For some reason could not turn left\n')
					break
				end
				i = i + 1
			end
			Write(ctx.task.computers, 'Turned left ' .. i .. ' time(s)\n')

		elseif direction == 'right' then
			while i < distance do
				if not Position.turnRight() then
					WriteError(ctx.task.computers, 'For some reason could not turn right\n')
					break
				end
				i = i + 1
			end
			Write(ctx.task.computers, 'Turned right ' .. i .. ' time(s)\n')

		elseif direction == 'up' or direction == 'down' or direction == 'forward' or direction == 'back' then
			while i < distance do
				if not Position[direction]() then
					WriteError(ctx.task.computers, 'Something is blocking my way\n')
					break
				end
				i = i + 1
			end
			Write(ctx.task.computers, 'Moved ' .. i .. ' block(s)\n')
		end
	end,
	description='<direction> <distance> - Works similarly to turtles\' "go" command'
}

Commands['coords'] = {
	callback = function(ctx)
		Write(ctx.task.computers, 'X: ' .. Position.x .. ' Y: ' .. Position.y .. ' Z: ' .. Position.z .. ' F: ' .. Position.facing .. '\n')
	end,
	description='- Prints out the coordinates of the turtle'
}