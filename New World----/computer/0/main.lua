-- Made by MyNameIsTrez in 2019
bundledOutputSide = 'back'

-- local numbers = '0123456789'
-- local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

local hex = {}
hex['0'] = '3F'
hex['1'] = '06'
hex['2'] = '5B'
hex['3'] = '4F'
hex['4'] = '66'
hex['5'] = '6D'
hex['6'] = '7D'
hex['7'] = '07'
hex['8'] = '7F'
hex['9'] = '6F'
hex['A'] = '77'
hex['B'] = '7C'
hex['C'] = '39'
hex['D'] = '5E'
hex['E'] = '79'
hex['F'] = '71'
hex['G'] = '3D'
hex['H'] = '76'
hex['I'] = '30'
hex['J'] = '1E'
hex['K'] = '75'
hex['L'] = '38'
hex['M'] = '37'
hex['N'] = '54'
hex['O'] = '3F'
hex['P'] = '73'
hex['Q'] = '67'
hex['R'] = '50'
hex['S'] = '6D'
hex['T'] = '78'
hex['U'] = '3E'
hex['V'] = '1C'
hex['W'] = '2A'
hex['X'] = '76'
hex['Y'] = '6E'
hex['Z'] = '5B'

function hexToDecimal(decimal, hex)
  for key, value in pairs(hex) do
    decimal[key] = tonumber(value, 16)
  end
  return decimal
end

local decimal = {}
hexToDecimal(decimal, hex)

function decimalContains(decimal, key)
  return decimal[key] ~= nil
end

function setTwoSegments(left_char, right_char)
  shifted_1st_char = bit.blshift(decimal[left_char], 8)
  final_2_chars = shifted_1st_char + decimal[right_char]
  rs.setBundledOutput(bundledOutputSide, final_2_chars)
end

function enterTwoChars()
  term.clear()
  term.setCursorPos(1,1)
  write('Left char: ')
  left_char = read()
  write('Right char: ')
  right_char = read()

  if (decimalContains(decimal, left_char) and decimalContains(decimal, right_char)) then
    setTwoSegments(left_char, right_char)
  else
    print('You entered an invalid character!')
    sleep(2)
    main()
  end
end

function setLeftSegment(left_char)
  char = bit.blshift(decimal[left_char], 8)
  rs.setBundledOutput(bundledOutputSide, char)
end

function scrollAllChars()
  while true do
    for key, value in pairs(decimal) do      
      setLeftSegment(key)
      sleep(0.5)
    end
  end
end

function main()
  -- enterTwoChars()
  scrollAllChars()
end

main()