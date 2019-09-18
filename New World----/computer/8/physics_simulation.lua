-- Physics simulation code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

-- The default terminal ratio is 25:9, with the standard being 50:18.

-- To get the terminal to fill the entire screen, use these widths and heights:
-- 426:153 on a 31.5" monitor in windowed mode.
-- 426:160 on a 31.5" monitor in fullscreen mode.
-- 227:78 on the laptop in windowed mode.
-- 227:85 on the laptop in fullscreen mode.

local w, h = term.getSize()

local gui_x = w/4*3 -- The x value of the left line of the GUI.
local simulation_middle_x = gui_x / 2 -- The middle is divided into two pixels; we take the left one.
local entity_symbol = "o"

local entity_min_x = 2
local entity_max_x = gui_x-1
local entity_min_y = 2
local entity_max_y = h-2

local g = 9.81 -- m/s^2 or N/kg. Gravitational acceleration.

function loadAPIs()
  -- Makes a table of the IDs and names of the APIs to load.
  local APIs = {
    {id = "drESpUSP", name = "shape"}
  }

  for i = 1, #APIs do
    -- Delete the old APIs, to make room for the more up-to-date online version.
    -- This returns no error if the program doesn't exist on the computer.
    fs.delete(APIs[i].name)

    shell.run("pastebin", "get", APIs[i].id, APIs[i].name)
    os.loadAPI(APIs[i].name)
  end
end
loadAPIs()

function clear()
  term.clear()
  term.setCursorPos(1,1)
end

local screen_corners = {
  { -- Top-left.
    x = 1,
    y = 1
  },
  { -- Bottom-right.
    x = w-1,
    y = h-1
  }
}

local gui_corners = {
  {
    {
      x = gui_x,
      y = 1
    },
    {
      x = gui_x,
      y = h-1
    }
  },
  {
    {
      x = gui_x + 9,
      y = 1
    },
    {
      x = gui_x + 9,
      y = h-1
    }
  },
  {
    {
      x = gui_x + 15,
      y = 1
    },
    {
      x = gui_x + 15,
      y = h-1
    }
  }
}

Entity = {
  new = function(self, id)
    local starting_values = {
      x = simulation_middle_x, -- m. offset.
      y = entity_min_y, -- m. offset.
      height = 0, -- m. Set by the code.
      mass = 0.25, -- kg.
      facing = 1.5 * 180, -- degrees. Setting it to face south by default.
      id = id,
      speed_horizontal = 0, -- m/s. Isn't affected by anything yet!
      speed_vertical = 0, -- m/s. Is affected by the gravity.
      energy_potential = 0, -- J.
      energy_kinetic = 0, -- J. Result of energy_total - energy_potential.
      energy_warmth = 0, -- J. (Summation of) the kinetic energy when the potential energy is 0.
      energy_total = 0 -- J. This value gets set in calcEnergies().
    }
    setmetatable(starting_values, {__index = self})
    return starting_values
  end,
  setVar = function(self, var)
    self.var = var
  end,
  printVar = function(self)
    print(self.var)
  end,
  printID = function(self)
    print(self.id)
  end
}

