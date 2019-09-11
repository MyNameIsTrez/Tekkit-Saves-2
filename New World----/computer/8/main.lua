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

-- for i = 1, 2 do
--   t:mForward(4)
--   t:zigZag(16)
--   t:mForward(7)
--   t:zigZag(16)
--   t:mForward(3)
--   t:tRight()
  
--   t:mForward(4)
--   t:zigZag(24)
--   t:mForward(7)
--   t:zigZag(24)
--   t:mForward(3)
--   t:tRight()
-- end

-- t:mRight()
-- t:mForward(2)
-- t:mLeft()
-- t:mForward(22)
-- t:mRight()

-- t:zigZag(24)
-- t:mForward(4)
-- t:mRight()
-- t:mForward(3)

-- t:zigZag(16)
-- t:tLeft() -- this can be done with t:tLeft(2) later
-- t:tLeft()
-- t:mForward(16)

-- t:mForward(5)
-- t:mRight()
-- t:mForward(2)

-- t:zigZag(24)
-- t:tLeft() -- this can be done with t:tLeft(2) later
-- t:tLeft()
-- t:mForward(24)

-- t:mForward(5)
-- t:mRight()
-- t:mForward(2)
-- t:zigZag(16)