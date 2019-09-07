-- 16-segment display code for Tekkit Classic
-- made by MyNameIsTrez in 2019
local bundledOutputSides = { 'back', 'right', 'left', 'bottom', 'top', 'front' } 
local display_count = 1
-- local segments = 16
local hex_16 = {}

-- 16-segment 0 to 9
hex_16[1] = '44FF'
hex_16[2] = '040C'
hex_16[3] = '8877'
hex_16[4] = '083F'
hex_16[5] = '888C'
hex_16[6] = '90B3'
hex_16[7] = '88FB'
hex_16[8] = '000F'
hex_16[9] = '88FF'
hex_16[10] = '88BF'

-- 16-segment A to Z
hex_16[11] = '88CF'
hex_16[12] = '2A3F'
hex_16[13] = '00F3'
hex_16[14] = '223F'
hex_16[15] = '80F3'
hex_16[16] = '80C3'
hex_16[17] = '08FB'
hex_16[18] = '88CC'
hex_16[19] = '2233'
hex_16[20] = '007C'
hex_16[21] = '94C0'
hex_16[22] = '00F0'
hex_16[23] = '05CC'
hex_16[24] = '11CC'
hex_16[25] = '00FF'
hex_16[26] = '88C7'
hex_16[27] = '10FF'
hex_16[28] = '98C7'
hex_16[29] = '88BB'
hex_16[30] = '2203'
hex_16[31] = '00FC'
hex_16[32] = '44C0'
hex_16[33] = '50CC'
hex_16[34] = '5500'
hex_16[35] = '88BC'
hex_16[36] = '4433'

local chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

function setSegment(segment_index, hex_16)
  local decimal = tonumber(hex_16, 16)
  rs.setBundledOutput(bundledOutputSides[segment_index], decimal)
end

function getHex(char)
  _hex = nil
  -- check if the char is in chars and get the hex_16
  for i = 1, #chars do
    if string.sub(chars, i, i) == char then
      _hex = hex_16[i]
    end
  end
  -- return the hex_16
  return _hex
end

function clearTerminal()
  term.clear()
  term.setCursorPos(1,1)
end

function userEnterChars()
  clearTerminal()
  
  -- get chars from the user and check if they're valid chars
  local entered_chars_hex = {}
  local all_entered_chars_correct = true
  for i = 1, display_count do
    write('Character '..i..': ')
    local char = read()
    local hex_16 = getHex(char)
    entered_chars_hex[i] = hex_16
    all_entered_chars_correct = all_entered_chars_correct and hex_16
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

-- variant of the modulo operator, so it can't output 0
function moduloWithoutZero(n, mod)
  return (n - 1) % mod + 1
end

function scrollAllChars()
  while true do
    -- loops for each char
    for i = 1, #hex_16 do
      -- loops for each segment
      for segment_index = 1, display_count do
        -- gets a hex_16 char based on the looped char and segment
        local k = i + segment_index - 1
        local l = moduloWithoutZero(k, #hex_16)
        -- tells a segment which char to display
        setSegment(segment_index, hex_16[l])
        clearTerminal()
        print('Character: '..string.sub(chars, i, i))
      end
      -- sleep before shifting all chars on the displays
      sleep(1)
    end
  end
end

function main()
  userEnterChars()
  -- scrollAllChars()
end

main()