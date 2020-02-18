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

-- local z = math.random() * 1000000
local z = 0

local zIncrement = 0.1

local leverSide = "right"

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
-- local width, height = 50, 18
-- local width, height = 100, 36
-- local width, height = 150, 54
-- local width, height = width/2, height/2

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function tryYield()
    local currentClock = os.clock()
    if currentClock - previousClock > 4 then
        previousClock = currentClock
        cf.yield()
    end
end

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
	if not rs.getInput(leverSide) then
		while true do
			local t1 = os.clock()


			z = z + zIncrement

			local perlinMap = getPerlinMap(width-1, height, z)
			local frame = dithering.getFrame(perlinMap, width-1)
			local noiseString = table.concat(frame)

			term.setCursorPos(1, 1)
			write(noiseString)

			tryYield()


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
	end
end

setup()
main()