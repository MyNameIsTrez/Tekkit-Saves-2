-- Physics simulation code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

-- The default terminal ratio is 25:9, with the standard being 50:18.

-- To get the terminal to fill the entire screen, use these widths and heights:
-- 426:153 on a 31.5" monitor in windowed mode.
-- 426:160 on a 31.5" monitor in fullscreen mode.
-- 227:78 on the laptop in windowed mode.
-- 227:85 on the laptop in fullscreen mode.

function loadAPIs()
  -- Makes a table of the IDs and names of the APIs to load.
  local APIs = {
    {id = "drESpUSP", name = "shape"}
  }

  for i = 1, #APIs do
    -- Delete the old APIs, to make room for the more up-to-date online version.
    -- This returns no error if the program doesn't exist on the computer.
    fs.delete(APIs[i].name)

    shell.run("pastebin", "get", APIs[i].id, APIs[i].name)
    os.loadAPI(APIs[i].name)
  end
end
loadAPIs()

local w, h = term.getSize()

function clear()
  term.clear()
  term.setCursorPos(1,1)
end

local corners = {
  {
    x = 1,
    y = 1
  },
  {
    x = w-1,
    y = h-1
  }
}

local entities = {
  {
    x = w/2,
    y = h/2
  }
}

function entities:move(i, x_diff, y_diff)
  local e = entities[i]
  local not_touching_wall = true
  if (not_touching_wall) then
    shape.point(e, false)
    e.x = e.x + x_diff
    e.y = e.y + y_diff
    shape.point(e)
  end
end

function main()
  shape.point(entities[1])
  while true do
    clear()
    shape.rectangle(corners[1], corners[2])
    entities:move(1, 1, 1)
    sleep(1)
  end
end
main()