-- Physics simulation code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

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

function entities:move(x_diff, y_diff)
  self.x = self.x + x_diff
  self.y = self.y + y_diff
end

function main()
  clear()
  shape.rectangle(corners[1], corners[2])
  shape.point(entities[1])
  sleep(1)
  entities[1].move(1, 1)
  sleep(1)
  entities[1].move(1, 1)
  sleep(1)
  entities[1].move(1, 1)
end
main()