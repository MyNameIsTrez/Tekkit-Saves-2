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

local function convertDataToFrames()
	print("Converting data to the optimized frames...")
    optimizedFrames = {}
    frameSize = frameWidth * frameHeight
    for f = 1, frameCount do
		table.insert(optimizedFrames, {})
		for x = 1, frameWidth do
			table.insert(optimizedFrames[f], {})
			for y = 1, frameHeight do
                -- print(y)
				local index = y + (x - 1) * frameHeight + (f - 1) * frameSize -- (1,1), (1,2), (2,1), (2,2) etc.
                local char = optimizedFramesString:sub(index, index)
                if char == "t" then -- "t" is a reserved character.
                    optimizedFrames[f][x][y] = nil
                else
                    optimizedFrames[f][x][y] = char
                end
			end
		end
		tryYield()
	end
    -- print(2)
    -- print('frame count: '..frameCount)
    -- print(textutils.serialize(optimizedFrames))
end

local function showImage(frame)
	for x = 1, frameWidth do
		for y = 1, frameHeight do
			local char = frame[x][y]
			if char then
				term.setCursorPos(x, y)
				write(char)
			end
		end

		if x % cfg.drawnColumnsYield == 0 then
			tryYield()
		end
	end
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
    importConfig()
	if not rs.getInput(cfg.leverSide) then
		importAPIs()
        -- importAnimation()
		getSelectedAnimationData()
		convertDataToFrames()

		-- term.clear()
		-- term.setCursorPos(1, 1)
	end
end

local function main()
	if not rs.getInput(cfg.leverSide) then
		if frameCount > 1 then
			if cfg.loop then
                while true do
                    if cfg.showFrameCounter then
                        i = 1
                    end
					for frameIndex = 1, frameCount do
						if not rs.getInput(cfg.leverSide) then
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
					end
				end
			else
				for frameIndex = 1, frameCount do
					if not rs.getInput(cfg.leverSide) then
						frame = optimizedFrames[frameIndex]
						showImage(frame)
						tryYield()
					end
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