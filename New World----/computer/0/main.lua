-- Made by MyNameIsTrez in 2019
bundledOutputSide = 'back'

local binary = {}
binary['0'] = 63
binary['1'] = 6
binary['2'] = 91
binary['3'] = 79
binary['4'] = 102
binary['5'] = 109
binary['6'] = 125
binary['7'] = 7
binary['8'] = 127
binary['9'] = 111
binary['a'] = 119
binary['b'] = 124
binary['c'] = 57
binary['d'] = 94
binary['e'] = 121
binary['f'] = 113

function binaryContains(key)
  return binary[key] ~= nil
end

function main()
  term.clear()
  term.setCursorPos(1,1)
  write('Left char: ')
  left_char = read()
  write('Right char: ')
  right_char = read()

  if (binaryContains(left_char) and binaryContains(right_char)) then
    shifted_1st_char = bit.blshift(binary[left_char], 8)
    final_2_chars = shifted_1st_char + binary[right_char]

    rs.setBundledOutput(bundledOutputSide, final_2_chars)
  else
    print('You entered an invalid character!')
    sleep(3)
    main()
  end
end

main()