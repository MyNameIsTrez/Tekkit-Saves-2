function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'VxsRKpDX', name = 'strbits'}, -- String Bits.
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

importAPIs()
-- local msg = 'test'
local startTime1 = os.clock()
local handle = fs.open('test.txt', 'r')
local msg = handle:readAll()
handle:close()
print('Obtaining the msg: ' .. tostring(os.clock() - startTime1) .. 's')
local startTime2 = os.clock()
local bits = strbits.strToBits(msg)
print('strToBits: ' .. tostring(os.clock() - startTime2) .. 's')
local startTime3 = os.clock()
local result = strbits.bitsToStr(bits)
print('bitsToStr: ' .. tostring(os.clock() - startTime3) .. 's')
print('Total elapsed time: ' .. tostring(os.clock() - startTime1) .. 's')
print(result:sub(1, 10))
-- for _, bit in ipairs(bits) do print(bit == 1) end
