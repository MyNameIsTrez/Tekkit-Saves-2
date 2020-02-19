function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common functions.
		{id = 'BWpkzQYp', name = 'td'}, -- Draw 3D objects.
		{id = '83q6p4Sp', name = 'fb'}, -- Frame buffer.
		{id = 'sSjBVjgc', name = 'keys'}, -- Detecting keys being pressed.
		{id = '9g8zvPpX', name = 'matrix'}, -- Matrix math.
		{id = 'nsrVpDY6', name = 'perlinNoise'}, -- Perlin noise.
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

importAPIs()
os.loadAPI('cfg')
-- term.clear()
-- term.setCursorPos(1, 1)

if not rs.getInput(cfg.leverSide) then
	-- Setup.
	local width, height = term.getSize()
	width = width - 1

	-- Code from this tutorial:
	-- https://youtu.be/p4Iz0XJY-Qk

	local distance = 2
	local rotation = vector.new()
	local connectionChar, cornerChar = 'l', 'c'

	local cubesCoords = {
		-- vector.new(-1,  0),
		vector.new( 0,  0),
		-- vector.new( 1,  0),
		-- vector.new( 0, -1),
	}

	-- local maxHeight = 5
	-- for y = 0.25, 0.75, 0.25 do
	-- 	for x = 0.25, 0.75, 0.25 do
	-- 		print(x, y)
	-- 		local val = perlinNoise.perlin:noise(x, y) -- Return range: [-1, 1]
	-- 		print(val)
	-- 		if val > 0 then
	-- 			cubesCoords[#cubesCoords + 1] = vector.new(x, y)
	-- 		end
	-- 	end
	-- end

	-- cf.printTable(cubesCoords)
	
	local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
	local threedee = td.ThreeDee.new(framebuffer, 1, 1, width, height, distance, rotation, cubesCoords, connectionChar, cornerChar)

	local distSinArg = 0

	-- Main.
	-- local vertices = {
	-- 	vector.new(-10, -8),
	-- 	vector.new(19, -13),
	-- 	vector.new(-20, 12),
	-- }

	-- threedee:drawFilledTriangle(vertices)
	-- framebuffer:writeLine(vertices[1].x + width/2, vertices[1].y + height/2, vertices[2].x + width/2, vertices[2].y + height/2, '#')
	-- framebuffer:writeLine(vertices[2].x + width/2, vertices[2].y + height/2, vertices[3].x + width/2, vertices[3].y + height/2, '#')
	-- framebuffer:writeLine(vertices[3].x + width/2, vertices[3].y + height/2, vertices[1].x + width/2, vertices[1].y + height/2, '#')
	-- framebuffer:draw()

	-- while true do
		-- local event, keyNum = os.pullEvent()
		-- if (event == "key") then
			-- local char = keys.getName(keyNum)
			-- threedee:moveCamera(char)

			threedee.distance = (math.sin(distSinArg) + 1)/2 * 4 + 2
			distSinArg = distSinArg + 0.01

			threedee:setProjectedCubes()
			
			-- threedee:drawFill()
			-- threedee:drawConnections()
			-- threedee:drawCorners()

			threedee.rotation.x = rotation.x + 0.01
			threedee.rotation.y = rotation.y + 0.01
			threedee.rotation.z = rotation.z + 0.01

			-- framebuffer:draw()

			os.queueEvent('yield')
			os.pullEvent('yield')
		-- end
	-- end
end