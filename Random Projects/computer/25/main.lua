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

	angle = 0

	while true do
		local rotationX = {
			{ 1, 0, 0 },
			{ 0, math.cos(angle), -math.sin(angle) },
			{ 0, math.sin(angle),  math.cos(angle) }
		}

		local rotationY = {
			{ math.cos(angle), 0, -math.sin(angle) },
			{ 0, 1, 0 },
			{ math.sin(angle), 0, math.cos(angle) }
		}

		local rotationZ = {
			{ math.cos(angle), -math.sin(angle), 0 },
			{ math.sin(angle),  math.cos(angle), 0 },
			{ 0, 0, 1 }
		}

		local projection = {
			{1, 0, 0},
			{0, 1, 0}
		}

		local points = {}
		points[1] = vector.new(-0.5, -0.5, -0.5)
		points[2] = vector.new(0.5, -0.5, -0.5)
		points[3] = vector.new(0.5, 0.5, -0.5)
		points[4] = vector.new(-0.5, 0.5, -0.5)

		points[5] = vector.new(-0.5, -0.5, 0.5)
		points[6] = vector.new(0.5, -0.5, 0.5)
		points[7] = vector.new(0.5, 0.5, 0.5)
		points[8] = vector.new(-0.5, 0.5, 0.5)

		local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
		
		local centerX, centerY = math.floor(width/2 + 0.5), math.floor(height/2 + 0.5)

		for _, v in ipairs(points) do
			local m = matrix.vecToMat(v:mul(100))
			local rotated = matrix.matMul(rotationX, m)
			rotated = matrix.matMul(rotationY, rotated)
			rotated = matrix.matMul(rotationZ, rotated)
			local projected2d = matrix.matMul(projection, rotated)

			-- ideally
			-- local x, y = centerX + projected2d.x * 1.5, centerY + projected2d.y
			local _x, _y = rotated[1][1], rotated[2][1]
			local x, y = centerX + _x * 1.5, centerY + _y

			framebuffer:writeChar(x, y, 'p')
		end

		framebuffer:draw()

		angle = angle + 0.01

		os.queueEvent('yield')
		os.pullEvent('yield')
	end

	-- local cubes = {
	-- 	{0,0,0},
	-- }

	-- local blockDiameter = 10
	-- local connectionChar = '@'
	-- local pointChar = '+'
	
    -- local threedee = td.ThreeDee.new(framebuffer, width, height, cubes, blockDiameter, connectionChar, pointChar)

	-- Main.
	-- threedee:drawConnections()
	-- threedee:drawFill()
	-- threedee:fill(threedee.cubesCorners[1][1][1], threedee.cubesCorners[1][1][2], threedee.cubesCorners[1][2][1], threedee.cubesCorners[1][2][2], threedee.cubesCorners[1][4][1], threedee.cubesCorners[1][4][2])
	-- threedee:fill(threedee.cubesCorners[1][1], threedee.cubesCorners[1][2], threedee.cubesCorners[1][5])
    -- framebuffer:draw()

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