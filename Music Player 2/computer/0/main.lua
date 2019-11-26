local width, height = term.getSize()
local instruments = {"bass", "snare", "hat", "bassdrum", "harp"}
local instrumentKeys = {[2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5}
local movement = {[17] = "w", [30] = "a", [31] = "s", [32] = "d"}
local cursor = {x = 4, y = 3}
local spacing = 5 -- Need a better name. Vertical line that separates the instrument notes.
local spacingSymbol = "."
local clearingKey = 42 -- The key to clear instrument notes from the song array. 42 is the shift key.

-- Fill the song table with empty tables, based on the width of the terminal.
local songSteps = width - 5
local song = {}
for x = 1, songSteps do
	song[x] = {}
	for y = 1, 25 do
		song[x][y] = 0
	end
end

term.clear()

-- Draw top line.
term.setCursorPos(1, 2)
write(string.rep("_", width - 1))

-- Write down 01 to 25 for the number of pitches.
for i = 1, 25 do
	term.setCursorPos(1, 2 + i)
	if (i < 10) then
		write(0)
	end
	write(i)
	-- Draw left line.
	write("|")
end

-- Draw bottom line.
term.setCursorPos(1, height)
write(string.rep("-", width - 1))

-- Draw right line.
for i = 1, 25 do
	term.setCursorPos(width - 1, 2 + i)
	write("|")
end

term.setCursorPos(1, 1)
write("Selected: "..instruments[1])

-- Draw the cursor starting position.
term.setCursorPos(cursor.x, cursor.y)
write("x")

function drawSpacingLines()
	for x = 1, #song do
		if (x % spacing == 0) then
			for y = 1, 25 do
				term.setCursorPos(x + 3, y + 2)
				write(spacingSymbol)
			end
		end
	end
end

function drawInstrumentNotes()
	for x = 1, #song do
		for y = 1, 25 do
			local instrumentNumber = song[x][y]
			if (instrumentNumber ~= 0) then
				term.setCursorPos(x + 3, y + 2)
				write(instrumentNumber)
			end
		end
	end
end

drawSpacingLines()
drawInstrumentNotes()

while true do
	local evt, key = os.pullEvent("key")

	-- Display the selected instrument.
	local selectedInstrument = instruments[instrumentKeys[key]]
	if (selectedInstrument) then
		-- Clear the first row of characters.
		term.setCursorPos(1, 1)
		write(string.rep(" ", width - 1))
		
		term.setCursorPos(1, 1)
		write("Selected: "..selectedInstrument)
	end

	-- Movement.
	local direction = movement[key]
	if (direction) then
		-- Undraw the cursor.
		term.setCursorPos(cursor.x, cursor.y)
		write(" ")

		-- Move the cursor.
		if (direction == "w" and cursor.y >= 4) then
			cursor.y = cursor.y - 1
		elseif (direction == "a" and cursor.x >= 5) then
			cursor.x = cursor.x - 1
		elseif (direction == "s" and cursor.y <= height - 2) then
			cursor.y = cursor.y + 1
		elseif (direction == "d" and cursor.x <= width - 3) then
			cursor.x = cursor.x + 1
		end
	end

	drawSpacingLines()
	drawInstrumentNotes()

	-- Draw the cursor.
	if (direction) then
		term.setCursorPos(cursor.x, cursor.y)
		write("x")
	end
	
	-- Write the key that's being pressed, for debugging purposes.
	-- term.setCursorPos(1, 1)
	-- write(string.rep(" ", width - 1))
	-- term.setCursorPos(1, 1)
	-- write("Key "..key.." pressed")

	-- Placing instruments.
	local instrumentKey = instrumentKeys[key]
	if (instrumentKey) then
		song[cursor.x - 3][cursor.y - 2] = instrumentKey

		-- Immediately draw the new instrument note.
		term.setCursorPos(cursor.x, cursor.y)
		write(instrumentKeys[key])
	end

	-- Clear instrument notes.
	if (key == clearingKey) then
		song[cursor.x - 3][cursor.y - 2] = 0

		-- Immediately clear the instrument note.
		term.setCursorPos(cursor.x, cursor.y)
		write("x")
	end
end