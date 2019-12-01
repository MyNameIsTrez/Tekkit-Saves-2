-- EDITABLE -------------------------------------------
local playingSleep = 0.05 -- The time slept between played notes.

local spacing = 5 -- Vertical line that separates the notes.

local modemSide = "back" -- The side of the computer the modem is placed on.

local instrumentKeys = {["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["i"] = 1, ["o"] = 2, ["p"] = 3, ["["] = 4, ["]"] = 5}

-- The index values that are numbers are for the arrow keys.
local movement = {["w"] = "w", ["a"] = "a", ["s"] = "s", ["d"] = "d", [200] = "w", [203] = "a", [208] = "s", [205] = "d"}

local cursor = {x = 4, y = 3}

local clearingKey = 42 -- The key to clear notes from the song array. 42 is the shift key.
local saveKey = 33 -- The key to save the song table to a file. 33 is the f key.
local playResetKey = 57 -- The key to start and stop transmitting the notes of the song to the other computers. 57 is the spacebar key.

local spacingSymbol = "."
local playingProgressCursorSymbol = "|"



-- NOT EDITABLE -------------------------------------------
local width, height = term.getSize()
local instruments = {"bass", "snare", "hat", "bassdrum", "harp"}
local xOffset = 0

local playing
local song
local playTimer
local playedColumn
local chosenSongName
local maxColumn -- The x position of the last column.

local colorsTable = { -- Under the hood 2^n starting at n = 0, used for addressing colored insulated wires.
  colors.white, colors.orange, colors.magenta,
  colors.lightBlue, colors.yellow, colors.lime,
  colors.pink, colors.gray, colors.lightGray,
  colors.cyan, colors.purple, colors.blue,
  colors.brown, colors.green, colors.red,
  colors.black
}



-- DRAWING FUNCTIONS -------------------------------------------

-- Program outlines.
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


-- Startup program.
function drawSelectedStartingInstrument()
    term.setCursorPos(1, 1)
	write("Selected: "..instruments[1])
end

function drawStartingCursorPos()
    -- Draw the cursor starting position.
    term.setCursorPos(cursor.x, cursor.y)
	write("x")
end


-- Spacing.
function drawSpacingLines()
	for col = 1, width - 2 do
		if (col % spacing == 0) then
			for row = 1, 25 do
				term.setCursorPos(col + 3 - xOffset, row + 2)
				write(spacingSymbol)
			end
		end
	end
end

function drawSpacingSeconds()
	for col = 1, width - 2 do
		local temp = 1 / playingSleep
		if (col % temp == 0) then
			term.setCursorPos(col + 3, 29)
			write(tostring(col / temp).."s")
		end
	end
end


-- Cursor.
function drawCursor()
    -- Draw the cursor.
	term.setCursorPos(cursor.x - xOffset, cursor.y)
	write("x")
end

function drawMovedProgressCursor()
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

function drawRemoveLastProgressCursor()
	-- Remove the remaining progress cursor.
	term.setCursorPos(playedColumn + 3, 2)
	write("_")
end


-- Miscellaneous.
function drawNotes()
	for col, _ in pairs(song.notes) do
	-- for x = 1, #song.notes do
		-- for y = 1, 25 do
		for row, _ in pairs(song.notes[col]) do
			local instrumentNumber = song.notes[col][row]
			if (instrumentNumber ~= nil) then
				term.setCursorPos(col + 3, 26 - row + 2)
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



-- CALCULATION FUNCTIONS -------------------------------------------

-- Startup.
function listExistingSongNames()
	print("Songs you can load:")
	local songNames = fs.list("songs/")
	for _, songName in ipairs(songNames) do
		print("- "..songName)
	end
	print()
end

function askUserSongName()
	-- Ask the user to enter a song name to load.
	print("Load a song or create a new one:")
	chosenSongName = read()
end


-- Notes.
function placeNote(instrumentKey)
	-- If there's no song column for this note, create one.
	if (not song.notes[cursor.x - 3]) then
		song.notes[cursor.x - 3] = {}
	end

	-- If the note you're placing isn't already saved at its spot.
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

function clearNotes()
	-- If there is a note in this column.
	if (song.notes[cursor.x - 3]) then
		-- If the note that gets removed is the only one left in its column, remove the column.
		if (getNotesInColumnCount()) then
			table.remove(song.notes, cursor.x - 3)
		else
			-- Clear notes.
			table.remove(song.notes[cursor.x - 3], 4 + 26 - cursor.y - 2)
		end

		-- Immediately clear the note by drawing the cursor over it.
		term.setCursorPos(cursor.x, cursor.y)
		write("x")
	end
end

function getNotesInColumnCount()
	local count = 0
	for key, value in pairs(song.notes[cursor.x - 3]) do count = count + 1 end
	return count
end

function broadcastNotesColumn()
	for row, instrumentNumber in pairs(song.notes[playedColumn]) do
		-- Broadcast the instrument/slave computer name.
		local instrument = instruments[instrumentNumber]
		if row <= 16 then
			instrument = instrument.."1"
		else
			instrument = instrument.."2"
		end
		rednet.broadcast(instrument)

		-- Broadcast the pitch of the instrument.
		local bundledColor
		if row <= 16 then
			bundledColor = colorsTable[row]
		else
			bundledColor = colorsTable[row - 16]
		end
		rednet.broadcast(tostring(bundledColor))
	end
end


-- Load/Save song.
function loadSong()
	if fs.exists("songs/"..chosenSongName) then
		-- Load the existing song.
		local file = fs.open("songs/"..chosenSongName, "r")
		local string = file.readAll()
		file.close()
		song = textutils.unserialize(string)
	else
		-- Fill the song table with empty tables.
		song = {}
		song.notes = {}
	end
end

function saveSong(value)
    -- Save the song table to a file.
	local file = fs.open("songs/"..chosenSongName, "w")
	file.write(textutils.serialize(song))
	file.close()

	local savedMsg = "Saved as "..chosenSongName
	term.setCursorPos(width - #savedMsg, 1)
	write(savedMsg)
end


-- Miscellaneous.
function moveCursor(direction)
    -- Undraw the cursor.
    term.setCursorPos(cursor.x, cursor.y)
    write(" ")

    -- moveCursor the cursor.
    if (direction == "w" and cursor.y >= 4) then cursor.y = cursor.y - 1
	elseif (direction == "a" and cursor.x >= 5) then
		cursor.x = cursor.x - 1
		if (cursor.x > width - 3) then
			xOffset = xOffset - 1
		end
    elseif (direction == "s" and cursor.y <= 26) then cursor.y = cursor.y + 1
    -- elseif (direction == "d" and cursor.x <= width - 3) then cursor.x = cursor.x + 1 end
	elseif (direction == "d") then
		cursor.x = cursor.x + 1
		if (cursor.x > width - 2) then
			xOffset = xOffset + 1
		end
	end
end

function checkStartStopSong()
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

function setMaxColumn()
	-- Finds the x position of the last column.
	maxColumn = 0
	for col, _ in pairs(song.notes) do
		if (col > maxColumn) then maxColumn = col end
	end
end

function debugWriteKeys(value)
    -- Write the key that's being pressed, for debugging purposes.
    term.setCursorPos(1, 1)
    write(string.rep(" ", width - 1))
    term.setCursorPos(1, 1)
    write("Key "..value.." pressed")
end



-- CODE EXECUTION -------------------------------------------
function setup()
	term.clear()

	listExistingSongNames()
	askUserSongName()
	
	term.clear()
	
	-- Draw the outlines of the program.
	drawTopLine()
	drawBottomLine()
	drawRightLine()

	drawNotePitches()
	drawSelectedStartingInstrument()

	loadSong()
	setMaxColumn()
	drawSpacingLines()
	drawSpacingSeconds()
	drawNotes()
	drawStartingCursorPos()

	rednet.open(modemSide) -- Activate the modem.
end


function main()
    while true do
		local event, value = os.pullEvent()

		-- USEFUL WHEN DEBUGGING ---------------------
		term.setCursorPos(1, 29)
		print("xOffset: "..xOffset.."       ")
		print("cursor.x: "..cursor.x.."       ")

        -- The 'key' event is fired when keys like shift are pressed.
        if (event == "char" or event == "key") then
			local selectedInstrument = instruments[instrumentKeys[value]]
			if (selectedInstrument) then drawSelectedInstrument(selectedInstrument) end

            local direction = movement[value]
            -- sleep(0.1) -- Why does this break the program??
            if (direction) then moveCursor(direction) end

            drawSpacingLines()
            drawNotes()
			if (direction) then drawCursor() end
			
			-- Meant for debugging/adding new keys.
			-- debugWriteKeys(value)
			
			local instrumentKey = instrumentKeys[value]
			if instrumentKey then placeNote(instrumentKey) end
            
			if value == clearingKey then clearNotes() end
            if value == saveKey then saveSong(value) end
            if value == playResetKey then checkStartStopSong(value) end
		elseif event == "timer" and playing then
			drawMovedProgressCursor()

			-- If the column currently selected by the progress cursor has a note in it, play it.
			if song.notes[playedColumn] then broadcastNotesColumn() end

			-- If the end of the song hasn't been reached.
			if playedColumn < maxColumn then
				playedColumn = playedColumn + 1
				-- One game tick of delay between playing each column by default.
				sleep(playingSleep)
			else
				playing = false
				drawRemoveLastProgressCursor()
				playedColumn = 1
			end
        end

		-- Loop to keep playing music while listening for user inputs.
		playTimer = os.startTimer(0.05)
    end
end


setup()
main()