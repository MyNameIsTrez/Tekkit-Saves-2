local t1=os.clock()
local width, height = term.getSize()

term.clear()
term.setCursorPos(1,1)

local tab={}
for i = 1, width*height do
  local n = math.floor(math.random()+.5)
  tab[i] = n
end

local str=table.concat(tab)
write(str)
os.queueEvent('a')
os.pullEvent('a')

term.setCursorPos(1,1)
local elapsed = os.clock()-t1
local rounded = math.floor(elapsed*100+.5)/100
write(rounded)
