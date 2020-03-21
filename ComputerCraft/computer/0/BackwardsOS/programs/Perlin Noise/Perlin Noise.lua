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
	write(emptyString)

	term.setCursorPos(px, py)
	write(progressString)

	term.setCursorPos(px, py + 1)
	write(emptyString)
end

local function getPerlinMap(hor, ver, z)
    local perlinMap = {}
	for y = 1, ver do
		printProgress(y)

        for x = 1, hor do
            local xNormalized = x / hor * noiseZoom
            local yNormalized = y / ver * noiseZoom

            local unmappedValue = perlinNoise.perlin:noise(xNormalized, yNormalized, z) -- Return range: [-1, 1]
            local value = cf.map(unmappedValue, -1, 1, 0, 1)

            perlinMap[#perlinMap+1] = value

            cf.tryYield()
        end
    end
    return perlinMap
end

-- CODE EXECUTION --------------------------------------------------------

while true do
	local t1 = os.clock()


	z = z + zIncrement

	local perlinMap = getPerlinMap(width-1, height, z)
	local frame = dithering.getFrame(perlinMap, width-1)
	local noiseString = table.concat(frame)

	term.setCursorPos(1, 1)
	write(noiseString)

	cf.tryYield()


	-- Measures the time it took for the program to run.
	local t2 = os.clock()
	local elapsedTime = t2 - t1
	local roundedTime = math.floor(elapsedTime * 100 + 0.5) / 100
	local clear = ' '
	local str = 'Elapsed time: '..tostring(roundedTime)..'s'..clear

	term.setCursorPos(1, 1)
	print(str)
	write(string.rep(' ', #str))
end