local bundledSide = "back"
local clicks = 200

function bundledOutput(clr)
	rs.setBundledOutput(bundledSide, clr)
end

function clearBundledOutput()
	bundledOutput(0)
end

function storageFull()
	return rs.getBundledInput(bundledSide) == colors.lightBlue
end

term.setCursorPos(1, 1)

while true do
	-- If the storage is full, check if it isn't full anymore every 60s.
	while storageFull() do
		print("Sleeping 60 seconds...")
		sleep(60)
	end

	term.clear()
	print("Wearing tool...")

	-- Insert tool.
	bundledOutput(colors.white)
	sleep(0.05)

	-- Wear down tool to minimum durability.
	for _ = 1, clicks do
		bundledOutput(colors.orange)
		sleep(0.05)
		clearBundledOutput()
		sleep(0.35)
	end

	-- Pull tool out.
	bundledOutput(colors.magenta)
	sleep(0.05)
	clearBundledOutput()
	sleep(0.05)
end