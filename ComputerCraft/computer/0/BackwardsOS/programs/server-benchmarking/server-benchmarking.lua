local url = "http://h2896147.stratoserver.net:3000/test-res-send-random"

local time_start, time_end
local total = 0
local calls = 0
while true do
	time_start = os.clock()
	http.get(url)
	time_end = os.clock()
	-- Makes sure 0.4999 -> 0.5
	total = total + math.floor((time_end - time_start) * 10 + 0.5) / 10
	calls = calls + 1
	term.setCursorPos(1, 1)
	write(total * 1000 / calls .. " ms avg   ")
	term.setCursorPos(1, 2)
	write(calls .. " calls   ")
end

-- local info = { bar = "baz" }
-- local objectStr = 'foo=' .. json.encode(info)
-- http.post(url, objectStr)