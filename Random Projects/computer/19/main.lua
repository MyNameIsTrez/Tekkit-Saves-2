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
        {id = "QERUp0Fc", name = "LibDeflate"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

-- local function importFrames()
-- 	local APIs = {
-- 		{id = "cegB4RwE", name = "dithering"},
--         {id = "p9tSSWcB", name = "cf"},
-- 		-- {id = "drESpUSP", name = "shape"},
-- 	}

-- 	fs.delete("apis") -- Deletes folder.
-- 	fs.makeDir("apis") -- Creates folder.

-- 	for _, API in pairs(APIs) do
-- 		shell.run("pastebin", "get", API.id, "apis/"..API.name)
-- 		os.loadAPI("apis/"..API.name)
-- 	end
-- end

-- EDITABLE VARIABLES --------------------------------------------------------

local fileName = "banana lol"
local loop = true

local decompression = false

local leverSide = "right"

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local frames

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function showImage(img)
    local imgWidth = #img
    local imgHeight = #img[1]

    for x = 1, imgWidth do
        for y = 1, imgHeight do
            local brightness = img[x][y]
            if brightness ~= -1 then
                if brightness < 0 or brightness > 1 then
                    term.setCursorPos(1, height - 5)
                    print("brightness: "..brightness)
                    sleep(3)
                end
                local char = dithering.getClosestChar(brightness)

                term.setCursorPos(x, y)
                write(char)
            end
        end
    end
    
    term.setCursorPos(width, height)
end

local function tryYield()
    local currentClock = os.clock()
    if currentClock - previousClock > 4 then
        previousClock = currentClock
        cf.yield()
    end
end

local function getSelectedFrames()
    local file = fs.open("input/"..fileName..".txt", "r")
    local stringFile = file.readAll()
    file.close()

    local string
    if decompression then
        shell.run("apis/LibDeflate")
        print("a")
        for index, value in pairs(LibDeflate) do
            print(index, ", ", value)
        end
        print("b")
        sleep(5)
        string = LibDeflate:DecompressDeflate(stringFile)
        print(string)
        sleep(5)
    else
        string = stringFile
    end

    frames = textutils.unserialize(string)
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
    importAPIs()
    -- importFrames()
    getSelectedFrames()

	term.clear()
    term.setCursorPos(1, 1)
end

local function main()
    if not rs.getInput(leverSide) then
        if #frames > 1 then
            if loop then
                while true do
                    for frameIndex = 1, #frames do
                        frame = frames[frameIndex]
                        showImage(frame)
                        tryYield()
                    end
                end
            else
                for frameIndex = 1, #frames do
                    frame = frames[frameIndex]
                    showImage(frame)
                    tryYield()
                end
                term.setCursorPos(width, height)
            end
        else
            frame = frames[1]
            showImage(frame)
            term.setCursorPos(width, height)
        end
	end
end

setup()
main()