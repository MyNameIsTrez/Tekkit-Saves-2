--local t1=os.clock()
local width, height = term.getSize()

term.clear()

local tab={}
for i = 1, width*height do
  local n = math.floor(math.random()+.5)
  tab[i] = n
end

local str=table.concat(tab)

term.setCursorPos(1,1)
write(str)

--local elapsed = os.clock()-t1
--local rounded = math.floor(elapsed*100+.5)/100
--term.setCursorPos(1,1)
--write(rounded)
