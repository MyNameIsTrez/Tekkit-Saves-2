-- README --------------------------------------------------------

-- The default terminal ratio is 25:9, which is absolutely tiny.

-- To get the terminal to fill the entire screen, use these widths and heights:
	-- My 31.5" monitor:
		-- 426:153 in windowed mode.
		-- 426:160 in fullscreen mode.
		-- 200:70 in windowed mode with GUI Scale: Normal. (for debugging)
	-- My laptop:
		-- 227:78 in windowed mode.
		-- 227:85 in fullscreen mode.



-- IMPORTING --------------------------------------------------------

function importAPIs()
	-- Makes a table of the IDs and names of the APIs to load.
	local APIs = {
		{id = "6qBVrzpK", name = "aStar"},
		{id = "drESpUSP", name = "shape"},
		{id = "p9tSSWcB", name = "cf"}
	}

	for _, API in pairs(APIs) do
		-- Deletes the old API file, to replace it with the more up-to-date version of the API.
		-- This call doesn't cause any problems when the API didn't exist on the computer.
		fs.delete("apis/"..API.name)

		-- Creates a folder, causes no problem if the folder already exists.
		fs.makeDir("apis")

		-- Saving as "apis/"..API.name works, because the API is still referred to without the "apis/" part in the code.
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end



-- EDITABLE VARIABLES --------------------------------------------------------

entityCount = 2 -- Default is 2.
diagonalMoving = true -- Default is true.
movingThroughDiagonalWalls = false -- Default is false.
noOccupyingTargetNode = true -- Default is true.
showPath = true -- Default is true.
showWalls = true -- Default is true.
wallChance = 0.25 -- Where 0 is 0% and 1 is 100%. Default is 0.25.

turboSpeed = false -- If turboSpeed is true, sleepTime is ignored. Default is false.
sleepTime = 0.15 -- 0 is the same as 0.05, which is the minimum. Default is 0.15.

setupSleep = false -- After generating the map, wait setupSleepTime seconds before starting to move the entity so you can see the path clearly. Default is false.
setupSleepTime = 5 -- Default is 5.

entityIcon = "e" -- Default is "e".
entityPathIcon = "." -- Default is ".".
wallIcon = "#" -- Default is "#".



-- UNEDITABLE VARIABLES --------------------------------------------------------

w, h = term.getSize()
w = w - 1



-- FUNCTIONS --------------------------------------------------------

function reachedTarget(entity)
	if noOccupyingTargetNode then
		if entity.pathStep == #entity.path then
			entity:die()
		end
	end
end



-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
	shell.run("apis/aStar")

	term.clear()
	
	createNodes()

	createEntities()
	entities[1].targetEntityId = 2

	-- debugShowNodesNeighbors()
	
	-- Prevents the enemy:pathfind() from being one move behind entity.move() in main().
	for i, entity in pairs(entities) do
		if entity.targetEntityId then
			entity:pathfind()
			entity:setPath()
			if showPath then
				entity:showPath()
			end
		end
		entity:show()
	end
end


function main()
	if setupSleep then
		sleep(setupSleepTime)
	end

	while true do
		for _, entity in pairs(entities) do
			if entity.targetEntityId then
				reachedTarget(entity)
				entity:move()
			end
			entity:show()
		end
		
		if turboSpeed then
			cf.yield()
		else
			sleep(sleepTime)
		end
	end
end

setup()
main()