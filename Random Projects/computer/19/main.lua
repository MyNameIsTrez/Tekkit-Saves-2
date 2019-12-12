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
        {id = "p9tSSWcB", name = "cf"},
        -- {id = "QERUp0Fc", name = "LibDeflate"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

-- local function importAnimation()
-- end

-- EDITABLE VARIABLES --------------------------------------------------------

local fileName = "banana lol"
local loop = true

local decompression = false

local leverSide = "right"

local slow = true
local slowTime = 0.2

-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local frameWidth
local frameHeight
local frameCount
local initialFrameString
local optimizedFramesString
local initialFrame
local optimizedFrames

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function getSelectedAnimationData()
    local file = fs.open("input/"..fileName..".txt", "r")
    local string = file.readAll()
    file.close()

    tab = textutils.unserialize(string)

    frameWidth = tab.width
    frameHeight = tab.height
    frameCount = tab.frame_count
    initialFrameString = tab.initial_frame
    optimizedFramesString = tab.optimized_frames
end

local function convertDataToFrames()
    initialFrame = {}
    for x = 1, frameWidth do
        table.insert(initialFrame, {})
        for y = 1, frameHeight do
            local index = y + (x - 1) * frameHeight
            local char = initialFrameString:sub(index, index)
            initialFrame[x][y] = char
        end
    end

    optimizedFrames = {}
    for f = 1, frameCount do
        table.insert(optimizedFrames, {})
        for x = 1, frameWidth do
            table.insert(optimizedFrames[f], {})
            for y = 1, frameHeight do
                local index = y + (x - 1) * frameHeight + f * frameWidth * frameHeight
                local char = optimizedFramesString:sub(index, index)
                optimizedFrames[f][x][y] = char
            end
        end
    end
end

local function showImage(frame)
    for x = 1, frameWidth do
        for y = 1, frameHeight do
            local char = frame[x][y]
            if char ~= "t" then -- "t" is a reserved character
                term.setCursorPos(x, y)
                write(char)
            end
        end
    end
end

local function tryYield()
    local currentClock = os.clock()
    if currentClock - previousClock > 4 then
        previousClock = currentClock
        cf.yield()
    end
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
    importAPIs()
    -- importAnimation()
    getSelectedAnimationData()
    convertDataToFrames()

	term.clear()
    term.setCursorPos(1, 1)
end

local function main()
    if not rs.getInput(leverSide) then
        showImage(initialFrame)
        tryYield()

        if frameCount > 1 then
            if loop then
                i = 0
                while true do
                    for frameIndex = 1, frameCount do
                        frame = optimizedFrames[frameIndex]
                        showImage(frame)
                        tryYield()
                        term.setCursorPos(1, height - 5)
                        write(i)
                        i = i + 1
                        if slow then
                            sleep(slowTime)
                        end
                    end
                end
            else
                for frameIndex = 1, frameCount do
                    frame = optimizedFrames[frameIndex]
                    showImage(frame)
                    tryYield()
                end
                term.setCursorPos(width, height)
            end
        else
            frame = optimizedFrames[1]
            showImage(frame)
            term.setCursorPos(width, height)
        end
	end
end

setup()
main()