local APIsPath = 'BackwardsOS/apis/'
local cfgPath = 'BackwardsOS/cfg'
local httpToHttpsUrl = 'http://request.mariusvanwijk.nl/'

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
	{ id = 'graph', name = 'graph' },
	{ id = 'connections', name = 'connections' },
	{ id = 'twitter', name = 'twitter' },
	{ id = 'voronoi_api', name = 'voronoiAPI' },
	-- { id = '', name = '' },
}

function importAPIs()
	if not fs.exists(APIsPath) then
		fs.makeDir(APIsPath)
	end

	for _, API in ipairs(APIs) do
		term.write("Downloading API '" .. API.id .. "' from GitHub...")

		local pathAPI = APIsPath .. API.name
		fs.delete(pathAPI)

		local url = 'https://raw.githubusercontent.com/MyNameIsTrez/ComputerCraft-APIs/master/' .. API.id .. '.lua'

		local handleHttps = http.post(httpToHttpsUrl, '{"url": "' .. url .. '"}' )

		if not handleHttps then
			error('Downloading file failed!')
		end
		
		local str = handleHttps.readAll()

		local handleFile = io.open(pathAPI, 'w')
		handleFile:write(str)
		handleFile:close()
		
		print(' Downloaded!')

		sleep(1) -- TRY TO FIND A BETTER SOLUTION FOR THIS LATER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	end

	print()
end

function loadAPIs()
	for _, API in ipairs(APIs) do
		term.write("Loading API '" .. API.id .. "'...")
		local pathAPI = APIsPath .. API.name
		os.loadAPI(pathAPI)
		print(' Loaded!')
	end
end

function downloadCfg()
	term.write("Downloading cfg from GitHub...")

	local url = 'https://raw.githubusercontent.com/MyNameIsTrez/ComputerCraft-APIs/master/backwardsos_cfg.lua'

	local handleHttps = http.post(httpToHttpsUrl, '{"url": "' .. url .. '"}' )

	if not handleHttps then
		error('Downloading file failed!')
	end

	local str = handleHttps.readAll()

	local handleFile = io.open(cfgPath, 'w')
	handleFile:write(str)
	handleFile:close()
	
	print(' Downloaded!')
end


if not fs.exists(cfgPath) then
	downloadCfg()
end

os.loadAPI(cfgPath)

if not cfg.useBackwardsOS or rs.getInput(cfg.disableSide) then
	return
end

if cfg.redownloadAPIsOnStartup and http then
	importAPIs()
end

loadAPIs()

term.clear()
term.setCursorPos(1, 1)

if cfg.useMonitor then
	term.redirect(cf.getMonitor())
end

local programsPath = 'BackwardsOS/programs'

if not fs.exists(programsPath) then
	fs.makeDir(programsPath)
end

local options = fs.list(programsPath)
local program = lo.listOptions(options)

term.clear()
term.setCursorPos(1, 1)

local path = 'BackwardsOS/programs/' .. program .. '/' ..program .. '.lua'

if fs.exists(path) then
	shell.run(path)
else
	error("Program '" .. tostring(program) .. "' not found.")
end