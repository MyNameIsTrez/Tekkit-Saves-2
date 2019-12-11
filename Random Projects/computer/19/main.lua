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
local folder = "police"

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local files = {}

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function showImage(img)
    local imgWidth = #img
    local imgHeight = #img[1]

    for x = 1, imgWidth do
        for y = 1, imgHeight do
            local brightness = img[x][y]
            if brightness ~= -1 then
                local char = dithering.getClosestChar(brightness)

                term.setCursorPos(x, y)
                write(char)
            end
        end
    end
    
    term.setCursorPos(width, height)
end

function tryYield()
    local currentClock = os.clock()
    if currentClock - previousClock > 4 then
        previousClock = currentClock
        cf.yield()
    end
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
    importAPIs()
	term.clear()
    term.setCursorPos(1, 1)
    
    local filesInFolder = fs.list(folder)
    for i = 1, #filesInFolder do
        local file = fs.open(folder.."/"..i..".txt", "r")
        -- print(files)
        files[#files + 1] = textutils.unserialize(file.readAll())
        file.close()
    end
end

local function main()
    if not rs.getInput(leverSide) then
        while true do
            for _, file in ipairs(files) do
                showImage(file)
                tryYield()
            end
        end
	end
end

setup()
main()