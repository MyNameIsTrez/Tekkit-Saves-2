function importAPIs()
	local APIs = {
		{ id = 'p9tSSWcB', name = 'cf' }, -- Common Functions.
        { id = '4nRg9CHU', name = 'json' }, -- HTTPS needs JSON.
        { id = 'iyBc3BWj', name = 'https' }, -- Animation needs HTTPS.
		{ id = 'LNab4wrv', name = 'an' }, -- Animation.
		{ id = 'nsrVpDY6', name = 'perlinNoise' }, -- Perlin noise.
		{ id = 'cegB4RwE', name = 'dithering' }, -- Dithering (ASCII).
		{ id = 'QKixgCbW', name = 'wt' }, -- World time.
		{ id = '83q6p4Sp', name = 'fb' }, -- FrameBuffer.
		{ id = 'ENwuVX0P', name = 'rc' }, -- RayCasting.
		{ id = 'sSjBVjgc', name = 'keys' }, -- Gets names of keys.
		{ id = 'BWpkzQYp', name = 'td' }, -- Draw 3D objects.
		{ id = '9g8zvPpX', name = 'matrix' }, -- Matrix math.
		{ id = 'drESpUSP', name = 'shape' },
        { id = 'snQZyasC', name = 'mandel' }, -- Mandelbrot.
        { id = 'VXufmAu2', name = 'lzstring' }, -- Mandelbrot.
		{ id = '6qBVrzpK', name = 'aStar' },
		{ id = 'BEmdjsuJ', name = 'bezier' },
		{ id = 'NqnSq1wK', name = 'tf' }, -- Turtle Functions.
		{ id = 'RTNpUUfH', name = 'breadthFirstSearch' }, -- Breadth First Search.
	}

	local path = 'BackwardsOS/apis/'

	if not fs.exists(path) then
		fs.makeDir(path)
	end

	for _, API in pairs(APIs) do
		local name = path .. API.name
		fs.delete(name)
		shell.run('pastebin', 'get', API.id, name)
		os.loadAPI(name)
	end
end

if not rs.getInput(cfg.disableSide) then
	importAPIs()

	term.clear()
	term.setCursorPos(1, 1)

	if cfg.useMonitor then
		term.redirect(cf.getMonitor())
	end

	local path = 'BackwardsOS/programs/' .. cfg.program .. '/' .. cfg.program .. '.lua'

	if fs.exists(path) then
		shell.run(path)
	else
		error('Program "' .. tostring(cfg.program) .. '" not found.')
	end
end