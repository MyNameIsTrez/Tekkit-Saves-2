-- Made by MyNameIsTrez in 2019
bundledOutputSide = 'back'

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


function setTwoSegments(left_hex, right_hex)
  local left_decimal = tonumber(left_hex, 16)
  local right_decimal = tonumber(right_hex, 16)
  
  shifted_left_char = bit.blshift(left_decimal, 8)
  combined_chars = shifted_left_char + right_decimal

  rs.setBundledOutput(bundledOutputSide, combined_chars)
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

function enterTwoChars()
  -- ready the terminal
  term.clear()
  term.setCursorPos(1,1)
  
  -- get two chars from the user
  write('Left char: ')
  left_char = read()
  write('Right char: ')
  right_char = read()

  left_hex = getHex(left_char)
  right_hex = getHex(right_char)
  correct_input = left_hex and right_hex

  -- check if the two entered chars are valid
  if (correct_input) then
    print('Success!')
    setTwoSegments(left_hex, right_hex)
  else
    print('You entered an invalid character!')
    sleep(2)
    main()
  end
end

function main()
  enterTwoChars()
end

main()







-- function hexToDecimal(decimal, hex)
--   for key, value in pairs(hex) do
--     decimal[key] = tonumber(value, 16)
--   end
--   return decimal
-- end

-- local decimal = {}
-- hexToDecimal(decimal, hex)

-- function decimalContains(decimals, left_char, right_char)
--   -- whether decimal contains left_char and right_char
--   local contains_left = nil
--   local contains_right = nil

--   -- gets the index of left_char and right_char in decimals
--   for index, subtable in ipairs(decimals) do
--     if subtable[left_char] ~= nil then
--       contains_left = index
--     end
--     if subtable[right_char] ~= nil then
--       contains_right = index
--     end
--   end

--   return contains_left ~= nil and contains_right ~= nil 
-- end

-- function setLeftSegment(left_char)
--   char = bit.blshift(decimal[left_char], 8)
--   rs.setBundledOutput(bundledOutputSide, char)
-- end

-- function scrollAllChars()
--   while true do
--     for key, value in pairs(decimal) do      
--       setLeftSegment(key)
--       sleep(0.5)
--     end
--   end
-- end