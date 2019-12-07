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



-- EDITABLE VARIABLES --------------------------------------------------------
local leverSide = "right"



-- CLASSES --------------------------------------------------------

Particle = {
	new = function(self, x, y, w, h, velMult)
		local starting_values = {
			pos = vector.new(x, y),
			vel = vector.new(cf.randomFloat(-1 * velMult, 1 * velMult), cf.randomFloat(-1 * velMult, 1 * velMult)),
			acc = vector.new(),
			icon = "*",
			w = w,
			h = h,
			mass = 10
		}
		setmetatable(starting_values, {__index = self})
		return starting_values
	end,
	show = function(self)
		shape.point(self.pos, self.icon) -- draw the particle
		
		-- draw an arrow for the velocity vector
		-- if (self.vel.x < -0.5) then
		-- 	local x = self.pos.x - 1
		-- 	if (x >= 1) then
		-- 		shape.point({x=x, y=self.pos.y}, "-")
		-- 	end
		-- elseif (self.vel.x > 0.5) then
		-- 	local x = self.pos.x + 1
		-- 	if (x <= self.w-1) then
		-- 		shape.point({x=x, y=self.pos.y}, "-")
		-- 	end
		-- end
		
		-- if (self.vel.y < -0.5) then
		-- 	local y = self.pos.y - 1
		-- 	if (y >= 1) then
		-- 		shape.point({x=self.pos.x, y=y}, "|")
		-- 	end
		-- elseif (self.vel.y > 0.5) then
		-- 	local y = self.pos.y + 1
		-- 	if (y <= self.h-1) then
		-- 		shape.point({x=self.pos.x, y=y}, "|")
		-- 	end
		-- end
	end,
	attracted = function(self, target, G, constraint)
		local force = target.pos:sub(self.pos) -- target.pos - self.pos
		local distanceSquared = cf.magSq(force)
		local strength = cf.clamp(G * ((self.mass * target.mass) / distanceSquared), 0, constraint)
		  
		force = force:normalize() -- normalizes the vector, so the hypothenuse is 1
		force = force:mul(strength)
		
		self.acc = self.acc:add(force:mul(1/self.mass)) -- F = m * a, a = F / m, a = F * (1/m)
	end,
	update = function(self)
		self.vel = self.vel:add(self.acc)
		self.pos = self.pos:add(self.vel)
	end
}

Attractor = {
	new = function(self, x, y)
		local starting_values = {
			pos = vector.new(x, y),
			icon = "o",
			mass = 400
		}
		setmetatable(starting_values, {__index = self})
		return starting_values
	end,
	show = function(self)
		shape.point(self.pos, self.icon)
	end
}



-- FUNCTIONS --------------------------------------------------------

function createParticles(n, x, y, w, h, velMult)
	local particles = {}
	for id = 1, n do
		particles[#particles+1] = Particle:new(x, y, w, h, velMult)
		-- particles[#particles+1] = Particle:new(math.random(w-1), math.random(h-1), w, h, velMult)
	end
	return particles
end

function createAttractors(n, w, h)
	local attractors = {}
	attractors[#attractors+1] = Attractor:new(w, h)
	return attractors
end



-- CODE EXECUTION --------------------------------------------------------

function main()
	while true do
		if not rs.getInput(leverSide) then
			local G = 1
			local constraint = 0.1
			local fps = 75
			local particleCount = 100
			local velMult = 1

			local w, h = term.getSize()
			local dt = 1/fps
			local particles = createParticles(particleCount, w/4, h/4, w, h, velMult)
			-- local particles = createParticles(particleCount, w-1, h-1, w, h, velMult)
			local attractors = createAttractors(5, w/2, h/2)

			while true do
				if not rs.getInput(leverSide) then
					cf.clearTerm()
					for i = 1, #particles do
						particle = particles[i]
						for j = 1, #attractors do
							attractor = attractors[j]
							particle:attracted(attractor, G, constraint)
						end
						particle:update()
						particle:show()
						particle.acc = particle.acc:mul(0) -- reset the acceleration
					end
					attractors[1]:show()
					sleep(dt)
				else
					sleep(1)
				end
			end
		else
			sleep(1)
		end
	end
end
main()