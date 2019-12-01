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



-- UNEDITABLE VARIABLES --------------------------------------------------------

local w, h = term.getSize()
w = w - 1
local entities = {}
local nodes = {}



-- CLASSES --------------------------------------------------------

Entity = {

	new = function(self, id, x, y)
		local startingValues = {
			id = id,
			pos = vector.new(x, y),
			icon = "e",

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

				for i = 1, #furthestNode.neighborNodes do
					local neighborNode = furthestNode.neighborNodes[i]

					if not self:tableContains(closedSet, neighborNode) and not neighborNode.impassable then
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
				print("FATAL ERROR: A path couldn't be found, blame the programmer.")
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

		-- local n = 0
		while childNode.parentNode[self.id] do
			-- 'childNode.parentNode[self.id]' doesn't have to be written twice here, I think.
			pathFromTargetEntity[#pathFromTargetEntity + 1] = childNode.parentNode[self.id]
			childNode = childNode.parentNode[self.id]
			-- print(n..". x="..childNode.pos.x..", y="..childNode.pos.y)
			-- n = n + 1
			-- sleep(0)
		end

		self.path = cf.reverseTable(pathFromTargetEntity)
	end,

	showPath = function(self)
		for i = 1, #self.path do
			local pathNode = self.path[i]
			term.setCursorPos(pathNode.pos.x, pathNode.pos.y)
			write("@")
		end
	end,

	move = function(self)
		if #self.path >= 2 then
			self:unshow()
			local nextNode = self.path[2]
			-- self.path[1].parentNode[self.id] = nil
			-- print(nextNode.pos.x..", "..nextNode.pos.y.."; "..self.pos.x..", "..self.pos.y)
			self.pos.x = nextNode.pos.x
			self.pos.y = nextNode.pos.y
			nextNode.parentNode[self.id] = nil
			-- print(nextNode.pos.x..", "..nextNode.pos.y.."; "..self.pos.x..", "..self.pos.y)
			-- sleep(1)
		end
	end,

	unshow = function(self)
		shape.point(self.pos, " ")
	end,

}


Node = {

	new = function(self, x, y, impassable)
		local startingValues = {
			pos = vector.new(x, y),
			impassable = impassable,

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
		-- Top.
		if self.pos.y > 1 then
			self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x][self.pos.y - 1]
		end

		-- Left.
		if self.pos.x > 1 then
			self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x - 1][self.pos.y]
		end

		-- Bottom.
		if self.pos.y < h then
			self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x][self.pos.y + 1]
		end

		-- Right.
		if self.pos.x < w then
			self.neighborNodes[#self.neighborNodes + 1] = nodes[self.pos.x + 1][self.pos.y]
		end
	end,

	show = function(self)
		term.setCursorPos(self.pos.x, self.pos.y)
		if self.impassable then
			write(".")
		end
	end

}



-- FUNCTIONS --------------------------------------------------------

function createNodes()
	for x = 1, w do
		nodes[x] = {}
		for y = 1, h do
			local impassable = math.random(0, 3) == 3
			nodes[x][y] = Node:new(x, y, impassable)
		end
	end

	-- This loop can be done with pairs() or ipairs() later.
	for x = 1, w do
		for y = 1, h do
			nodes[x][y]:setNeighborNodes()
		end
	end
end

function createEntities()
	for id = 1, entityCount do
		local x = math.random(w)
		local y = math.random(h)
		-- Makes sure the entity doesn't spawn inside an impassable node.
		while nodes[x][y].impassable do
			x = math.random(w)
			y = math.random(h)
		end
		-- !!! This code should also check if the entity doesn't spawn inside another entity !!!
		entities[id] = Entity:new(id, x, y)
	end
end



-- CODE EXECUTION --------------------------------------------------------

function setup()
	term.clear()
	
	createNodes()

	createEntities()
	entities[1].targetEntityId = 2
	
	-- Prevents the enemy:pathfind() from being one move behind entity.move() in main().
	for id = 1, entityCount do
		local entity = entities[id]
		if (entity.targetEntityId) then
			entity:pathfind()
			entity:setPath()
		end
	end
end


function main()
	while true do
		-- This loop can be done with pairs() or ipairs() later.
		for x = 1, w do
			for y = 1, h do
				nodes[x][y]:show()
			end
		end

		for id = 1, entityCount do
			local entity = entities[id]
			if (entity.targetEntityId) then
				entity:move()
				entity:pathfind()
				entity:setPath()
				entity:showPath()
			end
			entity:show()
			-- term.setCursorPos(10, 10)
			-- write(entity.pos.x..","..entity.pos.y)
		end
		sleep(0)
	end
end

setup()
main()
