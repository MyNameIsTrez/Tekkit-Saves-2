function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = '83q6p4Sp', name = 'fb'}, -- FrameBuffer.
		{id = 'ENwuVX0P', name = 'rc'}, -- RayCasting.
		{id = 'sSjBVjgc', name = 'keys'}, -- Gets names of keys.
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

if not rs.getInput(cfg.leverSide) then
	-- Setup.
	local width, height = term.getSize()
	width = width - 1

	local topDownWidth = width / 2
	local firstPersonWidth = width - topDownWidth - 1
	
	local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
	local boundaryCount, rayCount, fov, rotationSpeed = 5, 45, math.pi/3, math.pi/20
	local raycasting = rc.RayCasting.new(topDownWidth, height, firstPersonWidth, boundaryCount, rayCount, fov, rotationSpeed, '#', '.', '@', framebuffer)

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
end