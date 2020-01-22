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

-- term.clear()
-- term.setCursorPos(1, 1)

if not rs.getInput(cfg.leverSide) then
	-- Setup.
	local width, height = term.getSize()
	width = width - 1
	
	local framebuffer = fb.FrameBuffer.new(cfg.playArea.X, cfg.playArea.Y, width, height)
	local boundary = rc.Boundary.new(width/4*3, height/10, width/4*3, height/10*9, '#', framebuffer)
	local ray = rc.Ray.new(width/4, height/2, 'O', framebuffer)

	-- Main.
	boundary:draw()
	ray:draw()
	-- framebuffer:writeChar(51, 10, '9')
    framebuffer:draw()
end