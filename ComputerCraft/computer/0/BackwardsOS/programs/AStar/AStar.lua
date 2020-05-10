local settings = {
	entityCount = 2,                    -- Default is 2.
	diagonalMoving = true,              -- Default is true.
	movingThroughDiagonalWalls = false, -- Default is false.
	noOccupyingTargetNode = true,       -- Default is true.
	showPath = true,                    -- Default is true.
	showWalls = true,                   -- Default is true.
	wallChance = 0.35,                  -- Where 0 is 0% and 1 is 100%. Default is 0.35.
	showClosedSet = true,               -- Shows the nodes that have been explored by the pathing algorithm that aren't part of the final path. Default is true.

	turboSpeed = false,                 -- If turboSpeed is true, sleepTime is ignored. Default is false.
	sleepTime = 0.15,                   -- 0 is the same as 0.05, which is the minimum. Default is 0.15.

	setupSleep = false,                 -- After generating the map, wait setupSleepTime seconds before starting to move the entity so you can see the path clearly. Default is false.
	setupSleepTime = 5,                 -- Default is 5.

	entityIcon = "|",                   -- Default is "|".
	entityPathIcon = "*",               -- Default is "*".
	wallIcon = "#",                     -- Default is "#".
	closedSetIcon = "@",                -- Default is "@".
}

local sim = aStar.Simulation:new(settings)
sim:setup()
sim:main()