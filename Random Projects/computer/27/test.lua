local start = os.clock()

local iFile = fs.open("1.png", "rb")
local oFile = fs.open("2.jpg", "wb")

local clock = os.clock() + 4

for s in iFile.read do
	oFile.write(s)
	if os.clock() >= clock then
        os.queueEvent("")
        coroutine.yield()
        clock = os.clock() + 4
	end
end

iFile.close()
oFile.close()

print(os.clock() - start)