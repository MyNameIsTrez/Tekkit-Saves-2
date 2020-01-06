-- function importAPIs()
-- 	local APIs = {
-- 		{id = "p9tSSWcB", name = "cf"},
-- 	}

-- 	fs.delete("apis") -- To delete APIs in the folder.
-- 	fs.makeDir("apis") -- Recreates the folder.

-- 	for _, API in pairs(APIs) do
-- 		shell.run("pastebin", "get", API.id, "apis/"..API.name)
-- 		os.loadAPI("apis/"..API.name)
-- 	end
-- end

local max = 50
local leverSide = 'right'
local width, height = term.getSize()

if not rs.getInput(leverSide) then
	-- importAPIs()


	-- local t1 = os.clock()

	-- for _ = 1, max do
	-- 	for y = 1, height do
	-- 		for x = 1, width do
	-- 			term.setCursorPos(x, y)
	-- 			write('1')
	-- 		end
	-- 	end
	-- end

	-- local t2 = os.clock()


	-- local t3 = os.clock()

	-- for _ = 1, max do
	-- 	for y = 1, height do
	-- 		local str = ''
	-- 		for x = 1, width do
	-- 			str = str .. '1'
	-- 		end
	-- 		term.setCursorPos(1, y)
	-- 		write(str)
	-- 	end
	-- end

	-- local t4 = os.clock()


	-- local t5 = os.clock()

	-- for _ = 1, max do
	-- 	local stringTab = {}
	-- 	for y = 1, height do
	-- 		for x = 1, width do
	-- 			table.insert(stringTab, '1')
	-- 		end
	-- 	end
	-- 	term.setCursorPos(1, 1)
	-- 	write(table.concat(stringTab))
	-- end

	-- local t6 = os.clock()


	local t9 = os.clock()

	for _ = 1, max do
		local stringTab = {}
		for y = 1, height do
			for x = 1, width do
				stringTab[#stringTab] = '1'
			end
			stringTab[#stringTab] = '\n'
		end
		term.setCursorPos(1, 1)
		write(table.concat(stringTab))
	end

	local t10 = os.clock()


	local t7 = os.clock()

	for _ = 1, max do
		local stringTab = {}
		for y = 1, height do
			for x = 1, width do
				stringTab[#stringTab] = '1'
			end
		end
		term.setCursorPos(1, 1)
		write(table.concat(stringTab))
	end

	local t8 = os.clock()


	term.setCursorPos(1, 1)
	term.clear()

	print('ALL BELOW IS DONE '..tostring(max)..' TIMES!')
	-- print('term.setCursorPos() and write() every x and y: '..tostring(t2 - t1)..'s, ')
	-- print('term.setCursorPos() and write() every y: '..tostring(t4 - t3)..'s, ')
	-- print('table.concat(stringTab) with table.insert(): '..tostring(t6 - t5)..'s, ')
	print('table.concat(stringTab) with stringTab[#stringTab]: '..tostring(t8 - t7)..'s, ')
	print('table.concat(stringTab) with stringTab[#stringTab] and "\\n" inserted after every line: '..tostring(t10 - t9)..'s, ')
end