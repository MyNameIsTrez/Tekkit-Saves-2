function loadAPIs()
  -- Makes a table of the IDs and names of the APIs to load.
  local APIs = {
    {id = "TEAvD8FL", name = "discord"},
    {id = "c4BgMWbg", name = "temperature"},
    {id = "4nRg9CHU", name = "json"}
  }

  for i = 1, #APIs do
    -- Delete the old APIs to make room for
    -- a potential more up-to-date version on Pastebin.
    
    -- This returns no error if this API doesn't exist on the computer yet.
    fs.delete(APIs[i].name)

    shell.run("pastebin", "get", APIs[i].id, APIs[i].name)
    os.loadAPI(APIs[i].name)
  end
end
loadAPIs()

term.clear()
term.setCursorPos(1, 1)
-- print('The current temperature in Amsterdam is '..temperature.getTemperature()..' degrees.')
discord.sendMessage("hello, this is a test message!")