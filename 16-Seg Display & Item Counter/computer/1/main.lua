-- 16-segment display master controller code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

-- local text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local displays = 4
local offset_ID = 1
local modem_side = "back"
local sleep_time = 0.5

rednet.open(modem_side)

function loadAPIs()
  -- Makes a table of the IDs and names of the APIs to load.
  local APIs = {
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

local text = 'TEMP '..temperature.getTemperature()

function getOffsetText(text, offset)
  start_spaces_count = displays - offset
  end_spaces_count = offset - #text

  -- Remove the last letters in the text, according to the offset.
  -- string.sub() returns the text in the range of 1 and the offset!
  local output = string.sub(text, 1, offset)

  -- Only remove the first letters in the text, if letters are off-screen on the left.
  local a = -1 * (displays - 1) + offset
  if (a > -1) then -- Not sure if this check is necessary.
    output = string.sub(output, a, a + displays - 1)
  end

  -- Add spaces to the start of the text.
  for i = 1, start_spaces_count do
    output = " "..output
  end

  -- Add spaces to the end of the text.
  for i = 1, end_spaces_count do
    output = output.." "
  end

  return output
end

function main()
  print("Text: "..text)
  while true do
    local offsets = #text + displays - 1
    for offset = 0, offsets do
      offset_text = getOffsetText(text, offset)
      print("Displaying: '"..offset_text.."'")
      for displayID = 1, displays do
        local receiverID = displayID + offset_ID
        local char = string.sub(offset_text, displayID, displayID)
        rednet.broadcast(receiverID.."_"..char)
      end
      sleep(sleep_time)
    end
  end
end

main()
































































-- function userEnterChars()
--   clearTerminal()
  
--   -- get chars from the user and check if they're valid chars
--   local entered_chars_hex = {}
--   local all_entered_chars_correct = true
--   for i = 1, display_count do
--     write("Character "..i..": ")
--     local char = read()
--     local hex_16 = getHex(char)
--     entered_chars_hex[i] = hex_16
--     all_entered_chars_correct = all_entered_chars_correct and hex_16
--   end

--   -- set the segments if the entered chars are valid
--   if (all_entered_chars_correct) then
--     print("Success!")
--     for i = 1, #entered_chars_hex do
--       setSegment(i, entered_chars_hex[i])
--     end
--   else
--     print("One or multiple of the entered character(s) is invalid, try again!")
--     sleep(4)
--     main()
--   end
-- end

-- function scrollAllChars()
--   while true do
--     -- loops for each char
--     for i = 1, #hex_16 do
--       -- loops for each segment
--       for segment_index = 1, display_count do
--         -- gets a hex_16 char based on the looped char and segment
--         local k = i + segment_index - 1
--         local l = moduloWithoutZero(k, #hex_16)
--         -- tells a segment which char to display
--         setSegment(segment_index, hex_16[l])
--         clearTerminal()
--         print("Character: "..string.sub(chars, i, i))
--       end
--       -- sleep before shifting all chars on the displays
--       sleep(1)
--     end
--   end
-- end

-- function setSegment(segment_index, hex_16)
--   local decimal = tonumber(hex_16, 16)
--   rs.setBundledOutput(bundledOutputSides[segment_index], decimal)
-- end

-- function getHex(char)
--   _hex = nil
--   -- check if the char is in chars and get the hex_16
--   for i = 1, #chars do
--     if string.sub(chars, i, i) == char then
--       _hex = hex_16[i]
--     end
--   end
--   -- return the hex_16
--   return _hex
-- end

-- function clearTerminal()
--   term.clear()
--   term.setCursorPos(1,1)
-- end

-- -- variant of the modulo operator, so it can't output 0
-- function moduloWithoutZero(n, mod)
--   return (n - 1) % mod + 1
-- end
