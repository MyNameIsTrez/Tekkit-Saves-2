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
    os.loadAPI('cfg')
end

local function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'},
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

-- Request animation using http calls.
-- local function importAnimation()
-- end

-- NOT USER EDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local frameCount

local compressed

local unpackedOptimizedFrames = {}

-- FUNCTIONS --------------------------------------------------------

local function unpackOptimizedFrames(optimizedFrames)
    print('Unpacking optimized frames...')
	
	startTime = os.clock()
	local cursorX, cursorY = term.getCursorPos()
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
				-- local delimiterIndex = searchedString:find(';')

				local delimiterIndex
				for i = 1, #searchedString do
					local char = searchedString:sub(i, i)
					if char == ';' then
						delimiterIndex = i
						break
					end
				end

				-- print('delimiterIndex: '..tostring(delimiterIndex))
				-- sleep(1)

				local searchedDelimiterIndex = delimiterIndex + 2 - openBracketIndex
				local searchedClosedBracketIndex = closedBrackedIndex - openBracketIndex
				local repeatedChars = searchedString:sub(delimiterIndex + 1, searchedClosedBracketIndex)

				-- local repeatedChars = searchedString:sub(searchedDelimiterIndex, searchedClosedBracketIndex)
				-- print('searchedDelimiterIndex: '..tostring(searchedDelimiterIndex))
				-- print('searchedClosedBracketIndex: '..tostring(searchedClosedBracketIndex))
				-- sleep(1)
				
				-- Add the repeated characters.
				local repetition = tonumber(searchedString:sub(2, delimiterIndex - 1))

				-- print('searchedString: '..tostring(searchedString))
				-- print('openBracketIndex: '..tostring(openBracketIndex))
				-- print('repetitionStringEndIndex: '..tostring(delimiterIndex - 1))
				-- print('repetitionString: '..tostring(searchedString:sub(2, delimiterIndex - 1)))
				-- print('repetition: '..tostring(repetition))
				-- sleep(1)
				-- print(type(searchedString))
				-- print(#searchedString)
				-- print(searchedString:find('['))
				-- print(string.find('[288; ]', '['))
				-- print(repeatedChars)
				-- sleep(1)

				unoptimizedString = unoptimizedString .. repeatedChars:rep(repetition)
				
				openBracketIndex = nil
			end
		end

		table.insert(unpackedOptimizedFrames, unoptimizedString)

		cf.tryYield()
    end
end

local function getSelectedAnimationData()
	if cfg.computerType ~= 'laptop' and cfg.computerType ~= 'desktop' then
		error('You didn\'t enter a valid \'computerType\' name in the cfg file!')
	end

	print('1/5 - Opening data file...')
	local file = fs.open(cfg.computerType .. ' inputs/' .. cfg.fileName .. '.txt', 'r')
	cf.yield()

	local cursorX, cursorY = term.getCursorPos()
	local stringTab = {}
	local i = 1
	for lineStr in file.readLine do
		table.insert(stringTab, lineStr)

		if i % 100 == 0 then
			term.setCursorPos(cursorX, cursorY)
			print('2/5 - Got '..tostring(i)..'/'..'?'..' data lines...')
		end
		i = i + 1

		cf.yield()
	end
	file:close()
	cf.yield()

	local string = table.concat(stringTab)
	cf.yield()
	
	function getKeyValue(str, key)
		local keyLength = #(key..'=')
		local keyStart = str:find(key..'=')
		if keyStart == nil then return nil end
		local indexStart = keyStart + keyLength

		local indexEnd = str:find(',', indexStart)
		if not indexEnd then
			-- Last value doesn't have a comma after it.
			indexEnd = str:find('}', indexStart)
		end
		indexEnd = indexEnd - 1

		return str:sub(indexStart, indexEnd)
	end

	-- Convert number string to number.
	frameCount = tonumber(getKeyValue(string, 'frame_count'))
	cf.tryYield()

	-- Convert boolean string to boolean.
	compressed = getKeyValue(string, 'compressed') == 'true'
	cf.tryYield()
	
	function getFrames(str)
		local frames = {}
		
		local cursorX, cursorY = term.getCursorPos()
		local i = 1
		str:gsub('"(.-)"', function (n)
			table.insert(frames, n)

			if i % 100 == 0 then
				term.setCursorPos(cursorX, cursorY)
				print('3/5 - Got '..tostring(i)..'/'..tostring(frameCount)..' frames...')
			end
			i = i + 1

			cf.tryYield()
		end)
		return frames
	end
	
	local optimizedFrames = getFrames(string)
	cf.tryYield()

	if compressed then
		unpackOptimizedFrames(optimizedFrames)
	else
		unpackedOptimizedFrames = optimizedFrames
	end
end

local function createGeneratedCodeFolder()
	if fs.exists('.generatedCodeFiles') then
		local names = fs.list('.generatedCodeFiles')

		for _, name in pairs(names) do
			fs.delete('.generatedCodeFiles/'..tostring(name))
		end
	else
		fs.makeDir('.generatedCodeFiles')
	end
end

local function dataToGeneratedCode()
	whileLoop = frameCount > 1 and cfg.loop
	
	local numberOfNeededFiles = math.ceil(frameCount / cfg.maxFramesPerGeneratedCodeFile)

	local cursorX, cursorY = term.getCursorPos()
	local i = 1

	for generatedCodeFileIndex = 1, numberOfNeededFiles do
		local handle = io.open('.generatedCodeFiles/'..generatedCodeFileIndex, 'w')

		local frameOffset = (generatedCodeFileIndex - 1) * cfg.maxFramesPerGeneratedCodeFile

		local frameCountToFile = math.min(frameCount - frameOffset, cfg.maxFramesPerGeneratedCodeFile)

		local minFrames = frameOffset + 1
		local maxFrames = frameOffset + frameCountToFile

		for f = minFrames, maxFrames do
			local string =
			'\nterm.setCursorPos(1,1)'..
			'\nwrite("' .. unpackedOptimizedFrames[f] .. '")'..
			'\nos.queueEvent("r")'..
			'\nos.pullEvent("r")'

			if cfg.frameSleeping and cfg.frameSleep ~= -1 then
				string = string..
				'\nsleep(' .. tostring(cfg.frameSleep) .. ')'
			end
			
			handle:write(string)

			cf.tryYield()

			if i % 100 == 0 then
				term.setCursorPos(cursorX, cursorY)
				print('4/5 - Wrote '..tostring(i)..'/'..tostring(frameCount)..' optimized frames...')
			end
			i = i + 1
		end
		
		handle:close()
		
		cf.tryYield()
	end
end

local function executeRegularCode()
	for f = 1, frameCount do
		term.setCursorPos(1,1)
		write(unpackedOptimizedFrames[f])
		if cfg.frameSleeping and cfg.frameSleep ~= -1 then
			sleep(cfg.frameSleep)
		end
		cf.tryYield()
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
			createGeneratedCodeFolder()
			dataToGeneratedCode()
		end
    end
end

local function main()
	if not rs.getInput(cfg.leverSide) then
		if cfg.generateOptimizedCode then
			print('5/5 - Executing optimized code...')

			local len = #fs.list('.generatedCodeFiles')
			
			-- local handles = {}
			-- for i = 1, len do
			-- 	local handle = io.open('.generatedCodeFiles/'..i, 'r')
			-- 	table.insert(handles, handle)
			-- end

			while true do
				if not rs.getInput(cfg.leverSide) then
					for i = 1, len do
						-- local handle = handles[i]

						-- What goes here?

						shell.run('.generatedCodeFiles/'..tostring(i))
					end
				else
					sleep(1)
				end
				cf.tryYield()
			end
		else
			print('Executing regular code...')

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