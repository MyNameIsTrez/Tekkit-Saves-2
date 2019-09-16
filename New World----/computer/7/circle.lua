-- Shape drawer code for Tekkit Classic.
-- Made by MyNameIsTrez in 2019.

-- The default terminal ratio is 25:9, with the standard being 50:18
-- 426 by 160 is a fullscreen monitor when Minecraft is in fullscreen mode.
-- 426 by 153 is a fullscreen monitor when Minecraft is in windowed mode.
local start_time = os.time()

local w, h = term.getSize()

function clearTerminal()
  term.clear()
  term.setCursorPos(1,1)
end

function point(x, y)
  term.setCursorPos(x, y)
  print("#")
  term.setCursorPos(1, 1)
end

function circle(c, r)
  local circle_degrees = 360

  -- Using radians. -------------------------------------------------------
  -- 700 to 750 ms
  -- local radius = r
  -- local two_pi = 2 * math.pi
  -- -- Because the text height is about 1.5 times its width,
  -- -- we need this multiplier to make a circle shape.
  -- local x_fix = 1.5
  -- local step = two_pi / circle_degrees

  -- for i = 0, two_pi, step do
  --   local x = math.cos(i) * radius * x_fix
  --   local y = math.sin(i) * radius
  --   point(c.x + x, c.y + y)
  -- end
  
  -- Using degrees. -------------------------------------------------------
  -- 700 to 750 ms
  local radius = r
  -- Because the text height is about 1.5 times its width,
  -- we need this multiplier to make a circle shape.
  local x_fix = 1.5

  for i = 0, 359 do
    local rad = math.rad(i)
    local x = math.cos(rad) * radius * x_fix
    local y = math.sin(rad) * radius
    point(c.x + x, c.y + y)
  end
end

function dist(a, b)
  return math.sqrt(math.pow(a, 2) + math.pow(b, 2))
end

function line(p1, p2)
  local x_diff = p2.x - p1.x
  local y_diff = p2.y - p1.y
  local distance = dist(x_diff, y_diff)
  local angle = math.tan(y_diff / x_diff)
  local step_x = x_diff / distance
  local step_y = y_diff / distance

  for i = 0, distance do
    local x = i * step_x
    local y = i * step_y
    point(p1.x + x, p1.y + y)
  end
end

function rect(p1, p2)
  local x_diff = p2.x - p1.x
  local y_diff = p2.y - p1.y
  local p = {
    { -- Top-left.
      x = p1.x,
      y = p1.y
    },
    { -- Top-right.
      x = p1.x + x_diff,
      y = p1.y
    },
    { -- Bottom-right.
      x = p1.x + x_diff,
      y = p1.y + y_diff
    },
    { -- Bottom-left.
      x = p1.x,
      y = p1.y + y_diff
    }
  }

  line(p[1], p[2]) -- Top.
  line(p[2], p[3]) -- Right.
  line(p[3], p[4]) -- Bottom.
  line(p[4], p[1]) -- Left.
end

function main()
  local p = {
    { -- Middle of the screen.
      x = w / 2,
      y = h / 2 + 1
    },
    { -- Top-right.
      x = w / 4,
      y = h / 4
    },
    { -- Bottom-left.
      x = w / 4 * 3,
      y = h / 4 * 3
    },
    {
      x = 1,
      y = 1,
    },
    {
      x = w-1,
      y = h-1
    }
  }

  clearTerminal()
  local max = 24 -- Fullscreen mode.
  -- local max = 23 -- Windowed mode.
  for i = max, 0, -1 do
    circle(p[1], i)
    os.queueEvent("randomEvent")
    os.pullEvent("randomEvent")
  end
end

main()

local end_time = os.time()
local elapsed_time = end_time - start_time
local ms = elapsed_time * 50 * 1000
print(ms.." ms")