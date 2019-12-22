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
		shell.run("pastebin", "get", API.id, "apis/" .. API.name)
		os.loadAPI("apis/" .. API.name)
	end
end

-- Request animation using http calls.
-- local function importAnimation()
-- end

-- NOT USER EDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local frameWidth
local frameHeight
local frameCount

local unpackedOptimizedFrames = {}

local previousClock = 0

-- FUNCTIONS --------------------------------------------------------

local function tryYield()
    local currentClock = os.clock()
    if currentClock - previousClock > 4 then
        previousClock = currentClock
        cf.yield()
    end
end

local function unpackOptimizedFrames(optimizedFrames)
    print('Unpacking optimized frames...')
	
	startTime = os.clock()
    cursorX, cursorY = term.getCursorPos()
	for f = 1, frameCount do
		-- Print speed statistics.
		if f % 10 == 0 then
			-- Progress.
			progress = 'Creating frame ' .. tostring(f) .. '/' .. tostring(frameCount)

			-- Speed.
			elapsed = (os.clock() - startTime) / 10
			processedFps = 1 / elapsed
			speed = string.format('%d frames/s', processedFps)
			
			-- ETA.
			framesLeft = frameCount - f
			etaMinutes = math.floor(elapsed * framesLeft / 60)
			etaSeconds = math.floor(elapsed * framesLeft) % 60
			eta = string.format('%dm, %ds left', etaMinutes, etaSeconds)
			
			-- Clear.
			clear = '		'

			term.setCursorPos(cursorX, cursorY) -- Used so the next 'Creating frame' print statement can overwrite itself in its for loop.
            print(progress .. ', ' .. speed .. ', ' .. eta .. clear)
			startTime = os.clock()
        end

        local unoptimizedString = ''
        local optimizedFrame = optimizedFrames[f]
        
        local openBracketIndex = nil -- Probably not necessary to assign this with 'nil'.

        -- This can probably be done faster using table.concat:
        -- https://stackoverflow.com/a/1407187
        for currentIndex = 1, #optimizedFrame do
            local char = optimizedFrame:sub(currentIndex, currentIndex) -- can't use pairs or ipairs, I think
            
            if char == '[' then
                openBracketIndex = currentIndex
            end
            
            if openBracketIndex == nil then
                unoptimizedString = unoptimizedString .. char
            end
            
            if char == ']' then
                -- More efficient to look at 'optimizedFrame' once like this, because we 'sub:' it twice later.
                local closedBrackedIndex = currentIndex
                local searchedString = optimizedFrame:sub(openBracketIndex, closedBrackedIndex)
                
                -- Get the repeated characters.
                local delimiterIndex = searchedString:find(';')
                local searchedDelimiterIndex = delimiterIndex + 2 - openBracketIndex
                local searchedClosedBracketIndex = closedBrackedIndex - openBracketIndex
                local repeatedChars = searchedString:sub(searchedDelimiterIndex, searchedClosedBracketIndex)
                
                -- Add the repeated characters.
                local repetition = tonumber(searchedString:sub(2, delimiterIndex - openBracketIndex))
                unoptimizedString = unoptimizedString .. repeatedChars:rep(repetition)
                
                openBracketIndex = nil
            end
        end

        table.insert(unpackedOptimizedFrames, unoptimizedString)

		tryYield()
    end
end

local function getSelectedAnimationData()
	if cfg.computerType ~= "laptop" and cfg.computerType ~= "desktop" then
		error("You didn't enter a valid 'computerType' name in the cfg file!")
	end
	print("Loading animation data...")
	local file = fs.open(cfg.computerType .. " inputs/" .. cfg.fileName .. ".txt", "r")
	local string = file.readAll()
	file.close()
    
	tab = textutils.unserialize(string)
    
	frameWidth = tab.width
	frameHeight = tab.height
    frameCount = tab.frame_count
    
    local optimizedFrames = tab.optimized_frames
    unpackOptimizedFrames(optimizedFrames)
end

local function dataToGeneratedCode()
    local handle = io.open("generatedCode", "w")

    if handle then
        whileLoop = frameCount > 1 and cfg.loop

        if whileLoop then
			local string =
            'while true do'..
            '\n    if not rs.getInput("' .. cfg.leverSide .. '") then'
            handle:write(string)
        end

        for f = 1, frameCount do
            local string =
            '\n        term.setCursorPos(1,1)'..
            '\n        write("' .. unpackedOptimizedFrames[f] .. '")'..
            '\n        os.queueEvent("r")'..
            '\n        os.pullEvent("r")'

            if cfg.frameSleeping and cfg.frameSleep ~= -1 then
                string = string..
                '\n        sleep(' .. tostring(cfg.frameSleep) .. ')'
            end
            
            handle:write(string)

            tryYield()
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
        error("couldn't create/open the optimized code file")
    end
    
	handle:close()
	
	tryYield()
end

local function executeRegularCode()
	for f = 1, frameCount do
		term.setCursorPos(1,1)
		write(unpackedOptimizedFrames[f])
		if cfg.frameSleeping and cfg.frameSleep ~= -1 then
			sleep(cfg.frameSleep)
		end
		tryYield()
	end
end

-- CODE EXECUTION --------------------------------------------------------

local function setup()
    importConfig()
	if not rs.getInput(cfg.leverSide) then
		importAPIs()
		-- importAnimation() -- Request animation using http calls.
        getSelectedAnimationData()
		cf.yield()

		if cfg.generateOptimizedCode then
			print("Generating optimized code...")
			dataToGeneratedCode()
		end
		
		term.clear()
		term.setCursorPos(1, 1)
    end
end

local function main()
	if not rs.getInput(cfg.leverSide) then
		if cfg.generateOptimizedCode then
			print("Executing optimized code...")
			shell.run("generatedCode")
		else
			print("Executing regular code...")

			whileLoop = frameCount > 1 and cfg.loop
			if whileLoop then
				while true do
					executeRegularCode()
				end
			else
				executeRegularCode()
			end
		end
        term.setCursorPos(width, height)
	end
end

setup()
main()