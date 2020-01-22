function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'BWpkzQYp', name = 'td'}, -- Draw 3D objects.
		{id = '83q6p4Sp', name = 'fb'}, -- FrameBuffer.
		{id = 'sSjBVjgc', name = 'keys'}, -- Detecting keys being pressed.
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
	local cubes = {
		{0,0,0},
		-- {2,2,2},
	}

	-- local cubes = {}
	-- for i = 1, 5 do
	-- 	for j = 1, 5 do
	-- 		cubes[#cubes + 1] = {j, i, 0}
	-- 	end
	-- end

	local offsets = { 7, -10 }

	local width, height = term.getSize()
	width = width - 1

	local blockDiameter = 10
	local connectionChar = '@'
	local pointChar = '+'
	
    local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
    local threedee = td.ThreeDee.new(framebuffer, width, height, cubes, blockDiameter, offsets, connectionChar, pointChar)

	-- Main.
	-- cf.printTable(threedee.cubesCorners)

	-- threedee:line(0, 0, 20, 20, '8')

	-- threedee:drawConnections()
	threedee:drawFill()
	-- threedee:fill(threedee.cubesCorners[1][1][1], threedee.cubesCorners[1][1][2], threedee.cubesCorners[1][2][1], threedee.cubesCorners[1][2][2], threedee.cubesCorners[1][4][1], threedee.cubesCorners[1][4][2])
	-- threedee:fill(threedee.cubesCorners[1][1], threedee.cubesCorners[1][2], threedee.cubesCorners[1][5])
    framebuffer:draw()

    while true do
        local event, keyNum = os.pullEvent()
        if (event == "key") then
            local char = keys.getName(keyNum)
			threedee:moveCamera(char)
			threedee:getCubesCorners(threedee.cubesCoords, threedee.blockDiameter)
			-- threedee:drawConnections()
            threedee:drawFill()
            framebuffer:draw()
        end
    end
end