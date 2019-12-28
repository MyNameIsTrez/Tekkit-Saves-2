-- README --------------------------------------------------------

-- Program to demonstrate particles that utilize dithering.

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

local function importAPIs()
	local APIs = {
		{id = "cegB4RwE", name = "dithering"},
		{id = "p9tSSWcB", name = "cf"}
	}
	
	fs.delete("apis") -- Deletes the folder, with every API file in it.
	fs.makeDir("apis") -- Recreates the folder.
	
	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/" .. API.name)
		os.loadAPI("apis/" .. API.name)
	end
end

local function importCfg()
	os.loadAPI("cfg")
end

-- NOT USER EDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1

local spawners = {}

-- FUNCTIONS --------------------------------------------------------

local function createSpawner()
	local spawner = Spawner:new(math.random(width), math.random(height))
	
	for _ = 1, cfg.spawnerParticleCount do
		spawner:spawn()
	end

	table.insert(spawners, spawner)
end

-- Get the first index of an element in a table.
-- Returns false if the element isn't in the table.
local function indexOf(tab, element)
	for i = 1, #tab do
		local a = tab[i]
		if a == element then
			return i
		end
	end
	return false
end

local function showDebug()
	local fps = 1 / cfg.sleepTime

	local particleCount = 0
	for i = 1, #spawners do
		local spawner = spawners[i]
		particleCount = particleCount + #spawner.particles
	end

	local spawnerCount = #spawners

	term.setCursorPos(2, 2)
	term.write('FPS: '..tostring(fps))

	term.setCursorPos(2, 4)
	term.write('Particles: '..tostring(particleCount))

	term.setCursorPos(2, 6)
	term.write('Spawners: '..tostring(spawnerCount))
end

-- CLASSES --------------------------------------------------------

Spawner = {

	new = function(self, x, y)
		local startingValues = {
			x = x,
			y = y,

			particles = {},

			sharedParticleAttributes = {
				color = 0.6 -- not used
			}
		}
		
		setmetatable(startingValues, {__index = self})
		return startingValues
	end,

	spawn = function(self)
		randomParticleAttributes = {
			lifeTime = math.random(cfg.minLifeTime, cfg.maxLifeTime),
			velocity = cf.randomFloat(cfg.minVelocity, cfg.maxVelocity),
			direction = cf.randomFloat(cfg.minDirection, cfg.maxDirection)
		}

		particle = Particle:new(self.x, self.y, self.sharedParticleAttributes, randomParticleAttributes)

		table.insert(self.particles, particle)
	end,

	updateParticles = function(self)
		for i = 1, #self.particles do
			particle = self.particles[i]
			particle:update()
		end
	end,

	showParticles = function(self)
		for i = 1, #self.particles do
			particle = self.particles[i]
			particle:show()
		end
	end,

	removeDeadParticles = function(self)
		-- When removing elements from tables, you want to start at the end
		-- so elements shifting left don't interfere with the table.remove().
		for i = #self.particles, 1, -1 do
			local particle = self.particles[i]

			-- Remove particles that have a lifeTime of 0 or lower.
			local old = particle.lifeTime <= 0

			-- Remove particles that are out of bounds.
			-- Not sure if these checks are correct.
			local up = particle.y < 0;
			local down = particle.y >= height;
			local left = particle.x < 0;
			local right = particle.x >= width;

			if old or up or down or left or right then
				table.remove(self.particles, i)
			end
		end
	end

}

Particle = {

	new = function(self, x, y, sharedAttributes, randomAttributes)
		local startingValues = {
			x = x,
			y = y,

			color = sharedAttributes.color, -- not used
			
			initialLifeTime = randomAttributes.lifeTime,
			lifeTime = randomAttributes.lifeTime,

			velocity = randomAttributes.velocity,
			direction = randomAttributes.direction
		}
		
		setmetatable(startingValues, {__index = self})
		return startingValues
	end,

	update = function(self)
		self.lifeTime = self.lifeTime - 1

		self.x = self.x + math.cos(self.direction) * self.velocity
		self.y = self.y + -math.sin(self.direction) * self.velocity -- Flip the y-value with the -sin().
	end,

	show = function(self)		
		local normalizedLife = self.lifeTime / self.initialLifeTime
		local char = dithering.getClosestChar(normalizedLife)

		term.setCursorPos(self.x, self.y)
		term.write(char)
	end

}

-- SETUP AND MAIN FUNCTIONS --------------------------------------------------------

local function setup()
	importAPIs()
	importCfg()
	term.clear()
end

local function main()
	previousTime = os.clock()

	while true do
		if not rs.getInput(cfg.leverSide) then
			term.clear()

			-- Create a new spawner every second.
			if os.clock() - previousTime >= 1 then
				createSpawner()
				previousTime = os.clock()
			end

			-- Remove spawners with no particles.
			-- When removing elements from tables, you want to start at the end
			-- so elements shifting left don't interfere with the table.remove().
			for i = #spawners, 1, -1 do
				spawner = spawners[i]

				spawner:updateParticles()
				spawner:showParticles()

				spawner:removeDeadParticles()

				if #spawner.particles <= 0 then
					table.remove(spawners, indexOf(spawners, spawner))
				end
			end

			showDebug()

			sleep(cfg.sleepTime)
			-- cf.yield()
		else
			sleep(1)
		end
	end
end

-- CODE EXECUTION --------------------------------------------------------

setup()
main()