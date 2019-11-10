function loadAPIs()
	-- Makes a table of the IDs and names of the APIs to load.
	local APIs = {
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
loadAPIs()

Particle = {
	new = function(self, x, y, r, m)
		local starting_values = {
			pos = vector.new(x, y),
			icon = "."
		}
		setmetatable(starting_values, {__index = self})
		return starting_values
	end,
	show = function(self)
		shape.point(self.pos, self.icon)
	end
}

Attractor = {
	new = function(self, x, y, r, m)
		local starting_values = {
			pos = vector.new(x, y),
			icon = "o"
		}
		setmetatable(starting_values, {__index = self})
		return starting_values
	end,
	show = function(self)
		shape.point(self.pos, self.icon)
	end
}

function createParticles(n, w, h)
	local particles = {}
	for id = 1, n do
		particles[#particles+1] = Particle:new(math.random(w), math.random(h))
	end
	return particles
end

function createAttractors(n, w, h)
	local attractors = {}
	attractors[#attractors+1] = Attractor:new(w, h)
	return attractors
end

function main()
	local w, h = term.getSize()
	local fps = 60

	particles = createParticles(5, w, h)
	attractors = createAttractors(5, w/2, h/2)

	while true do
		cf.clearTerm()

		for i = 1, #particles do
			particles[i]:show()
		end
		attractors[1]:show()

		sleep(1/fps)
	end
end
main()