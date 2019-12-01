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
			targetId
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
				local target = entities[self.targetId]
				local targetNode = nodes[target.pos.x][target.pos.y]
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
							neighborNode.parents[self.id] = furthestNode
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
	end

}

Node = {

	new = function(self, x, y, impassable)
		local startingValues = {
			pos = vector.new(x, y),
			impassable = impassable,

			neighborNodes = {},
			parents = {},
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
			write("#")
		end
	end

}



-- FUNCTIONS --------------------------------------------------------

-- Enemies.
function createEntities()
	for id = 1, entityCount do
		entities[id] = Entity:new(id, math.random(w), math.random(h))
	end
end


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



-- CODE EXECUTION --------------------------------------------------------

function setup()
	term.clear()

	createEntities()
	entities[1].targetId = 2
	
	createNodes()
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
			if (entity.targetId) then
				entity:pathfind()
			end
			entity:show()
		end
		sleep(0)
	end
end

setup()
main()
