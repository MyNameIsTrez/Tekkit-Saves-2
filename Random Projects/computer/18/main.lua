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

function importAPIs()
	local APIs = {
		{id = "drESpUSP", name = "shape"},
        {id = "p9tSSWcB", name = "cf"},
        {id = "sSjBVjgc", name = "keys"},
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
local cursorIcon = "x"

local selectKey = "o"
local placeKey = "p"

local saveKey = "j"

local saveFolder = "saves"



-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local cursor = vector.new(1, 1)
local pixels = {}
local enteredChars

local moveKey
local otherKey



-- FUNCTIONS --------------------------------------------------------

function place()
	-- Currently, a "pixel" can hold a string. Should rewrite code so the string is split up into pixels or I should rename "pixel".
	local pixel = { pos = vector.new(cursor.x, cursor.y), char = enteredChars }
	shape.point(pixel.pos, pixel.char)
	pixels[#pixels + 1] = pixel
end



-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
	term.clear()
end

function main()
	while true do
		if not rs.getInput(leverSide) then
			term.clear()

			for i = 1, #pixels do
				local pixel = pixels[i]
				shape.point(pixel.pos, pixel.char)
			end

			cf.moveCursor(cursor, moveKey, width, height, cursorIcon)
			
			if otherKey == selectKey then
				local _, selectedKeyNum = os.pullEvent("key")
				while keys.getName(selectedKeyNum) == selectKey do
					_, selectedKeyNum = os.pullEvent("key")
				end
				
				enteredChars = read()
				shape.point(vector.new(cursor.x + 1, cursor.y), string.rep(" ", #enteredChars))
			elseif otherKey == placeKey then
				if enteredChars then
					place()
				end
			elseif otherKey == saveKey then
				cf.saveData(saveFolder, textutils.serialize(pixels))
			-- elseif otherKey == loadKey then
			end
			
			local event, keyNum = os.pullEvent("key")
			local char = keys.getName(keyNum)
			if char == "w" or char == "a" or char == "s" or char == "d" then
				moveKey = char
				otherKey = nil
			else
				otherKey = char
				moveKey = nil
			end
		else
			sleep(1)
		end
    end
end

setup()
main()