local entities = {}
function createEntities()
  for id = 1, 2 do
    entities[#entities+1] = Entity:new(id)
  end
end
createEntities()

function round(number, decimals)
  local c = math.pow(10, decimals)
  return math.floor(number * c) / c
end

function writeStaticGUI(label, name, height)
  term.setCursorPos(gui_x + 10, 1 + 2 * height)
  write("   ")
  term.setCursorPos(gui_x + 10, 1 + 2 * height)
  write(label)

  term.setCursorPos(gui_x + 17, 1 + 2 * height)
  write("                                       ")
  term.setCursorPos(gui_x + 17, 1 + 2 * height)
  write(name)
end

function writeDynamicGUI(number, height)
  local rounded_number = round(number, 2)

  term.setCursorPos(gui_x + 2, 1 + 2 * height)
  write("      ")
  term.setCursorPos(gui_x + 2, 1 + 2 * height)
  write(rounded_number)
end

function pythagoras(a, b)
  return math.sqrt(math.pow(a, 2) + math.pow(b, 2))
end

function entity:calcEnergy()
  entity.energy_potential = entity.mass * g * entity.height
  entity.energy_kinetic = entity.energy_total - entity.energy_potential - entity.energy_warmth
  if (entity.energy_potential == 0) then
    entity.energy_warmth = entity.energy_warmth + entity.energy_kinetic
    entity.energy_kinetic = 0
  end
  entity.energy_total = entity.energy_potential + entity.energy_kinetic + entity.energy_warmth
end

function entity:calcSpeed()
  -- Ek = 0.5 * m * v^2
  -- v = math.sqrt(Ek / 0.5 / m)
  entity.speed_vertical = math.sqrt(entity.energy_kinetic / 0.5 / entity.mass)
end

function entity:move()
  local dist_wall_north = entity.y - entity_min_y
  local dist_wall_east = entity_max_x - entity.x
  local dist_wall_south = entity_max_y - entity.y
  local dist_wall_west = entity_min_x - entity.x

  -- Remove the currently drawn position of the entity.
  shape.point(entity, " ")

  local x_movement
  if (entity.speed_horizontal > 0) then
    x_movement = 1
  elseif (entity.speed_horizontal == 0) then
    x_movement = 0
  else
    x_movement = -1
  end

  local y_movement
  if (entity.speed_vertical > 0) then
    y_movement = 1
  elseif (entity.speed_vertical == 0) then
    y_movement = 0
  else
    y_movement = -1
  end

  if (dist_wall_east >= 1 and x_movement == 1) then
    entity.x = entity.x + x_movement
  end
  if (dist_wall_west >= 1 and x_movement == -1) then
    entity.x = entity.x + x_movement
  end

  if (dist_wall_north >= 1 and y_movement == -1) then
    entity.y = entity.y + y_movement
  end
  if (dist_wall_south >= 1 and y_movement == 1) then
    entity.y = entity.y + y_movement
  end

  entity.height = entity_max_y - entity.y
  
  shape.point(entity, entity_symbol)
end

function drawRectangleLines()
  shape.rectangle(screen_corners[1], screen_corners[2])
  for i, corner in ipairs(gui_corners) do
    shape.line(corner[1], corner[2])
  end
end

function prepareStaticGUI()
  local args = {
    {" m", "x"},
    {" m", "y"},
    {" m", "h"},
    {" kg", "weight"},
    {" deg", "facing"},
    {" num", "id"},
    {" m/s", "entity.speed_horizontal"},
    {" m/s", "entity.speed_vertical"},
    {" J", "entity.energy_potential"},
    {" J", "entity.energy_kinetic"},
    {" J", "entity.energy_warmth"},
    {" J", "entity.energy_total"}
  }

  for i = 1, #args do
    local arg = args[i]
    writeStaticGUI(arg[1], arg[2], i)
  end
end

function prepareDynamicGUI()
  local args = {
    {entity.x},
    {entity.y},
    {entity.height},
    {entity.mass},
    {entity.facing},
    {entity.id},
    {entity.speed_horizontal},
    {entity.speed_vertical},
    {entity.energy_potential},
    {entity.energy_kinetic},
    {entity.energy_warmth},
    {entity.energy_total}
  }

  for i = 1, #args do
    local arg = args[i]
    writeDynamicGUI(arg[1], i)
  end
end

-- The sleep calculation is currently only dependent on the vertical speed of the entities,
-- but it should take the general speed of the entity in the future instead in the future.
function calcSoonestEntityUpdate()
  local update_intervals = {}
  for i, entity in ipairs(entities) do
    update_intervals[i] = 1/entity.speed_vertical
  end

  local soonest_entity_update = math.min(update_intervals) 
  return soonest_entity_update
end

function main()
  -- We need to make the total energy a tiny bit larger than the potential energy
  -- for the entity to start moving. I should fix this differently somehow.
  for i, entity in ipairs(entities) do
    local h = entity_max_y - entity.y
    local fix = 1.000001
    entity.energy_total = (entity.mass * g * h) * fix
  end

  clear()
  drawRectangleLines()
  prepareStaticGUI()

  -- Keeps track of how long the program has slept.
  local total_time_slept = 0
  while true do
    local soonest_entity_update = calcSoonestEntityUpdate()
    total_time_slept = soonest_entity_update + soonest_entity_update
    sleep(soonest_entity_update)
  





    -- local tiny = 0.000001 -- Makes sure the for loop always at least runs once.
    -- local iterations = math.ceil(math.abs(entity.speed_vertical) + 0.1) -- The range is [ 1, -> >.
    -- for i = 1, iterations do
    --   entity:move()
    --   entity:calcEnergy()
    --   entity:calcSpeed()
    -- end
    -- prepareDynamicGUI()
    
    -- -- If the vertical speed is 16 m/s, the entity gets updated 16 times in a second.
    -- -- To prevent the game taking incredibly long to update when the vertical speed is tiny,
    -- -- we set a maximum sleep time of 1 second.
    -- if (entity.speed_vertical > 1) then
    --   sleep(1/entity.speed_vertical)
    -- else
    --   sleep(1)
    -- end
  end
end
main()