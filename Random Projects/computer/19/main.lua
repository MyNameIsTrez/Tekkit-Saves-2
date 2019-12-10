-- README --------------------------------------------------------

-- Program used to create and preview animations/images.

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

local function importAPIs()
	local APIs = {
		{id = "cegB4RwE", name = "dithering"},
        {id = "p9tSSWcB", name = "cf"},
		-- {id = "drESpUSP", name = "shape"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

-- EDITABLE VARIABLES --------------------------------------------------------

local leverSide = "right"

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1
local maxDist = math.sqrt((width / 2)^2 + (height / 2)^2)

-- FUNCTIONS --------------------------------------------------------

local function getDistToCenter(x, y)
	local a = x - width / 2
	local b = y - height / 2
	return math.sqrt(a^2 + b^2)
end

local function mapDist(dist)
	return dist / maxDist
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
	importAPIs()
	term.clear()
	term.setCursorPos(1, 1)
end

local function main()
	if not rs.getInput(leverSide) then
		for x = 1, width do
			for y = 1, height do
				local dist = getDistToCenter(x, y)
				local mappedDist = mapDist(dist)
				local char = dithering.getClosestChar(mappedDist)
				term.setCursorPos(x, y)
				write(char)
			end
			cf.yield()
		end

		-- for n = 0, 24 do
		-- 	print(dithering.getClosestChar(n/24))
		-- end
	end
	term.setCursorPos(width, height)
end

setup()
main()