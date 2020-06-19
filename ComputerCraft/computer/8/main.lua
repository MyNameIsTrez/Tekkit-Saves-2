-- Set up a list which contains the sides as keys, and the current redstone state of each side as a boolean value.
local statelist = {
	["top"] = rs.getBundledInput("top"),
	["front"] = rs.getBundledInput("front"),
	["left"] = rs.getBundledInput("left"),
	["right"] = rs.getBundledInput("right"),
	["back"] = rs.getBundledInput("back"),
	["bottom"] = rs.getBundledInput("bottom"),
}

-- Ready the terminal for printing to.
term.clear()
term.setCursorPos(1,1)

print("LISTENING")

while true do -- Start an endless loop
	os.pullEvent("redstone") -- Yield the computer until some redstone changes.
	-- We don't care what the event returns, since the first variable will be "redstone" and the rest will be nil. 

	-- Now we check each side to see if it's changed.
	for side, state in pairs(statelist) do -- Run the lines of code in this loop for each key/value pair in statelist
		-- print("CHECKING STATELIST")
		-- print(os.clock())
		-- print("side: " .. tostring(side))
		-- print("rs.getBundledInput(side): " .. tostring(rs.getBundledInput(side)))
		-- print("state: " .. tostring(state))
		if rs.getBundledInput(side) ~= state then -- If the side we're checking doesn't match what it was last time we checked then.
			print(side.." is now "..tostring(rs.getBundledInput(side))) -- Print the new state of the side.
			statelist[side] = rs.getBundledInput(side) -- Update the statelist with the new change.
		end
	end
end