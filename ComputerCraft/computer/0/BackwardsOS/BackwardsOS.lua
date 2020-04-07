local APIs = {
	{ id = 'common_functions', name = 'cf' },
	{ id = 'json', name = 'json' },
	{ id = 'https', name = 'https' },
	{ id = 'animation', name = 'an' },
	{ id = 'perlin_noise', name = 'perlinNoise' },
	{ id = 'dithering', name = 'dithering' },
	{ id = 'world_time', name = 'wt' },
	{ id = 'frame_buffer', name = 'fb' },
	{ id = 'ray_casting', name = 'rc' },
	{ id = 'keys', name = 'keys' },
	{ id = 'threedee', name = 'td' },
	{ id = 'matrix', name = 'matrix' },
	{ id = 'shape', name = 'shape' },
	{ id = 'mandelbrot_set', name = 'mandel' },
	{ id = 'lz_string', name = 'lzstring' },
	{ id = 'a_star', name = 'aStar' },
	{ id = 'bezier_curve', name = 'bezier' },
	{ id = 'turtle_functions', name = 'tf' },
	{ id = 'breadth_first_search', name = 'breadthFirstSearch' },
	{ id = 'list_options', name = 'lo' },
	{ id = 'corona_virus', name = 'corona' },
	{ id = 'toki_pona', name = 'tokipona' },
	{ id = 'convert', name = 'convert' },
}

local pathAPIs = 'BackwardsOS/apis/'

function importAPIs()
	local httpToHttpsUrl = 'http://request.mariusvanwijk.nl/'

	if not fs.exists(pathAPIs) then
		fs.makeDir(pathAPIs)
	end

	for _, API in ipairs(APIs) do
		term.write('Downloading API "' .. API.id .. '" from GitHub...')

		local pathAPI = pathAPIs .. API.name
		fs.delete(pathAPI)

		local url = 'https://raw.githubusercontent.com/MyNameIsTrez/ComputerCraft-APIs/master/' .. API.id .. '.lua'
		local handleHttps = http.post(httpToHttpsUrl, '{"url": "' .. url .. '"}' )
		local str = handleHttps.readAll()

		if not handleHttps then
			error('Downloading file failed!')
		end

		local handleFile = io.open(pathAPI, 'w')
		handleFile:write(str)
		handleFile:close()
		
		print(' Downloaded!')

		sleep(1) -- REMOVE THIS LATER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	end
end

function loadAPIs()
	for _, API in ipairs(APIs) do
		term.write('Loading API "' .. API.id .. '"...')
		local pathAPI = pathAPIs .. API.name
		os.loadAPI(pathAPI)
		print(' Loaded!')
	end
end

if not rs.getInput(cfg.disableSide) then
	if cfg.redownloadAPIsOnStartup and http then
		importAPIs()
	end

	loadAPIs()

	term.clear()
	term.setCursorPos(1, 1)

	if cfg.useMonitor then
		term.redirect(cf.getMonitor())
	end

	local options = fs.list('BackwardsOS/programs')
	local program = lo.listOptions(options)

	term.clear()
	term.setCursorPos(1, 1)

	local path = 'BackwardsOS/programs/' .. program .. '/' ..program .. '.lua'

	if fs.exists(path) then
		shell.run(path)
	else
		error('Program "' .. tostring(program) .. '" not found.')
	end
end