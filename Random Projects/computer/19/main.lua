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

local function importConfig()
    os.loadAPI("cfg")
end

local function importAPIs()
	local APIs = {
		{id = "p9tSSWcB", name = "cf"},
	}

	fs.delete("apis") -- Deletes the folder, with every API file in it.
	fs.makeDir("apis") -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

-- local function importAnimation()
-- end

-- NOT USER EDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local frameWidth
local frameHeight
local frameCount

local optimizedFramesString
local optimizedFrames

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function getSelectedAnimationData()
	if cfg.computerType ~= "laptop" and cfg.computerType ~= "desktop" then
		error("You didn't enter a valid 'computerType' name in the cfg file!")
	end
	print("Loading animation...")
	local file = fs.open(cfg.computerType.." inputs/"..cfg.fileName..".txt", "r")
	local string = file.readAll()
	file.close()

	tab = textutils.unserialize(string)

	frameWidth = tab.width
	frameHeight = tab.height
    frameCount = tab.frame_count
    
    optimizedFramesString = tab.optimized_frames
end

local function tryYield()
	local currentClock = os.clock()
	if currentClock - previousClock > 4 then
		previousClock = currentClock
		cf.yield()
	end
end

local function dataToGeneratedCode()
	print("Converting data to the optimized frames...")
    optimizedFrames = {}
    frameSize = frameWidth * frameHeight

    local handle = io.open("generatedCode", "w")

    if handle then
        whileLoop = frameCount > 1 and cfg.loop

        if whileLoop then
            local string =
            'while true do'..
            '\n    if not rs.getInput("'..cfg.leverSide..'") then'
            handle:write(string)
        end

        for f = 1, frameCount do
            index1 = (f - 1) * frameSize + 1
            index2 = f * frameSize
            frameString = optimizedFramesString:sub(index1, index2)

            local string =
            '\n        term.setCursorPos(1,1)'..
            '\n        write("'..frameString..'")'..
            '\n        os.queueEvent("r")'..
            '\n        os.pullEvent("r")'

            if cfg.frameSleeping and cfg.frameSleep ~= -1 then
                string = string..
                '\n        sleep('..tostring(cfg.frameSleep)..')'
            end
            
            handle:write(string)

            if f % cfg.drawnColumnsYield == 0 then
                tryYield()
            end
        end
                
        if whileLoop then
            local string =
            '\n    else'..
            '\n        sleep(1)'..
            '\n    end'..
            '\nend'
            handle:write(string)
        end
    else
        error("couldn't create/open the generatedCode file")
    end
    
    handle:close()
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
    importConfig()
	if not rs.getInput(cfg.leverSide) then
		importAPIs()
        -- importAnimation()
        getSelectedAnimationData()
        cf.yield()
        dataToGeneratedCode()
		tryYield()
		term.clear()
		term.setCursorPos(1, 1)
        -- sleep(2)
    end
end

local function main()
	if not rs.getInput(cfg.leverSide) then
        shell.run("generatedCode")
        term.setCursorPos(width, height)
	end
end

setup()
main()