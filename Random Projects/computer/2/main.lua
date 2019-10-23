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

local tt = turtle_functions.tt:new("explorer", {1, 2})

for i = 1, 20 do
  tt:right()
  tt:forward()
  tt:left()
  tt:place()
  tt:print_own_data()
end

for i = 1, 20 do
  tt:dig()
  tt:left()
  tt:forward()
  tt:right()
  tt:print_own_data()
end

-- for key, nickname in pairs(Diva.nicknames) do
--   print(key .. ": " .. nickname)
-- end