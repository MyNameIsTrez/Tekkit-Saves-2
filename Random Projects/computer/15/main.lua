-- README --------------------------------------------------------

-- The default terminal ratio is 25:9, which is absolutely tiny.

-- To get the terminal to fill the entire screen, use these widths and heights:
-- 426:153 on my 31.5" monitor in windowed mode.
-- 426:160 on my 31.5" monitor in fullscreen mode.
-- 227:78 on my laptop in windowed mode.
-- 227:85 on my laptop in fullscreen mode.



-- IMPORTING --------------------------------------------------------

function import()
	-- Makes a table of the IDs and names of the APIs to load.
	local APIs = {
		-- {id = "6qBVrzpK", name = "aStar"},
		{id = "drESpUSP", name = "shape"},
		{id = "p9tSSWcB", name = "cf"}
	}

	for i = 1, #APIs do
		-- Delete the old APIs, to make room for the more up-to-date online version.
		-- This returns no error if the API doesn't exist on the computer yet.
		fs.delete(APIs[i].name)

		shell.run("pastebin", "get", APIs[i].id, APIs[i].name)
		os.loadAPI(APIs[i].name)
	end
end
import()



-- EDITABLE VARIABLES --------------------------------------------------------

local entityCount = 2
local diagonalMoving = false
local movingThroughDiagonalWalls = false
local noOccupyingTargetNode = true

local entityIcon = "e"
local entityPathIcon = "@"
local wallIcon = "#"



-- UNEDITABLE VARIABLES --------------------------------------------------------

local w, h = term.getSize()
w = w - 1
local entities = {}
local nodes = {}
local sleepTime = 0 -- 0 is the same as 0.05.



-- CLASSES --------------------------------------------------------

