function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = '83q6p4Sp', name = 'fb'}, -- FrameBuffer.
		{id = 'ENwuVX0P', name = 'rc'}, -- RayCasting.
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
	
	local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
	local raycasting = rc.RayCasting.new(width, height, '#', 'O', framebuffer)

	-- Main.
	for _, boundary in ipairs(raycasting.boundaries) do
		boundary:draw()
	end
	for _, ray in ipairs(raycasting.rays) do
		ray:draw()
	end
    framebuffer:draw()
end