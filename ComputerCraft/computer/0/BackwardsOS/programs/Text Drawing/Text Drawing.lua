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

while true do
	if not rs.getInput(cfg.disableSide) then
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