Entity = {

	new = function(self, id, x, y, icon, pathIcon, noOccupyingTargetNode)
		local startingValues = {
			id = id,
			pos = vector.new(x, y),
			icon = icon,
			pathIcon = pathIcon,
			noOccupyingTargetNode = noOccupyingTargetNode,

			targetEntityId,
			path
		}
		setmetatable(startingValues, {__index = self})
		return startingValues
	end,

	show = function(self)
		shape.point(self.pos, self.icon)
	end,

	pathfind = function(self)
		local openSet = {}
		openSet[1] = nodes[self.pos.x][self.pos.y]

		local closedSet = {}

		-- term.setCursorPos(1, 1)
		while true do
			if #openSet >= 1 then
				local currentIndex = 1
				for i = 1, #openSet do
					if openSet[i].f[self.id] and openSet[currentIndex].f[self.id] then
						if openSet[i].f[self.id] < openSet[currentIndex].f[self.id] then
							currentIndex = i
						end
					end
				end
				local furthestNode = openSet[currentIndex]

				-- Found a solution.
				local targetEntity = entities[self.targetEntityId]
				local targetNode = nodes[targetEntity.pos.x][targetEntity.pos.y]
				if furthestNode == targetNode then
					return
				end

				self:removeFromTable(openSet, furthestNode)
				closedSet[#closedSet + 1] = furthestNode

				-- print()
				-- print()
				-- print("furthestNode x: "..furthestNode.pos.x..", furthestNode y: "..furthestNode.pos.y)
				-- print("self.pos.x: "..self.pos.x..", self.pos.y: "..self.pos.y)
				-- print("#furthestNode.neighborNodes: "..#furthestNode.neighborNodes)
				-- print()

				for i = 1, #furthestNode.neighborNodes do
					-- write("1")
					local neighborNode = furthestNode.neighborNodes[i]

					if not self:tableContains(closedSet, neighborNode) and neighborNode then -- !!!!!!! can probably remove 'and neighborNode' !!!!!!!!!!
						-- write("2")
						-- I removed 'n / tileSizeFull', because each tile is 1 wide and high.
						local heur = self:heuristic(neighborNode, furthestNode)
						
						local tempG
						-- If the 'g' property exists, add it. Otherwise, keep it at 0.
						-- if furthestNode.g[self.id] + heur then
						if furthestNode.g[self.id] then
							tempG = furthestNode.g[self.id] + heur
						else
							tempG = heur
						end
						-- write("3")

						local newPath = false
						if self:tableContains(openSet, neighborNode) then
							if tempG < neighborNode.g[self.id] then
								neighborNode.g[self.id] = tempG
								newPath = true
							end
						else
							neighborNode.g[self.id] = tempG
							openSet[#openSet + 1] = neighborNode
							newPath = true
						end

						if newPath then
							-- What is targetNode exactly?
							neighborNode.h[self.id] = self:heuristic(neighborNode, targetNode)
							neighborNode.f[self.id] = neighborNode.g[self.id] + neighborNode.h[self.id]
							neighborNode.parentNode[self.id] = furthestNode
						end
					end
				end
			else
				print("ERROR: A path couldn't be found.")
				sleep(100)
				return
			end
		end
	end,

	removeFromTable = function(self, tab, element)
		for i = #tab, 1, -1 do
			if tab[i] == element then
				table.remove(tab, i)
			end
		end
	end,

	tableContains = function(self, table, element)
		for _, value in pairs(table) do
			if value == element then
				return true
			end
		end
		return false
	end,

	heuristic = function(self, a, b)
		return cf.dist(a, b)
	end,

	setPath = function(self)
		-- Sets a path from itself to the target.
		local targetEntity = entities[self.targetEntityId]
		local targetNode = nodes[targetEntity.pos.x][targetEntity.pos.y]
		local childNode = targetNode
		
		local pathFromTargetEntity = {}
		pathFromTargetEntity[#pathFromTargetEntity + 1] = childNode

		while childNode.parentNode[self.id] do
			local parentNode = childNode.parentNode[self.id]
			pathFromTargetEntity[#pathFromTargetEntity + 1] = parentNode
			childNode = parentNode
		end

		self.path = cf.reverseTable(pathFromTargetEntity)

		if noOccupyingTargetNode then
			self:removeFromTable(self.path, self.path[#self.path])
		end
	end,

	showPath = function(self)
		for i = 1, #self.path do
			local pathNode = self.path[i]
			shape.point(pathNode.pos, self.pathIcon)
		end
	end,

	move = function(self)
		if #self.path >= 2 then
			self:unshow()
			local nextNode = self.path[2]
			self.pos.x = nextNode.pos.x
			self.pos.y = nextNode.pos.y
			nextNode.parentNode[self.id] = nil
		end
	end,

	unshow = function(self)
		shape.point(self.pos, " ")
	end,

}


Node = {

	new = function(self, x, y, icon, diagonalMoving, movingThroughDiagonalWalls)
		local startingValues = {
			pos = vector.new(x, y),
			icon = icon,
			diagonalMoving = diagonalMoving,
			movingThroughDiagonalWalls = movingThroughDiagonalWalls,

			neighborNodes = {},
			parentNode = {},
			f = {}, -- g + h.
			g = {}, -- Cost from the start.
			h = {} -- Minimum cost to the end.
		}
		setmetatable(startingValues, {__index = self})
		return startingValues
	end,

	setNeighborNodes = function(self)
		local notTopBorder = self.pos.y > 1
		local notLeftBorder = self.pos.x > 1
		local notBottomBorder = self.pos.y < h
		local notRightBorder = self.pos.x < w
		
		-- print("x: "..self.pos.x..", y: "..self.pos.y)
		-- sleep(0.2)

		-- Top.
		if notTopBorder then
			local neighbor = nodes[self.pos.x][self.pos.y - 1]
			-- print("x: "..self.pos.x..", y: "..self.pos.y)
			-- print(type(nodes[self.pos.x][self.pos.y - 1]))
			-- sleep(100)
			if neighbor then
				self.neighborNodes[#self.neighborNodes + 1] = neighbor
			end
		end

		-- Left.
		if notLeftBorder then
			local neighbor = nodes[self.pos.x - 1][self.pos.y]
			if neighbor then
				self.neighborNodes[#self.neighborNodes + 1] = neighbor
			end
		end

		-- Bottom.
		if notBottomBorder then
			local neighbor = nodes[self.pos.x][self.pos.y + 1]
			if neighbor then
				self.neighborNodes[#self.neighborNodes + 1] = neighbor
			end
		end

		-- Right.
		if notRightBorder then
			local neighbor = nodes[self.pos.x + 1][self.pos.y]
			if neighbor then
				self.neighborNodes[#self.neighborNodes + 1] = neighbor
			end
		end

		if self.diagonalMoving then
			-- Prevents the path from going diagonally through two walls.
			local neighborTopIsWall, neighborLeftIsWall, neighborBottomIsWall, neighborRightIsWall

			if notTopBorder then
				neighborTopIsWall = not nodes[self.pos.x][self.pos.y - 1]
			end

			if notLeftBorder then
				neighborLeftIsWall = not nodes[self.pos.x - 1][self.pos.y]
			end

			if notBottomBorder then
				neighborBottomIsWall = not nodes[self.pos.x][self.pos.y + 1]
			end

			if notRightBorder then
				neighborRightIsWall = not nodes[self.pos.x + 1][self.pos.y]
			end


			-- Top-left.
			if notTopBorder and notLeftBorder then
				-- Prevents the path from going diagonally through two walls.
				if not (neighborTopIsWall and neighborLeftIsWall) or self.movingThroughDiagonalWalls then
					self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x - 1][self.pos.y - 1]
				end
			end

			-- Bottom-left.
			if notBottomBorder and notLeftBorder then
				-- Prevents the path from going diagonally through two walls.
				if not (neighborBottomIsWall and neighborLeftIsWall) or self.movingThroughDiagonalWalls then
					self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x - 1][self.pos.y + 1]
				end
			end

			-- Bottom-right.
			if notBottomBorder and notRightBorder then
				-- Prevents the path from going diagonally through two walls.
				if not (neighborBottomIsWall and neighborRightIsWall) or self.movingThroughDiagonalWalls then
					self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x + 1][self.pos.y + 1]
				end
			end

			-- Top-right.
			if notTopBorder and notRightBorder then
				-- Prevents the path from going diagonally through two walls.
				if not (neighborTopIsWall and neighborRightIsWall) or self.movingThroughDiagonalWalls then
					self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x + 1][self.pos.y - 1]
				end
			end
		end
	end

}



-- FUNCTIONS --------------------------------------------------------

function createNodes()
	for x = 1, w do
		nodes[x] = {}
		for y = 1, h do
			local impassable = math.random(0, 3) == 3
			-- local impassable = false
			if not impassable then
				nodes[x][y] = Node:new(x, y, wallIcon, diagonalMoving, movingThroughDiagonalWalls)
			end
		end
	end

	for x, _ in ipairs(nodes) do
		for y, _ in ipairs(nodes[x]) do
			nodes[x][y]:setNeighborNodes()
			-- print(textutils.serialize(nodes[x][y].neighborNodes))
			-- sleep(1)
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



-- CODE EXECUTION --------------------------------------------------------

function setup()
	term.clear()
	
	createNodes()

	createEntities()
	entities[1].targetEntityId = 2
	
	-- !!! I can use an ipair loop here later !!!
	-- Prevents the enemy:pathfind() from being one move behind entity.move() in main().
	for id = 1, entityCount do
		local entity = entities[id]
		if entity.targetEntityId then
			entity:pathfind()
			entity:setPath()
		end
	end

	-- for x, _ in ipairs(nodes) do
	-- 	cf.yield()
	-- 	for y, _ in ipairs(nodes[x]) do
	-- 		nodes[x][y]:show()
	-- 	end
	-- end
end


function main()
	while true do
		for id, _ in ipairs(entities) do
			local entity = entities[id]
			if entity.targetEntityId then
				entity:showPath()
				entity:move()
				entity:pathfind()
				entity:setPath()
			end
			entity:show()
		end
		sleep(sleepTime)
	end
end

setup()
main()
