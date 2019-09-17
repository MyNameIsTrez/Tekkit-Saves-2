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

local entity_min_x = 2
local entity_max_x = gui_x-1
local entity_min_y = 2
local entity_max_y = h-2

local g = 9.81 -- m/s^2. Gravitational acceleration.
local tick_speed = 10

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

local corners = {
  { -- Top-left.
    x = 1,
    y = 1
  },
  { -- Bottom-right.
    x = w-1,
    y = h-1
  }
}

local gui_corner = {
  x = gui_x,
  y = 1
}

local entities = {
  {
    x = w/2, -- m offset.
    y = h/2, -- m offset.
    x_speed = 0, -- m/s.
    y_speed = 1, -- m/s.
    speed = 0, -- m/s. pythagoras of x_speed and y_speed.
    mass = 0.25, -- kg.
    energy_potential = 0 -- J.
  }
}

function writeGUI(string, height)
  term.setCursorPos(gui_x + 2, 1 + 2 * height)
  write("                                                     ")
  term.setCursorPos(gui_x + 2, 1 + 2 * height)
  write(string)
end

function pythagoras(a, b)
  return math.sqrt(math.pow(a, 2) + math.pow(b, 2))
end

function entities:calcEnergyPotential(i)
  local entity = entities[i]

  local h = entity_max_y - entity.y
  entity.energy_potential = entity.mass * g * h

  writeGUI("h: "..h, 1)
  writeGUI("entity.energy_potential: "..entity.energy_potential.." J", 2)
end

function entities:calcEnergyKinetic(i)
  local entity = entities[i]

  entity.speed = pythagoras(entity.x_speed, entity.y_speed)
  entity.energy_kinetic = 0.5 * entity.mass * math.pow(entity.speed, 2)

  writeGUI("entity.x_speed: "..entity.x_speed.." m/s", 3)
  writeGUI("entity.y_speed: "..entity.y_speed.." m/s", 4)
  writeGUI("entity.speed: "..entity.speed.." m/s", 5)
  writeGUI("entity.energy_kinetic: "..entity.energy_kinetic.." J", 6)
end

function entities:move(i)
  local entity = entities[i]

  local dist_wall_north = entity_min_y - entity.y
  local dist_wall_east = entity_max_x - entity.x
  local dist_wall_south = entity_max_y - entity.y
  local dist_wall_west = entity_min_x - entity.x

  if (entity.y_speed < dist_wall_north) then
    entity.y_speed = dist_wall_north
  end
  if (entity.x_speed > dist_wall_east) then
    entity.x_speed = dist_wall_east
  end
  if ( entity.y_speed > dist_wall_south) then
    entity.y_speed = dist_wall_south
  end
  if (entity.x_speed < dist_wall_west) then
    entity.x_speed = dist_wall_west
  end

  -- Remove the currently drawn position of the entity.
  shape.point(entity, " ")
  entity.x = entity.x + entity.x_speed
  entity.y = entity.y + entity.y_speed
  -- Draw the new position of the entity.
  shape.point(entity, "#")
end

function drawGUI()
  shape.rectangle(corners[1], corners[2])
  shape.rectangle(gui_corner, corners[2])
end

function main()
  clear()
  drawGUI()
  shape.point(entities[1], "#")

  while true do
    entities:move(1)
    entities:calcEnergyPotential(1)
    entities:calcEnergyKinetic(1)
    sleep(1 / tick_speed)
  end
end
main()