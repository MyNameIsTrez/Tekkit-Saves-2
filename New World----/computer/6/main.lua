-- Item counter code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

local modem_side = "right"
local bundled_input_side = "back"
local measuring_limit = 60 -- How many updates are measured before the last ones are deleted.
local update_delay = 1 -- How often the measurements update in seconds.

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

function getFullBinary(full_binary, positive_binaries)
  for i = 1, #stats do
    if (positive_binaries[i] == 1) then
      table.insert(full_binary, 1)
    else
      table.insert(full_binary, 0)
    end
  end
  return full_binary
end

function getFullDecimal(full_decimal, full_binary)
  for i = 1, #stats do
    if (full_decimal[i] == nil) then
      full_decimal[i] = full_binary[i]
    else
      full_decimal[i] = full_decimal[i] + full_binary[i]
    end
  end
  return full_decimal
end

function pushToFinalBinary(final_binary, full_decimal)
  -- Add full_decimal to the beginning.
  for i, value in ipairs(full_decimal) do
    table.insert(final_binary[i], 1, value)
    -- If the table is longer than measuring_limit, remove the last element.
    if (#final_binary[i] > measuring_limit) then
      table.remove(final_binary[i])
    end
  end
  return final_binary
end

function main()
  local full_decimal = {}
  local final_binary = {}
  for i = 1, #stats do
    table.insert(final_binary, {})
  end
  local update_timer = os.startTimer(update_delay)
  -- Because the "redstone" event gets called when a redstone line turns on or off,
  -- we have the redstone_on variable to make sure we only activate the redstone code
  -- once every two times the "redstone" event gets recognized.
  local redstone_on = true

  -- Prevents breaking out of the loop when the computer receives rednet_message.
  while true do
    local event,p1,p2,p3 = os.pullEvent()
    if (event == "redstone") then
      if (redstone_on) then
        local state = rs.getBundledInput(bundled_input_side, decimal)
        -- Get all the binary numbers that are positive in a table.
        local positive_binaries = bit.tobits(state)
    
        -- Create a full table of 0's and the 1's from positive_binaries.
        local full_binary = {}
        full_binary = getFullBinary(full_binary, positive_binaries)

        full_decimal = getFullDecimal(full_decimal, full_binary)
      end
      redstone_on = not redstone_on
    elseif (event == "timer") then
      local update_timer = os.startTimer(update_delay)
  
      -- Add full_decimal to the final binary.
      -- If full_decimal is empty, fill it with zeros first.
      local empty = full_decimal[1] == nil
      if (empty) then
        for i = 1, #stats do
          full_decimal[i] = 0
        end
      end
      final_binary = pushToFinalBinary(final_binary, full_decimal)
      full_decimal = {}
  
      clearTerminal()
      local n = #final_binary[1] / measuring_limit * 100
      print("CALIBRATED "..round(n, 2).."%\n")
      for i = 1, #final_binary do
        local total = 0
        for j = 1, #final_binary[i] do
          total = total + final_binary[i][j]
        end
        print(stats[i].." "..total.."/MIN")
      end
    end
  end
end

main()