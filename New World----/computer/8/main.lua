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
  print(1)
  turtle.select(7)
  print(2)
  turtle.digUp()
  print(3)

  -- remove the ender chest
  print(4)
  turtle.up()
  print(5)
  turtle.select(8)
  print(6)
  turtle.digUp()
  print(7)

  -- remove the 2 timers
  print(8)
  t:tRight()
  print(9)
  t:dig()
  print(10)
  t:tLeft()
  print(11)
  t:tLeft()
  print(12)
  t:dig()
  print(13)

  -- remove the 2 iron blocks
  print(14)
  turtle.down()
  print(15)
  t:dig()
  print(16)
  t:tRight()
  print(17)
  t:tRight()
  print(18)
  t:dig()
  print(19)

  -- make the turtle face the original direction again
  t:tLeft()
  print(20)
end

function restock()
  local iron_blocks = 0
  
  -- item slots 1 to 5 are for iron blocks. 6 * 64 = 384 iron blocks max
  -- item slot 9 is for 2 timers, item slot 8 is for an ender chest,
  -- item slot 7 is for a filter
  for i = 1, 6 do
    iron_blocks = iron_blocks + turtle.getItemCount(i)
  end

  print("Number of iron blocks: "..iron_blocks)
  -- if (iron_blocks < 48) then
    print("Building the restocker...")
    -- buildRestocker()

    print("Restocking...")
    -- sleep(13) -- refill for at least 2*6 = 12 seconds

    print("Dismantling the restocker...")
    dismantleRestocker()
  -- end
end

function build()
  -- clear the terminal of text and reset the cursor position
  term.clear()
  term.setCursorPos(1,1)

  local startTime = os.time()
  -- print("Building the edge segments...")
  -- buildEdgeSegments()
  restock()
  -- print("Building the vertical and horizontal segments...")
  -- buildVerHorSegments()
  -- restock()
  -- print("Building the diagonal segments...")
  -- buildDiagonalSegments()
  -- restock()

  local endTime = os.time()
  -- 1 in os.time() equals 50 seconds
  local elapsedTime = (endTime - startTime) * 50
  local minutes = math.floor(elapsedTime / 60)
  local seconds = elapsedTime % 60
  print("Done! Elapsed time: \n"..minutes.." minutes and "..seconds.." seconds.")
end
build()