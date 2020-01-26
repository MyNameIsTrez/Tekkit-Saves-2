function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'BWpkzQYp', name = 'td'}, -- Draw 3D objects.
		{id = '83q6p4Sp', name = 'fb'}, -- FrameBuffer.
		{id = 'sSjBVjgc', name = 'keys'}, -- Detecting keys being pressed.
		{id = '9g8zvPpX', name = 'matrix'}, -- Matrix math.
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

function importConfig()
    os.loadAPI('cfg')
end

importAPIs()
importConfig()
-- term.clear()
-- term.setCursorPos(1, 1)

if not rs.getInput(cfg.leverSide) then
	-- Setup.
	local width, height = term.getSize()
	width = width - 1

	-- Code from this tutorial:
	-- https://youtu.be/p4Iz0XJY-Qk

	local corners = {}
	corners[1] = vector.new(-0.5, -0.5, -0.5)
	corners[2] = vector.new(0.5, -0.5, -0.5)
	corners[3] = vector.new(0.5, 0.5, -0.5)
	corners[4] = vector.new(-0.5, 0.5, -0.5)

	corners[5] = vector.new(-0.5, -0.5, 0.5)
	corners[6] = vector.new(0.5, -0.5, 0.5)
	corners[7] = vector.new(0.5, 0.5, 0.5)
	corners[8] = vector.new(-0.5, 0.5, 0.5)

	local distance = 2
	local connectionChar, cornerChar = 'l', 'c'
	
	local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
	local threedee = td.ThreeDee.new(framebuffer, 1, 1, width, height, distance, corners, connectionChar, cornerChar)
	
	local rotation = vector.new()

	local distSinArg = 0
	
	while true do
		threedee.distance = (math.sin(distSinArg) + 1)/2 * 4 + 2
		threedee:getProjectedCorners(rotation, distance)
		threedee:drawConnections()
		threedee:drawCorners()

		framebuffer:draw()

		distSinArg = distSinArg + 0.025
		rotation.x = rotation.x + 0.025
		rotation.y = rotation.y + 0.025
		rotation.z = rotation.z + 0.025

		os.queueEvent('yield')
		os.pullEvent('yield')
	end
	

	-- Main.

    -- while true do
    --     local event, keyNum = os.pullEvent()
    --     if (event == "key") then
    --         local char = keys.getName(keyNum)
	-- 		threedee:moveCamera(char)
	-- 		threedee:getCubesCorners(threedee.cubesCoords, threedee.blockDiameter)
	-- 		-- threedee:drawConnections()
    --         threedee:drawFill()
    --         framebuffer:draw()
    --     end
    -- end
end