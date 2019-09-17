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

local p = {
  {
    x = 1,
    y = 1
  },
  {
    x = w-1,
    y = h-1
  }
}

function main()
  clear()
  shape.rectangle(p[1], p[2])
end
main()