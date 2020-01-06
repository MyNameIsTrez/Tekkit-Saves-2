-- README --------------------------------------------------------

-- Program used to create and preview animations/images.
 
-- The default terminal ratio is 25:9.
-- To get the terminal to fill your entire monitor and to get a custom text color:
-- 1. Open AppData/Roaming/.technic/modpacks/tekkit/config/mod_ComputerCraft.cfg
-- 2. Divide your monitor's width by 6 and your monitor's height by 9.
-- 3. Set terminal_width to the calculated width and do the same for terminal_height.
-- 4. Set the terminal_textColour_r, terminal_textColour_g and terminal_textColour_b
--    to values between 0 and 255 to get a custom text color.



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