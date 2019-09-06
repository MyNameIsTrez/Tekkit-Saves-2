-- Made by MyNameIsTrez in 2019
local bundledOutputSides = { 'back', 'right', 'left', 'bottom', 'top', 'front' } 
local segment_count = 2

local hex = {}
hex[1] = '3F'
hex[2] = '06'
hex[3] = '5B'
hex[4] = '4F'
hex[5] = '66'
hex[6] = '6D'
hex[7] = '7D'
hex[8] = '07'
hex[9] = '7F'
hex[10] = '6F'
hex[11] = '77'
hex[12] = '7C'
hex[13] = '39'
hex[14] = '5E'
hex[15] = '79'
hex[16] = '71'
hex[17] = '3D'
hex[18] = '76'
hex[19] = '30'
hex[20] = '1E'
hex[21] = '75'
hex[22] = '38'
hex[23] = '37'
hex[24] = '54'
hex[25] = '3F'
hex[26] = '73'
hex[27] = '67'
hex[28] = '50'
hex[29] = '6D'
hex[30] = '78'
hex[31] = '3E'
hex[32] = '1C'
hex[33] = '2A'
hex[34] = '76'
hex[35] = '6E'
hex[36] = '5B'

local chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

function setSegment(segment_index, hex)
  local decimal = tonumber(hex, 16)
  rs.setBundledOutput(bundledOutputSides[segment_index], decimal)
end

function getHex(char)
  _hex = nil
  -- check if the char is in chars and get the hex
  for i = 1, #chars do
    if string.sub(chars, i, i) == char then
      _hex = hex[i]
    end
  end
  -- return the hex
  return _hex
end

function userEnterChars()
  -- ready the terminal
  term.clear()
  term.setCursorPos(1,1)
  
  -- get chars from the user and check if they're valid chars
  local entered_chars_hex = {}
  local all_entered_chars_correct = true
  for i = 1, segment_count do
    write('Char '..i..': ')
    local char = read()
    local hex = getHex(char)
    entered_chars_hex[i] = hex
    all_entered_chars_correct = all_entered_chars_correct and hex
  end

  -- set the segments if the entered chars are valid
  if (all_entered_chars_correct) then
    print('Success!')
    for i = 1, #entered_chars_hex do
      setSegment(i, entered_chars_hex[i])
    end
  else
    print('One or multiple of the entered character(s) is invalid, try again!')
    sleep(4)
    main()
  end
end

function scrollAllChars()
  while true do
    -- loops for each char
    for i = 1, #hex do
      -- loops for each segment
      for segment_index = 1, segment_count do
        -- gets a hex char based on the looped char and segment
        local k = i + segment_index - 1
        local l = (k - 1) % #hex + 1
        -- tells a segment which char to display
        setSegment(segment_index, hex[l])
      end
      -- sleep before shifting all chars on the displays
      sleep(1)
    end
  end
end

function main()
  -- userEnterChars()
  scrollAllChars()
end

main()





-- function setTwoSegments(left_hex, right_hex)
--   local left_decimal = tonumber(left_hex, 16)
--   local right_decimal = tonumber(right_hex, 16)
  
--   shifted_left_char = bit.blshift(left_decimal, 8)
--   combined_chars = shifted_left_char + right_decimal

--   rs.setBundledOutput(bundledOutputSide, combined_chars)
-- end