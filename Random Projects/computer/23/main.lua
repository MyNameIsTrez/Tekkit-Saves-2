-- README --------------------------------------------------------

-- Perlin Noise program.
 
-- The default terminal ratio is 25:9.
-- To get the terminal to fill your entire monitor and to get a custom text color:
-- 1. Open AppData/Roaming/.technic/modpacks/tekkit/config/mod_ComputerCraft.cfg
-- 2. Divide your monitor's width by 6 and your monitor's height by 9.
-- 3. Set terminal_width to the calculated width and do the same for terminal_height.
-- 4. Set the terminal_textColour_r, terminal_textColour_g and terminal_textColour_b
--    to values between 0 and 255 to get a custom text color.

-- IMPORTING --------------------------------------------------------

function importAPIs()
	local APIs = {
		{id = "p9tSSWcB", name = "cf"},
		{id = "nsrVpDY6", name = "perlinNoise"},
		{id = "cegB4RwE", name = "dithering"},
	}

	fs.delete("apis") -- To delete APIs in the folder.
	fs.makeDir("apis") -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

-- EDITABLE VARIABLES --------------------------------------------------------

local noiseZoom = 15

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

local function getPerlinMap(hor, ver)
    local perlinMap = {}
    for y = 1, ver do
        local progress = y / height * 100
        local roundedProgress = math.floor(progress + 0.5)
        local progressString = tostring(roundedProgress)..'%'

        term.setCursorPos(width / 2 - #progressString / 2, height / 2)
        write(progressString)

        for x = 1, hor do
            local xNormalized = x / hor * noiseZoom
            local yNormalized = y / ver * noiseZoom

            local unmappedValue = perlinNoise.perlin:noise(xNormalized, yNormalized) -- Return range: [-1, 1]
            local value = cf.map(unmappedValue, -1, 1, 0, 1)

            perlinMap[#perlinMap+1] = value

            tryYield()
        end
    end
    return perlinMap
end

-- CODE EXECUTION --------------------------------------------------------

function setup()
    importAPIs()
    term.clear()
end

function main()
	local t1 = os.clock()

	if not rs.getInput(leverSide) then
        local perlinMap = getPerlinMap(width-1, height)
        local frame = dithering.getFrame(perlinMap, width-1)
		local noiseString = table.concat(frame)

		term.setCursorPos(1, 1)
		write(noiseString)
	end

	-- Measures the time it took for the program to run.
	local t2 = os.clock()
	local elapsedTime = t2 - t1
	local roundedTime = math.floor(elapsedTime * 100 + 0.5) / 100
	local clear = ' '

	term.setCursorPos(1, 1)
	write('Elapsed time: '..tostring(roundedTime)..'s'..clear)
end

setup()
main()