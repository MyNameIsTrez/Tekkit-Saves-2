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