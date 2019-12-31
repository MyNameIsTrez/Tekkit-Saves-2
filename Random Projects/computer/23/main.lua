-- README --------------------------------------------------------

-- Perlin Noise program. (possibly OpenSimplexNoise too, later?)

-- The default terminal ratio is 25:9, which is absolutely tiny.
-- To get the terminal to fill the entire screen, use these widths and heights:
	-- My 31.5" monitor:
		-- 426:153 in windowed mode.
		-- 426:160 in fullscreen mode.
		-- 200:70 in windowed mode with GUI Scale: Normal. (for debugging)
	-- My laptop:
		-- 227:78 in windowed mode.
		-- 227:85 in fullscreen mode.

-- IMPORTING --------------------------------------------------------

function importAPIs()
	local APIs = {
		{id = "p9tSSWcB", name = "cf"},
		{id = "nsrVpDY6", name = "perlinNoise"},
		{id = "cegB4RwE", name = "dithering"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

-- EDITABLE VARIABLES --------------------------------------------------------

local noiseZoom = 10

local leverSide = "right"

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function tryYield()
    local currentClock = os.clock()
    if currentClock - previousClock > 4 then
        previousClock = currentClock
        cf.yield()
    end
end

-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
	term.clear()
end

function main()
	local t1 = os.clock()
	if not rs.getInput(leverSide) then
		local noiseTable = {}

		for y = 1, height do
			local progress = y / height * 100
			local roundedProgress = math.floor(progress + 0.5)
			local progressString = tostring(roundedProgress)..'%'

			term.setCursorPos(width / 2 - #progressString / 2, height / 2)
			write(progressString)

			for x = 1, width do
				local xNormalized = x / width * noiseZoom
				local yNormalized = y / height * noiseZoom
				local unmappedValue = perlinNoise.perlin:noise(xNormalized, yNormalized)-- Return range: [-1, 1]
				local value = cf.map(unmappedValue, -1, 1, 0, 1)
				local char = dithering.getClosestChar(value)

				table.insert(noiseTable, char)

				-- Writing every individual character one by one is incredibly slow,
				-- as it took 90 (+- 1) seconds to draw one frame.
				-- It took 16 (+- 1) seconds when all characters are written at once, so that's 5.625x faster.
				-- term.setCursorPos(x, y)
				-- write(char)

				tryYield()
			end
		end

		local noiseString = table.concat(noiseTable)

		term.setCursorPos(1, 1)
		write(noiseString)
	end

	-- Measures the time it took for the program to run.
	-- local t2 = os.clock()
	-- local elapsedTime = t2 - t1
	-- local roundedTime = math.floor(elapsedTime * 100 + 0.5) / 100
	-- local clear = ' '

	term.setCursorPos(1, 1)
	-- write('Elapsed time: '..tostring(roundedTime)..'s'..clear)
end

setup()
main()