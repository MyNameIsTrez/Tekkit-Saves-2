entityCount = 2 -- Default is 2.
diagonalMoving = true -- Default is true.
movingThroughDiagonalWalls = false -- Default is false.
noOccupyingTargetNode = true -- Default is true.
showPath = true -- Default is true.
showWalls = true -- Default is true.
wallChance = 0.35 -- Where 0 is 0% and 1 is 100%. Default is 0.25.
showClosedSet = true -- Shows the nodes that have been explored by the pathing algorithm that aren't part of the final path. Default is true.

turboSpeed = false -- If turboSpeed is true, sleepTime is ignored. Default is false.
sleepTime = 0.15 -- 0 is the same as 0.05, which is the minimum. Default is 0.15.

setupSleep = false -- After generating the map, wait setupSleepTime seconds before starting to move the entity so you can see the path clearly. Default is false.
setupSleepTime = 5 -- Default is 5.

entityIcon = "e" -- Default is "e".
entityPathIcon = "." -- Default is ".".
wallIcon = "O" -- Default is "O".
closedSetIcon = "|" -- Default is "|".



-- UNEDITABLE VARIABLES --------------------------------------------------------

w, h = term.getSize()
w = w - 1
-- nodes = {}



-- FUNCTIONS --------------------------------------------------------

function createNodes()
	for x = 1, w do
		nodes[x] = {}
		for y = 1, h do
			local wall = math.random() < wallChance
			if not wall then
				print(tostring(x) .. ', ' .. tostring(y))
				nodes[x][y] = Node:new(x, y, diagonalMoving, movingThroughDiagonalWalls)
			elseif showWalls then
				shape.point(vector.new(x, y), wallIcon)
			end
		end
		cf.yield()
	end

	for x, _ in pairs(nodes) do
		for _, node in pairs(nodes[x]) do
			node:setNeighborNodes()
		end
	end
end

function createEntities()
	for id = 1, entityCount do
		local x = math.random(w)
		local y = math.random(h)

		-- Makes sure the entity doesn't spawn inside a wall.
		while nodes[x][y] == nil do
			x = math.random(w)
			y = math.random(h)
		end
		
		-- !!! This code should also check if the entity doesn't spawn inside another entity !!!
		entities[id] = Entity:new(id, x, y, entityIcon, entityPathIcon, noOccupyingTargetNode)
	end
end

function debugShowNodesNeighbors()
	for x, _ in pairs(nodes) do
		for y, node in pairs(nodes[x]) do
			if node then
				shape.point(vector.new(x, y), #node.neighborNodes)
			end
		end
	end
	term.setCursorPos(1, 1)
end

function reachedTarget(entity)
	if noOccupyingTargetNode then
		if entity.pathStep == #entity.path then
			entity:die()
		end
	end
end



-- CODE EXECUTION --------------------------------------------------------

-- Setup
while true do
	if not rs.getInput(cfg.disableSide) then
		-- shell.run("apis/aStar") -- No clue why this needs to be here when os.loadAPI() has already been called.

		-- term.clear()
		
		createNodes()

		createEntities()
		entities[1].targetEntityId = 2

		-- debugShowNodesNeighbors()

		for _, entity in pairs(entities) do
			entity:show()
		end
		
		-- Prevents the enemy:pathfind() from being one move behind entity.move() in main().
		for _, entity in pairs(entities) do
			if entity.targetEntityId then
				entity:pathfind()
				entity:setPath()
				if showPath then
					entity:showPath()
				end
			end
		end

		break
	else
		sleep(1)
	end
end

-- Main
if setupSleep then
	sleep(setupSleepTime)
end

while true do
	if not rs.getInput(cfg.disableSide) then
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
	else
		sleep(1)
	end
end