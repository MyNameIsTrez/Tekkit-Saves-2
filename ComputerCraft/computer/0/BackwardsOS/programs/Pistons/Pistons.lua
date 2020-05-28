local pistonCount = 16

local sides = {
	'back',
	'top',
}

if pistonCount * 2 > 16 * #sides then
	error(#sides .. " bundled cable sides aren't enough for " .. pistonCount .. " pistons!")
end

function push(start, end_)
	local end_ = end_ or 1
	if start >= end_ then
		for i = start, end_, -1 do
			print(i)
			activate(i)
		end
		print()
		push(start + 1, end_ + 2)
	end
end

function pull(pistonCount, start, end_)
	local start = start or 2 * pistonCount - 1
	local end_ = end_ or start
	if start >= 1 then
		for i = start, end_ do
			print(i)
			activate(i)
		end
		print()
		pull(pistonCount, start - 2, end_ - 1)
	end
end

function activate(i)
	local side = sides[math.ceil(i / 16)]
	rs.setBundledOutput(side, 2 ^ ((i - 1) % 16 + 1 - 1))
	sleep(0.1)
	rs.setBundledOutput(side, 0)
	sleep(0.1)
end

-- while true do
	print("PUSHING")
	push(pistonCount)
	sleep(2)
	print("PULLING")
	pull(pistonCount)
-- end