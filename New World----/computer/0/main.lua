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

function scrollAllChars()
  while true do
    -- loops for each char
    for i = 1, #hex do
      -- loops for each segment
      for segment_index = 1, segment_count do
        -- gets a hex char based on the looped char and segment
        local k = i + segment_index - 1
        local l = k % (#hex + 1)
        if (l == 0) then -- dit is een slechte oplossing, want ik zie op de map een 0 en 2 gedisplayed
          l = 1
        end
        -- tells a segment which char to display
        print('l: '..l)
        print('hex: '..hex[l])
        setSegment(segment_index, hex[l])
      end
      print('-----------------')
      -- sleep before shifting all the chars
      sleep(0.5)
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

-- function userEnterChars()
--   -- ready the terminal
--   term.clear()
--   term.setCursorPos(1,1)
  
--   -- get two chars from the user
--   write('Left char: ')
--   left_char = read()
--   write('Right char: ')
--   right_char = read()

--   left_hex = getHex(left_char)
--   right_hex = getHex(right_char)
--   correct_inputs = left_hex and right_hex

--   -- check if the two entered chars are valid
--   if (correct_inputs) then
--     print('Success!')
--     setTwoSegments(left_hex, right_hex)
--   else
--     if (left_hex == nil) then
--       print('The first character was invalid, try again!')
--     end
--     if (right_hex == nil) then
--       print('The second character was invalid, try again!')
--     end
--     sleep(2)
--     main()
--   end
-- end