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

local framebuffer = fb.FrameBuffer.new(cfg.offset.x, cfg.offset.y, width, height)
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

while true do
	-- local event, keyNum = os.pullEvent()
	-- if (event == "key") then
		-- local char = keys.getName(keyNum)
		-- threedee:moveCamera(char)

		threedee.distance = math.cos(distSinArg) * 2 + 3
		distSinArg = distSinArg + 0.01

		threedee:setProjectedCubes()
		
		threedee:drawFill()
		-- threedee:drawConnections()
		-- threedee:drawCorners()

		threedee.rotation.x = rotation.x + 0.03
		threedee.rotation.y = rotation.y + 0.03
		threedee.rotation.z = rotation.z + 0.03

		framebuffer:draw()

		cf.tryYield()
		-- os.queueEvent('yield')
		-- os.pullEvent('yield')
	-- end
end