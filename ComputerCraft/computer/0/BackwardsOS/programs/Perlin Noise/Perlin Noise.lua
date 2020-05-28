local noiseZoom = 15

-- local z = math.random() * 1000000
local z = 0

local zIncrement = 0.1

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function printProgress(y)
	local progress = y / height * 100
	local roundedProgress = math.floor(progress + 0.5)
	local progressString = ' '..tostring(roundedProgress)..'% '
	local emptyString = string.rep(' ', #progressString)

	local px = width / 2 - #progressString / 2
	local py = height / 2

	term.setCursorPos(px, py - 1)
	term.write(emptyString)

	term.setCursorPos(px, py)
	term.write(progressString)

	term.setCursorPos(px, py + 1)
	term.write(emptyString)
end

local function getNoiseStr(hor, ver, z)
	local tab = {}
	local i = 1

	for y = 1, ver do
		printProgress(y)

        for x = 1, hor do
            local xNormalized = x / hor * noiseZoom
            local yNormalized = y / ver * noiseZoom

            local unmappedValue = perlinNoise.perlin:noise(xNormalized, yNormalized, z) -- Return range: [-1, 1]
			local value = cf.map(unmappedValue, -1, 1, 0, 1)
			local char = dithering.getClosestChar(value)

			tab[i] = char
			i = i + 1

            cf.tryYield() -- May be calling this too often.
		end
		
		if y ~= ver then
			tab[i] = '\n'
			i = i + 1
		end
	end

    return table.concat(tab)
end

-- CODE EXECUTION --------------------------------------------------------

while true do
	local t1 = os.clock()

	z = z + zIncrement

	local noiseStr = getNoiseStr(width-1, height, z)

	term.setCursorPos(1, 1)
	write(noiseStr)

	cf.tryYield()


	-- Measures the time it took for the program to run.
	local t2 = os.clock()
	local elapsedTime = t2 - t1
	local roundedTime = math.floor(elapsedTime * 100 + 0.5) / 100
	local clear = ' '
	local str = 'Elapsed time: '..tostring(roundedTime)..'s'..clear

	term.setCursorPos(1, 1)
	print(str)
	term.write(string.rep(' ', #str))
end