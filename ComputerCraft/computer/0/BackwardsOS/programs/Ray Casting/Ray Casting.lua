-- Setup.
local width, height = term.getSize()
width = width - 1

local topDownWidth = width / 2
local firstPersonWidth = width - topDownWidth - 1

local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
local boundaryCount, rayCount, fov, rotationSpeed, grayscaleBool = 15, 60, math.pi/3, math.pi/45, true
local boundaryChar, rayChar, raycasterChar = '#', '.', '~'
local raycasting = rc.RayCasting.new(topDownWidth, height, firstPersonWidth, boundaryCount, rayCount, fov, rotationSpeed, grayscaleBool, boundaryChar, rayChar, raycasterChar, framebuffer)

-- Main.
while true do
	local event, keyNum = os.pullEvent()
	if (event == 'key') then
		local key = keys.getName(keyNum)
		raycasting:moveRaycasters(key)
		raycasting:rotateRaycasters(key)

		raycasting:castRays()
		for _, boundary in ipairs(raycasting.boundaries) do
			boundary:draw()
		end
		for _, rayCaster in ipairs(raycasting.raycasters) do
			rayCaster:draw()
		end
		raycasting:drawFirstPerson()
		
		framebuffer:draw()
	end
end