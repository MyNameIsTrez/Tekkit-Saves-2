function startingSettings()
  -- code that needs to be ran at least once for the program to work, where you can also customize the starting data
  -- in lua, all these variables will still be globally accesible once this function is done
  term.clear() -- clear the text on the monitor
  shuffleSongs = {}
  playlistLength = 0 -- this needs to be 0, as it keeps track of the total time length of all the songs together
  termX, termY = term.getSize() -- store the terminal's dimensions in two variables
  gen = 0 -- which note the song is on

  screenSide = "right" -- which side the monitor is on, relative to the terminal.
  m = peripheral.wrap(screenSide) -- sets 'm' as being the monitor's variable, using screenSide.
  m.setTextScale(1) -- 1 by default, from 1 to 5
  w, h = m.getSize() -- store the width and height of the monitor
  w = w - 5 -- decrease the width by 5, to compensate for GUIs and border wrapping

  rednet.open("back") -- open the rednet network connection on the back of the terminal, so a modem can communicate with the terminal
  inputSideRandomSong = "left" -- if you place a lever on this side, you can activate the random song generator
  playSpeed = 1 -- the speed at which songs are played at (by default 1)
  randomPlaySpeed = 1 -- the speed at which randomly generated songs are played at (by default 1)
  page = 1 -- the page of the song pages you start at, where you can pick different songs to play (by default 1)
end
startingSettings() -- run the above function upon the startup of this program



function drawStartingGraphInfo()
  term.redirect(m) -- redirect the code to be ran on the monitor

  for i = 0, 24 do
    -- screen : max x-coordinate ratio is 1:6, 2:16, 3:26, 4:36
    -- screen : max y-coordinate ratio is 1:5, 2:11, 3:18, 4:25
    m.setCursorPos(1, 25 - i) -- set the cursor on the monitor to x, y
    if i <= 9 then
      i = "0"..i
    end
    write(i)
  end

  for i = 1, 25 do -- make a vertical line to the right of the numbers
    m.setCursorPos(3, i)
    write("|")
  end

  term.restore() -- redirect the code back to the terminal
end
drawStartingGraphInfo() -- run the above function upon the startup of this program



function drawSong(instrument, pitch) -- draws the given song data on the monitor
  term.redirect(m) -- redirect the code to be ran on the monitor
  -- screen : max x-coordinate ratio is 1:6, 2:16, 3:26, 4:36
  -- screen : max y-coordinate ratio is 1:5, 2:11, 3:18, 4:25

  m.setCursorPos(gen + 4, 26 - pitch - 1)
  if instrument == "bass" then
    write("a")
  elseif instrument == "snare" then
    write("b")
  elseif instrument == "hat" then
    write("c")
  elseif instrument == "bassdrum" then
    write("d")
  elseif instrument == "harp" then
    write("e")
  end
  term.restore() -- redirect the code back to the terminal
end



colorList = { -- all the colors to choose from
  colors.white, colors.orange, colors.magenta,
  colors.lightBlue, colors.yellow, colors.lime,
  colors.pink, colors.gray, colors.lightGray,
  colors.cyan, colors.purple, colors.blue,
  colors.brown, colors.green, colors.red,
  colors.black
}



instrumentList = { -- all the instruments that can be chosen from
  "bass", "snare", "hat", "bassdrum", "harp"
-- wood    sand    glass     stone     other
}



function getSongTitles() -- gets all the midi titles
  filesInCurDir = fs.list(shell.dir())

  for i = 1, #filesInCurDir do
    if filesInCurDir[i] == "startup" or filesInCurDir[i] == "main.lua" or filesInCurDir[i] == "rom" then
      table.remove(filesInCurDir, i)
    end
  end

  midiArrayTitles = {}

  for i = 1, #filesInCurDir do
    midiArrayTitles[i] = {} -- it's necessary to make this a 2D array, as it'll also hold the song lengths for every title
    midiArrayTitles[i][1] = filesInCurDir[i]
  end
end
getSongTitles() -- run the above function upon the startup of this program



