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
		-- Code from this tutorial:
		-- https://youtu.be/p4Iz0XJY-Qk

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

		local points = {}
		points[1] = vector.new(-0.5, -0.5, -0.5)
		points[2] = vector.new(0.5, -0.5, -0.5)
		points[3] = vector.new(0.5, 0.5, -0.5)
		points[4] = vector.new(-0.5, 0.5, -0.5)

		points[5] = vector.new(-0.5, -0.5, 0.5)
		points[6] = vector.new(0.5, -0.5, 0.5)
		points[7] = vector.new(0.5, 0.5, 0.5)
		points[8] = vector.new(-0.5, 0.5, 0.5)

		local projected = {}

		local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
		
		local centerX, centerY = math.floor(width/2 + 0.5), math.floor(height/2 + 0.5)

		for i = 1, #points do
			local v = points[i]
			local m = matrix.vecToMat(v)
			local rotated = matrix.matMul(rotationX, m)
			rotated = matrix.matMul(rotationY, rotated)
			rotated = matrix.matMul(rotationZ, rotated)
			
			local distance = 2
			local z = 1 / (distance - rotated[3][1])
			local projection = {
				{z, 0, 0},
				{0, z, 0}
			}
			
			local projected2d = matrix.matMul(projection, rotated)
			projected2d[1][1] = projected2d[1][1] * 100
			projected2d[2][1] = projected2d[2][1] * 100
			projected[i] = projected2d
		end

		function connect(i, j)
			local a, b = projected[i], projected[j]

			-- Translate to the middle of the screen and stretch x by 50%.
			local _x1, _y1 = a[1][1], a[2][1]
			local x1, y1 = centerX + _x1 * 1.5, centerY + _y1
			local _x2, _y2 = b[1][1], b[2][1]
			local x2, y2 = centerX + _x2 * 1.5, centerY + _y2

			framebuffer:writeLine(x1, y1, x2, y2, 'l')
		end

		-- Draw lines between corners.
		for i = 1, 4 do
			connect(i, i % 4 + 1) -- Front.
			connect(i, i + 4) -- Middle.
			connect(i + 4, i % 4 + 5) -- Back.
		end

		-- -- Draw corners.
		-- for _, v in ipairs(projected) do
		-- 	local _x, _y = v[1][1], v[2][1]
		-- 	local x, y = centerX + _x * 1.5, centerY + _y
		-- 	framebuffer:writeChar(x, y, 'c')
		-- end

		framebuffer:draw()

		angle = angle + 0.025

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