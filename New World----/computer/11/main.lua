-- Made by MyNameIsTrez

function loadAPIs()
  -- a table of the IDs and names of the APIs to load
  local APIs = {
    {id = "NqnSq1wK", name = "turtle_functions"}
  }

  for i = 1, #APIs do
    -- delete the old APIs, to make room for the more up-to-date versions
    -- returns no error if the program has already been deleted
    fs.delete(APIs[i].name)

    shell.run("pastebin", "get", APIs[i].id, APIs[i].name)
    os.loadAPI(APIs[i].name)
  end
end
loadAPIs() -- run the above code automatically

local t = turtle_functions.t:new("explorer", {1, 2})

function t:straightZigZag(n)
  for i = 1, n/2 do
    t:placeDown()
    t:mRight()
    t:placeDown()
    t:mLeft()
    t:placeDown()
    t:mLeft()
    t:placeDown()
    t:mRight()
  end
end

function t:diagonalZigZag(direction)
  if (direction == "right") then
  	for i = 1, 12 do
	  t:mForward(1)
	  t:placeDown()
	  t:mForward(1)
	  t:placeDown()
	  
	  t:mRight()
	  t:tLeft()
	  t:placeDown()
    end
  elseif (direction == "left") then
  	for i = 1, 12 do
	  t:mForward(1)
	  t:placeDown()
	  t:mForward(1)
	  t:placeDown()
	  
	  t:mLeft()
	  t:tRight()
	  t:placeDown()
    end
  else
	error("You entered a wrong direction for diagonalZigZag()")
  end
end

-- builds the edge segments a, b, c, d, e, f, g, h
function buildEdgeSegments()
  for i = 1, 2 do
    t:mForward(4)
    t:straightZigZag(16)
    t:mForward(7)
    t:straightZigZag(16)
    t:mForward(3)
    t:tRight()
    
    t:mForward(4)
    t:straightZigZag(24)
    t:mForward(7)
    t:straightZigZag(24)
    t:mForward(3)
    t:tRight()
  end
end

-- move back to the middle of the display
function moveToMiddle(n)
  t:tLeft() -- this can be done with t:tLeft(2) later
  t:tLeft()
  t:mForward(n)
end

-- builds the vertical and horizontal segments j, p, n, l
function buildVerHorSegments()
  -- move to segment j
  t:mRight()
  t:mForward(2)
  t:mLeft()
  t:mForward(22)
  t:mRight()
  -- build segment j
  t:straightZigZag(24)

  -- move to segment p
  t:mForward(4)
  t:mRight()
  t:mForward(3)
  -- build segment p
  t:straightZigZag(16)

  moveToMiddle(16)

  -- move to segment n
  t:mForward(5)
  t:mRight()
  t:mForward(2)
  -- build segment n
  t:straightZigZag(24)

  moveToMiddle(24)

  -- move to segment l
  t:mForward(5)
  t:mRight()
  t:mForward(2)
  -- build segment l
  t:straightZigZag(16)
end

function buildDiagonalSegment(direction)
  if (direction == "right") then
    t:diagonalZigZag("right")
  
    -- move back to the middle
    t:mForward(1)
    t:tLeft() -- this can be done with tLeft(2)
    t:tLeft()
    t:diagonalZigZag("right")
  elseif (direction == "left") then
    t:diagonalZigZag("left")
  
    -- move back to the middle
    t:mForward(1)
    t:tRight() -- this can be done with tLeft(2)
    t:tRight()
    t:diagonalZigZag("left")
  else
    error("You entered a wrong direction for buildDiagonalSegment()")
  end
end

function buildDiagonalSegments()
  moveToMiddle(16)

  -- move to segment k
  t:mRight()
  t:mForward(1)
  t:mRight()
  t:tLeft()

  -- build segment k
  buildDiagonalSegment("right")

  -- move to segment i
  t:mForward(1)
  t:tRight()
  t:mForward(10)
  t:tRight()

  -- build segment i
  buildDiagonalSegment("left")

  -- move to segment o
  t:mForward(7)

  -- build segment o
  buildDiagonalSegment("right")

  -- move to segment m
  t:mForward(1)
  t:tRight()
  t:mForward(10)
  t:tRight()

  -- build segment m
  buildDiagonalSegment("left")
end

function buildRestocker()  
  -- place the 2 iron blocks on the sides of the turtle
  turtle.select(1) -- this should be any available slot
  t:tRight()
  t:place()
  t:tLeft() -- this should be t:tLeft(2)
  t:tLeft()
  t:place()

  -- place the 2 timers
  turtle.select(9) -- this should be t:select(n), and the selected slot should be saved to the turtle
  turtle.up() -- make this t:up(n)
  t:place()
  t:tRight()
  t:tRight()
  t:place()

  -- make the turtle face the original direction again
  t:tLeft()

  -- place the ender chest
  turtle.select(8)
  turtle.placeUp()

  -- place the filter
  turtle.select(7)
  turtle.down()
  turtle.placeUp()
end

function dismantleRestocker()
  -- remove the filter
  turtle.select(7)
  turtle.digUp()

  -- remove the ender chest
  turtle.up()
  turtle.select(8)
  turtle.digUp()

  -- remove the 2 timers
  t:tRight()
  t:dig()
  t:tLeft()
  t:tLeft()
  t:dig()

  -- remove the 2 iron blocks
  turtle.select(1)
  turtle.down()
  t:dig()
  t:tRight()
  t:tRight()
  t:dig()

  -- make the turtle face the original direction again
  t:tLeft()
end

function restock()
  local iron_blocks = 0
  
  -- item slots 1 to 5 are for iron blocks. 6 * 64 = 384 iron blocks max
  -- item slot 9 is for 2 timers, item slot 8 is for an ender chest,
  -- item slot 7 is for a filter
  for i = 1, 6 do
    iron_blocks = iron_blocks + turtle.getItemCount(i)
  end

  -- if (iron_blocks < 48) then
    print("Building the restocker...")
    buildRestocker()

    print("Restocking...")
    sleep(13) -- refill for at least 2.1s * 6 stacks = 12.6 seconds

    print("Dismantling the restocker...")
    dismantleRestocker()
  -- end
end

function getElapsedTime(startTime)
  local endTime = os.time()
  -- 1 from os.time() equals 50 seconds IRL
  local elapsedTime = (endTime - startTime) * 50

  local minutes = math.floor(elapsedTime / 60)
  local seconds = math.floor(elapsedTime % 60)
  return minutes.." min, "..seconds.." sec."
end

function build()
  -- clear the terminal of text and reset the cursor position
  term.clear()
  term.setCursorPos(1,1)

  local startTime = os.time()
  restock()
  print("Done! Elapsed time: "..getElapsedTime(startTime))

  print("Building the edge segments...")
  local startTime = os.time()
  buildEdgeSegments()
  print("Done! Elapsed time: "..getElapsedTime(startTime))

  local startTime = os.time()
  restock()
  print("Done! Elapsed time: "..getElapsedTime(startTime))

  print("Building the vertical and horizontal segments...")
  local startTime = os.time()
  buildVerHorSegments()
  print("Done! Elapsed time: "..getElapsedTime(startTime))

  local startTime = os.time()
  restock()
  print("Done! Elapsed time: "..getElapsedTime(startTime))

  print("Building the diagonal segments...")
  local startTime = os.time()
  buildDiagonalSegments()
  print("Done! Elapsed time: "..getElapsedTime(startTime))

  print("Finished building the display!")
end
build()