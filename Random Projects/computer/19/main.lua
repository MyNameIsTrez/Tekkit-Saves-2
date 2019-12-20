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
    
    cursorX, cursorY = term.getCursorPos()
    for f = 1, frameCount do
        if f % 10 == 0 then
            term.setCursorPos(cursorX, cursorY) -- Used so the next 'Creating frame' print statement can overwrite itself in its for loop.
            print('Creating frame '..tostring(f)..'/'..tostring(frameCount)..'.')
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
                -- More efficient to look at 'optimizedFrame' once like this, because we need it multiple times.
                local searchedString = optimizedFrame:sub(openBracketIndex, currentIndex)
                
                print('searchedString: '..searchedString)
                print('#searchedString: '..tostring(#searchedString))
                print('openBracketIndex: '..tostring(openBracketIndex))
                local delimiterIndex = searchedString:find(';')
                
                -- Get the number of times to repeat the group of characters.
                local repetition = tonumber(searchedString:sub(2, delimiterIndex - openBracketIndex))
                -- print('repetition: '..tostring(repetition))
                
                -- Get the repeated characters.
                local searchedStringLen = currentIndex - delimiterIndex - 1 -- Because 5 - 3 - 1 -> 1.
                print('searchedStringLen: '..tostring(searchedStringLen))
                local repeatedChars = searchedString:sub(delimiterIndex + 1 - openBracketIndex, currentIndex - 1 - openBracketIndex)
                print('delimiterIndex: '..tostring(delimiterIndex))
                print('currentIndex: '..currentIndex)
                print('repeatedChars: '..tostring(repeatedChars))
                
                -- Add the repeated characters.
                unoptimizedString = unoptimizedString .. repeatedChars:rep(repetition)
                
                openBracketIndex = nil
            end
        end

        table.insert(unpackedOptimizedFrames, unoptimizedString)

        if f % 10 == 0 then
            tryYield()
        end
    end
end

local function getSelectedAnimationData()
	if cfg.computerType ~= "laptop" and cfg.computerType ~= "desktop" then
		error("You didn't enter a valid 'computerType' name in the cfg file!")
	end
	print("Loading animation data...")
	local file = fs.open(cfg.computerType.." inputs/"..cfg.fileName..".txt", "r")
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
	print("Generating executable code...")
    frameSize = frameWidth * frameHeight

    local handle = io.open("generated code", "w")

    if handle then
        whileLoop = frameCount > 1 and cfg.loop

        if whileLoop then
            local string =
            'while true do'..
            '\n    if not rs.getInput("'..cfg.leverSide..'") then'
            handle:write(string)
        end

        for f = 1, frameCount do
            local string =
            '\n        term.setCursorPos(1,1)'..
            '\n        write("'..unpackedOptimizedFrames[f]..'")'..
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
        error("couldn't create/open the generated code file")
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
    end
end

local function main()
	if not rs.getInput(cfg.leverSide) then
        shell.run("generated code")
        term.setCursorPos(width, height)
	end
end

setup()
main()