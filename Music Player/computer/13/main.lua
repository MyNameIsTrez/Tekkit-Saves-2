local width, height = term.getSize()
local instruments = {"bass", "snare", "hat", "bassdrum", "harp"}
local instrumentKeys = {["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5}
local movement = {["w"] = "w", ["a"] = "a", ["s"] = "s", ["d"] = "d", ["200"] = "w", ["203"] = "a", ["208"] = "s", ["205"] = "d"}
local cursor = {x = 4, y = 3}
local spacing = 5 -- Need a better name. Vertical line that separates the notes.
local spacingSymbol = "."
local songName = "we_are_number_one_timing"
local clearingKey = 42 -- The key to clear notes from the song array. 42 is the shift key.
local saveKey = 33 -- The key to save the song table to a file. 33 is the f key.
local playResetKey = 57 -- The key to start and stop transmitting the notes of the song to the other computers. 57 is the spacebar key.
local playingProgressCursorSymbol = "|"
local playingSleep = 0.05 -- The time slept between played notes.
local playTimer
local playing = false
local playedColumn -- The column of notes that the song starts playing at.
local song

rednet.open("back") -- Activate the modem.

local colorsTable = { -- Needed for addressing insulated wires.
  colors.white, colors.orange, colors.magenta,
  colors.lightBlue, colors.yellow, colors.lime,
  colors.pink, colors.gray, colors.lightGray,
  colors.cyan, colors.purple, colors.blue,
  colors.brown, colors.green, colors.red,
  colors.black
}

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

function drawSelectedInstrument(value)
    local selectedInstrument = instruments[instrumentKeys[value]]
    if (selectedInstrument) then
        -- Clear the first row of characters that display the selected instrument.
        term.setCursorPos(1, 1)
        write(string.rep(" ", 18))
        
        term.setCursorPos(1, 1)
        write("Selected: "..selectedInstrument)
    end
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

function drawCursor(direction)
    -- Draw the cursor.
    if (direction) then
        term.setCursorPos(cursor.x, cursor.y)
        write("x")
    end
end

function debugWriteKeys(value)
    -- Write the key that's being pressed, for debugging purposes.
    term.setCursorPos(1, 1)
    write(string.rep(" ", width - 1))
    term.setCursorPos(1, 1)
    write("Key "..value.." pressed")
end

function clearNotes(value)
    -- Clear notes.
    if (value == clearingKey) then
        table.remove(song.notes[cursor.x - 3], 4 + 26 - cursor.y - 2)

        -- Immediately clear the note by drawing the cursor over it.
        term.setCursorPos(cursor.x, cursor.y)
        write("x")
    end
end

function placeInstrument(value)
    -- Placing instruments.
    local instrumentKey = instrumentKeys[value]
    if (instrumentKey) then
        song.notes[cursor.x - 3][4 + 26 - cursor.y - 2] = instrumentKey

        -- Immediately draw the new note.
        term.setCursorPos(cursor.x, cursor.y)
        write(instrumentKeys[value])
    end
end

function saveSong(value)
    -- Save the song table to a file.
    if (value == saveKey) then
        local file = fs.open("songs/"..songName, "w")
        file.write(textutils.serialize(song))
        file.close()

        local savedMsg = "Saved as "..songName
        term.setCursorPos(width - #savedMsg, 1)
        write(savedMsg)
    end
end

function checkStartStopSong(value)
    -- Start or stop playing the song.
    if (value == playResetKey) then
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
end

function moveProgressCursor()
	if (playedColumn <= #song.notes) then
		-- Clear the previous progress cursor.
		if (playedColumn >= 2) then
			term.setCursorPos(playedColumn + 2, 2)
			write("_")
		end

		term.setCursorPos(playedColumn + 3, 2)
		write(playingProgressCursorSymbol)
	end
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

function setup()
    term.clear()
    
    -- Draw top line.
    term.setCursorPos(1, 2)
    write(string.rep("_", width - 1))
    
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
    
    -- Draw bottom line.
    term.setCursorPos(1, 28)
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

    fillSongTable()
	drawSpacingLines()
	drawSpacingSeconds()
    drawInstrumentNotes()
end

function main()
    while true do
        local event, value = os.pullEvent()

        -- The 'key' event is fired when keys like shift are pressed.
        if (event == "char" or event == "key") then
            drawSelectedInstrument(value)

            local direction = movement[value]
            -- sleep(0.1) -- Why does this break the program??
            if (direction) then
                move(direction)
            end

            drawSpacingLines()
            drawInstrumentNotes()
            drawCursor(direction)
            -- debugWriteKeys(value)
            placeInstrument(value)
            clearNotes(value)
            saveSong(value)
            checkStartStopSong(value)
		elseif (event == "timer") then
			if (playing) then
				moveProgressCursor()
				sendNotesColumn()
				if (playedColumn < #song.notes) then -- If the end of the song hasn't been reached.
					playedColumn = playedColumn + 1
					sleep(playingSleep) -- One game tick of delay between each column.
				else
					playing = false
					playedColumn = 1
				end
			end
        end

		playTimer = os.startTimer(0.05) -- Loop to keep playing music while listening for user inputs.
    end
end

setup()
main()