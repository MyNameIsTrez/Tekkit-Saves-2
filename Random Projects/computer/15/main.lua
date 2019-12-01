-- IMPORTING --------------------------------------------------------

function import()
	-- Makes a table of the IDs and names of the APIs to load.
	local APIs = {
		-- {id = "6qBVrzpK", name = "aStar"},
		{id = "drESpUSP", name = "shape"},
		{id = "drESpUSP", name = "cf"}
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

local entities = {}
local w, h = term.getSize()



-- CLASSES --------------------------------------------------------

Entity = {

	new = function(self, id, x, y, wall)
		local starting_values = {
			id = id,
			pos = vector.new(x, y),
			icon = "e",

			-- Pathfinding.
			targetId,
			neighbors,
			f = 0,
			g = 0,
			h = 0,
			wall = wall
		}
		setmetatable(starting_values, {__index = self})
		return starting_values
	end,

	show = function(self)
		shape.point(self.pos, self.icon)
	end,

	pathfind = function(self)
		local openSet = {}
		print(self.pos)
		-- sleep(10)
		openSet[1] = self.pos

		local closedSet = {}

		while true do
			if #openSet >= 1 then
				local currentIndex = 0
				for i = 1, #openSet do
					if openSet[i].f[self.id] < openSet[currentIndex].f[self.id] then
						currentIndex = i
					end
				end
				local furthest = openSet[currentIndex]

				-- Found a solution.
				if furthest == targetPos then
					return
				end

				self:removeFromTable(openSet, furthest)
				closedSet[#closedSet + 1] = furthest

				local neighbors = furthest.neighbors
				for i = 1, #neighbors do
					local neighbor = neighbors[i]

					if not self:tableContains(closedSet, neighbor) and not neighbor.wall then
						-- I removed 'n / tileSizeFull', because each tile is 1 wide and high.
						local heur = self:heuristic(neighbor, furthest) / 1
						
						local tempG
						-- If the 'g' property exists, add it. Otherwise, keep it at 0.
						if furthest.g[self.id] + heur then
							tempG = furthest.g[self.id] + heur
						else
							tempG = heur
						end

						local newPath = false
						if self:tableContains(openSet, neighbor) then
							if tempG < neighbor.g[self.id] then
								neighbor.g[self.id] = tempG
								newPath = true
							end
						else
							neighbor.g[self.id] = tempG
							openSet[#openSet + 1] = neighbor
							newPath = true
						end

						if newPath then
							-- What is targetPos exactly?
							neighbor.h[self.id] = self:heuristic(neighbor, targetPos)
							neighbor.f[self.id] = neighbor.g[self.id] + neighbor.h[self.id]
							neighbor.parents[self.id] = furthest
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



-- FUNCTIONS --------------------------------------------------------

-- Enemies.
function createEntities()
	for id = 1, entityCount do
		entities[id] = Entity:new(id, math.random(w), math.random(h), false)
	end
end



-- CODE EXECUTION --------------------------------------------------------

function setup()
	term.clear()
	createEntities()
	entities[1].targetId = 2
end


function main()
	while true do
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
