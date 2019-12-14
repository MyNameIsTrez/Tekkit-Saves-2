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
    print(os.loadAPI("cfg"))
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
local initialFrameString
local optimizedFramesString
local initialFrame
local optimizedFrames

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function getSelectedAnimationData()
	local file = fs.open(cfg.fileFolder.."/"..cfg.fileName..".txt", "r")
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
			if char ~= "t" then -- "t" is a reserved character.
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
    importConfig()
	importAPIs()
	-- importAnimation()
	getSelectedAnimationData()
	convertDataToFrames()

	term.clear()
	term.setCursorPos(1, 1)
end

local function main()
	if not rs.getInput(cfg.leverSide) then
        showImage(initialFrame)
        if cfg.showFrameCounter then
            term.setCursorPos(1, height - 5)
            write("frame: initial frame")
        end

		tryYield()
		if cfg.slow then
			sleep(cfg.slowTime)
        end
        
        if cfg.showFrameCounter then
            term.setCursorPos(1, height - 5)
            write("                    ")
        end

		if frameCount > 1 then
			if cfg.loop then
                while true do
                    if cfg.showFrameCounter then
                        i = 1
                    end
					for frameIndex = 1, frameCount do
						frame = optimizedFrames[frameIndex]
						showImage(frame)
                        if cfg.showFrameCounter then
                            term.setCursorPos(1, height - 5)
                            write("frame: "..i.."/"..frameCount)
                            i = i + 1
                        end

						tryYield()
						if cfg.slow then
							sleep(cfg.slowTime)
						end
					end
                    -- ALL BELOW SHOULD BE TEMPORARY!!!!!
                    -- THIS IS HERE, BECAUSE THERE ARE MANY ARTIFACTS LEFT AFTER EACH LOOP
                    showImage(initialFrame)
                    
                    if cfg.showFrameCounter then
                        term.setCursorPos(1, height - 5)
                        write("frame: initial frame")
                    end

					tryYield()
                    if cfg.slow then
                        sleep(cfg.slowTime)
                    end
                    
                    if cfg.showFrameCounter then
                        term.setCursorPos(1, height - 5)
                        write("                    ")
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