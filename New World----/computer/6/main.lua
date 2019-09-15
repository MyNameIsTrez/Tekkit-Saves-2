-- Item counter code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

local modem_side = "right"
local bundled_input_side = "back"
local measuring_seconds = 60 -- in seconds
local update_delay = 1 -- in seconds

local stats = {
  "DIAMONDS",
  "GOLD",
  "IRON"
}

rednet.open(modem_side)

function clearTerminal()
  term.clear()
  term.setCursorPos(1,1)
end

function round(n, decimals)
  local m = math.pow(10, decimals)
  return math.floor(n * m) / m
end

function main()
  while true do
    local start_time = os.time()
    local difference = 0 -- Temporary assignment.

    local binary_table = {}
    for i = 1, 16 do
      table.insert(binary_table, 0)
    end

    local measuring = measuring_seconds / 50
    while difference < measuring do
      local timer = os.startTimer(1)

      local state = rs.getBundledInput(bundled_input_side, decimal)
      new_binary_table = bit.tobits(state)
      for i, value in ipairs(new_binary_table) do
        binary_table[i] = binary_table[i] + value
      end

      -- Sleep for one tick, so difference is always > 0.
      -- This also means the program doesn't get a "Too long without yielding" error.
      sleep(0)

      local end_time = os.time()
      difference = end_time - start_time
      if (difference < 0) then
        difference = difference + 24
      end

      clearTerminal()
      for i = 1, #stats do
        local n = binary_table[i] / (difference * 50)
        print(stats[i].." "..round(n, 2))
      end
      
      -- Prevents breaking out of the loop when the computer receives rednet_message.
      while true do
        local event,p1,p2,p3 = os.pullEvent()
        if (event == "redstone" or event == "timer") then
          break
        end
      end
    end
  end
end

main()








































-- function userEnterChars()
--   clearTerminal()
  
--   -- get chars from the user and check if they're valid chars
--   local entered_chars_hex = {}
--   local all_entered_chars_correct = true

--   write("Character "..i..": ")
--   local char = read()
--   local hex_16 = getHex(char)
--   entered_chars_hex[i] = hex_16
--   all_entered_chars_correct = all_entered_chars_correct and hex_16

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

-- -- variant of the modulo operator, so it can't output 0
-- function moduloWithoutZero(n, mod)
--   return (n - 1) % mod + 1
-- end

-- function scrollAllChars()
--   while true do
--     -- loops for each char
--     for i = 1, #hex_16 do
--       -- gets a hex_16 char based on the looped char and segment
--       local k = i
--       local l = moduloWithoutZero(k, #hex_16)
--       -- tells a segment which char to display
--       setSegment(hex_16[l])
--       clearTerminal()
--       print("Character: "..string.sub(chars, i, i))
--       -- sleep before shifting all chars on the displays
--       sleep(1)
--     end
--   end
-- end