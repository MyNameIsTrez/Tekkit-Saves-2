-- Shape drawer code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

local w, h = term.getSize()

function clearTerminal()
  term.clear()
  term.setCursorPos(1,1)
end

function main()
  clearTerminal()
  local circle = 2 * math.pi
  local r = 10
  for i = 0, circle, circle / 360 do
    term.setCursorPos(1, 1)
    local cos = math.cos(i * math.pi)
    local sin = math.sin(i * math.pi)
    term.setCursorPos(w/2 + cos * r, h/2 + sin * r)
    print("0")
    sleep(0.1)
  end
end

main()