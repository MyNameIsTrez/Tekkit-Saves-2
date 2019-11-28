local width, height = term.getSize()
local instruments = {"bass", "snare", "hat", "bassdrum", "harp"}
local instrumentKeys = {["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["i"] = 1, ["o"] = 2, ["p"] = 3, ["["] = 4, ["]"] = 5}
-- The index values that are numbers are for the arrow keys.
local movement = {["w"] = "w", ["a"] = "a", ["s"] = "s", ["d"] = "d", [200] = "w", [203] = "a", [208] = "s", [205] = "d"}
local cursor = {x = 4, y = 3}
local spacing = 5 -- Need a better name. Vertical line that separates the notes.
local spacingSymbol = "."
local songName = "we_are_number_one_basic"
local clearingKey = 42 -- The key to clear notes from the song array. 42 is the shift key.
local saveKey = 33 -- The key to save the song table to a file. 33 is the f key.
local playResetKey = 57 -- The key to start and stop transmitting the notes of the song to the other computers. 57 is the spacebar key.
local playingProgressCursorSymbol = "|"
local playingSleep = 0.05 -- The time slept between played notes.
local playTimer
local playing = false
local playedColumn -- The column of notes that the song starts playing at.
local song

local colorsTable = { -- Under the hood 2^n starting at n = 0, used for addressing colored insulated wires.
  colors.white, colors.orange, colors.magenta,
  colors.lightBlue, colors.yellow, colors.lime,
  colors.pink, colors.gray, colors.lightGray,
  colors.cyan, colors.purple, colors.blue,
  colors.brown, colors.green, colors.red,
  colors.black
}

function drawTopLine()
    -- Draw top line.
    term.setCursorPos(1, 2)
	write(string.rep("_", width - 1))
end

function drawBottomLine()
    -- Draw bottom line.
    term.setCursorPos(1, 28)
	write(string.rep("-", width - 1))
end

function drawRightLine()
    -- Draw right line.
    for i = 1, 25 do
        term.setCursorPos(width - 1, 2 + i)
        write("|")
	end
end

function drawNotePitches()
	-- Write down 01 to 25 for the number of pitches.
	for i = 25, 1, -1 do
		term.setCursorPos(1, 3 + 25 - i)
		if (i < 10) then
			write(0)
		end
		write(i)
		-- Draw left line.
		write("|")
	end
end

function drawSelectedStartingInstrument()
    term.setCursorPos(1, 1)
	write("Selected: "..instruments[1])
end

function drawStartingCursorPos()
    -- Draw the cursor starting position.
    term.setCursorPos(cursor.x, cursor.y)
	write("x")
end

function drawSpacingLines()
	for x = 1, #song.notes do
		if (x % spacing == 0) then
			for y = 1, 25 do
				term.setCursorPos(x + 3, y + 2)
				write(spacingSymbol)
			end
		end
	end
end

function drawInstrumentNotes()
	for x = 1, #song.notes do
		for y = 1, 25 do
			local instrumentNumber = song.notes[x][y]
			if (instrumentNumber ~= nil) then
				term.setCursorPos(x + 3, 26 - y + 2)
				write(instrumentNumber)
			end
		end
	end
end

function drawSelectedInstrument(selectedInstrument)
	-- Clear the first row of characters that display the selected instrument.
	term.setCursorPos(1, 1)
	write(string.rep(" ", 18))
	
	term.setCursorPos(1, 1)
	write("Selected: "..selectedInstrument)
end

function move(direction)
    -- Undraw the cursor.
    term.setCursorPos(cursor.x, cursor.y)
    write(" ")

    -- Move the cursor.
    if (direction == "w" and cursor.y >= 4) then
        cursor.y = cursor.y - 1
    elseif (direction == "a" and cursor.x >= 5) then
        cursor.x = cursor.x - 1
    elseif (direction == "s" and cursor.y <= 26) then
        cursor.y = cursor.y + 1
    elseif (direction == "d" and cursor.x <= width - 3) then
        cursor.x = cursor.x + 1
    end
end

function drawCursor()
    -- Draw the cursor.
	term.setCursorPos(cursor.x, cursor.y)
	write("x")
end

function debugWriteKeys(value)
    -- Write the key that's being pressed, for debugging purposes.
    term.setCursorPos(1, 1)
    write(string.rep(" ", width - 1))
    term.setCursorPos(1, 1)
    write("Key "..value.." pressed")
end

function clearNotes()
    -- Clear notes.
	table.remove(song.notes[cursor.x - 3], 4 + 26 - cursor.y - 2)

	-- Immediately clear the note by drawing the cursor over it.
	term.setCursorPos(cursor.x, cursor.y)
	write("x")
end

function placeNote(instrumentKey)
    -- Placing instruments.
	if (song.notes[cursor.x - 3][4 + 26 - cursor.y - 2] ~= instrumentKey) then
		-- Add the note.
		song.notes[cursor.x - 3][4 + 26 - cursor.y - 2] = instrumentKey

		-- Immediately draw the new note.
		term.setCursorPos(cursor.x, cursor.y)
		write(instrumentKey)
	else
		-- Remove the note.
		clearNotes()
	end
end

function saveSong(value)
    -- Save the song table to a file.
	local file = fs.open("songs/"..songName, "w")
	file.write(textutils.serialize(song))
	file.close()

	local savedMsg = "Saved as "..songName
	term.setCursorPos(width - #savedMsg, 1)
	write(savedMsg)
end

function checkStartStopSong(value)
    -- Start or stop playing the song.
	if (playing) then
		playing = false
		
		-- Clear the last progress cursor.
		term.setCursorPos(playedColumn + 2, 2)
		write("_")
	else
		playing = true
		playedColumn = 1
	end
end

function moveProgressCursor()
	-- Clear the previous progress cursor.
	-- Don't need to clear behind the first progress cursor.
	if (playedColumn >= 2) then
		term.setCursorPos(playedColumn + 2, 2)
		write("_")
	end

	-- Draw the new progress cursor.
	term.setCursorPos(playedColumn + 3, 2)
	write(playingProgressCursorSymbol)
end

function fillSongTable()
	if fs.exists("songs/"..songName) then
		-- Load the existing song.
		local file = fs.open("songs/"..songName, "r")
		local string = file.readAll()
		file.close()
		song = textutils.unserialize(string)
	else
		-- Fill the song table with empty tables.
		song = {}
		local songSteps = width - 5
		song.notes = {}
		for x = 1, songSteps do
			song.notes[x] = {}
		end
	end
end

function drawSpacingSeconds()
	for x = 1, #song.notes do
		local temp = 1 / playingSleep
		if (x % temp == 0) then
			term.setCursorPos(x + 3, 29)
			write(tostring(x / temp).."s")
		end
	end
end

function sendNotesColumn()
	for songRow, instrumentNumber in pairs(song.notes[playedColumn]) do
		-- Broadcast the instrument/slave computer name.
		local instrument = instruments[instrumentNumber]
		if songRow <= 16 then
			instrument = instrument.."1"
		else
			instrument = instrument.."2"
		end
		rednet.broadcast(instrument)

		-- Broadcast the pitch of the instrument.
		local bundledColor
		if songRow <= 16 then
			bundledColor = colorsTable[songRow]
		else
			bundledColor = colorsTable[songRow - 16]
		end
		rednet.broadcast(tostring(bundledColor))
	end
end

function removeLastProgressCursor()
	-- Remove the remaining progress cursor.
	term.setCursorPos(playedColumn + 3, 2)
	write("_")
end

function getAllSongNames()
	return fs.list("songs/")
end

function tableContains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function setup()
	term.clear()

	local allSongNames = getAllSongNames()
	local chosenSongName = read()
	-- local chosenSongName = "we_are_number_one"
	if (chosenSongName == "new") then

	else
		if (tableContains(allSongNames, chosenSongName)) then
			-- User reads an existing song file.
			sleep(2)
		else
			write("You need to enter the name of an existing song. Type 'new' to create a new song.")
			sleep(2)
		end
	end
	
	term.clear()
	
	-- Draw the outlines of the program.
	drawTopLine()
	drawBottomLine()
	drawRightLine()

	drawNotePitches()
	drawSelectedStartingInstrument()

	fillSongTable()
	drawSpacingLines()
	drawSpacingSeconds()
	drawInstrumentNotes()
	drawStartingCursorPos()

	rednet.open("back") -- Activate the modem.
end

function main()
    while true do
        local event, value = os.pullEvent()

        -- The 'key' event is fired when keys like shift are pressed.
        if (event == "char" or event == "key") then
			local selectedInstrument = instruments[instrumentKeys[value]]
			if (selectedInstrument) then drawSelectedInstrument(selectedInstrument) end

            local direction = movement[value]
            -- sleep(0.1) -- Why does this break the program??
            if (direction) then move(direction) end

            drawSpacingLines()
            drawInstrumentNotes()
			if (direction) then drawCursor() end
			
			-- Meant for debugging/adding new keys.
			-- debugWriteKeys(value)
			
			local instrumentKey = instrumentKeys[value]
			if instrumentKey then placeNote(instrumentKey) end
            
			if value == clearingKey then clearNotes() end
            if value == saveKey then saveSong(value) end
            if value == playResetKey then checkStartStopSong(value) end
		elseif event == "timer" and playing then
			moveProgressCursor()
			sendNotesColumn()

			-- If the end of the song hasn't been reached.
			if (playedColumn < #song.notes) then
				playedColumn = playedColumn + 1
				-- One game tick of delay between each column.
				sleep(playingSleep)
			else
				playing = false
				removeLastProgressCursor()
				playedColumn = 1
			end
        end

		-- Loop to keep playing music while listening for user inputs.
		playTimer = os.startTimer(0.05)
    end
end

setup()
main()