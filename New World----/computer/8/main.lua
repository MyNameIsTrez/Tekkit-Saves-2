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
    t:zigZag(16)
    t:mForward(7)
    t:zigZag(16)
    t:mForward(3)
    t:tRight()
    
    t:mForward(4)
    t:zigZag(24)
    t:mForward(7)
    t:zigZag(24)
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
  t:zigZag(24)

  -- move to segment p
  t:mForward(4)
  t:mRight()
  t:mForward(3)
  -- build segment p
  t:zigZag(16)

  moveToMiddle(16)

  -- move to segment n
  t:mForward(5)
  t:mRight()
  t:mForward(2)
  -- build segment n
  t:zigZag(24)

  moveToMiddle(24)

  -- move to segment l
  t:mForward(5)
  t:mRight()
  t:mForward(2)
  -- build segment l
  t:zigZag(16)
end

function buildDiagonalSegments()
  moveToMiddle(16)
end

function build()
  -- clear the terminal of text and reset the cursor position
  term.clear()
  term.setCursorPos(1,1)

  local startTime = os.time()
  -- print("Building the edge segments...")
  -- buildEdgeSegments()
  -- print("Building the vertical and horizontal segments...")
  -- buildVerHorSegments()
  print("Building the diagonal segments...")
  buildDiagonalSegments()

  local endTime = os.time()
  -- 1 in os.time() equals 50 seconds
  local elapsedTime = (endTime - startTime) * 50
  print("Done! Time elapsed: "..elapsedTime.." seconds.")
end
build()