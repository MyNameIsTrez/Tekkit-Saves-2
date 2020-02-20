function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common functions.
		{id = 'QKixgCbW', name = 'wt'}, -- World time.
		{id = 'GSRpTU2e', name = 'json'}, -- JSON.
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

importAPIs()

local result = wt.getTime('europe', 'amsterdam')
-- cf.printTable(result)
cf.printTable(result.timeData)

-- local result = wt.getTime('etc', 'utc')
-- cf.printTable(result)

local unsorted = wt.getTimeArgs()
-- cf.printTable(unsorted)

local sorted = wt.getSortedTimeArgs(unsorted)
cf.printTable(sorted, false)

local keySet = {}
local n = 0

for k, _ in pairs(sorted) do
  n = n + 1
  keySet[n] = k
end

cf.printTable(keySet)