-- Set up a list which contains the sides as keys, and the current redstone state of each side as a boolean value.
local state_list = {
	["back"] = rs.getBundledInput("back"),
	["right"] = rs.getBundledInput("right"),
	["top"] = rs.getBundledInput("top"),
	["left"] = rs.getBundledInput("left"),
	["bottom"] = rs.getBundledInput("bottom"),
	["front"] = rs.getBundledInput("front"),
}

local side_additions = {
	["back"] = 0,
	["right"] = 16,
	["top"] = 32,
	["left"] = 48,
	["bottom"] = 64,
	["front"] = 80,
}

term.clear()
term.setCursorPos(1,1)

print("LISTENING")

while true do
	os.pullEvent("redstone")

	for side, state in pairs(state_list) do
		local input = rs.getBundledInput(side)
		if input ~= state then
			print(side .. " is now " .. tostring(input))

			if input ~= 0 then -- Cable off.
				local index = math.log(input) / math.log(2) + 1
				local true_index = side_additions[side]+index
				local char = string.char(true_index + 31) -- First 31 chars are bugged.
				print("char: " .. char)
			end

			state_list[side] = input
		end
	end
end