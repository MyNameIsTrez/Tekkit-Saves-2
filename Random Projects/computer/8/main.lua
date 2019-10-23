-- +-----------------------+
-- | Made by MyNameIsTrez. +---------------------------------------+
-- | Use 'pastebin get RQ9Ri8FN startup' to download this program. +---------------------------------------------------------+
-- | 1. Place a modem on top of the computer by crouching, this can be changed to any side by changing 'rednet.open("top")'. |
-- | 2. You can change the time it takes for an error to disappear by modifying 'sleepTime = 1'. +---------------------------+
-- +---------------------------------------------------------------------------------------------+

local alertTime = 1

function loadAPIs()
  -- Makes a table of the IDs and names of the APIs to load.
  local APIs = {
    {id = "U0dsahkX", name = "detectDevice"}
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

rednet.open(detectDevice.detectDevice('modem'))

function main()
 while true do
  term.setCursorPos(1,1)
  term.clear()
  
  write("Enter an item to request: ")
  rednet.broadcast(read())
  
  write("Enter the amount of stacks to request: ")
  stacks = read()
  stacksCheck()
  rednet.broadcast(stacks)
  
  senderId, message, protocol = rednet.receive(0)
  
  if message == "working" then
   message = 0
   while message ~= "restart" do
    senderId, message, protocol = rednet.receive()
    if type(tonumber(message)) == "number" then
     step = message
     calculateTimeLeft()
    else
     main()
    end
   end
  end
  write("You didn't enter a valid item name.")
  sleep(alertTime)
 end
end

function stacksCheck()
 stacks = tonumber(stacks)
 if type(stacks) == "number" then
  stacks = tostring(stacks)
 else
  write("You didn't enter the number of stacks.")
  rednet.broadcast("0")
  sleep(alertTime)
  main()
 end
end

function calculateTimeLeft()
 stacks = tonumber(stacks)
 timeLeft = math.ceil((stacks / 10 - step / 10) * 4.5)
 term.setCursorPos(1,3)
 write("Time left: "..timeLeft.." seconds  ")
end

main()