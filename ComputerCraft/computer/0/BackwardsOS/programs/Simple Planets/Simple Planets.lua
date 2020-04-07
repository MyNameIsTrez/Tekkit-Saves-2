-- CLASSES --------------------------------------------------------

Particle = {

	new = function(self, x, y, w, h, velMult, icon)
		local starting_values = {
			pos = vector.new(x, y),
			w = w,
			h = h,
			vel = vector.new(cf.randomFloat(-1 * velMult, 1 * velMult), cf.randomFloat(-1 * velMult, 1 * velMult)),
			icon = icon,

			acc = vector.new(),
			mass = 10,
		}
		setmetatable(starting_values, {__index = self})
		return starting_values
	end,

	show = function(self)
		shape.point(self.pos, self.icon) -- draw the particle
		
		-- -- draw an arrow representing the velocity vector
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
		  
		force = force:normalize() -- normalizes the vector, so the hypotenuse is 1
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
			icon = "#",
			mass = 400,
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
		local icon = string.char(32 + id) -- All chars except the space char.
		particles[#particles+1] = Particle:new(x, y, w, h, velMult, icon)
		-- particles[#particles+1] = Particle:new(math.random(w-1), math.random(h-1), w, h, velMult, icon)
	end
	return particles
end

function createAttractors(n, w, h)
	local attractors = {}
	attractors[#attractors+1] = Attractor:new(w, h)
	return attractors
end



-- CODE EXECUTION --------------------------------------------------------

local G = 1
local constraint = 0.15
local particleCount = 94 -- 94 by default
local velMult = 1

local w, h = term.getSize()
local particles = createParticles(particleCount, w/4, h/4, w, h, velMult)
local attractors = createAttractors(5, w/2, h/2)

while true do
	if not rs.getInput(cfg.disableSide) then
		-- cf.clearTerm()

		for i = 1, #particles do
			particle = particles[i]

			for j = 1, #attractors do
				attractor = attractors[j]
				particle:attracted(attractor, G, constraint)
			end

			particle:update()
			
			local x = particle.pos.x
			local y = particle.pos.y
			local inCanvas = particle.pos.x >= 1 and particle.pos.x <= w and particle.pos.y >= 1 and particle.pos.y <= h

			if inCanvas then
				particle.icon = dithering.getClosestChar(cf.clamp(particle.vel:length() / 2, 0, 1))
				particle:show()
			end

			particle.acc = particle.acc:mul(0) -- reset the acceleration
		end

		attractors[1]:show()

		cf.tryYield()
	else
		sleep(1)
	end
end