function songLengths() -- gets the lengths of the songs
  for i = 1, #midiArrayTitles do
    songLength = 0
    shell.run(midiArrayTitles[i][1])
    print(midiArrayTitles[i][1])
    for j = 1, #midiArray do
      songLength = songLength + midiArray[j][1]
    end
    midiArrayTitles[i][2] = songLength -- assigns the length of each song title to the 2D array
    playlistLength = playlistLength + songLength -- counts the total time length of all the songs together
    midiArray = nil -- why does it need to set the midiArray to nil???
  end
end
songLengths() -- run the above function upon the startup of this program



function clearSongLines() -- clears the song lines of text
  for i = 1, 10 do
    term.setCursorPos(1, 4 + i)
    term.clearLine()
  end
  term.setCursorPos(1, 6)
end



function centerUserInput() -- courtesy of /u/HydrantHunter
  word = "" -- declare the variable to hold the complete word typed
  term.clearLine()
  while true do --# start an infinite loop
    local event, key = os.pullEvent() --# wait for an event
    if event == "key" and (key == 28 or key == 14) then --# if enter or backspace are pressed, deal with the separately
      if key == 28 then
        break
      end --# stop the cursor blinking and break the loop is enter is pressed
      if key == 14 and #word > 0 then --# handle backspace
        term.setCursorPos(math.floor((termX - #word) / 2) + 1, 17) --# set the cursor position
        term.write(string.rep(" ", #word)) --# clear the previous word
        word = word:sub(1, #word - 1) --# shorten the word
        term.setCursorPos(math.floor((termX - #word) / 2) + 1, 17) --# set the cursor position
        term.write(word) --# write the word
      end
    elseif event == "char" then --# if any regular character is typed then...
      word = word .. key --# concatenate the the character typed with the current word
      term.setCursorPos(math.floor((termX - #word) / 2) + 1, 17) --# set the cursor position
      term.write(word) --# write the word
    end
  end
end



function centerWords() -- centers the "word" variable which was set
  local x, y = term.getCursorPos()
  term.setCursorPos(math.floor((termX - #word) / 2) + 1, y) --# set the cursor position
  term.write(word) --# write the word
  word = ""
end



function invalidInput() -- draws the invalid input error
  term.setCursorPos(1, 17)
  word = "Invalid input."
  centerWords()
  sleep(1)
end



function readUserInput() -- reading the user input
  term.setCursorPos(1, 17)
  centerUserInput() -- asks the user input and stores in variable 'word'
  userInput = string.lower(word)
  numberUserInput = tonumber(word) -- converts the user input to a number and stores

  -- clears all previous song playing modes when a user has entered something
  playlistSongBoolean = "false"
  invalidInputBoolean = "false"
  shuffleSongBoolean = "false"
  randomSongBoolean = "false"
  playlistSongNumber = 0
  shuffleSongNumber = 0
  randomSongNumber = 0
  chosenSongNumber = 0

  if (type(numberUserInput) == "number") and (numberUserInput > 0) and (numberUserInput < (#midiArrayTitles + 1)) then -- checks if the user input is a number that's the index of a song title
    chosenSongNumber = numberUserInput
    page = math.ceil(chosenSongNumber / 10)
  elseif userInput == "help" or userInput =="help 1" then
    term.clear()
    term.setCursorPos(19, 2)
    print("Help page 1/2:")

    term.setCursorPos(19, 5)
    print("'help <number>'")
    term.setCursorPos(12, 6)
    print("Changes the viewed help page.")

    term.setCursorPos(16, 8)
    print("'page' -> '<number>'")
    term.setCursorPos(12, 9)
    print("Changes the viewed song page.")
    
    term.setCursorPos(20, 11)
    print("'playlist'")
    term.setCursorPos(4, 12)
    print("Play all the songs in the order of the pages.")

    -- term.setCursorPos(20, 11)
    -- print("'shuffle'")
    -- term.setCursorPos(4, 12)
    -- print("Play all the songs in a random order, but")
    -- term.setCursorPos(4, 13)
    -- print("it can't immediately repeat the same song.")
    
    term.setCursorPos(5, 16)
    print("Press the enter key to exit this help menu!")
    term.setCursorPos(1, 17)
    centerUserInput() -- asks a user input so the help menu stays open
  elseif userInput == "help 2" then
    term.clear()
    term.setCursorPos(19, 2)
    print("Help page 2/2:")

    term.setCursorPos(22, 4)
    print("'random'")
    term.setCursorPos(7, 5)
    print("Play all the songs in a random order,")
    term.setCursorPos(9, 6)
    print("but can immediately repeat songs.")

    term.setCursorPos(13, 8)
    print("'playspeed' -> '<number>'")
    term.setCursorPos(13, 9)
    print("Change the speed at which")
    term.setCursorPos(14, 10)
    print("the songs are played at.")

    term.setCursorPos(11, 12)
    print("'randomplayspeed' -> '<speed>'")
    term.setCursorPos(9, 13)
    print("Change the speed at which randomly")
    term.setCursorPos(11, 14)
    print("generated songs are played at.")
    
    term.setCursorPos(5, 16)
    print("Press the enter key to exit this help menu!")
    term.setCursorPos(1, 17)
    centerUserInput() -- asks a user input so the help menu stays open
  elseif userInput == "page" then
    term.setCursorPos(1, 17)
    centerUserInput() -- asks the user input and stores in variable 'word'
    numberUserInput = tonumber(word)

    if type(numberUserInput) == "number" then
      if numberUserInput > 0 and numberUserInput < (math.ceil(#midiArrayTitles / 10) + 1) then
        page = numberUserInput
        pageChangeBoolean = "true"
      else
        invalidInputBoolean = "true"
        invalidInput()
      end
    else
      invalidInput()
    end
  elseif userInput == "playlist" then
    playlistSongBoolean = "true"
  elseif userInput == "shuffle" then
    shuffleSongBoolean = "true"
  elseif userInput == "random" then
    randomSongBoolean = "true"
  elseif userInput == "playspeed" then
    term.setCursorPos(1, 17)
    centerUserInput() -- asks the user input and stores in variable 'word'
    numberUserInput = tonumber(word)

    if type(numberUserInput) == "number" then
      playSpeed = numberUserInput
      playSpeedChangeBoolean = "true"
    else
      invalidInput()
    end
  elseif userInput == "randomplayspeed" then
    term.setCursorPos(1, 17)
    centerUserInput() -- asks the user input and stores in variable 'word'
    numberUserInput = tonumber(word)

    if type(numberUserInput) == "number" then
      randomPlaySpeed = numberUserInput
      randomPlaySpeedChangeBoolean = "true"
    else
      invalidInput()
    end
  else
    midiArray = nil
  end

  if invalidInputBoolean == "false" then
    if playlistSongBoolean == "true" or shuffleSongBoolean == "true" or randomSongBoolean == "true" then -- if a song playing mode has been selected, temporarily set midiArray to the first song
      shell.run(midiArrayTitles[1][1])
    elseif playSpeedChangeBoolean == "true" or randomPlaySpeedChangeBoolean == "true" or pageChangeBoolean == "true" then
      midiArray = nil
      playSpeedChangeBoolean = "false"
      randomPlaySpeedChangeBoolean = "false"
      pageChangeBoolean = "false"
    else
      if type(numberUserInput) == "number" then
        if numberUserInput > 0 and numberUserInput < #midiArrayTitles + 1 then
          shell.run(midiArrayTitles[chosenSongNumber][1])
        end
      end
    end
  end
end



function songModeChecking() -- check which kind of song mode to play
  if playlistSongBoolean == "true" then
    if playlistSongNumber == #midiArrayTitles then
      playlistSongNumber = 1
    else
      playlistSongNumber = playlistSongNumber + 1
    end
    shell.run(midiArrayTitles[playlistSongNumber][1])
    page = math.ceil(playlistSongNumber / 10)
  end

  if shuffleSongBoolean == "true" then
    if #shuffleSongs == 0 then
      for i = 1, #midiArrayTitles do
        table.insert(shuffleSongs, i)
      end
    end
    shuffleSongIndex = math.random(1, #shuffleSongs)
    shuffleSongNumber = shuffleSongs[shuffleSongIndex]
    shell.run(midiArrayTitles[shuffleSongNumber][1])
    table.remove(shuffleSongs, shuffleSongIndex)
    page = math.ceil(shuffleSongNumber / 10)
  end

  if randomSongBoolean == "true" then
    randomSongNumber = math.random(1, #midiArrayTitles)
    shell.run(midiArrayTitles[randomSongNumber][1])
    page = math.ceil(randomSongNumber / 10)
  end
end



function drawSongTitles()
  for i = 1, #midiArrayTitles do -- draws the song titles and the current song pointer
    if (i > (page * 10 - 10)) and (i < (page * 10 + 1)) then
      if (i == (page * 10 - 10 + 1)) then
        clearSongLines()
      end

      term.setCursorPos(1, i - (page * 10 - 10) + 5)
      print("           "..i..". "..midiArrayTitles[i][1].." ("..(midiArrayTitles[i][2] / 10).."s)")

      term.setCursorPos(1, i - (page * 10 - 10) + 5)
      if (i == chosenSongNumber) or (i == playlistSongNumber) or (i == shuffleSongNumber) or (i == randomSongNumber) then
        print("         >")
      end
    end
  end
  term.setCursorPos(1, 17)
  write("                        ") -- draws the song titles on the terminal
end



function clearMonitorSongData()
  gen = 0
  for i = 1, w + 1 do
    for j = 1, 25 do
      term.redirect(m)
      m.setCursorPos(i + 3, j)
      write(" ")
      term.restore()
    end
  end
end



function playSongListData() -- plays the song
  clearMonitorSongData()

  for i = 1, #midiArray do -- plays the midiArray table data
    for j = 2, #midiArray[i] do
      bundledColors = 0

      for k = 2, #midiArray[i][j] do
        if midiArray[i][j][k] >= 16 then
          chosenInstrument = midiArray[i][j][1].."2"
          bundledColors = bundledColors + colorList[midiArray[i][j][k] - 16 + 1]
        else
          chosenInstrument = midiArray[i][j][1].."1"
          bundledColors = bundledColors + colorList[midiArray[i][j][k] + 1]
        end

        drawSong(midiArray[i][j][1], midiArray[i][j][k]) -- instrument, pitch
      end
      rednet.broadcast(tostring(chosenInstrument))
      rednet.broadcast(tostring(bundledColors))
    end
    sleep(midiArray[i][1] * 0.1 / playSpeed)

    gen = gen + 1

    if gen == w + 1 then
      gen = 0
      clearMonitorSongData()
    end
  end
end



function playGeneratedSong() -- play a generated song
  randInstrumentLevel = math.random(2)
  randInstrumentType = math.random(5)
  chosenColorA = math.random(16)
  chosenColorB = math.random(9)

  if randInstrumentLevel == 1 then
    chosenInstrument = instrumentList[randInstrumentType].."1"
    rednet.broadcast(chosenInstrument)
    rednet.broadcast(tostring(colorList[chosenColorA]))
  else
    chosenInstrument = instrumentList[randInstrumentType].."2"
    rednet.broadcast(chosenInstrument)
    rednet.broadcast(tostring(colorList[chosenColorB]))
  end

  sleep(math.random(1, 10) * 0.1 / randomPlaySpeed) -- plays random note blocks
end



function playSong() -- playing the songs
  if not rs.getInput(inputSideRandomSong) then -- plays and draws the song
    drawSongTitles()
    playSongListData()
  else -- plays random note blocks
    playGeneratedSong()
  end
end



while true do -- always looping
  term.clear()

  songModeChecking()

  drawSongTitles()

  term.setCursorPos(1, 2)
  word = "Type the song number to play:"
  centerWords()

  term.setCursorPos(1, 3)
  word = tostring("Playlist length: "..(playlistLength / 10).."s")
  centerWords()

  term.setCursorPos(1, 4)
  word = tostring("Page "..page.."/"..math.ceil(#midiArrayTitles / 10))
  centerWords()

  term.setCursorPos(1, 17)
  write("                        ")

  if midiArray == nil then -- makes sure that playSong only gets called when midiArray has data
    if rs.getInput(inputSideRandomSong) then -- if there's an input signal
      parallel.waitForAny(readUserInput, playSong)
    else
      readUserInput()
    end
  else
    parallel.waitForAny(readUserInput, playSong)
  end
end
